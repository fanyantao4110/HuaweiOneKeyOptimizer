package com.huawei.onekey.optimizer.hook.launcher;

import android.widget.TextView;

import com.huawei.onekey.optimizer.hook.launcher.Kit;

import de.robv.android.xposed.XC_MethodHook;

/**
 * 功能 12：服务卡片标题无字。
 *
 * 对应教程【十二】：服务卡片标题与桌面图标是三条独立路径，必须分别覆盖：
 *  1. AbilityFormHostView#setTitle(CharSequence)      —— 直接把入参置空
 *     AbilityFormHostView#updateCeliaTitleIfNeed() 及 lambda$updateCeliaTitleIfNeed$*
 *                                                    —— 清空 mHostViewTitle
 *  2. AbilityFormStackGroup#applyFromWorkspaceItem(...) / updateTitle(...) —— 清空 mTitleView
 */
public final class HookFormTitle {

    private static final String CLS_HOST = "com.huawei.android.launcher.abilityform.AbilityFormHostView";
    private static final String CLS_GROUP = "com.huawei.android.launcher.abilityform.view.AbilityFormStackGroup";

    private HookFormTitle() {
    }

    public static void install(ClassLoader cl) {
        Class<?> host = Kit.load(cl, CLS_HOST);
        if (host != null) {
            Kit.hook(host, "setTitle", 1, new XC_MethodHook() {
                @Override
                protected void beforeHookedMethod(MethodHookParam p) {
                    if (p.args != null && p.args.length == 1 && p.args[0] instanceof CharSequence) {
                        p.args[0] = "";
                    }
                }
            });
            Kit.hook(host, "updateCeliaTitleIfNeed", 0, clearHook("mHostViewTitle", "服务卡片标题(updateCeliaTitleIfNeed)"));
            Kit.hookPrefix(host, "lambda$updateCeliaTitleIfNeed",
                    clearHook("mHostViewTitle", "服务卡片标题(lambda$updateCeliaTitleIfNeed)"));
            Kit.hookPrefix(host, "lambda$setTitle", clearHook("mHostViewTitle", "服务卡片标题(lambda$setTitle)"));
        }

        Class<?> group = Kit.load(cl, CLS_GROUP);
        if (group != null) {
            XC_MethodHook clear = clearHook("mTitleView", "服务卡片堆叠标题");
            Kit.hook(group, "applyFromWorkspaceItem", null, clear);
            Kit.hook(group, "updateTitle", null, clear);
        }
    }

    private static XC_MethodHook clearHook(final String fieldName, final String tag) {
        return new XC_MethodHook() {
            @Override
            protected void afterHookedMethod(MethodHookParam p) {
                Object holder = p.thisObject;
                // 1) 优先用公开 getter（AbilityFormStackGroup#getTitleView）
                Object v = Kit.call(holder, "getTitleView");
                if (v instanceof TextView) {
                    ((TextView) v).setText("");
                    Kit.once("formtitle." + fieldName, tag + "：已清空");
                    return;
                }
                // 2) 退回字段（mTitleView / mHostViewTitle 都是 BubbleTextView）
                Object f = Kit.get(holder, fieldName);
                if (f instanceof TextView) {
                    ((TextView) f).setText("");
                    Kit.once("formtitle." + fieldName, tag + "：已清空");
                    return;
                }
                // 3) lambda 的第二个参数常常就是标题视图
                if (p.args != null) {
                    for (Object a : p.args) {
                        if (a instanceof TextView) {
                            ((TextView) a).setText("");
                            Kit.once("formtitle." + fieldName, tag + "：已清空(入参视图)");
                            return;
                        }
                    }
                }
            }
        };
    }
}
