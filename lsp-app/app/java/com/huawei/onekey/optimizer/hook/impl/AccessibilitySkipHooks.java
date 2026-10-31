package com.huawei.onekey.optimizer.hook.impl;

import android.content.Context;
import android.widget.Button;
import android.view.View;
import android.widget.CheckBox;

import java.lang.reflect.Field;
import java.lang.reflect.Method;

import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.callbacks.XC_LoadPackage;

/**
 * 跳过「开启无障碍服务」时的 10 秒风险提示倒计时。
 *
 * 现象：新版设置弹窗要求先勾选「我已知晓如上风险…(10 秒)」，并且「开启」按钮要等
 * 倒计时走完且已勾选才可用；旧版只弹一个确认框，点确定即可。
 *
 * 实现（全部在 com.android.settings 进程内）：
 *   1) AccessibilityDownloadServicesDialogActivity 的私有构造 <init>(Context,int) 之后：
 *      - 字段 v（倒计时是否完成）置 true
 *      - 勾选框 k 置为已勾选，文本去掉「(N 秒)」
 *      - 「开启」按钮 p 置为可点，并调用私有 l(true) 把文字颜色刷成可用色
 *   2) $2（CountDownTimer）的 onTick(long) 直接跳过：不再每秒改写勾选框文本，
 *      也不会把 v 重新置 false
 *
 * 这样弹窗一出现就是「已勾选 + 不读秒 + 开启可点」，和旧版手感一致。
 * 私有构造/字段都是通过反射拿的，字段名（q/k/p/v）来自本机 Settings.apk 的反编译结果，
 * 万一某版本改名，整个过程只打日志不抛异常，不影响其它功能。
 */
public final class AccessibilitySkipHooks {

    private static final String TAG = "[OneKey][A11y] ";
    private static final String PKG_SETTINGS = "com.android.settings";

    private static final String CLS_DIALOG =
            "com.android.settings.accessibility.AccessibilityDownloadServicesDialogActivity";
    private static final String CLS_TIMER = CLS_DIALOG + "$2";

    private AccessibilitySkipHooks() {
    }

    public static void install(XC_LoadPackage.LoadPackageParam lp) {
        if (lp == null || !PKG_SETTINGS.equals(lp.packageName)) {
            return;
        }
        ClassLoader cl = lp.classLoader;
        boolean any = false;
        any |= hookDialog(cl);
        any |= hookTimer(cl);
        if (any) {
            log("无障碍授权弹窗：已跳过 10 秒倒计时与勾选门槛");
        } else {
            log("无障碍授权弹窗：目标类没找到，可能是 Settings 版本差异");
        }
    }

    /** 弹窗 show() 之后立刻改状态（构造签名随版本会变，直接用 Dialog.show 更稳） */
    private static boolean hookDialog(ClassLoader cl) {
        try {
            Method show = Class.forName("android.app.Dialog", false, cl).getDeclaredMethod("show");
            show.setAccessible(true);
            XposedBridge.hookMethod(show, new XC_MethodHook() {
                @Override
                protected void afterHookedMethod(MethodHookParam param) {
                    Object dialog = param.thisObject;
                    if (dialog == null || !CLS_DIALOG.equals(dialog.getClass().getName())) {
                        return;
                    }
                    try {
                        apply(dialog);
                    } catch (Throwable t) {
                        log("改写弹窗状态失败: " + t);
                    }
                }
            });
            log("已挂钩 Dialog#show（仅处理 " + CLS_DIALOG + "）");
            return true;
        } catch (Throwable t) {
            log("show 挂钩失败: " + t);
            return false;
        }
    }

    /** 让 CountDownTimer 的每秒回调与结束回调都不生效 */
    private static boolean hookTimer(ClassLoader cl) {
        boolean ok = false;
        try {
            Class<?> timer = Class.forName(CLS_TIMER, false, cl);
            Method onTick = timer.getDeclaredMethod("onTick", long.class);
            onTick.setAccessible(true);
            XposedBridge.hookMethod(onTick, new XC_MethodHook() {
                @Override
                protected void beforeHookedMethod(MethodHookParam param) {
                    // void 方法，给结果即跳过原实现：文本不再刷新、倒计时完成标志不被清掉
                    param.setResult(null);
                }
            });
            log("已挂钩 " + CLS_TIMER + "#onTick(long)（跳过读秒）");
            ok = true;
        } catch (Throwable t) {
            log("onTick 挂钩失败: " + t);
        }
        try {
            Class<?> timer = Class.forName(CLS_TIMER, false, cl);
            Method onFinish = timer.getDeclaredMethod("onFinish");
            onFinish.setAccessible(true);
            XposedBridge.hookMethod(onFinish, new XC_MethodHook() {
                @Override
                protected void beforeHookedMethod(MethodHookParam param) {
                    // 原实现在这里会对「原始文案」字段做 split；该字段只在 onTick 里赋值，
                    // 既然 onTick 被跳过了，这里再跑就会 NPE 把设置搞崩，所以一并跳过
                    param.setResult(null);
                }
            });
            log("已挂钩 " + CLS_TIMER + "#onFinish()（跳过结束回调）");
            ok = true;
        } catch (Throwable t) {
            log("onFinish 挂钩失败: " + t);
        }
        return ok;
    }

    /** 把弹窗改成「已勾选 + 不读秒 + 开启可点」 */
    private static void apply(Object dialog) throws Exception {
        if (dialog == null) {
            return;
        }
        Class<?> c = dialog.getClass();

        // 1) 倒计时完成标志（字段名可能是 v，取不到就算了：直接点开启并不校验它）
        setField(dialog, c, "v", Boolean.TRUE);

        // 2) 找出勾选框与「开启」按钮：先按已知字段名，失败再按控件类型兜底
        CheckBox cb = null;
        Button positive = null;
        Object cbObj = getField(dialog, c, "k");
        if (cbObj instanceof CheckBox) {
            cb = (CheckBox) cbObj;
        }
        Object btnObj = getField(dialog, c, "p");
        if (btnObj instanceof Button) {
            positive = (Button) btnObj;
        }
        for (Field f : c.getDeclaredFields()) {
            try {
                f.setAccessible(true);
                Object v = f.get(dialog);
                if (cb == null && v instanceof CheckBox) {
                    cb = (CheckBox) v;
                }
                if (v instanceof Button) {
                    Button b = (Button) v;
                    if (positive == null || !isPositiveText(positive)) {
                        if (isPositiveText(b)) {
                            positive = b;
                        }
                    }
                }
            } catch (Throwable ignored) {
            }
        }

        // 3) 勾选框：先勾上，再整行隐藏（show() 时原文本还没填，自己拼容易拼歪）
        if (cb != null) {
            cb.setChecked(true);
            // 兜底：原始文案字段正常是 onTick 里赋值的，这里先填一句，
            // 万一某些版本 onTick 没被成功跳过，onFinish 里的 split 也不会 NPE
            String fallback = "我已知晓如上风险，并自愿承担可能导致的后果。";
            if (getField(dialog, c, "q") == null) {
                setField(dialog, c, "q", fallback);
            }
            String base = null;
            Object q = getField(dialog, c, "q");
            if (q instanceof CharSequence) {
                base = q.toString();
            }
            if (base == null || base.isEmpty()) {
                base = cb.getText() == null ? "" : cb.getText().toString();
            }
            cb.setText(stripCountdown(base));
            cb.setVisibility(View.GONE);
        }

        // 4) 「开启」按钮先变成可点
        if (positive != null) {
            positive.setEnabled(true);
        }

        // 5) 文字颜色走原来的私有方法，避免自己硬编码颜色资源
        try {
            Method color = c.getDeclaredMethod("l", boolean.class);
            color.setAccessible(true);
            color.invoke(dialog, Boolean.TRUE);
        } catch (Throwable ignored) {
        }
    }

    private static boolean isPositiveText(Button b) {
        if (b == null) {
            return false;
        }
        CharSequence t = b.getText();
        if (t == null) {
            return false;
        }
        String s = t.toString();
        return s.contains("开启") || s.contains("确定") || s.contains("允许");
    }

    /** 去掉「(10 秒)」「（10秒）」这类后缀，以及格式化时残留的 %s */
    private static String stripCountdown(String s) {
        if (s == null) {
            return "";
        }
        String out = s.replace("%s", "").replace("%S", "");
        out = out.replaceAll("[\\s\\u3000]*[（(][^（()）]{0,24}秒[^（()）]{0,24}[)）]", "");
        return out.trim();
    }

    private static Object getField(Object target, Class<?> c, String name) {
        try {
            Field f = c.getDeclaredField(name);
            f.setAccessible(true);
            return f.get(target);
        } catch (Throwable t) {
            return null;
        }
    }

    private static void setField(Object target, Class<?> c, String name, Object value) {
        try {
            Field f = c.getDeclaredField(name);
            f.setAccessible(true);
            f.set(target, value);
        } catch (Throwable ignored) {
        }
    }

    private static void log(String s) {
        try {
            XposedBridge.log(TAG + s);
        } catch (Throwable ignored) {
        }
    }
}