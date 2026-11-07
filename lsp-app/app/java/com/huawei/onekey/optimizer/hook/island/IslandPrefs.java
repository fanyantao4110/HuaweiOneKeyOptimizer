package com.huawei.onekey.optimizer.hook.island;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.util.Log;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.util.HashMap;
import java.util.Map;

/**
 * 灵动岛配置读取（集成版）。
 *
 * 与独立版 LiveIsland 的差别：不再使用自己的 ContentProvider，
 * 直接复用「华为一键优化」App 的开关存储，四个通道依次尝试：
 * 1) XSharedPreferences(com.huawei.onekey.optimizer / onekey) —— LSPosed 提供
 * 2) persist.sys.onekey.* 系统属性
 * 3) /data/adb/huawei_onekey/flags.sh
 * 4) 内置默认值
 *
 * 设置变更时 App 会发 ACTION_CHANGED 广播，SystemUI 侧收到即重载。
 */
public final class IslandPrefs {

    public static final String ACTION_CHANGED =
            "com.huawei.onekey.optimizer.ISLAND_PREFS_CHANGED";

    public static final int BG_FROSTED = 0;
    public static final int BG_BLACK = 2;

    /** 总开关 */
    public static final String K_ENABLED = "hook_island";
    /** 背景样式 */
    public static final String K_BG = "island_bg";
    /** 背景自动反色跟随 */
    public static final String K_BG_FOLLOW = "island_bg_follow";

    public static final String K_FEAT_MEDIA = "island_feat_media";
    public static final String K_FEAT_NAV = "island_feat_nav";
    public static final String K_FEAT_CAPSULE = "island_feat_capsule";
    public static final String K_FEAT_STOPWATCH = "island_feat_stopwatch";
    public static final String K_FEAT_USB = "island_feat_usb";
    public static final String K_FEAT_CHARGE = "island_feat_charge";
    public static final String K_FEAT_FLASH = "island_feat_flash";
    public static final String K_FEAT_RECORD = "island_feat_record";

    public static final String[] ALL_KEYS = new String[]{
            K_ENABLED, K_BG, K_BG_FOLLOW,
            K_FEAT_MEDIA, K_FEAT_NAV, K_FEAT_CAPSULE, K_FEAT_STOPWATCH,
            K_FEAT_USB, K_FEAT_CHARGE, K_FEAT_FLASH, K_FEAT_RECORD
    };

    private static final String PKG = "com.huawei.onekey.optimizer";
    private static final String SP = "onekey";
    private static final String FLAGS_FILE = "/data/adb/huawei_onekey/flags.sh";

    private static final Map<String, String> CACHE = new HashMap<String, String>();

    static {
        for (String k : ALL_KEYS) {
            CACHE.put(k, defaultOf(k));
        }
    }

    private IslandPrefs() {
    }

    private static String defaultOf(String key) {
        if (K_ENABLED.equals(key)) {
            return "1";
        }
        if (K_BG.equals(key)) {
            return String.valueOf(BG_BLACK);
        }
        return "1";
    }

    // ================= 读取 =================

    public static synchronized void load(Context ctx) {
        Map<String, String> m = new HashMap<String, String>();
        readXsp(m);
        Map<String, String> fl = null;
        for (String k : ALL_KEYS) {
            if (m.containsKey(k)) {
                continue;
            }
            String v = prop(k);
            if (v == null) {
                if (fl == null) {
                    fl = readFlags();
                }
                v = fl.get(k);
            }
            if (v != null) {
                m.put(k, v);
            }
        }
        CACHE.clear();
        for (String k : ALL_KEYS) {
            String v = m.get(k);
            CACHE.put(k, v == null ? defaultOf(k) : v);
        }
        Log.i(IslandHook.TAG, "prefs loaded: enabled=" + CACHE.get(K_ENABLED)
                + " bg=" + CACHE.get(K_BG));
    }

    private static void readXsp(Map<String, String> out) {
        try {
            Class<?> c = Class.forName("de.robv.android.xposed.XSharedPreferences");
            Object xsp = c.getConstructor(String.class, String.class).newInstance(PKG, SP);
            c.getMethod("reload").invoke(xsp);
            Object all = c.getMethod("getAll").invoke(xsp);
            if (!(all instanceof Map)) {
                return;
            }
            for (Object o : ((Map<?, ?>) all).entrySet()) {
                Map.Entry<?, ?> e = (Map.Entry<?, ?>) o;
                if (e.getKey() == null || e.getValue() == null) {
                    continue;
                }
                String k = String.valueOf(e.getKey());
                Object v = e.getValue();
                String sv = (v instanceof Boolean)
                        ? (((Boolean) v).booleanValue() ? "1" : "0") : String.valueOf(v);
                out.put(k, sv);
            }
        } catch (Throwable t) {
            Log.i(IslandHook.TAG, "xsp read failed: " + t);
        }
    }

    private static String prop(String key) {
        try {
            Class<?> sp = Class.forName("android.os.SystemProperties");
            Object v = sp.getMethod("get", String.class, String.class)
                    .invoke(null, "persist.sys.onekey." + key, "");
            if (v instanceof String && ((String) v).length() > 0) {
                return (String) v;
            }
        } catch (Throwable ignored) {
        }
        return null;
    }

    private static Map<String, String> readFlags() {
        Map<String, String> m = new HashMap<String, String>();
        File f = new File(FLAGS_FILE);
        if (!f.exists()) {
            return m;
        }
        BufferedReader r = null;
        try {
            r = new BufferedReader(new FileReader(f));
            String line;
            while ((line = r.readLine()) != null) {
                line = line.trim();
                int i = line.indexOf('=');
                if (i <= 0) {
                    continue;
                }
                String k = line.substring(0, i).trim();
                String v = line.substring(i + 1).trim();
                if (k.startsWith("onekey_")) {
                    m.put(k.substring(7), v);
                }
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
        return m;
    }

    public static String get(String key, String def) {
        String v = CACHE.get(key);
        return v == null ? def : v;
    }

    public static boolean getBool(String key, boolean def) {
        String v = CACHE.get(key);
        if (v == null) {
            return def;
        }
        return "1".equals(v) || "true".equalsIgnoreCase(v);
    }

    public static int getInt(String key, int def) {
        try {
            String v = CACHE.get(key);
            return v == null ? def : Integer.parseInt(v);
        } catch (Throwable t) {
            return def;
        }
    }

    public static boolean enabled() {
        return getBool(K_ENABLED, false);
    }

    public static int bgMode() {
        int m = getInt(K_BG, BG_BLACK);
        if (m != BG_FROSTED && m != BG_BLACK) {
            return BG_BLACK;
        }
        return m;
    }

    public static void watch(Context ctx, final Runnable onChange) {
        if (ctx == null || onChange == null) {
            return;
        }
        try {
            ctx.registerReceiver(new BroadcastReceiver() {
                @Override
                public void onReceive(Context c, Intent intent) {
                    load(c);
                    onChange.run();
                }
            }, new IntentFilter(ACTION_CHANGED));
        } catch (Throwable t) {
            Log.i(IslandHook.TAG, "prefs watch failed: " + t);
        }
    }
}