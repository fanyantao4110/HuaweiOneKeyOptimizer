package com.huawei.onekey.optimizer.hook.launcher;

import com.huawei.onekey.optimizer.hook.launcher.Kit;

import de.robv.android.xposed.XC_MethodHook;

/**
 * 功能 8：去除管控应用（克隆/信任空间等）的警告角标。
 *
 * 对应教程【八】：BadgeUtils.getCloneOrTrustAppMark(ShortcutInfo) 恒返回 null，
 * 等价于原教程把方法体整体替换为 `const/4 v0, 0x0 + return-object v0`。
 */
public final class HookBadge {

    private static final String CLS = "com.huawei.android.launcher.BadgeUtils";

    private HookBadge() {
    }

    public static void install(ClassLoader cl) {
        Class<?> c = Kit.load(cl, CLS);
        if (c == null) {
            return;
        }
        Kit.hook(c, "getCloneOrTrustAppMark", 1, new XC_MethodHook() {
            @Override
            protected void beforeHookedMethod(MethodHookParam p) {
                p.setResult(null);
                Kit.once("badge", "BadgeUtils.getCloneOrTrustAppMark 恒返回 null：管控应用角标已去除");
            }
        });
    }
}
