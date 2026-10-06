// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger

import androidx.compose.foundation.Canvas
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.border
import androidx.compose.foundation.gestures.detectDragGestures
import androidx.compose.foundation.gestures.detectTapGestures
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.AlertDialog
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.OutlinedTextField
import androidx.compose.material3.Slider
import androidx.compose.material3.Text
import androidx.compose.material3.TextButton
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableFloatStateOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.drawscope.Stroke
import androidx.compose.ui.graphics.toArgb
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.text.font.FontFamily
import androidx.compose.ui.unit.dp
import kotlin.math.abs
import kotlin.math.atan2
import kotlin.math.hypot
import kotlin.math.min

/**
 * FDM 自己的 **颜色轮盘** 🐲
 *
 * 主人 2026-09-30：「我们不是单开新 APP 了吗，那干脆用 compose 的颜色轮盘
 * 给用户让用户手动选值，选好把颜色发给宿主」
 *
 * 所以这里不依赖任何第三方取色器 —— 手搓一个：
 *   · **色相环**（外圈，拖拽选色相）
 *   · **饱和度/明度方块**（内方块，横轴饱和度、纵轴明度）
 *   · **透明度滑杆**
 *   · **十六进制输入**（能手打 #RRGGBB / #AARRGGBB）
 *
 * 确认后回调一个 ARGB Int，交给现成的 cfg_put 通道发给宿主。
 */
@Composable
fun ColorWheelDialog(
    title: String,
    initial: Int,
    onDismiss: () -> Unit,
    onConfirm: (Int) -> Unit,
) {
    // 拆成 HSVA 四个分量来编辑（比直接改 ARGB 直观得多）
    val initA = ((initial ushr 24) and 0xFF) / 255f
    val initR = ((initial ushr 16) and 0xFF) / 255f
    val initG = ((initial ushr 8) and 0xFF) / 255f
    val initB = (initial and 0xFF) / 255f
    val hsv = rgbToHsv(initR, initG, initB)

    var hue by remember { mutableFloatStateOf(hsv[0]) }
    var sat by remember { mutableFloatStateOf(hsv[1]) }
    var bri by remember { mutableFloatStateOf(hsv[2]) }
    var alpha by remember { mutableFloatStateOf(if (initA == 0f) 1f else initA) }

    val argb: Int = hsvToArgb(hue, sat, bri, alpha)
    var hexText by remember { mutableStateOf(hexOf(argb)) }
    var hexErr by remember { mutableStateOf(false) }

    val ringW = 34.dp
    val wheel = 230.dp

    AlertDialog(
        onDismissRequest = onDismiss,
        title = { Text(title) },
        text = {
            Column(Modifier.fillMaxWidth()) {
                // ── 预览 + 十六进制 ──
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Box(
                        Modifier.size(46.dp).clip(CircleShape)
                            .background(Color(argb))
                            .border(1.dp, MaterialTheme.colorScheme.outlineVariant, CircleShape),
                    )
                    Spacer(Modifier.width(12.dp))
                    OutlinedTextField(
                        value = hexText,
                        onValueChange = { s ->
                            hexText = s
                            val v = parseHex(s)
                            hexErr = (v == null)
                            if (v != null) {
                                val a2 = ((v ushr 24) and 0xFF) / 255f
                                val h2 = rgbToHsv(
                                    ((v ushr 16) and 0xFF) / 255f,
                                    ((v ushr 8) and 0xFF) / 255f,
                                    (v and 0xFF) / 255f,
                                )
                                hue = h2[0]; sat = h2[1]; bri = h2[2]
                                if (a2 > 0f) alpha = a2
                            }
                        },
                        singleLine = true,
                        isError = hexErr,
                        label = { Text("十六进制") },
                        textStyle = MaterialTheme.typography.bodySmall.copy(fontFamily = FontFamily.Monospace),
                        modifier = Modifier.weight(1f),
                    )
                }

                Spacer(Modifier.height(14.dp))

                // ── 色相环 ──
                Box(Modifier.align(Alignment.CenterHorizontally).size(wheel)) {
                    Canvas(
                        Modifier.fillMaxWidth().height(wheel)
                            .pointerInput(Unit) {
                                detectTapGestures { off -> hue = hueAt(off, size.width.toFloat(), size.height.toFloat()) }
                            }
                            .pointerInput(Unit) {
                                detectDragGestures { change, _ ->
                                    hue = hueAt(change.position, size.width.toFloat(), size.height.toFloat())
                                }
                            },
                    ) {
                        val cx = size.width / 2f
                        val cy = size.height / 2f
                        val ringPx = ringW.toPx()
                        val rOut = min(cx, cy)
                        val rMid = rOut - ringPx / 2f
                        // 用手绘小扇形拼出环（比 sweepGradient + mask 简单且颜色准）
                        val steps = 360
                        for (i in 0 until steps) {
                            drawArc(
                                color = Color.hsv(i.toFloat(), 1f, 1f),
                                startAngle = i.toFloat() - 0.7f,
                                sweepAngle = 1.5f,
                                useCenter = false,
                                style = Stroke(width = ringPx),
                                topLeft = Offset(cx - rMid, cy - rMid),
                                size = androidx.compose.ui.geometry.Size(rMid * 2, rMid * 2),
                            )
                        }
                        // 色相指示点
                        val ang = Math.toRadians(hue.toDouble())
                        val px = cx + (rMid * Math.cos(ang)).toFloat()
                        val py = cy + (rMid * Math.sin(ang)).toFloat()
                        drawCircle(Color.White, radius = ringPx * 0.30f, center = Offset(px, py))
                        drawCircle(Color.Black, radius = ringPx * 0.30f, center = Offset(px, py),
                            style = Stroke(width = 2f))
                    }

                    // ── 内方块：饱和度 × 明度 ──
                    val inner = wheel * 0.62f
                    Box(
                        Modifier.align(Alignment.Center).size(inner)
                            .clip(RoundedCornerShape(6.dp))
                            .background(Brush.horizontalGradient(
                                listOf(Color.White, Color.hsv(hue, 1f, 1f))))
                            .background(Brush.verticalGradient(
                                listOf(Color.Transparent, Color.Black)))
                            .pointerInput(Unit) {
                                detectTapGestures { off ->
                                    val s = (off.x / size.width.toFloat()).coerceIn(0f, 1f)
                                    val v = 1f - (off.y / size.height.toFloat()).coerceIn(0f, 1f)
                                    sat = s; bri = v
                                }
                            }
                            .pointerInput(Unit) {
                                detectDragGestures { change, _ ->
                                    val s = (change.position.x / size.width.toFloat()).coerceIn(0f, 1f)
                                    val v = 1f - (change.position.y / size.height.toFloat()).coerceIn(0f, 1f)
                                    sat = s; bri = v
                                }
                            },
                    ) {
                        Canvas(Modifier.fillMaxWidth().height(inner)) {
                            val px = sat * size.width
                            val py = (1f - bri) * size.height
                            drawCircle(Color.White, radius = 8f, center = Offset(px, py))
                            drawCircle(Color.Black, radius = 8f, center = Offset(px, py),
                                style = Stroke(width = 2f))
                        }
                    }
                }

                Spacer(Modifier.height(10.dp))

                // ── 透明度 ──
                Text("透明度  ${(alpha * 100).toInt()}%",
                    style = MaterialTheme.typography.labelMedium)
                Slider(
                    value = alpha,
                    onValueChange = { alpha = it },
                    valueRange = 0f..1f,
                )

                // ── 快速色板（常用色一键选，色相环还是主力）──
                Spacer(Modifier.height(4.dp))
                Row(horizontalArrangement = Arrangement.spacedBy(8.dp)) {
                    listOf(
                        0xFFFFFFFF, 0xFFE8E8E8, 0xFF9E9E9E, 0xFF3A3A3A, 0xFF000000,
                        0xFFEF5350, 0xFFFFA726, 0xFF66BB6A, 0xFF42A5F5, 0xFF7E57C2,
                    ).forEach { c ->
                        Box(
                            Modifier.size(22.dp).clip(CircleShape)
                                .background(Color(c.toInt()))
                                .border(1.dp, MaterialTheme.colorScheme.outlineVariant, CircleShape)
                                .clickableNoRipple {
                                    val h3 = rgbToHsv(
                                        ((c ushr 16) and 0xFF) / 255f,
                                        ((c ushr 8) and 0xFF) / 255f,
                                        (c and 0xFF) / 255f,
                                    )
                                    hue = h3[0]; sat = h3[1]; bri = h3[2]
                                    hexText = hexOf(hsvToArgb(hue, sat, bri, alpha))
                                },
                        )
                    }
                }
            }
        },
        confirmButton = {
            TextButton(onClick = { onConfirm(argb) }) { Text("确定") }
        },
        dismissButton = {
            TextButton(onClick = onDismiss) { Text("取消") }
        },
    )
}

/* ───────────────────── 小工具 ───────────────────── */

/** 色相环上某个坐标对应的色相（0~360，按 12 点方向为 0 顺时针） */
private fun hueAt(off: Offset, w: Float, h: Float): Float {
    val dx = off.x - w / 2f
    val dy = off.y - h / 2f
    if (hypot(dx, dy) < 1f) return 0f
    var deg = Math.toDegrees(atan2(dy.toDouble(), dx.toDouble())).toFloat()
    if (deg < 0f) deg += 360f
    return deg
}

/** #RGB / #RRGGBB / #AARRGGBB / 不带 # 都认。 */
private fun parseHex(s0: String): Int? {
    var s = s0.trim().removePrefix("#")
    if (s.isEmpty() || s.any { it !in "0123456789aAbBcCdDeEfF" }) return null
    return try {
        when (s.length) {
            3 -> {   // #RGB → #RRGGBB
                val r = s[0]; val g = s[1]; val b = s[2]
                ("FF$r$r$g$g$b$b").toLong(16).toInt()
            }
            6 -> (0xFF000000L or s.toLong(16)).toInt()
            8 -> s.toLong(16).toInt()
            else -> null
        }
    } catch (e: Throwable) {
        null
    }
}

private fun hexOf(argb: Int): String =
    String.format("#%08X", argb)

/** RGB(0~1) → [h(0~360), s, v] */
private fun rgbToHsv(r: Float, g: Float, b: Float): FloatArray {
    val max = maxOf(r, g, b); val min = minOf(r, g, b)
    val d = max - min
    var h = 0f
    if (d > 1e-6f) {
        h = when (max) {
            r -> 60f * (((g - b) / d) % 6f)
            g -> 60f * (((b - r) / d) + 2f)
            else -> 60f * (((r - g) / d) + 4f)
        }
    }
    if (h < 0f) h += 360f
    val s = if (max <= 1e-6f) 0f else d / max
    return floatArrayOf(h, s, max)
}

/** HSV + alpha(0~1) → ARGB Int */
private fun hsvToArgb(h: Float, s: Float, v: Float, a: Float): Int {
    val c = Color.hsv(h, s.coerceIn(0f, 1f), v.coerceIn(0f, 1f))
    val alphaInt = (a.coerceIn(0f, 1f) * 255f).toInt()
    return (alphaInt shl 24) or (c.toArgb() and 0x00FFFFFF)
}

/** 无涟漪点击（避免引入额外的 indication 依赖） */
private fun Modifier.clickableNoRipple(onClick: () -> Unit): Modifier =
    this.clickable(
        interactionSource = null,
        indication = null,
        onClick = onClick,
    )
