package com.huawei.onekey.optimizer.hook.island;

import android.app.Activity;
import android.app.Application;
import android.os.Handler;
import android.os.Looper;
import android.util.Log;

import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.XposedHelpers;
import de.robv.android.xposed.callbacks.XC_LoadPackage;

/**
 * 灵动岛（原 LiveIsland v1.2.0）的装入口。
 *
 * 与独立模块的差别：
 * - 不作为第二个 Xposed 模块存在，而是被 HookEntry 在对应进程里调用；
 * - 配置来源改为本 App 的开关（见 IslandPrefs）；
 * - 总开关关闭时只是不画，hook 依旧常驻，改完设置立即生效，不用重启 SystemUI。
 */
public final class IslandHook {

    static final String TAG = "OneKey-Island";

    private static final String SYSTEMUI = "com.android.systemui";
    private static final String[] MAP_APPS = {
            "com.baidu.BaiduMap",
            "com.autonavi.minimap"
    };
    private static final String DESKCLOCK = "com.huawei.deskclock";
    private static final String SETTINGS = "com.android.settings";

    private static volatile boolean sStarted;

    private IslandHook() {
    }

    /** 系统界面：面板/通知/电量弹窗 + 启动岛控制器 */
    public static void installSystemUi(XC_LoadPackage.LoadPackageParam lpp) {
        if (lpp.processName != null && !SYSTEMUI.equals(lpp.processName)) {
            return;
        }
        try {
            IslandController.hookPanel(lpp.classLoader);
        } catch (Throwable t) {
            log("panel hook 失败: " + t);
        }
        try {
            IslandController.hookPowerWarnings(lpp.classLoader);
        } catch (Throwable t) {
            log("power hook 失败: " + t);
        }
        try {
            IslandController.hookNotifications(lpp.classLoader);
        } catch (Throwable t) {
            log("notification hook 失败: " + t);
        }
        hookApplication();
    }

    private static void hookApplication() {
        try {
            XposedHelpers.findAndHookMethod(Application.class, "onCreate", new XC_MethodHook() {
                @Override
                protected void afterHookedMethod(MethodHookParam param) {
                    final Application app = (Application) param.thisObject;
                    if (app == null || sStarted) {
                        return;
                    }
                    sStarted = true;
                    new Handler(Looper.getMainLooper()).postDelayed(new Runnable() {
                        @Override
                        public void run() {
                            try {
                                new IslandController(app).start();
                            } catch (Throwable t) {
                                log("启动失败: " + t);
                            }
                        }
                    }, 2500);
                }
            });
            log("已挂 SystemUI Application.onCreate");
        } catch (Throwable t) {
            log("hook Application 失败: " + t);
        }
    }

    /** 地图：把导航状态报给岛上 */
    public static boolean isMapApp(String pkg) {
        if (pkg == null) {
            return false;
        }
        for (String p : MAP_APPS) {
            if (p.equals(pkg)) {
                return true;
            }
        }
        return false;
    }

    public static void installMap(XC_LoadPackage.LoadPackageParam lpp) {
        try {
            NavReporter.install(lpp.classLoader, lpp.packageName);
        } catch (Throwable t) {
            log("导航上报失败: " + t);
        }
    }

    /** 时钟：秒表时间取自时钟进程 */
    public static void installClock(XC_LoadPackage.LoadPackageParam lpp) {
        if (lpp.processName != null && !DESKCLOCK.equals(lpp.processName)) {
            return;
        }
        try {
            StopwatchReporter.install(lpp.classLoader);
        } catch (Throwable t) {
            log("秒表上报失败: " + t);
        }
    }

    /** 设置：接管 USB 连接方式弹窗（改由岛上直接切换） */
    public static void installSettings(XC_LoadPackage.LoadPackageParam lpp) {
        if (!IslandPrefs.enabled()) {
            return;
        }
        try {
            Class<?> cls = XposedHelpers.findClass(
                    "com.android.settings.deviceinfo.UsbConnModeChooserActivity",
                    lpp.classLoader);
            XposedBridge.hookAllMethods(cls, "onCreate", new XC_MethodHook() {
                @Override
                protected void afterHookedMethod(MethodHookParam param) {
                    try {
                        if (param.thisObject instanceof Activity) {
                            ((Activity) param.thisObject).finish();
                            log("已拦截 USB 选择弹窗");
                        }
                    } catch (Throwable ignored) {
                    }
                }
            });
            log("USB 选择弹窗 hook 已安装");
        } catch (Throwable t) {
            log("USB 选择弹窗 hook 失败: " + t);
        }
    }

    /** 目标进程统一日志（logcat + LSPosed 日志） */
    static void log(String msg) {
        try {
            Log.i(TAG, msg);
        } catch (Throwable ignored) {
        }
        try {
            XposedBridge.log("[OneKey] [岛] " + msg);
        } catch (Throwable ignored) {
        }
    }
}