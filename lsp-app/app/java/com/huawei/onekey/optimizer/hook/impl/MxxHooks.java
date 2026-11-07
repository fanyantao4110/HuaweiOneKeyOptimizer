package com.huawei.onekey.optimizer.hook.impl;

import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XC_MethodReplacement;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.callbacks.XC_LoadPackage;

/**
 * 系统限制解锁（MxxHook）—— 逻辑 1:1 移植自原模块 MxxHook.smali。
 *
 * 只在 system_server（packageName == "android"）生效。
 * 原 smali 里有两张静态二维数组：
 *   HOOK_FALSE：{类名, 方法名} → 返回 false
 *   HOOK_TRUE ：{类名, 方法名} → 返回 true
 * 逐条 hookConst()：
 *   Class.forName("com.android.server.mxx." + 类名, false, classLoader)
 *   XposedBridge.hookAllMethods(clazz, 方法名, XC_MethodReplacement{ return 常量 })
 * 成功 +1 / 失败 +1，最后打印 hooked / missed 数量。
 */
public final class MxxHooks {

    private static final String TAG = "[MxxHook] ";
    private static final String PKG_PREFIX = "com.android.server.mxx.";

    /** 原 MxxHook.HOOK_FALSE（顺序与 clinit 中 v2..v11 完全一致） */
    private static final String[][] HOOK_FALSE = {
            {"HwMxxFilterAmsPolicyScene", "shouldPreventMxxCalled"},
            {"HwMxxFilterAmsPolicyScene", "shouldPreventMxxCalledInAnco"},
            {"HwMxxFilterAmsPolicyScene", "shouldPreventMxxInitiativeCall"},
            {"HwMxxFilterAmsPolicyScene", "shouldManageByPolicy"},
            {"HwMxxFilterAmsPolicyScene", "isChinaTimezone"},
            {"HwMxxFilterPolicyScene", "shouldFilterByManagePolicy"},
            {"HwMxxFilterPolicyScene", "shouldFilterInAnco"},
            {"HwMxxFilterPolicyScene", "shouldManageByPolicy"},
            {"HwMxxManagerPolicyController", "shouldManageByPolicy"},
            {"HwMxxManagerPolicyUtils", "isChinaTimezone"},
    };

    /** 原 MxxHook.HOOK_TRUE */
    private static final String[][] HOOK_TRUE = {
            {"HwMxxManagerPolicyParser", "isInAllowlist"},
    };

    private MxxHooks() {
    }

    public static void install(XC_LoadPackage.LoadPackageParam lp) {
        if (lp == null || !"android".equals(lp.packageName)) {
            return;
        }
        // 先探测锚点类：HarmonyOS 4.0（EMUI 14）已经把 com.android.server.mxx.* 整套移除，
        // 这种情况下不能逐条 hook 再逐条打印 ClassNotFoundException（11 行 MISS 日志刷屏），
        // 直接一行说明并跳过。
        java.util.HashSet<String> probe = new java.util.HashSet<String>();
        for (String[] entry : HOOK_FALSE) {
            probe.add(entry[0]);
        }
        for (String[] entry : HOOK_TRUE) {
            probe.add(entry[0]);
        }
        int present = 0;
        for (String cls : probe) {
            if (classPresent(lp.classLoader, cls)) {
                present++;
            }
        }
        if (present == 0) {
            XposedBridge.log(TAG + "skip: 本机型不存在 " + PKG_PREFIX + "* 服务类"
                    + "（HarmonyOS 4.0 已移除 mxx 限制），无需 hook，静默跳过");
            return;
        }

        XposedBridge.log(TAG + "==== system_server loaded, installing Mxx hooks ====");
        int hooked = 0;
        int missed = 0;

        for (String[] entry : HOOK_FALSE) {
            if (hookConst(lp.classLoader, entry[0], entry[1], Boolean.FALSE)) {
                hooked++;
            } else {
                missed++;
            }
        }
        for (String[] entry : HOOK_TRUE) {
            if (hookConst(lp.classLoader, entry[0], entry[1], Boolean.TRUE)) {
                hooked++;
            } else {
                missed++;
            }
        }
        XposedBridge.log(TAG + "==== done: hooked=" + hooked + " missed=" + missed + " ====");
    }

    /** 只探测类是否存在，不打印日志（避免刷屏） */
    private static boolean classPresent(ClassLoader cl, String cls) {
        try {
            Class.forName(PKG_PREFIX + cls, false, cl);
            return true;
        } catch (Throwable ignored) {
            return false;
        }
    }

    private static boolean hookConst(ClassLoader cl, String cls, String method, final Object value) {
        String full = PKG_PREFIX + cls;
        try {
            Class<?> c = Class.forName(full, false, cl);
            XposedBridge.hookAllMethods(c, method, new XC_MethodReplacement() {
                @Override
                protected Object replaceHookedMethod(MethodHookParam param) {
                    return value;
                }
            });
            XposedBridge.log(TAG + "OK   " + full + "#" + method + " -> " + value);
            return true;
        } catch (Throwable t) {
            XposedBridge.log(TAG + "MISS " + full + "#" + method + " : " + t);
            return false;
        }
    }
}