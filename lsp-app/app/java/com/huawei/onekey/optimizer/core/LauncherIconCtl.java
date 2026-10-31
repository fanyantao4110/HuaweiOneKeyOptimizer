package com.huawei.onekey.optimizer.core;

import android.content.ComponentName;
import android.content.Context;
import android.content.pm.PackageManager;

/**
 * 桌面图标显隐控制。
 *
 * 做法：清单里桌面入口是独立的 activity-alias（com.huawei.onekey.optimizer.LauncherEntry），
 * 「隐藏」= 只把这个别名 DISABLED，应用本体 MainActivity 一直可用，
 * 所以以下入口在任何时候都能进来把开关关掉恢复图标：
 *   1) LSPosed → 模块 → 华为一键优化 → 打开
 *   2) 设置 → 应用和服务 → 应用管理 → 华为一键优化 → 打开
 *   3) 终端/adb：su -c am start -n com.huawei.onekey.optimizer/.ui.MainActivity
 */
public final class LauncherIconCtl {

    private static final String ALIAS = "com.huawei.onekey.optimizer.LauncherEntry";

    private LauncherIconCtl() {
    }

    private static ComponentName alias(Context c) {
        return new ComponentName(c.getPackageName(), ALIAS);
    }

    /** 当前是否已隐藏（别名被禁用） */
    public static boolean isHidden(Context c) {
        try {
            int st = c.getPackageManager().getComponentEnabledSetting(alias(c));
            return st == PackageManager.COMPONENT_ENABLED_STATE_DISABLED
                    || st == PackageManager.COMPONENT_ENABLED_STATE_DISABLED_USER
                    || st == PackageManager.COMPONENT_ENABLED_STATE_DISABLED_UNTIL_USED;
        } catch (Throwable t) {
            return false;
        }
    }

    /** @return true 表示设置成功 */
    public static boolean setHidden(Context c, boolean hidden) {
        try {
            c.getPackageManager().setComponentEnabledSetting(
                    alias(c),
                    hidden ? PackageManager.COMPONENT_ENABLED_STATE_DISABLED
                            : PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
                    PackageManager.DONT_KILL_APP);
            return true;
        } catch (Throwable t) {
            return false;
        }
    }
}