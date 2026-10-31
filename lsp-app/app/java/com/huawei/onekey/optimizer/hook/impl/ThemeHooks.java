package com.huawei.onekey.optimizer.hook.impl;

import java.lang.reflect.Method;
import java.util.Locale;

import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.callbacks.XC_LoadPackage;

/**
 * 主题试用解锁 —— 逻辑 1:1 移植自原模块 MainHook.smali：
 *
 * 1) packageName == "android"（system_server）
 *    反射 android.hwtheme.HwThemeManager，遍历 getDeclaredMethods()，
 *    对「返回 boolean 且方法名(小写)包含 check / valid / author / restrict / verify / need 之一」的方法
 *    hook afterHookedMethod → setResult(Boolean.TRUE)。
 *
 * 2) packageName == "com.huawei.android.thememanager"
 *    对以下 3 个类的**全部返回 boolean 的方法**同样 setResult(TRUE)：
 *      com.huawei.android.thememanager.mvp.model.helper.tryout.TryOutTimeFenceService
 *      com.huawei.android.thememanager.mvp.model.helper.pay.PayedManagerServiceImpl
 *      com.huawei.android.thememanager.mvp.bean.TrialBackInfo
 *
 * 原 smali 全部 hook 都包在 try/catch 里逐个吞异常，这里保持一致，且统计成功数量后打日志。
 */
public final class ThemeHooks {

    private static final String TAG = "[OneKey][Theme] ";

    private static final String[] KEYWORDS = {
            "check", "valid", "author", "restrict", "verify", "need"
    };

    private static final String[] TRIAL_CLASSES = {
            "com.huawei.android.thememanager.mvp.model.helper.tryout.TryOutTimeFenceService",
            "com.huawei.android.thememanager.mvp.model.helper.pay.PayedManagerServiceImpl",
            "com.huawei.android.thememanager.mvp.bean.TrialBackInfo"
    };

    /** 等价于 MainHook$1 / MainHook$2 的 afterHookedMethod → setResult(true) */
    private static final XC_MethodHook FORCE_TRUE = new XC_MethodHook() {
        @Override
        protected void afterHookedMethod(MethodHookParam param) {
            param.setResult(Boolean.TRUE);
        }
    };

    private ThemeHooks() {
    }

    public static void install(XC_LoadPackage.LoadPackageParam lp) {
        if (lp == null || lp.packageName == null) {
            return;
        }
        if ("android".equals(lp.packageName)) {
            hookSystemTheme(lp.classLoader);
        } else if ("com.huawei.android.thememanager".equals(lp.packageName)) {
            hookTrialClasses(lp.classLoader);
        }
    }

    /** 第一段：android.hwtheme.HwThemeManager */
    private static void hookSystemTheme(ClassLoader cl) {
        int hooked = 0;
        try {
            Class<?> c = Class.forName("android.hwtheme.HwThemeManager", false, cl);
            for (Method m : c.getDeclaredMethods()) {
                String name = m.getName().toLowerCase(Locale.ROOT);
                if (m.getReturnType() != boolean.class) {
                    continue;
                }
                if (!matches(name)) {
                    continue;
                }
                try {
                    XposedBridge.hookMethod(m, FORCE_TRUE);
                    hooked++;
                } catch (Throwable ignored) {
                }
            }
            XposedBridge.log(TAG + "HwThemeManager hooked=" + hooked);
        } catch (Throwable t) {
            XposedBridge.log(TAG + "HwThemeManager failed: " + t);
        }
    }

    private static boolean matches(String name) {
        for (String k : KEYWORDS) {
            if (name.contains(k)) {
                return true;
            }
        }
        return false;
    }

    /** 第二段：主题商店的三个试用/付费相关类 */
    private static void hookTrialClasses(ClassLoader cl) {
        int total = 0;
        for (String cn : TRIAL_CLASSES) {
            int n = 0;
            try {
                Class<?> c = Class.forName(cn, false, cl);
                for (Method m : c.getDeclaredMethods()) {
                    if (m.getReturnType() != boolean.class) {
                        continue;
                    }
                    try {
                        XposedBridge.hookMethod(m, FORCE_TRUE);
                        n++;
                    } catch (Throwable ignored) {
                    }
                }
                XposedBridge.log(TAG + " " + c.getSimpleName() + "=" + n);
            } catch (Throwable t) {
                XposedBridge.log(TAG + " " + cn + " skip: " + t);
            }
            total += n;
        }
        XposedBridge.log(TAG + " v10 total=" + total);
    }
}