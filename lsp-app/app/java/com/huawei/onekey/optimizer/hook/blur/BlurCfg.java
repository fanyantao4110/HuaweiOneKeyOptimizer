package com.huawei.onekey.optimizer.hook.blur;

/**
 * 桌面模糊（ColorOS 风格）的运行时配置。
 *
 * 桌面进程不能读本应用的 SharedPreferences，统一走 persist.sys.onekey.* 系统属性，
 * 由界面里的「应用到桌面」/开关切换写入。每次转场信号都会重新读取，
 * 所以调半径、开关模糊都能在下一个转场立刻生效，无需重启桌面。
 */
public final class BlurCfg {

    public static final int DEF_RADIUS = 46;
    public static final int MAX_RADIUS = 100;

    public static final String PROP_ENABLE = "persist.sys.onekey.launcher_blur";
    public static final String PROP_RADIUS = "persist.sys.onekey.launcher_blur_radius";

    private BlurCfg() {
    }

    /** 总开关：app 打开/关闭 + Dock + 壁纸 一起生效。 */
    public static boolean enabled() {
        return "1".equals(get(PROP_ENABLE, "0"));
    }

    public static int radius() {
        int r = parseInt(get(PROP_RADIUS, String.valueOf(DEF_RADIUS)), DEF_RADIUS);
        if (r < 1) {
            r = 1;
        }
        if (r > MAX_RADIUS) {
            r = MAX_RADIUS;
        }
        return r;
    }

    private static String get(String key, String def) {
        try {
            Class<?> sp = Class.forName("android.os.SystemProperties");
            Object v = sp.getMethod("get", String.class, String.class).invoke(null, key, def);
            return v == null ? def : v.toString();
        } catch (Throwable t) {
            return def;
        }
    }

    private static int parseInt(String s, int def) {
        try {
            return Integer.parseInt(s.trim());
        } catch (Throwable t) {
            return def;
        }
    }
}
