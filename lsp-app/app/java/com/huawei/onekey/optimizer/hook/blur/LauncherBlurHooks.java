package com.huawei.onekey.optimizer.hook.blur;

import android.app.Instrumentation;

import java.util.Optional;

import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.XposedHelpers;

/**
 * 模糊信号源的安装。
 *
 * <p>华为桌面「打开 app」「返回桌面」在不同场景（点图标 / 最近任务卡片 / 手势上滑 /
 * 导航键返回 / 快速切换 / 打断重来）走完全不同的路径，单点 hook 必漏，
 * 所以同一语义挂多个入口，任一命中即可，控制器保证重复信号不抖动。
 *
 * <p>每个 hook 单独 try/catch：某个类在别的版本里不存在只是少一个信号源。
 */
public final class LauncherBlurHooks {

    private LauncherBlurHooks() {
    }

    public static void install(ClassLoader cl) {
        LauncherBlurController.init(cl);
        installAppOpeningSignals(cl);
        installLauncherShowingSignals(cl);
        installStateSignals(cl);
        installDiagnostics(cl);
    }

    // ==================== 「应用打开」信号 ====================

    private static void installAppOpeningSignals(final ClassLoader cl) {
        // (1) 点图标启动 app 的最直接入口（华为自己的方法名）
        hook(LauncherBlurController.CLS_LAUNCHER, cl, "startActivityByClickIcon", new XC_MethodHook() {
            @Override
            protected void afterHookedMethod(MethodHookParam param) {
                if (isLauncher(param.thisObject, cl)) {
                    LauncherBlurController.signalAppOpening("startActivityByClickIcon");
                }
            }
        }, "app打开·startActivityByClickIcon");

        // (2) 构造 ActivityOptions（父类声明，子类未覆写 → 必命中）
        hook(LauncherBlurController.CLS_QUICKSTEP_APPTRANS, cl, "getActivityLaunchOptions", new XC_MethodHook() {
            @Override
            protected void afterHookedMethod(MethodHookParam param) {
                LauncherBlurController.signalAppOpening("getActivityLaunchOptions");
            }
        }, "app打开·getActivityLaunchOptions");

        // (3) 全路径兜底：所有 startActivity* 最终都走 Instrumentation.execStartActivity
        try {
            int n = XposedBridge.hookAllMethods(Instrumentation.class, "execStartActivity", new XC_MethodHook() {
                @Override
                protected void beforeHookedMethod(MethodHookParam param) {
                    try {
                        if (param.args != null && param.args.length >= 1 && isLauncher(param.args[0], cl)) {
                            LauncherBlurController.signalAppOpening("Instrumentation.execStartActivity");
                        }
                    } catch (Throwable ignore) {
                    }
                }
            }).size();
            LauncherBlurController.log(n > 0
                    ? "已挂载 app打开·Instrumentation.execStartActivity（" + n + " 个重载）"
                    : "⚠ 未命中 Instrumentation.execStartActivity");
        } catch (Throwable t) {
            LauncherBlurController.log("⚠ 挂载 Instrumentation.execStartActivity 失败: " + t);
        }

        // (4)(5) 转场编排；第 4 参 true = 桌面在关闭集合 = app 正在打开
        hookCompose(cl, LauncherBlurController.CLS_QUICKSTEP_APPTRANS, "composeViewLaunchAnimator");
        hookCompose(cl, LauncherBlurController.CLS_APPTRANS_IMPL, "composeRecentsLaunchAnimator");
    }

    private static void hookCompose(final ClassLoader cl, String cls, final String method) {
        hook(cls, cl, method, new XC_MethodHook() {
            @Override
            protected void afterHookedMethod(MethodHookParam param) {
                boolean launcherClosing = true;
                if (param.args != null && param.args.length >= 4 && param.args[3] instanceof Boolean) {
                    launcherClosing = ((Boolean) param.args[3]).booleanValue();
                }
                // 先对齐时长，再发信号：否则渐入会用上一轮的旧时长启动，随后再被重跑一次。
                if (param.args != null && param.args.length >= 1) {
                    LauncherBlurController.syncDurationFromTransition(param.args[0], method, launcherClosing);
                }
                if (launcherClosing) {
                    LauncherBlurController.signalAppOpening(method);
                } else {
                    // 桌面是转场目标 = app 正在关闭，同样是确定性的转场信号
                    LauncherBlurController.signalLauncherShowingTrusted(method + "(launcherOpening)");
                }
            }
        }, "app转场·" + method);
    }

    // ==================== 「桌面正在显示」信号 ====================

    private static void installLauncherShowingSignals(final ClassLoader cl) {
        // (1) 返回桌面的远程动画入口（导航键 / 胶囊返回）。转场驱动、语义确定，直接渐出。
        hook(LauncherBlurController.CLS_BACK_HOME_RUNNER, cl, "onCreateAnimation", new XC_MethodHook() {
            @Override
            protected void afterHookedMethod(MethodHookParam param) {
                LauncherBlurController.signalLauncherShowingTrusted("BackHomeRemoteAnimRunner");
            }
        }, "返回桌面·BackHomeRemoteAnimRunner");

        // (2) 返回桌面动画本体（手势上滑 + 导航键都汇聚于此），顺手同步真实时长
        hook(LauncherBlurController.CLS_RETURN_HOME_ANIM, cl, "createReturnToHomeAnim", new XC_MethodHook() {
            @Override
            protected void afterHookedMethod(MethodHookParam param) {
                // 先取真实时长（返回转场是「渐出」通道），再发渐出信号，
                // 这样渐出从第一帧起就是 300ms，而不是先用旧值再重跑。
                try {
                    Object r = param.getResult();
                    if (r instanceof Optional) {
                        LauncherBlurController.syncDurationFromTransition(
                                ((Optional<?>) r).orElse(null), "ReturnToHomeAnim", false);
                    }
                } catch (Throwable ignore) {
                }
                LauncherBlurController.signalLauncherShowingTrusted("ReturnToHomeAnim");
            }
        }, "返回桌面·ReturnToHomeAnim");

        // (3) 兜底三件套（可能迟到，统一走否决闸口）
        XC_MethodHook guarded = new XC_MethodHook() {
            @Override
            protected void afterHookedMethod(MethodHookParam param) {
                if (!isLauncher(param.thisObject, cl)) {
                    return;
                }
                String why = param.method != null ? param.method.getName() : "onResume";
                if (param.args != null && param.args.length >= 1 && param.args[0] instanceof Boolean) {
                    if (!((Boolean) param.args[0]).booleanValue()) {
                        return;
                    }
                    why = "onWindowFocusChanged(true)";
                }
                LauncherBlurController.signalLauncherShowing("兜底:" + why);
            }
        };
        hook(LauncherBlurController.CLS_LAUNCHER, cl, "onResume", guarded, "兜底·onResume");
        hook(LauncherBlurController.CLS_LAUNCHER, cl, "onWindowFocusChanged", guarded, "兜底·onWindowFocusChanged");
        hook(LauncherBlurController.CLS_LAUNCHER, cl, "onNewIntent", guarded, "兜底·onNewIntent");
    }

    // ==================== 状态机 ====================

    private static void installStateSignals(final ClassLoader cl) {
        hook(LauncherBlurController.CLS_STATE_MGR, cl, "onStateTransitionStart", new XC_MethodHook() {
            @Override
            protected void afterHookedMethod(MethodHookParam param) {
                LauncherBlurController.onStateTransitionStart(ordinal(param));
            }
        }, "状态机·onStateTransitionStart");

        hook(LauncherBlurController.CLS_STATE_MGR, cl, "onStateTransitionEnd", new XC_MethodHook() {
            @Override
            protected void afterHookedMethod(MethodHookParam param) {
                LauncherBlurController.onStateTransitionEnd(ordinal(param));
            }
        }, "状态机·onStateTransitionEnd");
    }

    // ==================== 诊断 ====================

    private static void installDiagnostics(final ClassLoader cl) {
        hook(LauncherBlurController.CLS_LAUNCHER, cl, "onCreate", new XC_MethodHook() {
            @Override
            protected void afterHookedMethod(MethodHookParam param) {
                if (!isLauncher(param.thisObject, cl)) {
                    return;
                }
                LauncherBlurController.log("桌面 Activity 已创建：" + param.thisObject.getClass().getName());
                post(600L, false);
                post(2000L, true);
                post(5000L, true);
            }
        }, "诊断·Launcher.onCreate");
    }

    private static void post(final long delayMs, final boolean withCoverage) {
        try {
            new android.os.Handler(android.os.Looper.getMainLooper()).postDelayed(new Runnable() {
                @Override
                public void run() {
                    LauncherBlurController.logTargetsOnce();
                    LauncherBlurController.log("模糊状态 " + LauncherBlurController.dumpState());
                    if (withCoverage) {
                        LauncherBlurController.logCoverage();
                    }
                }
            }, delayMs);
        } catch (Throwable ignore) {
        }
    }

    // ==================== 工具 ====================

    private static int ordinal(XC_MethodHook.MethodHookParam param) {
        try {
            if (param.args == null || param.args.length < 1 || param.args[0] == null) {
                return -1;
            }
            Object o = XposedHelpers.callMethod(param.args[0], "getOrdinal", new Object[0]);
            return o instanceof Integer ? ((Integer) o).intValue() : -1;
        } catch (Throwable t) {
            return -1;
        }
    }

    /** BaseActivity 系也会被 hook 到，只认桌面本体，避免桌面内嵌的设置页误触发。 */
    private static boolean isLauncher(Object thisObject, ClassLoader cl) {
        if (thisObject == null) {
            return false;
        }
        try {
            return XposedHelpers.findClass(LauncherBlurController.CLS_LAUNCHER, cl).isInstance(thisObject);
        } catch (Throwable t) {
            return true;
        }
    }

    private static void hook(String className, ClassLoader cl, String method, XC_MethodHook cb, String desc) {
        try {
            Class<?> c = XposedHelpers.findClass(className, cl);
            int n = XposedBridge.hookAllMethods(c, method, cb).size();
            if (n > 0) {
                LauncherBlurController.log("已挂载 " + desc + "（" + n + " 个重载）");
            } else {
                LauncherBlurController.log("⚠ 未命中 " + desc + "：" + className + "#" + method
                        + " 未在该类声明（这个信号源缺失，其余照常）");
            }
        } catch (Throwable t) {
            LauncherBlurController.log("⚠ 挂载失败 " + desc + ": " + t);
        }
    }
}