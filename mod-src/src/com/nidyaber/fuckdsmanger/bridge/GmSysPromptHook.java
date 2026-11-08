// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.bridge;

import com.nidyaber.fuckdsmanger.gm.GmSysPrompt;
import com.nidyaber.fuckdsmanger.gm.GmUtil;

import java.lang.reflect.Constructor;
import java.util.ArrayList;

import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedBridge;

/**
 * GmSysPromptHook —— 「系统提示词注入」的挂点 🐲（2026-10-03 · 尼得亚伯）
 *
 * <h3>为什么挂在这里</h3>
 * 目标是 DeepSeek 的 {@code com.deepseek.chat.network.chat.model.chat.ChatFullCompletionRequest}
 * —— 这是「要发一条 completion 请求」的<b>唯一入口</b>
 * （实证：全宿主只有 {@code st1.z} / {@code hu1.z} / {@code yt1.z} 三处构造它）。
 *
 * <p>比 hook OkHttp / Ktor 稳得多：网络栈版本一变全废，而这个构造器是<b>业务语义</b>的。
 *
 * <h3>宿主侧实证签名（2.6.1 / vc279）</h3>
 * <pre>
 * Lqv1;-&gt;&lt;init&gt;(Ljava/lang/String;Ljava/lang/Integer;Ljava/lang/String;Ljava/util/ArrayList;ZZLjava/lang/String;ZLjava/lang/String;Ljava/lang/String;I)V
 *             0=a:session_id  1=b:parent_id  2=c:prompt  3=d:ref_file_ids  4=e:thinking  5=f:search
 *             6=g:audio_id    7=h:preempt    8=i:model_type  9=j:action      10=mask
 * </pre>
 * ⇒ 注入点 = <b>args[2]</b>（prompt）；「是不是首条」= <b>args[1] == null</b>（parent_message_id）。
 *
 * <h3>⚠️ 混淆名纪律</h3>
 * {@code qv1} 是 R8 改的名字，宿主升级必变。<b>本类不写死任何混淆类名</b>，
 * 只按<b>构造器参数签名</b>匹配（教训 261：混淆名从调用点反查；铁律：不依赖宿主包名）。
 *
 * <h3>⚠️ 热路径纪律</h3>
 * 这个构造器每次发消息都会被调用 ⇒ <b>必须零异常外抛</b>（教训 255）。
 * 整个 before 包 try/catch(Throwable)，任何异常都静默放行原请求。
 */
public final class GmSysPromptHook extends XC_MethodHook {

    /**
     * 构造器参数签名 —— **多版并存**（2.7.5 起宿主在 ref_file_ids 后面又插了一个 String）。
     *
     * <p>按「最新版在前」排，逐个试；都失败再走 {@link #findCtorStructural} 结构兜底。
     */
    private static final Class<?>[][] CTOR_SIGS = new Class<?>[][]{
            {   // ★ 2.7.5 / qy1 —— 12 参（比 2.7.2 多插一个 String，在 index 9 处）
                String.class,        // 0 chat_session_id
                Integer.class,       // 1 parent_message_id   ← null ⇒ 会话首条
                String.class,        // 2 prompt             ← ★ 注入点
                ArrayList.class,     // 3 ref_file_ids
                boolean.class,       // 4 thinking_enabled
                boolean.class,       // 5 search_enabled
                String.class,        // 6 audio_id
                boolean.class,       // 7 preempt
                String.class,        // 8 model_type
                String.class,        // 9 ★ 2.7.5 新增
                String.class,        // 10 action
                int.class            // 11 默认参数掩码
            },
            {   // 2.6.1 ~ 2.7.2（qv1 / tv1 / ly1）—— 11 参
                String.class,        // 0
                Integer.class,       // 1
                String.class,        // 2 ★ 注入点
                ArrayList.class,     // 3
                boolean.class,       // 4
                boolean.class,       // 5
                String.class,        // 6
                boolean.class,       // 7
                String.class,        // 8
                String.class,        // 9
                int.class            // 10
            }
    };

    /**
     * 结构兜底：不认签名，只认「业务形状」——
     * {@code (String, Integer, String, List, …)} 且参数 ≥ 10、末位是 int（默认参掩码）。
     *
     * <p>为什么能这么认：<b>args[2] 必须是 prompt</b> 是本类的全部依赖，
     * 而「会话 id / 父消息 id / 正文 / 引用文件」这个前四元组是业务契约，跨版本稳定。
     * 后面宿主想再加字段，随便加，这里都不用改。
     */
    private static Constructor<?> findCtorStructural(Class<?> c) {
        Constructor<?> best = null;
        for (Constructor<?> k : c.getDeclaredConstructors()) {
            Class<?>[] p = k.getParameterTypes();
            if (p.length < 10) continue;
            if (p[0] != String.class) continue;
            if (p[1] != Integer.class) continue;
            if (p[2] != String.class) continue;
            if (!java.util.List.class.isAssignableFrom(p[3])) continue;
            if (p[p.length - 1] != int.class) continue;
            if (best == null || p.length > best.getParameterTypes().length) best = k;
        }
        return best;
    }

    /** 命中计数（诊断用，见 {@link #hits()}） */
    private static volatile int sHits = 0;

    public static int hits() { return sHits; }

    @Override
    protected void beforeHookedMethod(MethodHookParam p) {
        try {
            if (p.args == null || p.args.length < 11) return;

            // ★ 2026-10-03 加：**每进程只打一次**的现场快照 —— 血泪教训换来的。
            //   之前"装机后没效果"卡了很久，就是因为开关恒 false ⇒ inject() 第一行就 return
            //   ⇒ 连 `sysprompt.inject` 都不打 ⇒ 日志里什么都没有 ⇒ 分不清
            //   「hook 没装上」还是「开关没读到」。这一行两秒定责：
            //      看到它 ⇒ hook 装上了，且顺便告诉你 on/mode/text 读成什么
            //      没看到 ⇒ hook 根本没挂上（该去查宿主混淆名了）
            if (p.args[2] instanceof String) {
                GmUtil.logOnce("sysprompt.state",
                        "hook 活了 on=" + GmSysPrompt.on()
                        + " mode=" + GmSysPrompt.mode()
                        + " textLen=" + GmSysPrompt.text().length());
            }

            Object parentId = p.args[1];
            boolean first = (parentId == null);

            Object raw = p.args[2];
            if (!(raw instanceof String)) return;

            // ★★ 2026-11-07（3.76.0）· 「仅首条」裁静态段的前提判据：
            //   **本会话的历史里真的出现过完整锚点**（⟦FDM⟧ 明文 / Unicode Tag 隐形）。
            //   只认「这一条是不是本会话第一条」是不够的 ——
            //   在**这个功能上线之前**就存在的老会话里，第 2 条消息满足 `first=false`，
            //   但历史里从来没有过那几段静态约定 ⇒ 一裁就永久丢掉富文本/追问建议的规则，
            //   模型于是把 <b>…</b>、<Suggestion>…</Suggestion> 原样吐出来（主人 11-07 亲眼见到）。
            //   ⚠️ 这就是「裁」必须配一条**可验证的痕迹**、而不是靠推断的原因。
            boolean historyHasFull = false;
            if (!first && p.args.length > 3 && p.args[3] instanceof java.util.List) {
                historyHasFull = GmSysPrompt.hasAnchor((java.util.List<?>) p.args[3]);
            }

            String injected = GmSysPrompt.inject((String) raw, first, historyHasFull);
            if (injected != null && injected != raw) {
                p.args[2] = injected;
                sHits++;
            }
        } catch (Throwable t) {
            // ★ 热路径：绝不让异常逃出去（逃出去 = 带崩宿主发消息）
            GmUtil.logFail("syspromptHook", t);
        }
    }

    // ─────────────────────────── 安装 ───────────────────────────

    /**
     * 候选混淆名表 —— ★ **宿主升级必变，靠签名校验兜底**。
     *
     * <p>反查方法（升级后照做，别猜）：在宿主工作区搜 smali 里的字符串常量
     * {@code "com.deepseek.chat.network.chat.model.chat.ChatFullCompletionRequest"}，
     * 命中的那个类的 <b>&lt;clinit&gt;</b> 就是它的序列化器（`ca8.(fqn, obj, 10)`），
     * 而数据类本身 = 构造 {@code <init>(…)V} 且<b>参数签名吻合</b>的那个。
     *
     * <p>当前实测：**2.7.2 (vc289) = `ly1`**（2.7.1 为 `sx1`、2.6.2 为 `tv1`）。
     */
    private static final String[] CANDIDATE_NAMES = {
            "qy1",                                   // ★ 2026-11-06 deepseek 2.7.5 (vc295) 实测                                                     //   铁证：`Lqy1;->Companion:Lpy1;`、12 实例字段
                                                     //   (a:String b:Integer c:String d:List e:Z f:Z g:String h:Z i:String j:String k:String l:String)
                                                     //   ctor `(String,Integer,String,ArrayList,ZZ String,Z,String,String,String,I)V` 12 参
                                                     //   序列化器 `oy1`（descriptor 里带 ChatFullCompletionRequest），
                                                     //   `qy1.<clinit>`/`qy1.equals` 都引用 `Loy1;->a` ⇒ 绑定关系确凿
            "ly1",                                   // deepseek 2.7.2 (vc289) 实测
                                                     //   证据：字段 12/12 逐位同序（Companion/l:[Lqh6;/a:St/b:Int/c:St/d:List/e:Z/f:Z/g:St/h:Z/i:St/j:St/k:St）
                                                     //        + ctor 逐位 `(String,Integer,String,ArrayList,ZZString,Z,String,String,I)V`
                                                     //        + 反射：2.7.2 全树唯一命中该构造器前缀
            "sx1",                                   // deepseek 2.7.1 (vc287)
            "tv1",                                   // deepseek 2.6.2 (vc281)
    };

    /**
     * 在指定 ClassLoader 里找出 `ChatFullCompletionRequest` 并挂上。
     *
     * <p>策略：<b>候选混淆名 → 逐个 try → 用构造器签名验证语义 → 通过才钩</b>。
     * 签名不吻合 ⇒ 报错退出（**绝不盲目挂上去咬无关代码**，教训 887：装钩必须有回执）。
     *
     * @return 装上的钩子数（0 = 没找到 / 签名不符，需要重新反查）
     */
    public static int install(ClassLoader cl) {
        for (String name : CANDIDATE_NAMES) {
            try {
                Class<?> c = Class.forName(name, false, cl);
                if (c == null) continue;

                Constructor<?> ctor = null;
                for (Class<?>[] sig : CTOR_SIGS) {
                    try {
                        ctor = c.getDeclaredConstructor(sig);
                        break;
                    } catch (NoSuchMethodException ignore) { /* 试下一个版本 */ }
                }
                if (ctor == null) ctor = findCtorStructural(c);
                if (ctor == null) {
                    // 类在、但没有任何一个像样的构造器 ⇒ 名字被复用了（2.6.1 / 2.7.5 都踩过）
                    GmUtil.log("hookM FAIL sysprompt " + name
                            + " → 类在但无匹配构造器（名字被复用？该重新反查了）");
                    continue;
                }
                ctor.setAccessible(true);
                XposedBridge.hookMethod(ctor, new GmSysPromptHook());

                StringBuilder ps = new StringBuilder();
                for (Class<?> t : ctor.getParameterTypes()) {
                    if (ps.length() > 0) ps.append(',');
                    ps.append(t.getSimpleName());
                }
                GmUtil.log("hookM sysprompt count=1 cls=" + name
                        + " (" + c.getName() + ") ctor=" + ctor.getParameterTypes().length + "参(" + ps + ")");
                return 1;
            } catch (Throwable t) {
                // 「类在但构造器对不上」的情况已经在上面 continue 掉了；
                // 走到这里说明是这个候选类本身有问题（名字被复用的另一种形态）
                GmUtil.logFail("syspromptHook.install/" + name, t);
            }
        }
        GmUtil.log("hookM FAIL sysprompt → 全部候选未命中，宿主可能已改版");
        return 0;
    }
}
