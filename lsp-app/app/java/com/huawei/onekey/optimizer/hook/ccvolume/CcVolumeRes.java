package com.huawei.onekey.optimizer.hook.ccvolume;

import android.content.Context;
import android.content.res.Resources;
import android.util.Log;

/**
 * 控制中心音量条（原 CCVolume 模块）的资源桥。
 *
 * 原模块自带一个 App，音量条的 4 个音量图标和音量条背景都直接从
 * 自己的 R$drawable 里取。整合进本模块后这些资源搬到本 App 的 res 下，
 * 但 smali 里不能写死 R 常量（资源 ID 每次构建都可能变），
 * 所以由这个类在运行时按名字解析，smali 改成调用这里。
 */
public final class CcVolumeRes {

    private static final String TAG = "CCVolume: ";
    private static final String PKG = "com.huawei.onekey.optimizer";

    private static Resources sRes;

    private CcVolumeRes() {
    }

    private static synchronized Resources res(Context c) {
        if (sRes != null) {
            return sRes;
        }
        try {
            sRes = c.createPackageContext(PKG, 0).getResources();
        } catch (Throwable t) {
            sRes = c.getResources();
        }
        return sRes;
    }

    private static int id(Context c, String name) {
        int v = 0;
        try {
            v = res(c).getIdentifier(name, "drawable", PKG);
        } catch (Throwable t) {
            Log.w(TAG, "resolve " + name + " failed: " + t);
        }
        if (v == 0) {
            Log.w(TAG, "drawable not found: " + name);
        }
        return v;
    }

    public static int mirrorBg(Context c) {
        return id(c, "cc_mirror_bg");
    }

    public static int icMute(Context c) {
        return id(c, "cc_ic_volume_mute");
    }

    public static int icLow(Context c) {
        return id(c, "cc_ic_volume_low");
    }

    public static int icMedium(Context c) {
        return id(c, "cc_ic_volume_medium");
    }

    public static int icHigh(Context c) {
        return id(c, "cc_ic_volume_high");
    }
}
