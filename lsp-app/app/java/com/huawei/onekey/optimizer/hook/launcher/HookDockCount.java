package com.huawei.onekey.optimizer.hook.launcher;

import com.huawei.onekey.optimizer.hook.launcher.Kit;

import de.robv.android.xposed.XC_MethodHook;

/**
 * 功能 4：dock 栏自适应 11(横) / 8(竖)。
 *
 * 对应教程【四】：图标数量被「网格层」和「拖放上限层」两层控制，必须同时改：
 *  网格层   DrawerLauncherPolicy.getDockCellNum()
 *           NewSimpleLauncherPolicy.getDockCellNum()
 *  拖放上限 DeviceResource.getHotseatMaxIconNum()
 *           FoldableDeviceResource.getHotseatMaxIconNum()
 *           ProductivityDeviceResource.getHotseatMaxIconNum()   ← 平板生产力模式实际走这个
 *  另加     LauncherApplication.getFoldDockAllMaxNum()  原 10 -> 11
 *
 * 方向判定使用 Resources.getSystem()（与原教程一致，无需 context）。
 */
public final class HookDockCount {

    private static final int LANDSCAPE = 11;
    private static final int PORTRAIT = 8;

    private static final String[] DOCK_CELL = {
            "com.huawei.android.launcher.drawer.DrawerLauncherPolicy",
            "com.huawei.android.launcher.newsimpleui.NewSimpleLauncherPolicy",
    };

    private static final String[] HOTSEAT_MAX = {
            "com.huawei.android.launcher.res.DeviceResource",
            "com.huawei.android.launcher.res.FoldableDeviceResource",
            "com.huawei.android.launcher.productivity.ProductivityDeviceResource",
    };

    private static final String CLS_APP = "com.huawei.android.launcher.LauncherApplication";

    private HookDockCount() {
    }

    public static void install(ClassLoader cl) {
        for (String name : DOCK_CELL) {
            Class<?> c = Kit.load(cl, name);
            if (c == null) {
                continue;
            }
            Kit.hook(c, "getDockCellNum", 0, oriented("getDockCellNum@" + c.getSimpleName()));
        }

        for (String name : HOTSEAT_MAX) {
            Class<?> c = Kit.load(cl, name);
            if (c == null) {
                continue;
            }
            Kit.hook(c, "getHotseatMaxIconNum", 0, oriented("getHotseatMaxIconNum@" + c.getSimpleName()));
        }

        Class<?> app = Kit.load(cl, CLS_APP);
        if (app != null) {
            Kit.hook(app, "getFoldDockAllMaxNum", 0, new XC_MethodHook() {
                @Override
                protected void afterHookedMethod(MethodHookParam p) {
                    Object r = p.getResult();
                    if (!(r instanceof Integer) || ((Integer) r).intValue() != LANDSCAPE) {
                        Kit.once("folddock", "getFoldDockAllMaxNum: " + r + " -> " + LANDSCAPE);
                        p.setResult(LANDSCAPE);
                    }
                }
            });
        }
    }

    private static XC_MethodHook oriented(final String tag) {
        return new XC_MethodHook() {
            @Override
            protected void afterHookedMethod(MethodHookParam p) {
                int want = Kit.portrait() ? PORTRAIT : LANDSCAPE;
                Object r = p.getResult();
                if (!(r instanceof Integer) || ((Integer) r).intValue() != want) {
                    Kit.once(tag, tag + ": " + r + " -> " + want + "（" + (Kit.portrait() ? "竖屏" : "横屏") + "）");
                    p.setResult(want);
                }
            }
        };
    }
}
