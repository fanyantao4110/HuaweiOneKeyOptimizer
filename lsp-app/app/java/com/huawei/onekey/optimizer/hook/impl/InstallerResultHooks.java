package com.huawei.onekey.optimizer.hook.impl;

import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.XposedHelpers;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;

/**
 * 安装器「查验」兜底净化（版本无关）。
 *
 * 原作者 PI-Cleaner 的净化是靠 profiles 里写死的混淆方法名（a/b/h…）来定位，
 * 一旦系统安装器版本变化（本机 13.2.1.302 就属于这种情况）这些名字对不上，
 * 风险/安全检测那块 hook 会全部落空 —— 表现就是「模块开了，装 APK 还是弹查验」。
 *
 * 这类安装器最终一定走同一个漏斗：
 *   PackageInstallerActivity#(方法名不定)(InstallationControlResult, boolean)
 * 也就是说凡是把 InstallationControlResult + boolean 作为参数的方法，都是结果落地入口。
 *
 * 这里不依赖任何方法名，按「参数签名」扫描并 hook 全部漏斗方法，
 * 在 before 阶段把 InstallationControlResult 换成一个净化后的新对象：
 *   riskType / virusType / virusDetail / tipText / title 全部清零，
 *   pwdCheckType = 0（不再要求本地密码/儿童模式校验），
 *   pureModeExempt = true（纯净模式豁免），PendingIntent / WashAppInfo 置空。
 *
 * 同时把 InstallationControlResult#isNeedPwdVerify 固定 false、isPureModeExempt 固定 true 作为双保险。
 */
public final class InstallerResultHooks {

    private static final String TAG = "[OneKey][Installer] ";

    private static final String PIA = "com.android.packageinstaller.PackageInstallerActivity";
    private static final String ICR =
            "com.huawei.android.packageinstaller.storeapi.response.InstallationControlResult";

    private InstallerResultHooks() {
    }

    public static void install(ClassLoader cl) {
        if (cl == null) {
            return;
        }
        final Class<?> icr;
        try {
            icr = Class.forName(ICR, false, cl);
        } catch (Throwable t) {
            XposedBridge.log(TAG + "skip: InstallationControlResult 不存在: " + t);
            return;
        }
        hookIcFlags(icr);
        hookFunnels(cl, icr);
        hookViewCleanup(cl);
    }

    /**
     * 安装页顶部那个孤零零的「!」：PIA 在 n() 里永远会 inflate app_risk_check_layout，
     * 里面 risk_img(24dp 警告图标) + risk_tip_title。结果被我们净化后标题变空，
     * 图标却还留着 → 只剩一个感叹号。这里在 onResume/onStart 之后把整块风险视图收掉。
     */
    private static void hookViewCleanup(ClassLoader cl) {
        Class<?> pia;
        try {
            pia = Class.forName(PIA, false, cl);
        } catch (Throwable t) {
            return;
        }
        XC_MethodHook cleanup = new XC_MethodHook() {
            @Override
            protected void afterHookedMethod(MethodHookParam param) {
                Object act = param.thisObject;
                if (!(act instanceof android.app.Activity)) {
                    return;
                }
                final android.app.Activity a = (android.app.Activity) act;
                final android.view.View root = a.getWindow() == null
                        ? null : a.getWindow().getDecorView();
                if (root == null) {
                    return;
                }
                // 延后一帧：安装器自己还会 setVisibility(0) 覆盖一次
                root.post(new Runnable() {
                    @Override
                    public void run() {
                        hideRisk(a, root);
                    }
                });
            }
        };
        int n = 0;
        for (String m : new String[]{"onResume", "onStart"}) {
            try {
                for (de.robv.android.xposed.XC_MethodHook.Unhook u
                        : XposedBridge.hookAllMethods(pia, m, cleanup)) {
                    if (u != null) {
                        n++;
                    }
                }
            } catch (Throwable ignored) {
            }
        }
        XposedBridge.log(TAG + "风险视图清理 hook: " + n);
    }

    private static final String[] RISK_VIEW_IDS = {
            "risk_check_layout", "risk_img", "risk_tip_title",
            "risk_desc_content", "pure_introduction_tv",
    };

    private static volatile boolean sLogged;

    private static void hideRisk(android.app.Activity a, android.view.View root) {
        try {
            android.content.res.Resources r = a.getResources();
            StringBuilder sb = null;
            for (String name : RISK_VIEW_IDS) {
                int id = r.getIdentifier(name, "id", "com.android.packageinstaller");
                if (id == 0) {
                    continue;
                }
                android.view.View v = root.findViewById(id);
                if (v == null) {
                    continue;
                }
                v.setVisibility(android.view.View.GONE);
                if (sb == null) {
                    sb = new StringBuilder();
                }
                sb.append(name).append(' ');
            }
            if (sb != null && !sLogged) {
                sLogged = true;
                XposedBridge.log(TAG + "已隐藏风险视图: " + sb.toString().trim());
            } else if (sb == null && !sLogged) {
                sLogged = true;
                XposedBridge.log(TAG + "未找到风险视图（可能本版本用别的布局）");
            }
        } catch (Throwable ignored) {
        }
    }

    /** isNeedPwdVerify -> false / isPureModeExempt -> true */
    private static void hookIcFlags(Class<?> icr) {
        int n = 0;
        for (Method m : icr.getDeclaredMethods()) {
            if (Modifier.isStatic(m.getModifiers()) || m.getParameterTypes().length != 0) {
                continue;
            }
            String name = m.getName();
            final Object value;
            if ("isNeedPwdVerify".equals(name)) {
                value = Boolean.FALSE;
            } else if ("isPureModeExempt".equals(name)) {
                value = Boolean.TRUE;
            } else {
                continue;
            }
            try {
                XposedBridge.hookMethod(m, new XC_MethodHook() {
                    @Override
                    protected void afterHookedMethod(MethodHookParam param) {
                        param.setResult(value);
                    }
                });
                n++;
            } catch (Throwable ignored) {
            }
        }
        XposedBridge.log(TAG + "ICR 标志 hook: " + n);
    }

    /** 扫描 PackageInstallerActivity 里所有 (InstallationControlResult, boolean) 漏斗方法 */
    private static void hookFunnels(ClassLoader cl, final Class<?> icr) {
        Class<?> pia;
        try {
            pia = Class.forName(PIA, false, cl);
        } catch (Throwable t) {
            XposedBridge.log(TAG + "skip: PackageInstallerActivity 不存在: " + t);
            return;
        }
        int n = 0;
        for (Method m : pia.getDeclaredMethods()) {
            Class<?>[] ps = m.getParameterTypes();
            int idx = -1;
            boolean hasBool = false;
            for (int i = 0; i < ps.length; i++) {
                if (icr.isAssignableFrom(ps[i])) {
                    idx = i;
                }
                if (ps[i] == boolean.class) {
                    hasBool = true;
                }
            }
            if (idx < 0 || !hasBool) {
                continue;
            }
            final int argIndex = idx;
            try {
                XposedBridge.hookMethod(m, new XC_MethodHook() {
                    @Override
                    protected void beforeHookedMethod(MethodHookParam param) {
                        try {
                            Object old = param.args[argIndex];
                            Object clean = sanitize(icr, old);
                            if (clean != null) {
                                param.args[argIndex] = clean;
                            }
                        } catch (Throwable t) {
                            XposedBridge.log(TAG + "sanitize 失败: " + t);
                        }
                    }
                });
                n++;
            } catch (Throwable ignored) {
            }
        }
        XposedBridge.log(TAG + "结果漏斗 hook: " + n + " 个方法（按签名匹配，与方法名无关）");
    }

    /**
     * 原地净化：只改风险相关字段，其它（checkType / appId / displayPolicy / subscene…）全部保留。
     *
     * 上一版是 new 一个空对象再逐项复制，结果 checkType 掉回 ONLINE(0)，
     * 安装器每次打开都会重新走一遍在线安全检测 —— 那就是「打开安装器明显变慢」的原因。
     */
    private static Object sanitize(Class<?> icr, Object src) {
        if (src == null) {
            try {
                return XposedHelpers.newInstance(icr);
            } catch (Throwable t) {
                return null;
            }
        }
        // 风险判定清零（保留 appId / checkType / displayPolicy 等，避免触发重新检测）
        call_(src, "setRiskType", 0);
        call_(src, "setVirusType", 0);
        call_(src, "setVirusDetail", "");
        call_(src, "setTipText", "");
        call_(src, "setTitle", "");
        call_(src, "setPwdCheckType", 0);
        call_(src, "setControlType", "0");
        call_(src, "setControlByteCode", "0");
        call_(src, "setForwardBtnType", 1);
        call_(src, "setPureModeExempt", Boolean.TRUE);
        call_(src, "setAbiUnCompatibility", Boolean.FALSE);
        call_(src, "setPendingIntent", null);
        call_(src, "setWashAppInfo", null);
        fieldInt(src, "controlByteCodeNum", 0);
        fieldBool(src, "isPureModeExempt", true);
        fieldObj(src, "mPendingIntent", null);
        fieldObj(src, "mWashAppInfo", null);
        return src;
    }

    private static Object call(Object target, String method) {
        if (target == null) {
            return null;
        }
        try {
            return XposedHelpers.callMethod(target, method, new Object[0]);
        } catch (Throwable ignored) {
            return null;
        }
    }

    private static void call_(Object target, String method, Object value) {
        try {
            XposedHelpers.callMethod(target, method, new Object[]{value});
        } catch (Throwable ignored) {
        }
    }

    private static void fieldObj(Object target, String name, Object value) {
        try {
            XposedHelpers.setObjectField(target, name, value);
        } catch (Throwable ignored) {
        }
    }

    private static void fieldInt(Object target, String name, int value) {
        try {
            XposedHelpers.setIntField(target, name, value);
        } catch (Throwable ignored) {
        }
    }

    private static void fieldBool(Object target, String name, boolean value) {
        try {
            XposedHelpers.setBooleanField(target, name, value);
        } catch (Throwable ignored) {
        }
    }
}