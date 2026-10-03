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

    /** 构造器参数签名（去掉首个 `seen` 掩码后，就是 10 个业务字段） */
    private static final Class<?>[] CTOR_SIG = new Class<?>[]{
            String.class,        // 0 chat_session_id
            Integer.class,       // 1 parent_message_id   ← null ⇒ 会话首条
            String.class,        // 2 prompt             ← ★ 注入点
            ArrayList.class,     // 3 ref_file_ids
            boolean.class,       // 4 thinking_enabled
            boolean.class,       // 5 search_enabled
            String.class,        // 6 audio_id
            boolean.class,       // 7 preempt
            String.class,        // 8 model_type
            String.class,        // 9 action
            int.class            // 10 默认参数掩码
    };

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

            String injected = GmSysPrompt.inject((String) raw, first);
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
     * <p>当前实测：**2.6.1 (vc279) = `qv1`**。
     */
    private static final String[] CANDIDATE_NAMES = {
            "qv1",                                   // deepseek 2.6.1 (vc279) 实测
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

                Constructor<?> ctor = c.getDeclaredConstructor(CTOR_SIG);
                ctor.setAccessible(true);
                XposedBridge.hookMethod(ctor, new GmSysPromptHook());

                GmUtil.log("hookM sysprompt count=1 cls=" + name
                        + " (" + c.getName() + ")");
                return 1;
            } catch (NoSuchMethodException e) {
                // 类在、但签名不对 ⇒ 名字被复用了（2.6.1 轮换时踩过这个坑）
                GmUtil.log("hookM FAIL sysprompt " + name
                        + " → 类在但无匹配构造器（名字被复用？该重新反查了）");
            } catch (Throwable t) {
                GmUtil.logFail("syspromptHook.install/" + name, t);
            }
        }
        GmUtil.log("hookM FAIL sysprompt → 全部候选未命中，宿主可能已改版");
        return 0;
    }
}
