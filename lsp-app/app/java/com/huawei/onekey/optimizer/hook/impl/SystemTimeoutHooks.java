package com.huawei.onekey.optimizer.hook.impl;

import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.ArrayList;
import java.util.List;

import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.callbacks.XC_LoadPackage;

/**
 * 设置 → 显示和亮度 → 屏幕休眠：新增 20 / 30 / 60 分钟档位（共 10 项）。
 *
 * 原教程（系统设置修改教程.txt）要反编译 138MB 的 Settings.apk，改三处：
 *   1) HwTimeoutPreferenceController.SCREEN_TIMEOUT 数组 6 项 → 9 项
 *   2) buildLcdScreenTimeoutEntries() 的 7 项 → 10 项（LCD 屏走这里）
 *   3) res/values/arrays.xml 的 screen_timeout_values_emui 7 项 → 10 项
 * 然后再重签名、换 priv-app、刷 super.img。
 *
 * 这里改用 Hook：LCD 路径最终都会调用
 *   HwTimeoutPreferenceController.setScreenTimeoutEntriesAndArrow()
 * 由它给 mScreenTimeoutPreference（ListPreference）setEntries + setEntryValues。
 * 在方法返回后把这两个数组替换成 10 项即可，条目文本由现有「10 分钟」文案
 * 推出来（把数字 10 换成 20/30/60），不依赖任何资源 id，也不改 APK。
 */
public final class SystemTimeoutHooks {

    private static final String TAG = "[OneKey][Timeout] ";
    private static final String CLS = "com.android.settings.display.HwTimeoutPreferenceController";

    /** 新增档位（分钟） */
    private static final int[] EXTRA_MINUTES = new int[]{20, 30, 60};
    /** 对应毫秒值（必须是合法 screen_off_timeout） */
    private static final String[] EXTRA_VALUES = new String[]{"1200000", "1800000", "3600000"};

    private static Field F_PREF;
    private static Method M_GET_ENTRIES;
    private static Method M_GET_VALUES;
    private static Method M_SET_ENTRIES;
    private static Method M_SET_VALUES;
    private static Field F_IS_SMART_SCREEN;

    private SystemTimeoutHooks() {
    }

    public static void install(XC_LoadPackage.LoadPackageParam lp) {
        Class<?> c;
        Class<?> lpCls;
        try {
            c = Class.forName(CLS, false, lp.classLoader);
            lpCls = Class.forName("androidx.preference.ListPreference", false, lp.classLoader);
        } catch (Throwable t) {
            log("未找到类，跳过: " + t);
            return;
        }
        try {
            F_PREF = c.getDeclaredField("mScreenTimeoutPreference");
            F_PREF.setAccessible(true);
            M_GET_ENTRIES = lpCls.getMethod("getEntries");
            M_GET_VALUES = lpCls.getMethod("getEntryValues");
            M_SET_ENTRIES = lpCls.getMethod("setEntries", CharSequence[].class);
            M_SET_VALUES = lpCls.getMethod("setEntryValues", CharSequence[].class);
            try {
                F_IS_SMART_SCREEN = c.getDeclaredField("IS_SMART_SCREEN");
                F_IS_SMART_SCREEN.setAccessible(true);
            } catch (Throwable ignored) {
            }
        } catch (Throwable t) {
            log("反射失败: " + t);
            return;
        }

        XposedBridge.hookAllMethods(c, "setScreenTimeoutEntriesAndArrow", new XC_MethodHook() {
            @Override
            protected void afterHookedMethod(MethodHookParam param) {
                try {
                    apply(param.thisObject, lpCls);
                } catch (Throwable t) {
                    log("注入失败: " + t);
                }
            }
        });
        log("屏幕休眠档位已挂载 → " + CLS + ".setScreenTimeoutEntriesAndArrow");
    }

    private static void apply(Object self, Class<?> lpCls) throws Exception {
        // 智慧屏（MatePad 走 LCD，不涉及）保持原样
        if (F_IS_SMART_SCREEN != null) {
            try {
                if (F_IS_SMART_SCREEN.getBoolean(null)) {
                    return;
                }
            } catch (Throwable ignored) {
            }
        }
        Object pref = F_PREF.get(self);
        if (pref == null || !lpCls.isInstance(pref)) {
            return;
        }
        CharSequence[] entries = (CharSequence[]) M_GET_ENTRIES.invoke(pref);
        CharSequence[] values = (CharSequence[]) M_GET_VALUES.invoke(pref);
        if (entries == null || values == null || entries.length < 2
                || entries.length != values.length) {
            return;
        }
        if (values.length == entries.length && values.length == 7 + EXTRA_MINUTES.length) {
            // 已经是 10 项，别重复加
            return;
        }

        List<CharSequence> outEntries = new ArrayList<CharSequence>();
        List<CharSequence> outValues = new ArrayList<CharSequence>();
        // 前 6 项（15 秒 ~ 10 分钟）原样保留
        for (int i = 0; i < entries.length - 1; i++) {
            outEntries.add(entries[i]);
            outValues.add(values[i]);
        }
        // 中间插入 20 / 30 / 60 分钟
        CharSequence tenMinutes = entries.length >= 6 ? entries[5] : "10";
        for (int i = 0; i < EXTRA_MINUTES.length; i++) {
            outEntries.add(buildLabel(tenMinutes, EXTRA_MINUTES[i]));
            outValues.add(EXTRA_VALUES[i]);
        }
        // 最后一项固定是「永不」
        outEntries.add(entries[entries.length - 1]);
        outValues.add(values[values.length - 1]);

        M_SET_ENTRIES.invoke(pref, new Object[]{outEntries.toArray(new CharSequence[0])});
        M_SET_VALUES.invoke(pref, new Object[]{outValues.toArray(new CharSequence[0])});
        log("已注入 10 档（15秒/30秒/1/2/5/10/20/30/60分钟/永不）");
    }

    /** 用「10 分钟」这条文案推导「N 分钟」：把其中的 10 换成 N */
    private static CharSequence buildLabel(CharSequence tenMinutes, int minutes) {
        String s = String.valueOf(tenMinutes);
        int idx = s.indexOf("10");
        if (idx >= 0) {
            return s.substring(0, idx) + minutes + s.substring(idx + 2);
        }
        // 兜底（理论上不会走到）
        return minutes + "分钟";
    }

    private static void log(String s) {
        try {
            XposedBridge.log(TAG + s);
        } catch (Throwable ignored) {
        }
    }
}