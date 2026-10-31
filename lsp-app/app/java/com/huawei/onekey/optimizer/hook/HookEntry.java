package com.huawei.onekey.optimizer.hook;

import com.huawei.onekey.optimizer.hook.impl.AccessibilitySkipHooks;
import com.huawei.onekey.optimizer.hook.impl.DoubleTapLockHooks;
import com.huawei.onekey.optimizer.hook.impl.StatusBarSecondsHooks;
import com.huawei.onekey.optimizer.hook.impl.SystemTimeoutHooks;
import com.huawei.onekey.optimizer.hook.impl.MxxHooks;
import com.huawei.onekey.optimizer.hook.impl.ThemeHooks;

import de.robv.android.xposed.IXposedHookLoadPackage;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.callbacks.XC_LoadPackage;

/**
 * LSPosed 总入口（assets/xposed_init 指向本类）。
 *
 * 三个模块的归属：
 *   安装器净化 → com.android.packageinstaller → smali 实现 hook.pi.HookEntry
 *                （= 原作者 PI-Cleaner 1.0.1，10 项功能统一受一个开关控制）
 *   主题解锁   → android / com.huawei.android.thememanager → 源码实现 hook.impl.ThemeHooks
 *   系统限制   → android（system_server）→ 源码实现 hook.impl.MxxHooks
 *
 * 安装器模块原始实现是 smali 编译产物，保持原样调用；
 * 主题 / Mxx 两段逻辑已在 ThemeHooks / MxxHooks 里按 smali 逐句重写，
 * Java 版出错时才回退到 smali 版，保证可用性。
 */
public class HookEntry implements IXposedHookLoadPackage {

    private static final String TAG = "[OneKey] ";

    /** 安装器净化（PI-Cleaner 1.0.1 全功能整合版） */
    private static final String CLS_INSTALLER =
            "com.huawei.onekey.optimizer.hook.pi.HookEntry";
    private static final String CLS_THEME_SMALI =
            "com.huawei.onekey.optimizer.hook.theme.ThemeHook";
    private static final String CLS_MXX_SMALI =
            "com.huawei.onekey.optimizer.hook.mxx.MxxHook";

    @Override
    public void handleLoadPackage(XC_LoadPackage.LoadPackageParam lpparam) {
        if (lpparam == null || lpparam.packageName == null) {
            return;
        }
        String pn = lpparam.packageName;
        try {
            if ("com.android.packageinstaller".equals(pn)) {
                // 安装器净化：原作者 PI-Cleaner 1.0.1 的 10 项净化能力全部由这一个开关控制
                // （纯净模式 / 风险与安全检测拦截 / 未知来源 / 匿名来源 / 本地密码校验 /
                //   广告拦截 / 商店与推广位清理 / 安装界面旋转跟随 / 结果净化）
                if (HookFlags.enabled(HookFlags.K_INSTALLER)) {
                    long t0 = android.os.SystemClock.elapsedRealtime();
                    dispatch(CLS_INSTALLER, lpparam, "安装器净化(全功能整合)");
                    long t1 = android.os.SystemClock.elapsedRealtime();
                    // 版本无关兜底：按签名抓 InstallationControlResult 漏斗方法，直接净化查验结果。
                    // 原作者 profiles 里写死的混淆方法名在本机 13.2.1.302 上对不上，靠这层保证不弹查验。
                    try {
                        com.huawei.onekey.optimizer.hook.impl.InstallerResultHooks
                                .install(lpparam.classLoader);
                    } catch (Throwable t) {
                        log("安装器结果净化失败: " + t);
                    }
                    long t2 = android.os.SystemClock.elapsedRealtime();
                    log("安装器耗时: 作者特性=" + (t1 - t0) + "ms, 结果净化=" + (t2 - t1) + "ms");
                }
            } else if ("android".equals(pn)) {
                if (HookFlags.enabled(HookFlags.K_THEME)) {
                    try {
                        ThemeHooks.install(lpparam);
                    } catch (Throwable t) {
                        log("主题解锁(Java) 失败，回退 smali: " + t);
                        dispatch(CLS_THEME_SMALI, lpparam, "主题解锁(smali)");
                    }
                }
                if (HookFlags.enabled(HookFlags.K_MXX)) {
                    try {
                        MxxHooks.install(lpparam);
                    } catch (Throwable t) {
                        log("系统限制解锁(Java) 失败，回退 smali: " + t);
                        dispatch(CLS_MXX_SMALI, lpparam, "系统限制解锁(smali)");
                    }
                }
            } else if ("com.android.settings".equals(pn)) {
                // 屏幕休眠 20/30/60 分钟档位：hook HwTimeoutPreferenceController
                if (HookFlags.enabled(HookFlags.K_TIMEOUT)) {
                    try {
                        SystemTimeoutHooks.install(lpparam);
                    } catch (Throwable t) {
                        log("屏幕休眠档位 失败: " + t);
                    }
                }
                // 无障碍授权弹窗：跳过 10 秒读秒与勾选门槛（默认开启）
                if (HookFlags.enabled(HookFlags.K_ACC_SKIP, true)) {
                    try {
                        AccessibilitySkipHooks.install(lpparam);
                    } catch (Throwable t) {
                        log("无障碍弹窗 失败: " + t);
                    }
                }
            } else if ("com.android.systemui".equals(pn)) {
                // 状态栏时钟显示秒：hook TimeManagerImpl（含备用通道）
                if (HookFlags.enabled(HookFlags.K_SECONDS)) {
                    try {
                        StatusBarSecondsHooks.install(lpparam);
                    } catch (Throwable t) {
                        log("状态栏秒数 失败: " + t);
                    }
                }
            } else if ("com.huawei.android.launcher".equals(pn)) {
                // 桌面双击锁屏：hook Workspace.onInterceptTouchEvent，不修改系统 APK
                if (HookFlags.enabled(HookFlags.K_DOUBLETAP)) {
                    try {
                        DoubleTapLockHooks.install(lpparam);
                    } catch (Throwable t) {
                        log("双击锁屏 失败: " + t);
                    }
                }
                // 桌面增强（主页 2 项 + 高级设置 8 项）
                try {
                    com.huawei.onekey.optimizer.hook.launcher.LauncherAdvanced
                            .install(lpparam.classLoader);
                } catch (Throwable t) {
                    log("桌面增强 失败: " + t);
                }
                // 桌面模糊（ColorOS 风格）：总开关 + 模糊程度由系统属性驱动，
                // hook 常驻安装，运行期判断开关，所以改完设置下一个转场就生效。
                try {
                    com.huawei.onekey.optimizer.hook.blur.LauncherBlurHooks
                            .install(lpparam.classLoader);
                } catch (Throwable t) {
                    log("桌面模糊 失败: " + t);
                }
            } else if ("com.huawei.android.thememanager".equals(pn)) {
                if (HookFlags.enabled(HookFlags.K_THEME)) {
                    try {
                        ThemeHooks.install(lpparam);
                    } catch (Throwable t) {
                        log("主题解锁(Java) 失败，回退 smali: " + t);
                        dispatch(CLS_THEME_SMALI, lpparam, "主题解锁(smali)");
                    }
                }
            }
        } catch (Throwable t) {
            log("入口异常: " + t);
        }
    }

    /** 反射调用迁移过来的 smali 实现（避免 javac 编译期依赖 classes2.dex 里的类型） */
    private void dispatch(String className, XC_LoadPackage.LoadPackageParam lpparam, String label) {
        try {
            ClassLoader cl = HookEntry.class.getClassLoader();
            Class<?> c = Class.forName(className, true, cl);
            Object impl = c.newInstance();
            c.getMethod("handleLoadPackage", XC_LoadPackage.LoadPackageParam.class)
                    .invoke(impl, lpparam);
            log(label + " 已加载");
        } catch (Throwable t) {
            log(label + " 加载失败: " + t);
        }
    }

    private static void log(String s) {
        try {
            XposedBridge.log(TAG + s);
        } catch (Throwable ignored) {
        }
    }
}