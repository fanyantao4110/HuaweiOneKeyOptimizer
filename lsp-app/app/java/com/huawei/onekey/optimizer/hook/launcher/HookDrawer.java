package com.huawei.onekey.optimizer.hook.launcher;

import com.huawei.onekey.optimizer.hook.launcher.Kit;

import de.robv.android.xposed.XC_MethodHook;

/**
 * 功能 3：抽屉去应用建议。
 *
 * 对应教程【三】：AlphabeticalAppsList.processPredictedApps(int) 是「生成建议应用」的入口，
 * 原教程用 goto 跳到方法尾部整段跳过。这里直接在 before 钩子里 returnEarly，
 * 效果等价（原厂代码不执行），且不破坏方法结构。
 */
public final class HookDrawer {

    private static final String CLS = "com.huawei.android.launcher.drawer.AlphabeticalAppsList";

    private HookDrawer() {
    }

    public static void install(ClassLoader cl) {
        Class<?> c = Kit.load(cl, CLS);
        if (c == null) {
            return;
        }
        int n = Kit.hook(c, "processPredictedApps", 1, new XC_MethodHook() {
            @Override
            protected void beforeHookedMethod(MethodHookParam p) {
                p.setResult(null);   // void 方法：直接结束，跳过建议应用生成
                Kit.once("drawer", "已跳过 processPredictedApps(int)：抽屉不再显示应用建议");
            }
        });
        if (n == 0) {
            Kit.log("抽屉去建议：未找到目标方法（该版本可能改了实现），本功能未生效");
        }
    }
}
