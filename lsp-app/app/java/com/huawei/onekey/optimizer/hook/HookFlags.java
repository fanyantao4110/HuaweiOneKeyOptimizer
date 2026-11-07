package com.huawei.onekey.optimizer.hook;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.InputStreamReader;
import java.util.HashMap;
import java.util.Map;

/**
 * 目标进程内的开关读取（关键：不能读本应用私有 SP，只能走跨进程通道）。
 *
 * 取值顺序：
 * 1) XSharedPreferences（LSPosed 提供）
 * 2) getprop persist.sys.onekey.*
 * 3) /data/adb/huawei_onekey/flags.sh
 * 4) 默认 true（刷完即生效）
 */
public final class HookFlags {

    public static final String K_INSTALLER = "hook_installer";
    public static final String K_THEME = "hook_theme";
    public static final String K_MXX = "hook_mxx";
    public static final String K_FREEFORM = "sys_freeform";
    public static final String K_MEMINFO = "sys_meminfo";
    public static final String K_DOUBLETAP = "hook_doubletap_lock";
    public static final String K_TIMEOUT = "hook_screen_timeout";
    public static final String K_SECONDS = "hook_status_seconds";
    public static final String K_ACC_SKIP = "hook_accessibility_skip";
    /** 控制中心音量条（默认开启） */
    public static final String K_CCVOLUME = "hook_ccvolume";

    /** 主页：桌面增强 */
    public static final String K_BADGE = "hook_badge";
    public static final String K_APP_DETAILS = "hook_app_details";

    /** 高级设置（默认关闭） */
    public static final String K_ADV_CELLS = "adv_cells";
    public static final String K_ADV_DEDUPE = "adv_dedupe";
    public static final String K_ADV_DRAWER = "adv_drawer";
    public static final String K_ADV_DOCK = "adv_dock";
    public static final String K_ADV_PORTRAIT = "adv_portrait";
    public static final String K_ADV_NOTEXT = "adv_notext";
    public static final String K_ADV_CARD_FOLDER = "adv_card_folder";
    public static final String K_ADV_FORM_TITLE = "adv_form_title";

    private static final String PKG = "com.huawei.onekey.optimizer";
    private static final String SP = "onekey";

    private static final Map<String, Boolean> CACHE = new HashMap<String, Boolean>();

    private HookFlags() {
    }

    public static boolean enabled(String key) {
        return enabled(key, true);
    }

    /** def：三个通道都读不到时的默认值（高级设置里的选项默认 false） */
    public static boolean enabled(String key, boolean def) {
        String ck = key + "|" + def;
        synchronized (CACHE) {
            Boolean b = CACHE.get(ck);
            if (b != null) {
                return b.booleanValue();
            }
        }
        boolean v = read(key, def);
        synchronized (CACHE) {
            CACHE.put(ck, Boolean.valueOf(v));
        }
        return v;
    }

    private static boolean read(String key, boolean def) {
        Boolean b = fromXSharedPreferences(key, def);
        if (b == null) {
            b = fromProp(key);
        }
        if (b == null) {
            b = fromFlagsFile(key);
        }
        return b == null ? def : b.booleanValue();
    }

    private static Boolean fromXSharedPreferences(String key, boolean def) {
        try {
            Class<?> c = Class.forName("de.robv.android.xposed.XSharedPreferences");
            Object xsp = c.getConstructor(String.class, String.class).newInstance(PKG, SP);
            c.getMethod("reload").invoke(xsp);
            // 必须先 contains()：否则 key 不存在时 getBoolean 会直接返回默认值，
            // 把后面的 getprop / flags.sh 两个通道全部挡住（高级设置默认 false 就会永远读成 false）
            Object has = c.getMethod("contains", String.class).invoke(xsp, key);
            if (!(has instanceof Boolean) || !((Boolean) has).booleanValue()) {
                return null;
            }
            Object v = c.getMethod("getBoolean", String.class, boolean.class)
                    .invoke(xsp, key, Boolean.valueOf(def));
            if (v instanceof Boolean) {
                return (Boolean) v;
            }
        } catch (Throwable ignored) {
        }
        return null;
    }

    private static Boolean fromProp(String key) {
        try {
            Process p = new ProcessBuilder("getprop", "persist.sys.onekey." + shortName(key))
                    .redirectErrorStream(true).start();
            BufferedReader r = new BufferedReader(new InputStreamReader(p.getInputStream(), "UTF-8"));
            String line = r.readLine();
            r.close();
            p.destroy();
            return parse(line);
        } catch (Throwable ignored) {
        }
        return null;
    }

    private static Boolean fromFlagsFile(String key) {
        File f = new File("/data/adb/huawei_onekey/flags.sh");
        if (!f.exists()) {
            return null;
        }
        String var = "onekey_" + shortName(key);
        BufferedReader r = null;
        try {
            r = new BufferedReader(new FileReader(f));
            String line;
            while ((line = r.readLine()) != null) {
                line = line.trim();
                if (!line.startsWith(var + "=")) {
                    continue;
                }
                return parse(line.substring(var.length() + 1).trim());
            }
        } catch (Throwable ignored) {
        } finally {
            if (r != null) {
                try {
                    r.close();
                } catch (Throwable ignored) {
                }
            }
        }
        return null;
    }

    private static Boolean parse(String v) {
        if (v == null) {
            return null;
        }
        v = v.trim();
        if ("1".equals(v) || "true".equalsIgnoreCase(v)) {
            return Boolean.TRUE;
        }
        if ("0".equals(v) || "false".equalsIgnoreCase(v)) {
            return Boolean.FALSE;
        }
        return null;
    }

    /** hook_installer -> installer */
    private static String shortName(String key) {
        if (key == null) {
            return "";
        }
        int i = key.indexOf('_');
        return i >= 0 ? key.substring(i + 1) : key;
    }
}