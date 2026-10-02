package com.nidyaber.fuckdsmanger.glass;

/**
 * 液态玻璃 · 弹簧（Q 弹的来源）🐲
 *
 * <p>参照物里那个 {@code Spring} 类就是干这个的：按下缩一点、松手过冲一下再稳住。
 * 这里用一个阻尼谐振子（damped harmonic oscillator）的**数值积分**，
 * 不依赖动画框架 —— 因为我们是在别人的绘制回调里，每帧被叫一次，正好当 tick 用。
 *
 * <pre>
 *   a = k · (target − x) − c · v
 *   v += a · dt        x += v · dt
 * </pre>
 *
 * <p>手感调参（照参照物的味道）：
 * <ul>
 *   <li>{@code k = 900} —— 硬一点，回弹快；</li>
 *   <li>{@code c = 26} —— 阻尼，让它**过冲一次**再停（c 太小会抖，太大会像贴纸不弹）；</li>
 *   <li>按下目标 {@code 0.94}、松开 {@code 1.0} ⇒ 视觉上是「压下去、弹回来」。</li>
 * </ul>
 */
public final class GmGlassSpring {

    private GmGlassSpring() {
    }

    private static final double K = 900.0;
    private static final double C = 26.0;
    /** 按下时的收缩量。 */
    public static final double PRESS_SCALE = 0.94;

    private static volatile double sX = 1.0;
    private static volatile double sV = 0.0;
    private static volatile long sLastNs = 0L;

    /** 按下 / 松手（由触摸钩子驱动）。 */
    private static volatile boolean sDown = false;

    public static void onDown() {
        sDown = true;
    }

    public static void onUp() {
        sDown = false;
    }

    public static boolean isDown() {
        return sDown;
    }

    /**
     * 每帧推进一步，返回当前缩放系数。
     *
     * <p>多线程安全靠 volatile + 允许丢帧（动画而已，丢一帧无所谓）。
     */
    public static double tick() {
        long now = System.nanoTime();
        long last = sLastNs;
        sLastNs = now;
        if (last == 0L) return sX;

        double dt = (now - last) / 1.0e9;
        if (dt <= 0) return sX;
        if (dt > 0.05) dt = 0.05;        // 卡顿保护：别让大步长把弹簧炸了

        double target = sDown ? PRESS_SCALE : 1.0;
        double x = sX, v = sV;
        int steps = 4;                    // 分几步积分，数值更稳
        double h = dt / steps;
        for (int i = 0; i < steps; i++) {
            double a = K * (target - x) - C * v;
            v += a * h;
            x += v * h;
        }
        sX = x;
        sV = v;
        return x;
    }

    /** 是不是还在动（用来决定要不要主动重画）。 */
    public static boolean moving() {
        return Math.abs(sX - (sDown ? PRESS_SCALE : 1.0)) > 0.002
                || Math.abs(sV) > 0.02;
    }
}
