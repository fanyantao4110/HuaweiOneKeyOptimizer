package com.huawei.onekey.optimizer.core;

import android.content.Context;
import android.content.SharedPreferences;

/**
 * 统一开关存储。
 *
 * 三通道同步，保证 Hook 进程（当前应用以外的进程）也能读到开关：
 * 1) SharedPreferences（应用自身 / XSharedPreferences）
 * 2) /data/adb/huawei_onekey/flags.sh（Magisk 脚本读取）
 * 3) persist.sys.onekey.* 系统属性（其它进程读取最稳）
 */
public final class Prefs {

    public static final String SP_NAME = "onekey";
    public static final String PKG = "com.huawei.onekey.optimizer";

    public static final String K_INSTALLER = "hook_installer";
    public static final String K_THEME = "hook_theme";
    public static final String K_MXX = "hook_mxx";
    public static final String K_PARALLEL = "sys_parallel";
    public static final String K_CLONE = "sys_clone";
    public static final String K_FREEFORM = "sys_freeform";
    public static final String K_MEMINFO = "sys_meminfo";
    public static final String K_DOUBLETAP = "hook_doubletap_lock";
    public static final String K_TIMEOUT = "hook_screen_timeout";
    public static final String K_SECONDS = "hook_status_seconds";
    public static final String K_ACC_SKIP = "hook_accessibility_skip";

    /** 主页：桌面模糊（ColorOS 风格），默认关闭 */
    public static final String K_BLUR = "hook_launcher_blur";
    /** 模糊程度 1..100 */
    public static final String K_BLUR_RADIUS = "coloros_blur_radius";
    public static final int DEF_BLUR_RADIUS = 46;

    /** 主页：桌面增强（跟「一键全开」联动，默认开） */
    public static final String K_BADGE = "hook_badge";
    public static final String K_APP_DETAILS = "hook_app_details";

    /** 高级设置：桌面布局/手势类（默认关，**不受**「一键全开」影响） */
    public static final String K_ADV_CELLS = "adv_cells";
    public static final String K_ADV_DEDUPE = "adv_dedupe";
    public static final String K_ADV_DRAWER = "adv_drawer";
    public static final String K_ADV_DOCK = "adv_dock";
    public static final String K_ADV_PORTRAIT = "adv_portrait";
    public static final String K_ADV_NOTEXT = "adv_notext";
    public static final String K_ADV_CARD_FOLDER = "adv_card_folder";
    public static final String K_ADV_FORM_TITLE = "adv_form_title";
    public static final String[] ALL_KEYS = new String[]{
            K_INSTALLER, K_THEME, K_MXX, K_PARALLEL, K_CLONE, K_FREEFORM, K_MEMINFO, K_DOUBLETAP, K_TIMEOUT, K_SECONDS,
            K_ACC_SKIP,
            K_BADGE, K_APP_DETAILS
    };

    /** 高级设置里的 8 项：默认关闭，且 setAll() 不碰它们 */
    public static final String[] ADV_KEYS = new String[]{
            K_ADV_CELLS, K_ADV_DEDUPE, K_ADV_DRAWER, K_ADV_DOCK,
            K_ADV_PORTRAIT, K_ADV_NOTEXT, K_ADV_CARD_FOLDER, K_ADV_FORM_TITLE
    };

    /** 与 flags.sh 中的变量名一一对应 */
    public static final String FLAGS_FILE = "/data/adb/huawei_onekey/flags.sh";
    public static final String MODULE_DIR = "/data/adb/modules/huawei_onekey";

    private Prefs() {
    }

    public static SharedPreferences sp(Context c) {
        return c.getSharedPreferences(SP_NAME, Context.MODE_PRIVATE);
    }

    public static boolean isOn(Context c, String key) {
        return sp(c).getBoolean(key, true);
    }

    /** 高级设置用：默认关闭 */
    public static boolean isOnAdv(Context c, String key) {
        return sp(c).getBoolean(key, false);
    }

    public static boolean isOn(Context c, String key, boolean def) {
        return sp(c).getBoolean(key, def);
    }

    public static void set(Context c, String key, boolean value) {
        sp(c).edit().putBoolean(key, value).apply();
    }

    public static int getInt(Context c, String key, int def) {
        return sp(c).getInt(key, def);
    }

    public static void setInt(Context c, String key, int value) {
        sp(c).edit().putInt(key, value).apply();
    }

    public static void setAll(Context c, boolean value) {
        SharedPreferences.Editor e = sp(c).edit();
        for (String k : ALL_KEYS) {
            e.putBoolean(k, value);
        }
        e.apply();
    }

    private static String propKey(String key) {
        // hook_installer -> persist.sys.onekey.installer
        if (K_INSTALLER.equals(key)) {
            return "persist.sys.onekey.installer";
        }
        if (K_THEME.equals(key)) {
            return "persist.sys.onekey.theme";
        }
        if (K_MXX.equals(key)) {
            return "persist.sys.onekey.mxx";
        }
        if (K_PARALLEL.equals(key)) {
            return "persist.sys.onekey.parallel";
        }
        if (K_CLONE.equals(key)) {
            return "persist.sys.onekey.clone";
        }
        if (K_FREEFORM.equals(key)) {
            return "persist.sys.onekey.freeform";
        }
        if (K_MEMINFO.equals(key)) {
            return "persist.sys.onekey.meminfo";
        }
        if (K_DOUBLETAP.equals(key)) {
            return "persist.sys.onekey.doubletap_lock";
        }
        if (K_TIMEOUT.equals(key)) {
            return "persist.sys.onekey.screen_timeout";
        }
        if (K_SECONDS.equals(key)) {
            return "persist.sys.onekey.status_seconds";
        }
        if (K_ACC_SKIP.equals(key)) {
            return "persist.sys.onekey.accessibility_skip";
        }
        if (K_BLUR.equals(key)) {
            return "persist.sys.onekey.launcher_blur";
        }
        if (K_BLUR_RADIUS.equals(key)) {
            return "persist.sys.onekey.launcher_blur_radius";
        }
        if (K_BADGE.equals(key)) {
            return "persist.sys.onekey.badge";
        }
        if (K_APP_DETAILS.equals(key)) {
            return "persist.sys.onekey.app_details";
        }
        if (key != null && key.startsWith("adv_")) {
            return "persist.sys.onekey." + key.substring(4);
        }
        return "persist.sys.onekey." + key;
    }

    /** 模糊程度：钳制 1..100，缺省 46 */
    public static int blurRadius(Context c) {
        int r = getInt(c, K_BLUR_RADIUS, DEF_BLUR_RADIUS);
        if (r < 1) {
            r = 1;
        }
        if (r > 100) {
            r = 100;
        }
        return r;
    }

    /** 把当前开关同步到 flags.sh 与系统属性（需要 root）。 */
    public static RootShell.Result push(Context c) {
        StringBuilder sb = new StringBuilder();
        sb.append("#!/system/bin/sh\n");
        sb.append("# generated by HuaweiOneKeyOptimizer, do not edit\n");
        sb.append("onekey_installer=").append(isOn(c, K_INSTALLER) ? 1 : 0).append('\n');
        sb.append("onekey_theme=").append(isOn(c, K_THEME) ? 1 : 0).append('\n');
        sb.append("onekey_mxx=").append(isOn(c, K_MXX) ? 1 : 0).append('\n');
        sb.append("onekey_parallel=").append(isOn(c, K_PARALLEL) ? 1 : 0).append('\n');
        sb.append("onekey_clone=").append(isOn(c, K_CLONE) ? 1 : 0).append('\n');
        sb.append("onekey_freeform=").append(isOn(c, K_FREEFORM) ? 1 : 0).append('\n');
        sb.append("onekey_meminfo=").append(isOn(c, K_MEMINFO) ? 1 : 0).append('\n');
        sb.append("onekey_doubletap_lock=").append(isOn(c, K_DOUBLETAP) ? 1 : 0).append('\n');
        sb.append("onekey_status_seconds=").append(isOn(c, K_SECONDS) ? 1 : 0).append('\n');
        sb.append("onekey_accessibility_skip=").append(isOn(c, K_ACC_SKIP) ? 1 : 0).append('\n');
        sb.append("onekey_launcher_blur=").append(isOn(c, K_BLUR, false) ? 1 : 0).append('\n');
        sb.append("onekey_launcher_blur_radius=").append(blurRadius(c)).append('\n');
        sb.append("onekey_screen_timeout=").append(isOn(c, K_TIMEOUT) ? 1 : 0).append('\n');
        sb.append("onekey_badge=").append(isOn(c, K_BADGE) ? 1 : 0).append('\n');
        sb.append("onekey_app_details=").append(isOn(c, K_APP_DETAILS) ? 1 : 0).append('\n');
        for (String k : ADV_KEYS) {
            sb.append("onekey_").append(k.substring(4)).append('=')
                    .append(isOnAdv(c, k) ? 1 : 0).append('\n');
        }

        StringBuilder cmd = new StringBuilder();
        cmd.append("mkdir -p /data/adb/huawei_onekey 2>/dev/null; ");
        for (String k : ALL_KEYS) {
            cmd.append("setprop ").append(propKey(k)).append(' ')
                    .append(isOn(c, k) ? "1" : "0").append(" 2>/dev/null; ");
        }
        for (String k : ADV_KEYS) {
            cmd.append("setprop ").append(propKey(k)).append(' ')
                    .append(isOnAdv(c, k) ? "1" : "0").append(" 2>/dev/null; ");
        }
        cmd.append("setprop ").append(propKey(K_BLUR)).append(' ')
                .append(isOn(c, K_BLUR, false) ? "1" : "0").append(" 2>/dev/null; ");
        cmd.append("setprop ").append(propKey(K_BLUR_RADIUS)).append(' ')
                .append(blurRadius(c)).append(" 2>/dev/null; ");
        cmd.append("chmod 644 /data/data/").append(PKG).append("/shared_prefs/").append(SP_NAME)
                .append(".xml 2>/dev/null; ");
        cmd.append("chmod 644 /data/user_de/0/").append(PKG).append("/shared_prefs/").append(SP_NAME)
                .append(".xml 2>/dev/null; ");
        cmd.append("echo PUSHED");

        RootShell.Result r = RootShell.writeFile(FLAGS_FILE, sb.toString());
        RootShell.Result r2 = RootShell.exec(cmd.toString(), 20);
        if (r.ok()) {
            return r2;
        }
        return r;
    }
}