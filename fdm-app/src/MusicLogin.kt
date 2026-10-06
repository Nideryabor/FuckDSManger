// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
//
//  网易云登录页 🐲 —— 2026-10-06 主人：「去掉二维码，换成手机或者 cookie 或者密码登录」
//
//  三条路：
//    ① 手机号 + 短信验证码（先发码，再带着码登录）
//    ② 手机号 / 邮箱 + 密码
//    ③ 直接粘 cookie（MUSIC_U）—— 最省事，从浏览器 / 别的客户端抠出来
//
//  网络请求**在本模块进程直接发**（HTTPS，跟宿主无关；
//  实测：假密码登录能收到服务端真实答复「账号或密码错误」⇒ 通道是通的）。
//  登录成功后把凭证（MUSIC_U）通过桥送到**宿主进程**，由宿主写进它自己的私有目录
//  （模块没有权限写宿主 /data/data）。
//
//  ⚠️ 明文存储：见「隐私」那张卡的说明 —— 主人特别交代要告诉用户。
package com.nidyaber.fuckdsmanger

import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.text.KeyboardOptions
import androidx.compose.foundation.verticalScroll
import androidx.compose.material3.Button
import androidx.compose.material3.ExperimentalMaterial3Api
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.rememberCoroutineScope
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.input.KeyboardType
import androidx.compose.ui.text.input.PasswordVisualTransformation
import androidx.compose.ui.unit.dp
import com.nidyaber.fuckdsmanger.bridge.FdmPush
import com.nidyaber.fuckdsmanger.music.GmMusicApi
import com.nidyaber.fuckdsmanger.music.GmMusicCrypto
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.delay
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import org.json.JSONObject

/** 三选一：验证码 / 密码 / cookie。 */
private enum class Mode { CAPTCHA, PASSWORD, COOKIE }

@OptIn(ExperimentalMaterial3Api::class)
@Composable
fun MusicLoginPage(onBack: () -> Unit) {
    val ctx = LocalContext.current
    val sp = remember { FdmPush.sp(ctx) }
    val scope = rememberCoroutineScope()

    var mode by remember { mutableStateOf(Mode.CAPTCHA) }
    var tick by remember { mutableIntStateOf(0) }
    var busy by remember { mutableStateOf(false) }
    var msg by remember { mutableStateOf("") }

    // 输入
    var phone by remember { mutableStateOf("") }
    var ctcode by remember { mutableStateOf("86") }
    var captcha by remember { mutableStateOf("") }
    var pwd by remember { mutableStateOf("") }
    var email by remember { mutableStateOf("") }
    var cookie by remember { mutableStateOf("") }
    var sentAt by remember { mutableStateOf(0L) }
    var countdown by remember { mutableIntStateOf(0) }

    // 宿主回报的登录态
    LaunchedEffect(tick) {
        FdmPush.sendCmd(ctx, "cfg_state", null)
        delay(1500)
        tick++
    }
    val st: JSONObject = remember(tick) {
        try {
            JSONObject(sp.getString("cmd.cfg_state", "{}") ?: "{}")
        } catch (t: Throwable) {
            JSONObject()
        }
    }
    val logged = st.optBoolean("music_logged", false)
    val user = st.optString("music_user", "")
    val diag = st.optString("music_login_diag", "")

    // ★ 2026-10-06 自愈：宿主要是没存上（或它重启后丢了），
    //   只要**本地还留着凭证**，就再补推一次。
    //   （主人遇到的 bug：登录提示成功、重启 UI 还是"未登录"）
    LaunchedEffect(tick) {
        if (!logged) {
            val local = sp.getString("music.token", "") ?: ""
            if (local.isNotEmpty()) {
                FdmPush.sendCmd(ctx, "music_login_save", "$local\u001f\u001f")
            }
        }
    }

    // 验证码倒计时
    LaunchedEffect(sentAt) {
        var left = 60
        while (left > 0) {
            countdown = left
            delay(1000)
            left--
        }
        countdown = 0
    }

    /** 登录成功后：把凭证送进宿主（只有宿主能写它自己的私有目录）。 */
    fun handOff(musicU: String, uid: String, nick: String) {
        if (musicU.isEmpty()) {
            msg = "服务端没给凭证（MUSIC_U）——登录没成功，或这版接口变了"
            return
        }
        // ★ 本地也留一份（键名刻意**不带 fuckds_ 前缀** ⇒ 不会被全量推给宿主，
        //   免得凭证又被塞进宿主的 MMKV、多一处副本）
        sp.edit().putString("music.token", musicU).apply()
        FdmPush.sendCmd(ctx, "music_login_save", "$musicU\u001f$uid\u001f$nick")
        msg = "已把凭证交给宿主，等它回执…"
        // ★ 不写"假成功"：读**宿主的真实回执**（last_result）再下结论
        scope.launch {
            delay(1200)
            // 立刻催一次状态，别等下一轮轮询（主人上次就是"看着像没登录"）
            FdmPush.sendCmd(ctx, "cfg_state", null)
            delay(600)
            val r = sp.getString("last_result", "") ?: ""
            msg = if (r.isEmpty()) "宿主没回执（它可能没在跑）" else "宿主回执：$r"
            tick++
        }
    }

    Scaffold(
        topBar = { FdmTopBar("网易云登录", onBack = onBack) },
        containerColor = MaterialTheme.colorScheme.surface,
    ) { pad ->
        Column(
            Modifier
                .padding(pad)
                .verticalScroll(rememberScrollState())
                .padding(bottom = 24.dp),
        ) {
            // ───────── 当前状态 ─────────
            SectionLabel("登录状态")
            CardBox {
                Text(
                    if (logged) "✅ 已登录" + (if (user.isNotEmpty()) "：$user" else "")
                    else "未登录（免登录也能听 320k，登录后才能听会员曲 / 无损）",
                    style = MaterialTheme.typography.bodyMedium,
                    color = MaterialTheme.colorScheme.onSurface,
                )
                if (logged) {
                    Spacer(Modifier.height(8.dp))
                    Button(onClick = {
                        FdmPush.sendCmd(ctx, "music_login_clear", null)
                        FdmPush.sp(ctx).edit().remove("music.token").apply()
                        msg = "已退出登录"
                        tick++
                    }) { Text("退出登录") }
                }
                if (diag.isNotEmpty()) {
                    Spacer(Modifier.height(6.dp))
                    Text(
                        "宿主侧：$diag",
                        style = MaterialTheme.typography.labelSmall,
                        color = MaterialTheme.colorScheme.onSurfaceVariant,
                    )
                }
            }

            // ───────── 三条路 ─────────
            SectionLabel("登录方式")
            CardBox {
                Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    Tab("手机验证码", mode == Mode.CAPTCHA) { mode = Mode.CAPTCHA }
                    Tab("密码", mode == Mode.PASSWORD) { mode = Mode.PASSWORD }
                    Tab("粘 cookie", mode == Mode.COOKIE) { mode = Mode.COOKIE }
                }

                Spacer(Modifier.height(10.dp))

                when (mode) {
                    Mode.CAPTCHA -> {
                        OutlinedTextField(
                            value = phone, onValueChange = { phone = it.filter { c -> c.isDigit() } },
                            label = { Text("手机号") }, singleLine = true,
                            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Phone),
                            modifier = Modifier.fillMaxWidth(),
                        )
                        Spacer(Modifier.height(6.dp))
                        Row(verticalAlignment = Alignment.CenterVertically) {
                            OutlinedTextField(
                                value = captcha, onValueChange = { captcha = it.filter { c -> c.isDigit() } },
                                label = { Text("短信验证码") }, singleLine = true,
                                keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Number),
                                modifier = Modifier.weight(1f),
                            )
                            Spacer(Modifier.width(8.dp))
                            Button(
                                enabled = !busy && phone.length >= 6 && countdown == 0,
                                onClick = {
                                    busy = true
                                    msg = "正在发验证码…"
                                    scope.launch {
                                        val r = withContext(Dispatchers.IO) {
                                            try {
                                                GmMusicApi.captchaSent(phone, ctcode)
                                            } catch (t: Throwable) {
                                                mapOf("code" to -1L, "msg" to (t.message ?: "网络失败"))
                                            }
                                        }
                                        val code = (r["code"] as? Number)?.toLong() ?: -1L
                                        msg = if (code == 200L) "验证码已发出，请查收短信"
                                        else "发码失败：code=$code ${r["msg"]}"
                                        if (code == 200L) sentAt = System.currentTimeMillis()
                                        busy = false
                                    }
                                },
                            ) { Text(if (countdown > 0) "${countdown}s" else "发验证码") }
                        }
                        Spacer(Modifier.height(10.dp))
                        Button(
                            enabled = !busy && phone.isNotEmpty() && captcha.isNotEmpty(),
                            onClick = {
                                busy = true
                                msg = "正在登录…"
                                scope.launch {
                                    val r = withContext(Dispatchers.IO) {
                                        try {
                                            GmMusicApi.loginByCaptcha(phone, captcha, ctcode)
                                        } catch (t: Throwable) {
                                            mapOf("code" to -1L, "msg" to (t.message ?: "网络失败"))
                                        }
                                    }
                                    val code = (r["code"] as? Number)?.toLong() ?: -1L
                                    if (code == 200L) {
                                        handOff(
                                            (r["musicU"] as? String) ?: "",
                                            (r["uid"] as? String) ?: "",
                                            (r["nick"] as? String) ?: "",
                                        )
                                    } else {
                                        msg = "登录失败：code=$code ${r["msg"]}"
                                    }
                                    busy = false
                                }
                            },
                        ) { Text("登录") }
                    }

                    Mode.PASSWORD -> {
                        OutlinedTextField(
                            value = phone, onValueChange = { phone = it.filter { c -> c.isDigit() } },
                            label = { Text("手机号") }, singleLine = true,
                            keyboardOptions = KeyboardOptions(keyboardType = KeyboardType.Phone),
                            modifier = Modifier.fillMaxWidth(),
                        )
                        Spacer(Modifier.height(6.dp))
                        OutlinedTextField(
                            value = email, onValueChange = { email = it },
                            label = { Text("或者邮箱（二选一）") }, singleLine = true,
                            modifier = Modifier.fillMaxWidth(),
                        )
                        Spacer(Modifier.height(6.dp))
                        OutlinedTextField(
                            value = pwd, onValueChange = { pwd = it },
                            label = { Text("密码") }, singleLine = true,
                            visualTransformation = PasswordVisualTransformation(),
                            modifier = Modifier.fillMaxWidth(),
                        )
                        Spacer(Modifier.height(10.dp))
                        Button(
                            enabled = !busy && pwd.isNotEmpty() && (phone.isNotEmpty() || email.isNotEmpty()),
                            onClick = {
                                busy = true
                                msg = "正在登录…"
                                scope.launch {
                                    val md5 = GmMusicCrypto.md5Hex(pwd)
                                    val r = withContext(Dispatchers.IO) {
                                        try {
                                            if (phone.isNotEmpty()) {
                                                GmMusicApi.loginByPassword(phone, md5, ctcode)
                                            } else {
                                                GmMusicApi.loginByEmail(email, md5)
                                            }
                                        } catch (t: Throwable) {
                                            mapOf("code" to -1L, "msg" to (t.message ?: "网络失败"))
                                        }
                                    }
                                    val code = (r["code"] as? Number)?.toLong() ?: -1L
                                    if (code == 200L) {
                                        handOff(
                                            (r["musicU"] as? String) ?: "",
                                            (r["uid"] as? String) ?: "",
                                            (r["nick"] as? String) ?: "",
                                        )
                                    } else {
                                        msg = "登录失败：code=$code ${r["msg"]}"
                                    }
                                    busy = false
                                }
                            },
                        ) { Text(if (phone.isNotEmpty()) "手机密码登录" else "邮箱密码登录") }
                    }

                    Mode.COOKIE -> {
                        OutlinedTextField(
                            value = cookie, onValueChange = { cookie = it },
                            label = { Text("MUSIC_U 的值") },
                            modifier = Modifier.fillMaxWidth(),
                        )
                        Spacer(Modifier.height(6.dp))
                        Text(
                            "怎么拿：浏览器登录 music.163.com → F12 → Application → Cookies → " +
                            "找 MUSIC_U，把它的值整段粘进来即可。\n" +
                            "（也可以整条 cookie 串直接粘 —— 会自动从中挑出 MUSIC_U）",
                            style = MaterialTheme.typography.labelSmall,
                            color = MaterialTheme.colorScheme.onSurfaceVariant,
                        )
                        Spacer(Modifier.height(10.dp))
                        Button(
                            enabled = !busy && cookie.isNotEmpty(),
                            onClick = {
                                var v = cookie.trim()
                                if (v.contains("=")) {
                                    val picked = GmMusicApi.pickCookie(v, "MUSIC_U")
                                    if (picked.isNotEmpty()) v = picked
                                }
                                handOff(v, "", "")
                            },
                        ) { Text("用这段 cookie 登录") }
                    }
                }

                if (msg.isNotEmpty()) {
                    Spacer(Modifier.height(10.dp))
                    Text(
                        msg,
                        style = MaterialTheme.typography.bodySmall,
                        color = MaterialTheme.colorScheme.primary,
                    )
                }
            }

            // ───────── 隐私（主人特别交代要说清楚）─────────
            SectionLabel("⚠️ 隐私")
            CardBox {
                Text(
                    "登录凭证（MUSIC_U）是**明文存储**的，没有做任何加密。\n\n" +
                    "· 存在哪：宿主自己的私有目录\n" +
                    "  /data/data/<宿主包名>/files/FDMmusic/login.json\n" +
                    "· 谁能读：只有宿主自己（别的 App 读不到）\n" +
                    "· ⚠️ **root 用户请注意**：root / 备份 / 调试工具可以直接读到这个文件，" +
                    "拿到它就等于拿到你的网易云账号。请自行评估风险。\n" +
                    "· 永远不要把这段凭证分享、截图、上传到任何地方。\n" +
                    "· 不放心就点上面的「退出登录」，文件会被删除。",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
            }

            // ───────── 说明 ─────────
            SectionLabel("说明")
            CardBox {
                Text(
                    "· 不登录也能听 —— 实测能拿到 320k（exhigh）。登录后能听会员曲 / 无损。\n" +
                    "· 登录请求由**模块**直接发（HTTPS）；成功后凭证交给**宿主**保存，\n" +
                    "  宿主的播放器读取它、后续请求自动带上。\n" +
                    "· 密码只在本机做一次 MD5，**不会保存**（保存的只有登录凭证）。",
                    style = MaterialTheme.typography.bodySmall,
                    color = MaterialTheme.colorScheme.onSurfaceVariant,
                )
            }
        }
    }
}

@Composable
private fun Tab(label: String, on: Boolean, onClick: () -> Unit) {
    Box(
        Modifier
            .clip(RoundedCornerShape(20.dp))
            .background(
                if (on) MaterialTheme.colorScheme.primaryContainer
                else MaterialTheme.colorScheme.surfaceContainerHigh
            )
            .clickable { onClick() }
            .padding(horizontal = 14.dp, vertical = 8.dp),
    ) {
        Text(
            label,
            style = MaterialTheme.typography.labelLarge,
            color = if (on) MaterialTheme.colorScheme.onPrimaryContainer
            else MaterialTheme.colorScheme.onSurfaceVariant,
        )
    }
}
