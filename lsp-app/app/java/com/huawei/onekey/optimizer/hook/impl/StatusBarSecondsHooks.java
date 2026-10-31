package com.huawei.onekey.optimizer.hook.impl;

import android.content.Context;
import android.os.Handler;
import android.os.SystemClock;
import android.text.format.DateFormat;
import android.view.View;
import android.widget.TextView;

import java.lang.ref.WeakReference;
import java.lang.reflect.Method;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.callbacks.XC_LoadPackage;

/**
 * 状态栏时钟：默认不显示秒，长按左侧时间切换显示/隐藏秒。
 *
 * 原 smali（com.Str9527.statusbarseconds）是「装上就一直显示秒」，这里改成按需：
 *   - 默认 sShowSeconds = false，TimeManager 产出的文案保持系统原样（HH:mm）
 *   - 长按状态栏时间 → 切到带秒文案，并自己每秒 setText 刷新（不依赖 TimeManager 的刷新节奏）
 *   - 再长按 → 去掉秒，停掉自己的刷新
 *
 * 挂钩点：
 *   1) TimeManagerImpl#formatAmAndPm(Context,long)  after：仅在显示秒时改写成 HH:mm:ss
 *   2) HwNotchUtils#getDateTime(Context)            after：备用通道，同上，结果非 null 才改
 *   3) HwStatusBarClock#onAttachedToWindow()        after：给时钟装上长按监听（HarmonyOS 实际显示时钟的类）
 *
 * 注意：不再改 TimeManagerImpl#updateNextData，避免把系统整体的时间刷新节奏改成 1 秒（耗电）。
 */
public final class StatusBarSecondsHooks {

    private static final String TAG = "[OneKey][Seconds] ";
    private static final String SYSTEMUI = "com.android.systemui";

    private static final String CLS_TIME_MANAGER = "com.android.systemui.time.TimeManagerImpl";
    private static final String CLS_STATUS_BAR_CLOCK = "com.android.systemui.time.HwStatusBarClock";
    private static final String CLS_HEADER_CLOCK = "com.android.systemui.statusbar.phone.HwStatusBarHeaderClock";
    private static final String CLS_NOTCH_UTILS = "com.android.systemui.utils.HwNotchUtils";

    /** 每秒刷新间隔（毫秒） */
    private static final long REFRESH_MS = 1000L;

    /** 当前是否显示秒：**默认 false**，长按切换 */
    private static volatile boolean sShowSeconds = false;

    /** 长按防抖时间戳 */
    private static long sLastToggle = 0L;

    /** 已经挂钩到的时钟实例（状态栏可能重建，保留多个） */
    private static final List<WeakReference<TextView>> CLOCKS = new ArrayList<WeakReference<TextView>>();

    /** 显示秒时自己驱动刷新 */
    private static final Runnable TICK = new Runnable() {
        @Override
        public void run() {
            if (!sShowSeconds) {
                return;
            }
            Handler h = null;
            synchronized (CLOCKS) {
                for (WeakReference<TextView> ref : CLOCKS) {
                    TextView tv = ref.get();
                    if (tv == null) {
                        continue;
                    }
                    applyText(tv, true);
                    if (h == null) {
                        h = tv.getHandler();
                    }
                }
            }
            if (h != null) {
                h.postDelayed(this, REFRESH_MS);
            }
        }
    };

    private StatusBarSecondsHooks() {
    }

    public static void install(XC_LoadPackage.LoadPackageParam lp) {
        if (lp == null || !SYSTEMUI.equals(lp.packageName)) {
            return;
        }
        ClassLoader cl = lp.classLoader;
        boolean any = false;
        any |= hookTimeManager(cl);
        any |= hookHwStatusBarClock(cl);
        any |= hookHeaderClock(cl);
        any |= hookHwNotchUtils(cl);
        if (any) {
            log("状态栏时钟已接管：默认不显示秒，长按时间切换显示秒");
        } else {
            log("状态栏时钟：所有目标方法都没挂上，可能是 SystemUI 版本差异");
        }
    }

    // ================= TimeManagerImpl：只在显示秒时改写文案 =================

    private static boolean hookTimeManager(ClassLoader cl) {
        try {
            Class<?> tm = Class.forName(CLS_TIME_MANAGER, false, cl);
            Method m = tm.getDeclaredMethod("formatAmAndPm", Context.class, long.class);
            m.setAccessible(true);
            XposedBridge.hookMethod(m, new XC_MethodHook() {
                @Override
                protected void afterHookedMethod(MethodHookParam param) {
                    if (!sShowSeconds) {
                        return;
                    }
                    try {
                        Context ctx = (Context) param.args[0];
                        long when = ((Number) param.args[1]).longValue();
                        param.setResult(format(ctx, when, true));
                    } catch (Throwable t) {
                        log("formatAmAndPm 处理失败: " + t);
                    }
                }
            });
            log("已挂钩 TimeManagerImpl#formatAmAndPm(Context,long)（按需改文案）");
            return true;
        } catch (Throwable t) {
            log("formatAmAndPm 挂钩失败: " + t);
            return false;
        }
    }

    // ================= HwStatusBarClock：装长按监听 =================

    private static boolean hookHwStatusBarClock(ClassLoader cl) {
        try {
            Class<?> clock = Class.forName(CLS_STATUS_BAR_CLOCK, false, cl);
            Method m = clock.getDeclaredMethod("onAttachedToWindow");
            m.setAccessible(true);
            XposedBridge.hookMethod(m, new XC_MethodHook() {
                @Override
                protected void afterHookedMethod(MethodHookParam param) {
                    try {
                        Object o = param.thisObject;
                        if (!(o instanceof TextView)) {
                            return;
                        }
                        final TextView tv = (TextView) o;
                        track(tv);
                        tv.setOnLongClickListener(new View.OnLongClickListener() {
                            @Override
                            public boolean onLongClick(View v) {
                                toggle(v);
                                return true;
                            }
                        });
                        if (sShowSeconds) {
                            // 状态栏重建时保持当前状态
                            restartTick(tv);
                        }
                        log("已给状态栏时钟装上长按切换");
                    } catch (Throwable t) {
                        log("时钟长按挂钩失败: " + t);
                    }
                }
            });
            log("已挂钩 HwStatusBarClock#onAttachedToWindow()");
            return true;
        } catch (Throwable t) {
            log("HwStatusBarClock 未挂钩: " + t);
            return false;
        }
    }

    // ================= HwStatusBarHeaderClock：下拉面板/控制中心的时间，也要跟着跳秒 =================

    private static boolean hookHeaderClock(ClassLoader cl) {
        try {
            Class<?> clock = Class.forName(CLS_HEADER_CLOCK, false, cl);
            Method m = clock.getDeclaredMethod("onAttachedToWindow");
            m.setAccessible(true);
            XposedBridge.hookMethod(m, new XC_MethodHook() {
                @Override
                protected void afterHookedMethod(MethodHookParam param) {
                    try {
                        Object o = param.thisObject;
                        if (!(o instanceof TextView)) {
                            return;
                        }
                        // 它只在 onAttachedToWindow / 每分钟的 onTimeChange 里 setText，
                        // 显示秒时就会「卡」在展开那一刻，这里把它也纳入每秒刷新列表
                        track((TextView) o);
                        log("已接管下拉面板时钟的每秒刷新");
                    } catch (Throwable t) {
                        log("面板时钟挂钩失败: " + t);
                    }
                }
            });
            log("已挂钩 HwStatusBarHeaderClock#onAttachedToWindow()");
            return true;
        } catch (Throwable t) {
            log("HwStatusBarHeaderClock 未挂钩: " + t);
            return false;
        }
    }

    // ================= HwNotchUtils：备用通道 =================

    private static boolean hookHwNotchUtils(ClassLoader cl) {
        try {
            Class<?> notch = Class.forName(CLS_NOTCH_UTILS, false, cl);
            Method m = notch.getDeclaredMethod("getDateTime", Context.class);
            m.setAccessible(true);
            XposedBridge.hookMethod(m, new XC_MethodHook() {
                @Override
                protected void afterHookedMethod(MethodHookParam param) {
                    if (!sShowSeconds) {
                        return;
                    }
                    try {
                        // 原结果为空说明该路径不负责时钟，别硬塞
                        if (param.getResult() == null) {
                            return;
                        }
                        Context ctx = (Context) param.args[0];
                        param.setResult(format(ctx, System.currentTimeMillis(), true));
                    } catch (Throwable t) {
                        log("getDateTime 处理失败: " + t);
                    }
                }
            });
            log("已挂钩 HwNotchUtils#getDateTime(Context)（备用通道）");
            return true;
        } catch (Throwable t) {
            log("HwNotchUtils 未挂钩: " + t);
            return false;
        }
    }

    // ================= 长按切换 =================

    private static void toggle(View anchor) {
        long now = SystemClock.uptimeMillis();
        if (now - sLastToggle < 800L) {
            // 状态栏里可能叠着多个时钟实例，同一次长按会被它们各触发一次，这里做个防抖
            return;
        }
        sLastToggle = now;
        sShowSeconds = !sShowSeconds;
        Handler h = null;
        synchronized (CLOCKS) {
            for (WeakReference<TextView> ref : CLOCKS) {
                TextView tv = ref.get();
                if (tv == null) {
                    continue;
                }
                applyText(tv, sShowSeconds);
                if (h == null) {
                    h = tv.getHandler();
                }
            }
        }
        if (h != null) {
            h.removeCallbacks(TICK);
            if (sShowSeconds) {
                h.postDelayed(TICK, REFRESH_MS);
            }
        }
        log("长按状态栏时间 → " + (sShowSeconds ? "显示秒数" : "隐藏秒数"));
    }
    /**
     * 把一个时钟 View 纳入「显示秒时每秒刷新」的列表
     */
    private static void track(TextView tv) {
        synchronized (CLOCKS) {
            // 顺手清掉已经被回收的实例，避免列表越滚越大
            for (int i = CLOCKS.size() - 1; i >= 0; i--) {
                TextView old = CLOCKS.get(i).get();
                if (old == null) {
                    CLOCKS.remove(i);
                } else if (old == tv) {
                    if (sShowSeconds) {
                        applyText(tv, true);
                    }
                    return;
                }
            }
            CLOCKS.add(new WeakReference<TextView>(tv));
        }
        if (sShowSeconds) {
            applyText(tv, true);
        }
    }

    private static void restartTick(TextView tv) {
        Handler h = tv.getHandler();
        if (h == null) {
            return;
        }
        h.removeCallbacks(TICK);
        if (sShowSeconds) {
            h.postDelayed(TICK, REFRESH_MS);
        }
    }

    private static void applyText(TextView tv, boolean seconds) {
        try {
            tv.setText(format(tv.getContext(), System.currentTimeMillis(), seconds));
        } catch (Throwable t) {
            log("设置时间文本失败: " + t);
        }
    }

    // ================= 工具 =================

    /** 24 小时制 HH:mm(:ss)，12 小时制 h:mm(:ss) a（跟随系统设置） */
    private static String format(Context ctx, long when, boolean seconds) {
        boolean h24 = ctx != null && DateFormat.is24HourFormat(ctx);
        String pattern;
        if (h24) {
            pattern = seconds ? "HH:mm:ss" : "HH:mm";
        } else {
            pattern = seconds ? "h:mm:ss a" : "h:mm a";
        }
        SimpleDateFormat f = new SimpleDateFormat(pattern, Locale.getDefault());
        return f.format(new Date(when));
    }

    private static void log(String s) {
        try {
            XposedBridge.log(TAG + s);
        } catch (Throwable ignored) {
        }
    }
}