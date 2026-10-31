package com.huawei.onekey.optimizer.hook.blur;

import android.animation.Animator;
import android.animation.AnimatorListenerAdapter;
import android.animation.AnimatorSet;
import android.animation.ValueAnimator;
import android.app.Activity;
import android.app.WallpaperManager;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.Rect;
import android.graphics.RenderEffect;
import android.graphics.Shader;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.os.Handler;
import android.os.Looper;
import android.os.SystemClock;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.view.Window;
import android.view.WindowManager;
import android.view.animation.PathInterpolator;

import java.lang.ref.WeakReference;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.XposedHelpers;

/**
 * 桌面模糊引擎（ColorOS 风格）。
 *
 * <p>一个总开关同时管三处，跟 ColorOS 的观感一致：
 * <ul>
 *   <li>app 打开/关闭：Workspace（图标层）做 RenderEffect 模糊，随转场淡入淡出；</li>
 *   <li>Dock 栏：Hotseat + QuickNavigationView 一起糊（它们是 Workspace 的兄弟节点）；</li>
 *   <li>壁纸（背景）：跨窗口模糊可用时走 blur-behind，否则退化为「已模糊壁纸位图」叠加到 DecorView。</li>
 * </ul>
 * 模糊程度由滑条控制（1..100），每次转场重新读取，所以调完下一个转场就生效。
 *
 * <p>关键防御（移植自 ColorOS 模块 v1.4 的实战结论）：
 * <ul>
 *   <li>打开信号之后 750ms 内的任何渐出信号一律否决（打断竞态），并安排复检；</li>
 *   <li>看门狗兜底，桌面绝不永久糊着；</li>
 *   <li>逐帧复读，视图被重建/效果被顶掉时自愈。</li>
 * </ul>
 */
public final class LauncherBlurController {

    private LauncherBlurController() {
    }

    // ---------------- 被 hook 的华为桌面类 ----------------
    static final String CLS_LAUNCHER = "com.huawei.android.launcher.Launcher";
    static final String CLS_STATE_MGR = "com.huawei.android.launcher.quickstep.util.LauncherStateManager";
    static final String CLS_QUICKSTEP_APPTRANS = "com.huawei.android.launcher.QuickstepAppTransitionManagerImpl";
    static final String CLS_APPTRANS_IMPL = "com.huawei.android.launcher.LauncherAppTransitionManagerImpl";
    static final String CLS_BACK_HOME_RUNNER = "com.huawei.android.launcher.exitapp.BackHomeRemoteAnimRunner";
    static final String CLS_RETURN_HOME_ANIM = "com.huawei.android.launcher.exitapp.ReturnToHomeAnim";
    static final String CLS_UTILITIES = "com.huawei.android.launcher.Utilities";

    static final String ID_HOTSEAT = "hotseat";
    static final String ID_DOCK_DIVIDER = "dock_divider";
    static final String ID_DRAG_LAYER = "drag_layer";
    static final String ID_ROOT_VIEW = "launcher_root_view";

    private static final String TAG = "[OneKey][Blur] ";

    // ---------------- 可调参数 ----------------
    private static final long OUT_VETO_MS = 550L;
    /** 渐入完成后自检，避免桌面卡在模糊态（app 启动失败/悬浮窗等异常路径）。 */
    private static final long WATCHDOG_DELAY_MS = 1100L;
    private static final long WALLPAPER_MIN_INTERVAL_MS = 45L;
    private static final long REASSERT_MIN_INTERVAL_MS = 100L;
    private static final float MIN_VISIBLE_RADIUS = 0.6f;
    private static final long TARGET_CACHE_MS = 400L;
    private static final int WALLPAPER_MAX_RADIUS = 100;
    private static final long WALLPAPER_FETCH_MIN_INTERVAL_MS = 20000L;
    private static final long SYNC_MIN_MS = 150L;
    /**
     * 采纳上限按方向分开：打开转场实测 370ms；返回转场主缩放实测 300ms。
     * 返回路径的 AnimatorSet 有时会把「延迟 + 收尾子动画」一起算进 getTotalDuration()，
     * 读出 600~800ms —— 那是总时长而不是视觉主时长，采纳会让模糊比动画慢一倍，必须丢掉。
     */
    private static final long SYNC_IN_MAX_MS = 520L;
    private static final long SYNC_OUT_MAX_MS = 460L;
    /** 打不开转场时长时的兜底时长（华为桌面主转场实测 300~370ms）。 */
    private static final long DEF_DURATION_IN_MS = 340L;
    private static final long DEF_DURATION_OUT_MS = 300L;
    /** 渐入/渐出重跑（对齐真实时长）时的最短剩余时长。 */
    private static final long MIN_RESYNC_MS = 110L;
    private static final int TIMELINE_MAX = 30;

    // ---------------- 运行时状态 ----------------
    private static Handler sUi;
    private static volatile ClassLoader sCl;

    private static float sCur = 0f;
    private static RenderEffect sEffect;
    private static ValueAnimator sAnim;
    private static boolean sAnimating;

    private static long sLastInMs = 0L;
    private static long sLastOutMs = 0L;
    private static long sNormalTransStartMs = 0L;
    /** 打开转场真实时长（composeViewLaunchAnimator 的 AnimatorSet）。 */
    private static long sInDurationMs = 0L;
    /** 返回桌面转场真实时长（createReturnToHomeAnim 的 AnimatorSet）。 */
    private static long sOutDurationMs = 0L;
    /** 当前动画的目标半径与启动时刻，用于「重复信号去抖」和「按剩余时长对齐重跑」。 */
    private static float sAnimTarget = -1f;
    private static long sAnimStartMs = 0L;

    private static final Map<View, Float> sApplied = new HashMap<>();
    private static List<View> sTargets = new ArrayList<>(4);
    private static long sTargetsMs = 0L;
    private static String sLastResolveFail = "";

    // 壁纸
    private static int sWallMode = 0; // 0=未探测 1=blur-behind 2=位图叠加 -1=不可用
    private static BitmapDrawable sWallDrawable;
    private static int sWallAlpha = -1;
    private static long sWallMs = 0L;
    private static long sWallFetchMs = 0L;
    private static volatile boolean sWallFetching = false;
    private static int sWallBehindApplied = -1;
    private static Drawable sOrigHostBg;
    private static boolean sOrigBgSaved = false;
    private static View sWallHost;

    // 逐帧复读
    private static ViewTreeObserver sVto;
    private static ViewTreeObserver.OnPreDrawListener sPreDraw;
    private static long sLastReassertMs = 0L;

    // 时间线
    private static final ArrayList<String> sTimeline = new ArrayList<>();
    private static long sTimelineT0 = 0L;
    private static int sInCount = 0;
    private static int sOutCount = 0;
    private static int sVetoCount = 0;

    private static WeakReference<Activity> sLauncherRef;
    private static Method sMLauncher, sMWorkspace, sMHotseat, sMQuickNavi, sMDragLayer;

    /**
     * 渐入曲线：快起长尾（模糊在 app 放大前段就压上来，收尾拉长），
     * 与 ColorOS 打开转场的 fast-out-extra-slow-in 观感一致。
     */
    private static final PathInterpolator CURVE_IN = new PathInterpolator(0.18f, 0f, 0.2f, 1f);
    /** 渐出曲线：标准 fast-out-slow-in，随 app 缩小把模糊化开。 */
    private static final PathInterpolator CURVE_OUT = new PathInterpolator(0.4f, 0f, 0.2f, 1f);

    // ---------------- 定时任务 ----------------

    private static final Runnable sWatchdog = new Runnable() {
        @Override
        public void run() {
            try {
                if (sCur <= MIN_VISIBLE_RADIUS) {
                    return;
                }
                if (now() - sLastInMs < OUT_VETO_MS) {
                    return;
                }
                Activity a = launcher();
                if (a != null && a.hasWindowFocus()) {
                    record("WATCHDOG", "桌面已获焦点但仍有残留模糊");
                    log("看门狗：桌面已获得焦点但仍有残留模糊，强制渐出");
                    doBlurOut(220L, "watchdog");
                }
            } catch (Throwable ignore) {
            }
        }
    };

    private static final Runnable sVetoRecheck = new Runnable() {
        @Override
        public void run() {
            try {
                if (sCur <= MIN_VISIBLE_RADIUS) {
                    return;
                }
                if (now() - sLastInMs < OUT_VETO_MS) {
                    scheduleVetoRecheck();
                    return;
                }
                Activity a = launcher();
                if (a != null && a.hasWindowFocus()) {
                    record("OUT", "否决复检·桌面已获焦点");
                    log("○ 否决复检：桌面确实已回到前台，补做渐出");
                    doBlurOut(durationOut(), "veto复检");
                } else {
                    record("KEEP", "否决复检·app 仍在前台");
                    log("○ 否决复检：桌面未获焦点，判定 app 确实在前台，保持模糊");
                }
            } catch (Throwable ignore) {
            }
        }
    };

    // ---------------- 基础设施 ----------------

    private static Handler ui() {
        Handler h = sUi;
        if (h == null) {
            h = new Handler(Looper.getMainLooper());
            sUi = h;
        }
        return h;
    }

    private static long now() {
        return SystemClock.uptimeMillis();
    }

    public static void init(ClassLoader cl) {
        sCl = cl;
        log("模糊引擎已初始化，当前状态：" + (BlurCfg.enabled() ? "开" : "关")
                + " 半径=" + BlurCfg.radius());
    }

    private static float radius() {
        return Math.max(1f, BlurCfg.radius());
    }

    /** 渐入时长：打开转场实测值优先，没有就用兜底。 */
    private static long durationIn() {
        if (sInDurationMs >= SYNC_MIN_MS && sInDurationMs <= SYNC_IN_MAX_MS) {
            return sInDurationMs;
        }
        return DEF_DURATION_IN_MS;
    }

    /** 渐出时长：返回桌面转场实测值优先，没有就用兜底。 */
    private static long durationOut() {
        if (sOutDurationMs >= SYNC_MIN_MS && sOutDurationMs <= SYNC_OUT_MAX_MS) {
            return sOutDurationMs;
        }
        return DEF_DURATION_OUT_MS;
    }

    // ---------------- 时间线 ----------------

    private static void record(String kind, String why) {
        long n = now();
        synchronized (sTimeline) {
            if (sTimelineT0 == 0L) {
                sTimelineT0 = n;
            }
            sTimeline.add(String.format("%7dms %-8s r=%-3d %s",
                    Long.valueOf(n - sTimelineT0), kind, Integer.valueOf((int) sCur), why));
            while (sTimeline.size() > TIMELINE_MAX) {
                sTimeline.remove(0);
            }
        }
        if ("IN".equals(kind)) {
            sInCount++;
        } else if ("OUT".equals(kind)) {
            sOutCount++;
        } else if ("VETO".equals(kind)) {
            sVetoCount++;
        }
    }

    public static void dumpTimeline(String reason) {
        List<String> copy;
        synchronized (sTimeline) {
            copy = new ArrayList<>(sTimeline);
        }
        log("┌─ 信号时间线（" + reason + "）：渐入" + sInCount + " 渐出" + sOutCount
                + " 否决" + sVetoCount + " ─");
        for (int i = 0; i < copy.size(); i++) {
            log("│ " + copy.get(i));
        }
        log("└─ " + dumpState());
    }

    // ---------------- 对外信号入口 ----------------

    /** 应用正在打开 → 模糊渐入（强信号：刷新否决窗口）。 */
    public static void signalAppOpening(String why) {
        signalAppOpening(why, false);
    }

    /**
     * 应用正在打开 → 模糊渐入。
     *
     * @param weak true = 来自状态机（BACKGROUND_APP / QUICK_SWITCH）的<b>弱信号</b>：
     *             只保证「模糊还在」，<b>不刷新否决窗口</b>。
     *             状态机回调经常在转场结束后才到（实测可达 1~2 秒），
     *             若拿它当「刚打开」的依据，用户随后返回桌面时的渐出会被误否决，
     *             表现就是「图标都回原位了，模糊还要糊好几秒」。
     */
    public static void signalAppOpening(String why, boolean weak) {
        if (!BlurCfg.enabled()) {
            releaseIfNeeded("disabled-in");
            return;
        }
        long dur = durationIn();
        if (!weak) {
            sLastInMs = now();
            ui().removeCallbacks(sVetoRecheck);
        }
        ui().removeCallbacks(sWatchdog);
        ui().postDelayed(sWatchdog, WATCHDOG_DELAY_MS + dur);
        record("IN", weak ? why + "(弱)" : why);
        if (isAnimatingTo(radius(), dur)) {
            return;
        }
        log("● 模糊渐入 ← " + why + "（r=" + (int) sCur + "→" + (int) radius()
                + "，" + dur + "ms，targets=" + sTargets.size() + "）");
        animateTo(radius(), dur, "IN:" + why, false);
    }

    /** 桌面正在显示 → 模糊渐出（兜底信号的闸口，带打断否决）。 */
    public static void signalLauncherShowing(String why) {
        if (!BlurCfg.enabled()) {
            releaseIfNeeded("disabled-out");
            return;
        }
        long n = now();
        sLastOutMs = n;
        if (sCur <= MIN_VISIBLE_RADIUS) {
            return;
        }
        long sinceIn = sLastInMs > 0L ? n - sLastInMs : Long.MAX_VALUE;
        if (sinceIn < OUT_VETO_MS) {
            record("VETO", why + "（距打开信号 " + sinceIn + "ms）");
            log("○ 否决渐出 ← " + why + "：距上次打开信号仅 " + sinceIn + "ms，判定为打断竞态");
            scheduleVetoRecheck();
            return;
        }
        fadeOut(why, false);
    }

    /**
     * 转场驱动的「app 正在关闭」信号 —— <b>不做否决，立刻渐出</b>。
     *
     * <p>{@code ReturnToHomeAnim} / {@code BackHomeRemoteAnimRunner} 是华为自己「返回桌面动画开始」的
     * 确定性回调，语义等同于「app 正在关闭」，不存在「迟到误报」。之前把它们也塞进 750ms 否决窗口，
     * 结果：刚打开过 app 再返回时，渐出被挡 → 只能等复检（+750ms）甚至看门狗（+1.8s），
     * 表现就是「图标早回原位了，模糊还糊着好几秒」。
     *
     * <p>打断场景（开 A→返回→开 B）不受影响：真实返回本来就该渐出，之后 B 的渐入会再压回来。
     */
    public static void signalLauncherShowingTrusted(String why) {
        if (!BlurCfg.enabled()) {
            releaseIfNeeded("disabled-out");
            return;
        }
        sLastOutMs = now();
        if (sCur <= MIN_VISIBLE_RADIUS) {
            return;
        }
        // 保护：120ms 内刚启动渐入 —— 说明这是「app 打开」转场被误判成关闭，别把模糊抹掉。
        if (sAnimating && sAnimTarget > MIN_VISIBLE_RADIUS && now() - sAnimStartMs < 120L) {
            log("·转场渐出信号与刚启动的渐入冲突，忽略 ← " + why);
            return;
        }
        fadeOut(why, true);
    }

    private static void fadeOut(String why, boolean trusted) {
        long dur = durationOut();
        record("OUT", trusted ? why + "(转场)" : why);
        if (isAnimatingTo(0f, dur)) {
            return;
        }
        log("○ 模糊渐出 ← " + why + "（r=" + (int) sCur + "→0，" + dur + "ms"
                + (trusted ? "，转场驱动" : "") + "）");
        animateTo(0f, dur, "OUT:" + why, false);
    }

    /** 已经在朝同一个目标跑、且还没跑过一半 —— 重复信号直接忽略，避免把总时长叠长。 */
    private static boolean isAnimatingTo(float target, long dur) {
        if (!sAnimating || sAnim == null) {
            return false;
        }
        if (Math.abs(sAnimTarget - target) >= 0.5f) {
            return false;
        }
        return now() - sAnimStartMs < Math.max(MIN_RESYNC_MS, dur / 2);
    }

    private static void doBlurOut(long dur, String why) {
        animateTo(0f, dur, "OUT:" + why, false);
    }

    private static void scheduleVetoRecheck() {
        long delay = Math.max(60L, (sLastInMs + OUT_VETO_MS + 80L) - now());
        ui().removeCallbacks(sVetoRecheck);
        ui().postDelayed(sVetoRecheck, delay);
    }

    /** 开关键关掉后，若还残留模糊就立刻清掉。 */
    private static void releaseIfNeeded(String why) {
        if (sCur > MIN_VISIBLE_RADIUS) {
            log("模糊已关闭，清除残留（" + why + "）");
            animateTo(0f, 180L, "OUT:disabled", true);
        }
    }

    public static void onStateTransitionStart(int ordinal) {
        if (ordinal == 0) {
            sNormalTransStartMs = now();
        } else if (ordinal == 6 || ordinal == 7) {
            // BACKGROUND_APP / QUICK_SWITCH：桌面被 app 盖住。
            // 用弱信号：状态机这条回调常在转场结束后 1~2 秒才到，不能拿它刷新否决窗口。
            signalAppOpening("state→" + ordinal, true);
        }
    }

    public static void onStateTransitionEnd(int ordinal) {
        if (ordinal != 0) {
            return;
        }
        if (sNormalTransStartMs > 0L && sNormalTransStartMs < sLastInMs) {
            record("VETO", "state→NORMAL（转换起点早于打开信号）");
            log("○ 否决 state→NORMAL 渐出：该转换开始于最近一次打开信号之前，判定为迟到回调");
            scheduleVetoRecheck();
        } else {
            signalLauncherShowing("state→NORMAL");
        }
    }

    /**
     * 读转场 AnimatorSet 的真实时长，让模糊渐变与 app 缩放严格同速。
     *
     * <p>v1.4.1 关键修正：<b>打开与返回两条转场的时长分开存</b>。
     * 之前共用一个变量，打开（实测 370ms）会把返回（实测 300ms）的时长污染掉，
     * 结果「关闭 app 时模糊比动画慢 70ms / 打开时又提前清晰」—— 这就是「速度不对」的根因。
     *
     * @param incoming true=打开转场（渐入），false=返回桌面转场（渐出）
     */
    public static void syncDurationFromTransition(Object animatorSet, String why, boolean incoming) {
        long d = totalDurationMs(animatorSet);
        if (d <= 0L) {
            log("⚠ 转场时长读不到（" + why + "），保留 " + (incoming ? durationIn() : durationOut()) + "ms");
            return;
        }
        long max = incoming ? SYNC_IN_MAX_MS : SYNC_OUT_MAX_MS;
        if (d < SYNC_MIN_MS || d > max) {
            log("转场时长 " + d + "ms 超出采纳区间 " + SYNC_MIN_MS + "~" + max
                    + "ms，保留 " + (incoming ? durationIn() : durationOut()) + "ms ← " + why);
            return;
        }
        if (incoming) {
            if (d == sInDurationMs) {
                return;
            }
            sInDurationMs = d;
            log("渐入时长对齐转场：" + d + "ms ← " + why);
            resyncIfRunning(radius(), d, "IN-resync");
        } else {
            if (d == sOutDurationMs) {
                return;
            }
            sOutDurationMs = d;
            log("渐出时长对齐转场：" + d + "ms ← " + why);
            resyncIfRunning(0f, d, "OUT-resync");
        }
    }

    /**
     * 转场时长是转场走到一半才拿到的，此时动画已经用旧时长跑了几十毫秒。
     * 这里按「真实时长 - 已走时长」重跑剩余部分，保证总时长严格等于转场时长，
     * 而不是「已走 40ms + 全时长 370ms」那样整体被拉长。
     */
    private static void resyncIfRunning(float target, long d, String why) {
        if (!sAnimating || sAnim == null || sAnimStartMs <= 0L) {
            return;
        }
        if (Math.abs(sAnimTarget - target) >= 0.5f) {
            return;
        }
        if (Math.abs(sCur - target) < 0.8f) {
            return;
        }
        long elapsed = now() - sAnimStartMs;
        long remain = d - elapsed;
        if (remain < MIN_RESYNC_MS) {
            remain = MIN_RESYNC_MS;
        }
        log("按剩余时长重跑：" + remain + "ms（已走 " + elapsed + "ms / 目标 " + d + "ms）← " + why);
        animateTo(target, remain, why, true);
    }

    /** 转场 AnimatorSet 的总时长（getTotalDuration 拿不到时递归子动画累加）。 */
    private static long totalDurationMs(Object o) {
        try {
            if (!(o instanceof Animator)) {
                return -1L;
            }
            Animator a = (Animator) o;
            long d = a.getTotalDuration();
            if (d > 0L) {
                return d;
            }
            if (a instanceof AnimatorSet) {
                long max = -1L;
                ArrayList<Animator> kids = new ArrayList<>(((AnimatorSet) a).getChildAnimations());
                for (int i = 0; i < kids.size(); i++) {
                    Animator kid = kids.get(i);
                    long kd = totalDurationMs(kid);
                    if (kd < 0L) {
                        kd = 0L;
                    }
                    long end = Math.max(0L, kid.getStartDelay()) + kd;
                    if (end > max) {
                        max = end;
                    }
                }
                if (max > 0L) {
                    return max;
                }
            }
            long self = a.getDuration();
            return self > 0L ? self + Math.max(0L, a.getStartDelay()) : -1L;
        } catch (Throwable t) {
            return -1L;
        }
    }

    public static void clearNow() {
        ui().removeCallbacks(sWatchdog);
        ui().removeCallbacks(sVetoRecheck);
        ui().post(new Runnable() {
            @Override
            public void run() {
                if (sAnim != null) {
                    sAnim.removeAllUpdateListeners();
                    sAnim.removeAllListeners();
                    sAnim.cancel();
                    sAnim = null;
                }
                sAnimating = false;
                apply(0f);
                uninstallPreDraw();
            }
        });
    }

    // ---------------- 渐变引擎 ----------------

    /**
     * 渐变引擎。
     *
     * @param force true = 时长对齐重跑（允许打断同向动画）；false = 同向动画进行中时忽略重复信号
     */
    private static void animateTo(final float target, long dur, final String why, final boolean force) {
        final long d = Math.max(1L, dur);
        ui().post(new Runnable() {
            @Override
            public void run() {
                try {
                    // 去抖：多个信号会在同一帧里排队进来（如 onResume + onWindowFocusChanged），
                    // 若每次都 cancel 重跑，总时长会被叠成「已走 + 全时长」，观感就是「动画变慢」。
                    if (!force && sAnimating && sAnim != null
                            && Math.abs(sAnimTarget - target) < 0.5f
                            && now() - sAnimStartMs < Math.max(MIN_RESYNC_MS, d / 2)) {
                        if (BlurCfg.enabled()) {
                            log("·重复信号已忽略（同向动画已走 " + (now() - sAnimStartMs) + "ms / " + d
                                    + "ms）← " + why);
                        }
                        return;
                    }
                    if (sAnim != null) {
                        sAnim.removeAllUpdateListeners();
                        sAnim.removeAllListeners();
                        sAnim.cancel();
                        sAnim = null;
                    }
                    float from = sCur;
                    if (Math.abs(target - from) < 0.5f) {
                        sAnimating = false;
                        sAnimTarget = target;
                        apply(target);
                        return;
                    }
                    installPreDraw();
                    sAnimating = true;
                    sAnimTarget = target;
                    sAnimStartMs = now();
                    final boolean outgoing = target <= MIN_VISIBLE_RADIUS;
                    ValueAnimator va = ValueAnimator.ofFloat(from, target);
                    va.setDuration(d);
                    va.setInterpolator(outgoing ? CURVE_OUT : CURVE_IN);
                    va.addUpdateListener(new ValueAnimator.AnimatorUpdateListener() {
                        @Override
                        public void onAnimationUpdate(ValueAnimator a) {
                            Object v = a.getAnimatedValue();
                            if (v instanceof Float) {
                                apply(((Float) v).floatValue());
                            }
                        }
                    });
                    va.addListener(new AnimatorListenerAdapter() {
                        @Override
                        public void onAnimationEnd(Animator a) {
                            sAnimating = false;
                            apply(target);
                            sAnim = null;
                            if (target <= MIN_VISIBLE_RADIUS) {
                                uninstallPreDraw();
                            }
                        }
                    });
                    sAnim = va;
                    va.start();
                } catch (Throwable t) {
                    sAnimating = false;
                    log("animateTo 失败(" + why + "): " + t);
                    apply(target);
                }
            }
        });
    }

    private static void apply(float r) {
        sCur = r;
        if (r > MIN_VISIBLE_RADIUS) {
            try {
                sEffect = RenderEffect.createBlurEffect(r, r, Shader.TileMode.CLAMP);
            } catch (Throwable t) {
                log("createBlurEffect(r=" + r + ") 失败: " + t);
                return;
            }
        } else {
            sEffect = null;
        }
        List<View> ts = targets();
        List<View> hit = new ArrayList<>(ts.size());
        for (int i = 0; i < ts.size(); i++) {
            View v = ts.get(i);
            try {
                v.setRenderEffect(sEffect);
                sApplied.put(v, Float.valueOf(r));
                hit.add(v);
            } catch (Throwable t) {
                log("setRenderEffect 失败 " + name(v) + ": " + t);
            }
        }
        if (!sApplied.isEmpty()) {
            Iterator<Map.Entry<View, Float>> it = sApplied.entrySet().iterator();
            while (it.hasNext()) {
                Map.Entry<View, Float> e = it.next();
                if (!hit.contains(e.getKey())) {
                    try {
                        e.getKey().setRenderEffect(null);
                    } catch (Throwable ignore) {
                    }
                    it.remove();
                }
            }
        }
        applyWallpaper(r);
        if (ts.isEmpty()) {
            log("⚠ 模糊目标为空，本次施加无效：" + sLastResolveFail);
        }
    }

    // ---------------- 逐帧复读 ----------------

    private static void installPreDraw() {
        if (sPreDraw != null) {
            return;
        }
        try {
            Activity a = launcher();
            if (a == null) {
                return;
            }
            View dl = dragLayer(a);
            if (dl == null) {
                return;
            }
            ViewTreeObserver vto = dl.getViewTreeObserver();
            if (vto == null || !vto.isAlive()) {
                return;
            }
            sPreDraw = new ViewTreeObserver.OnPreDrawListener() {
                @Override
                public boolean onPreDraw() {
                    try {
                        if (sCur <= MIN_VISIBLE_RADIUS) {
                            return true;
                        }
                        long n = now();
                        if (sAnimating || n - sLastReassertMs < REASSERT_MIN_INTERVAL_MS) {
                            return true;
                        }
                        sLastReassertMs = n;
                        RenderEffect eff = sEffect;
                        List<View> ts = targets();
                        for (int i = 0; i < ts.size(); i++) {
                            ts.get(i).setRenderEffect(eff);
                        }
                        reassertWallpaper();
                    } catch (Throwable ignore) {
                    }
                    return true;
                }
            };
            vto.addOnPreDrawListener(sPreDraw);
            sVto = vto;
        } catch (Throwable t) {
            log("installPreDraw 失败: " + t);
        }
    }

    private static void uninstallPreDraw() {
        if (sPreDraw == null) {
            return;
        }
        try {
            if (sVto != null && sVto.isAlive()) {
                sVto.removeOnPreDrawListener(sPreDraw);
            }
        } catch (Throwable ignore) {
        }
        sPreDraw = null;
        sVto = null;
    }

    // ---------------- 目标视图解析 ----------------

    /**
     * 目标 = Workspace（图标层）+ Hotseat（Dock 本体）+ QuickNavigationView（dock 分隔条）。
     * 刻意不糊 DragLayer：app 启动时放大飞出的 FloatingIconView 也在 DragLayer 下，
     * 糊上去会让那个本该清晰的图标一起变糊。
     */
    private static List<View> targets() {
        long n = now();
        if (n - sTargetsMs < TARGET_CACHE_MS && targetsValid(sTargets)) {
            return sTargets;
        }
        List<View> list = resolve();
        sTargets = list;
        sTargetsMs = n;
        return list;
    }

    private static boolean targetsValid(List<View> list) {
        if (list.isEmpty()) {
            return false;
        }
        for (int i = 0; i < list.size(); i++) {
            View v = list.get(i);
            if (v == null || !v.isAttachedToWindow()) {
                return false;
            }
        }
        return true;
    }

    private static List<View> resolve() {
        List<View> out = new ArrayList<>(4);
        StringBuilder fail = new StringBuilder();
        try {
            Activity a = launcher();
            if (a == null) {
                sLastResolveFail = "Launcher.getLauncher() 返回 null（桌面 Activity 还没建好？）";
                return out;
            }
            add(out, call(a, mWorkspace(), "getWorkspace"), "getWorkspace", fail);
            add(out, call(a, mHotseat(), "getHotseat"), "getHotseat", fail);
            add(out, call(a, mQuickNavi(), "getQuickNaviView"), "getQuickNaviView", fail);
            if (out.size() < 2) {
                addById(out, a, ID_HOTSEAT);
                addById(out, a, ID_DOCK_DIVIDER);
            }
            if (out.isEmpty()) {
                add(out, dragLayer(a), "getDragLayer", fail);
                if (!out.isEmpty()) {
                    fail.append(" 已退化到 DragLayer 兜底");
                }
            }
        } catch (Throwable t) {
            fail.append(" 异常:").append(t);
        }
        sLastResolveFail = fail.length() == 0 ? "ok" : fail.toString();
        return out;
    }

    private static void add(List<View> out, Object o, String how, StringBuilder fail) {
        if (!(o instanceof View)) {
            fail.append(how).append("=非View/null; ");
            return;
        }
        View v = (View) o;
        if (out.contains(v)) {
            return;
        }
        if (!v.isAttachedToWindow()) {
            fail.append(how).append("=未attach; ");
            return;
        }
        out.add(v);
    }

    private static void addById(List<View> out, Activity a, String idName) {
        try {
            int id = resId(a, idName);
            if (id == 0) {
                return;
            }
            Window w = a.getWindow();
            View root = w != null ? w.getDecorView() : null;
            if (root != null) {
                View v = root.findViewById(id);
                if (v != null && v.isAttachedToWindow() && !out.contains(v)) {
                    out.add(v);
                }
            }
        } catch (Throwable ignore) {
        }
    }

    private static View dragLayer(Activity a) {
        Object o = call(a, mDragLayer(), "getDragLayer");
        if (o instanceof View) {
            return (View) o;
        }
        try {
            int id = resId(a, ID_DRAG_LAYER);
            Window w = a != null ? a.getWindow() : null;
            if (id != 0 && w != null) {
                return w.getDecorView().findViewById(id);
            }
        } catch (Throwable ignore) {
        }
        return null;
    }

    private static int resId(Activity a, String name) {
        try {
            return a.getResources().getIdentifier(name, "id", "com.huawei.android.launcher");
        } catch (Throwable t) {
            return 0;
        }
    }

    private static Object call(Activity a, Method m, String name) {
        if (m != null) {
            try {
                return m.invoke(a);
            } catch (Throwable ignore) {
            }
        }
        try {
            return XposedHelpers.callMethod(a, name, new Object[0]);
        } catch (Throwable ignore) {
            return null;
        }
    }

    private static Method mWorkspace() {
        if (sMWorkspace == null) {
            sMWorkspace = find(CLS_LAUNCHER, "getWorkspace");
        }
        return sMWorkspace;
    }

    private static Method mHotseat() {
        if (sMHotseat == null) {
            sMHotseat = find(CLS_LAUNCHER, "getHotseat");
        }
        return sMHotseat;
    }

    private static Method mQuickNavi() {
        if (sMQuickNavi == null) {
            sMQuickNavi = find(CLS_LAUNCHER, "getQuickNaviView");
        }
        return sMQuickNavi;
    }

    private static Method mDragLayer() {
        if (sMDragLayer == null) {
            sMDragLayer = find(CLS_LAUNCHER, "getDragLayer");
        }
        return sMDragLayer;
    }

    private static Method find(String cls, String method) {
        try {
            Class<?> c = XposedHelpers.findClass(cls, sCl);
            Method m = c.getMethod(method, new Class[0]);
            m.setAccessible(true);
            return m;
        } catch (Throwable t) {
            return null;
        }
    }

    static Activity launcher() {
        Activity cached = sLauncherRef != null ? sLauncherRef.get() : null;
        if (cached != null && !cached.isFinishing() && !cached.isDestroyed()) {
            return cached;
        }
        try {
            if (sMLauncher == null) {
                Class<?> c = XposedHelpers.findClass(CLS_LAUNCHER, sCl);
                sMLauncher = c.getMethod("getLauncher", new Class[0]);
                sMLauncher.setAccessible(true);
            }
            Object o = sMLauncher.invoke(null, new Object[0]);
            if (o instanceof Activity) {
                Activity a = (Activity) o;
                sLauncherRef = new WeakReference<>(a);
                return a;
            }
        } catch (Throwable ignore) {
        }
        return null;
    }

    // ---------------- 壁纸（背景）模糊 ----------------

    private static void applyWallpaper(float r) {
        boolean want = BlurCfg.enabled();
        if (!want) {
            if (sWallMode == 1) {
                setBlurBehind(0);
            } else if (sWallMode == 2) {
                setWallAlpha(0);
            }
            return;
        }
        if (sWallMode == 0) {
            sWallMode = probeWallpaperMode();
        }
        if (sWallMode == 1) {
            int target = r > MIN_VISIBLE_RADIUS ? Math.min(WALLPAPER_MAX_RADIUS, Math.round(r)) : 0;
            if (target == sWallBehindApplied) {
                return;
            }
            long n = now();
            if (target != 0 && n - sWallMs < WALLPAPER_MIN_INTERVAL_MS) {
                return;
            }
            sWallMs = n;
            setBlurBehind(target);
        } else if (sWallMode == 2) {
            setWallAlpha(r <= MIN_VISIBLE_RADIUS ? 0 : Math.round(255f * Math.min(1f, r / radius())));
        }
    }

    private static int probeWallpaperMode() {
        try {
            Activity a = launcher();
            if (a != null) {
                WindowManager wm = a.getWindowManager();
                if (wm != null && wm.isCrossWindowBlurEnabled()) {
                    log("壁纸模糊方案：跨窗口 blur-behind（实时）");
                    return 1;
                }
            }
        } catch (Throwable ignore) {
        }
        log("壁纸模糊方案：系统未开启跨窗口模糊，改用位图叠加");
        return 2;
    }

    private static void setBlurBehind(int radiusPx) {
        try {
            Activity a = launcher();
            if (a == null) {
                return;
            }
            Window w = a.getWindow();
            if (w == null) {
                return;
            }
            WindowManager.LayoutParams lp = w.getAttributes();
            if (lp == null) {
                return;
            }
            if (radiusPx > 0) {
                lp.flags |= WindowManager.LayoutParams.FLAG_BLUR_BEHIND;
                lp.setBlurBehindRadius(radiusPx);
            } else {
                lp.flags &= ~WindowManager.LayoutParams.FLAG_BLUR_BEHIND;
                lp.setBlurBehindRadius(0);
            }
            w.setAttributes(lp);
            sWallBehindApplied = radiusPx;
        } catch (Throwable t) {
            log("blur-behind 失败，改用位图叠加: " + t);
            sWallMode = 2;
            sWallBehindApplied = 0;
            applyWallpaper(sCur);
        }
    }

    /**
     * 位图叠加：alpha 0=透明（露出真壁纸），255=完全用模糊壁纸盖住。
     * 载体用 DecorView（覆盖整个窗口），bounds 取真实屏幕尺寸，避免四周留一圈清晰壁纸。
     */
    private static void setWallAlpha(int alpha) {
        try {
            if (alpha > 0 && sWallDrawable == null) {
                fetchWallpaperAsync();
                return;
            }
            if (sWallDrawable == null) {
                return;
            }
            Activity a = launcher();
            View host = wallpaperHost(a);
            if (host == null) {
                return;
            }
            if (alpha == sWallAlpha && host == sWallHost) {
                reassertWallpaper();
                return;
            }
            sWallAlpha = alpha;
            sWallHost = host;
            int w = Math.max(1, screenW(a, host.getWidth()));
            int h = Math.max(1, screenH(a, host.getHeight()));
            if (alpha > 0) {
                if (!sOrigBgSaved) {
                    sOrigHostBg = host.getBackground();
                    sOrigBgSaved = true;
                }
                sWallDrawable.setAlpha(alpha);
                sWallDrawable.setBounds(0, 0, w, h);
                if (host.getBackground() != sWallDrawable) {
                    host.setBackground(sWallDrawable);
                }
            } else {
                sWallDrawable.setAlpha(0);
                if (sOrigBgSaved) {
                    host.setBackground(sOrigHostBg);
                }
            }
            host.invalidate();
        } catch (Throwable t) {
            log("壁纸叠加失败: " + t);
        }
    }

    private static View wallpaperHost(Activity a) {
        if (a == null) {
            return null;
        }
        try {
            Window w = a.getWindow();
            if (w != null && w.getDecorView() != null) {
                return w.getDecorView();
            }
        } catch (Throwable ignore) {
        }
        return dragLayer(a);
    }

    private static int screenW(Activity a, int fallback) {
        Rect b = screenBounds(a);
        int v = b != null ? b.width() : 0;
        return v > 0 ? v : fallback;
    }

    private static int screenH(Activity a, int fallback) {
        Rect b = screenBounds(a);
        int v = b != null ? b.height() : 0;
        return v > 0 ? v : fallback;
    }

    private static Rect screenBounds(Activity a) {
        if (a == null) {
            return null;
        }
        try {
            return a.getWindowManager().getMaximumWindowMetrics().getBounds();
        } catch (Throwable ignore) {
        }
        try {
            android.util.DisplayMetrics dm = a.getResources().getDisplayMetrics();
            return new Rect(0, 0, dm.widthPixels, dm.heightPixels);
        } catch (Throwable ignore) {
            return null;
        }
    }

    private static void reassertWallpaper() {
        try {
            if (sWallDrawable == null || sWallAlpha <= 0 || sWallHost == null) {
                return;
            }
            if (sWallHost.getBackground() != sWallDrawable) {
                Activity a = launcher();
                int w = Math.max(1, screenW(a, sWallHost.getWidth()));
                int h = Math.max(1, screenH(a, sWallHost.getHeight()));
                sWallDrawable.setBounds(0, 0, w, h);
                sWallHost.setBackground(sWallDrawable);
                sWallHost.invalidate();
            }
        } catch (Throwable ignore) {
        }
    }

    /** 后台取「已模糊的壁纸位图」，三级兜底。 */
    private static void fetchWallpaperAsync() {
        if (sWallFetching) {
            return;
        }
        long n = now();
        if (sWallDrawable != null && n - sWallFetchMs < WALLPAPER_FETCH_MIN_INTERVAL_MS) {
            return;
        }
        final Activity a = launcher();
        if (a == null) {
            return;
        }
        sWallFetching = true;
        Thread t = new Thread(new Runnable() {
            @Override
            public void run() {
                Bitmap bmp = callHuaweiWallpaper(a, "getBigBlurWallpaperCache");
                String how = bmp != null ? "Utilities.getBigBlurWallpaperCache" : null;
                if (bmp == null) {
                    try {
                        Class<?> u = XposedHelpers.findClass(CLS_UTILITIES, sCl);
                        Method m = u.getMethod("getBlurWallpaperCache",
                                XposedHelpers.findClass(CLS_LAUNCHER, sCl));
                        Object d = m.invoke(null, a);
                        if (d instanceof BitmapDrawable) {
                            bmp = ((BitmapDrawable) d).getBitmap();
                            if (bmp != null) {
                                how = "Utilities.getBlurWallpaperCache";
                            }
                        }
                    } catch (Throwable ignore) {
                    }
                }
                if (bmp == null) {
                    try {
                        Drawable d = WallpaperManager.getInstance(a).getDrawable();
                        if (d instanceof BitmapDrawable) {
                            Bitmap src = ((BitmapDrawable) d).getBitmap();
                            if (src != null && !src.isRecycled()) {
                                bmp = Bitmap.createScaledBitmap(src,
                                        Math.max(1, src.getWidth() / 12),
                                        Math.max(1, src.getHeight() / 12), true);
                                how = "WallpaperManager + 降采样";
                            }
                        }
                    } catch (Throwable ignore) {
                    }
                }
                final Bitmap fb = bmp;
                final String fhow = how;
                ui().post(new Runnable() {
                    @Override
                    public void run() {
                        sWallFetching = false;
                        sWallFetchMs = now();
                        if (fb == null || fb.isRecycled()) {
                            sWallMode = -1;
                            log("⚠ 壁纸模糊不可用：三条取图路径都拿不到壁纸位图（图标/Dock 模糊不受影响）");
                            return;
                        }
                        Resources res = a.getResources();
                        BitmapDrawable bd = res != null ? new BitmapDrawable(res, fb) : new BitmapDrawable(fb);
                        bd.setFilterBitmap(true);
                        bd.setGravity(Gravity.FILL);
                        sWallDrawable = bd;
                        sWallAlpha = -1;
                        sOrigBgSaved = false;
                        log("壁纸模糊已就绪：" + fhow + "（" + fb.getWidth() + "x" + fb.getHeight()
                                + "，铺满 " + screenW(a, 0) + "x" + screenH(a, 0) + "）");
                        apply(sCur);
                    }
                });
            }
        }, "OneKey-blur-wallpaper");
        t.setPriority(Thread.NORM_PRIORITY - 1);
        t.start();
    }

    private static Bitmap callHuaweiWallpaper(Activity a, String method) {
        try {
            Class<?> u = XposedHelpers.findClass(CLS_UTILITIES, sCl);
            Class<?> lc = XposedHelpers.findClass(CLS_LAUNCHER, sCl);
            int w = 1080, h = 2340;
            try {
                android.util.DisplayMetrics dm = a.getResources().getDisplayMetrics();
                w = Math.max(1, dm.widthPixels);
                h = Math.max(1, dm.heightPixels);
            } catch (Throwable ignore) {
            }
            Method m = u.getMethod(method, lc, int.class, int.class);
            Object o = m.invoke(null, a, Integer.valueOf(Math.max(1, w / 8)), Integer.valueOf(Math.max(1, h / 8)));
            if (o instanceof Bitmap) {
                Bitmap b = (Bitmap) o;
                return b.isRecycled() ? null : b;
            }
            if (o instanceof BitmapDrawable) {
                Bitmap b = ((BitmapDrawable) o).getBitmap();
                return b != null && !b.isRecycled() ? b : null;
            }
        } catch (Throwable t) {
            log("调用 Utilities." + method + " 失败: " + t);
        }
        return null;
    }

    // ---------------- 诊断 ----------------

    private static String name(View v) {
        if (v == null) {
            return "null";
        }
        String s = v.getClass().getName();
        int i = s.lastIndexOf('.');
        return i >= 0 ? s.substring(i + 1) : s;
    }

    static void log(String msg) {
        try {
            XposedBridge.log(TAG + msg);
        } catch (Throwable ignore) {
        }
    }

    public static String dumpState() {
        String wm = sWallMode == 1 ? "blur-behind(" + sWallBehindApplied + ")"
                : sWallMode == 2 ? (sWallDrawable != null ? "位图叠加(α=" + sWallAlpha + ")" : "位图叠加(取图中)")
                : sWallMode == -1 ? "不可用" : "未探测";
        return "cur=" + (int) sCur + " targets=" + sTargets.size()
                + " wallpaper=" + wm + " host=" + name(sWallHost)
                + " preDraw=" + (sPreDraw != null)
                + " inDur=" + durationIn() + " outDur=" + durationOut()
                + " animating=" + sAnimating + " animTarget=" + (int) sAnimTarget
                + " sinceIn=" + (now() - sLastInMs) + "ms";
    }

    public static void logTargetsOnce() {
        try {
            List<View> list = resolve();
            StringBuilder sb = new StringBuilder("模糊目标视图: ");
            if (list.isEmpty()) {
                sb.append("（空！）原因: ").append(sLastResolveFail);
            } else {
                for (int i = 0; i < list.size(); i++) {
                    View v = list.get(i);
                    sb.append(name(v)).append('(').append(v.getWidth()).append('x').append(v.getHeight())
                            .append(" vis=").append(v.getVisibility());
                    if (v instanceof ViewGroup) {
                        sb.append(" 子=").append(((ViewGroup) v).getChildCount());
                    }
                    sb.append(')');
                    if (i < list.size() - 1) {
                        sb.append(" + ");
                    }
                }
            }
            log(sb.toString());
        } catch (Throwable t) {
            log("logTargetsOnce 失败: " + t);
        }
    }

    public static void logCoverage() {
        try {
            Activity a = launcher();
            if (a == null) {
                log("覆盖诊断：拿不到 Launcher 实例");
                return;
            }
            Rect sc = screenBounds(a);
            View decor = a.getWindow() != null ? a.getWindow().getDecorView() : null;
            View content = null;
            try {
                content = a.findViewById(android.R.id.content);
            } catch (Throwable ignore) {
            }
            View rootView = null;
            try {
                int id = resId(a, ID_ROOT_VIEW);
                if (id != 0 && decor != null) {
                    rootView = decor.findViewById(id);
                }
            } catch (Throwable ignore) {
            }
            View dl = dragLayer(a);
            log("覆盖诊断：屏幕=" + rect(sc) + " DecorView=" + rect(decor)
                    + " content=" + rect(content) + " LauncherRootView=" + rect(rootView)
                    + " DragLayer=" + rect(dl) + " 壁纸载体=" + name(wallpaperHost(a)));
        } catch (Throwable t) {
            log("logCoverage 失败: " + t);
        }
    }

    private static String rect(View v) {
        return v == null ? "无" : v.getWidth() + "x" + v.getHeight();
    }

    private static String rect(Rect r) {
        return r == null ? "无" : r.width() + "x" + r.height();
    }
}