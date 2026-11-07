package com.huawei.onekey.optimizer.hook.launcher;

import android.widget.TextView;

import com.huawei.onekey.optimizer.hook.launcher.Kit;

import de.robv.android.xposed.XC_MethodHook;

/**
 * 功能 9：无字模式（应用图标 + 文件夹图标）。
 *
 * 对应教程【九】：
 *  - BubbleTextView.setDropedName(boolean)：方法体替换为无条件 setText("")
 *  - FolderIcon.initFolder(...) / onTitleChanged(...)：把 mFolderName 的文本清空
 */
public final class HookNoText {

    private static final String CLS_BUBBLE = "com.huawei.android.launcher.BubbleTextView";
    private static final String CLS_FOLDER = "com.huawei.android.launcher.FolderIcon";

    private HookNoText() {
    }

    public static void install(ClassLoader cl) {
        Class<?> bubble = Kit.load(cl, CLS_BUBBLE);
        if (bubble != null) {
            Kit.hook(bubble, "setDropedName", 1, new XC_MethodHook() {
                @Override
                protected void beforeHookedMethod(MethodHookParam p) {
                    if (p.thisObject instanceof TextView) {
                        ((TextView) p.thisObject).setText("");
                    }
                    p.setResult(null);   // void：不改写原厂逻辑，直接设置空文本并结束
                    Kit.once("notext.icon", "无字模式：BubbleTextView.setDropedName 已恒置空文本");
                }
            });
        }

        Class<?> folder = Kit.load(cl, CLS_FOLDER);
        if (folder != null) {
            XC_MethodHook clearName = new XC_MethodHook() {
                @Override
                protected void afterHookedMethod(MethodHookParam p) {
                    Object name = Kit.get(p.thisObject, "mFolderName");
                    if (name instanceof TextView) {
                        ((TextView) name).setText("");
                    }
                    Kit.once("notext.folder", "无字模式：FolderIcon 名称已清空");
                }
            };
            // initFolder 有 (Launcher, FolderInfo) 与 4 参两个重载，这里都挂
            Kit.hook(folder, "initFolder", null, clearName);
            Kit.hook(folder, "onTitleChanged", 1, clearName);
        }
    }
}
