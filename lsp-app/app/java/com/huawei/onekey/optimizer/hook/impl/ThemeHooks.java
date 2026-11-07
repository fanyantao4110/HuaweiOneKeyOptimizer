package com.huawei.onekey.optimizer.hook.impl;

import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.util.Locale;
import android.app.Notification;
import android.os.Bundle;
import android.view.View;
import android.widget.TextView;


import com.huawei.onekey.optimizer.hook.HookFlags;

import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.callbacks.XC_LoadPackage;

/**
 * 主题解锁总实现（唯一开关：HookFlags.K_THEME / 设置里的「主题解锁」）。
 *
 * 整块逻辑全在这一个类里，不再有 smali 版 ThemeHook 回退、也不再拆第二个类：
 *
 * A. system_server（packageName == "android"）
 *    android.hwtheme.HwThemeManager 里「返回 boolean 且名字含 check/valid/author/restrict/verify/need」
 *    的方法统一返回 true —— 系统侧的主题授权/校验放行。
 *
 * B. 主题商店（packageName == "com.huawei.android.thememanager"）12.0.44.300 逆向结论：
 *   1) 试用总开关
 *       qy9.g1()Z（client_support_tryout_theme）/ qy9.e1()Z（client_support_tryout_font）→ true
 *   2) 永久试用
 *       TryOutTimeFenceService 是到期执行体（AwarenessKit 时间围栏 → 服务 → 回滚主题）。
 *       逐个方法按语义废掉：void→空实现、boolean→false、onStartCommand→START_NOT_STICKY，
 *       于是到期不回滚、开机不回滚、点通知不回滚、进度条不弹。
 *   3) 通知栏不显示「正在试用」
 *       a. TryOutTimeFenceService 的通知相关方法已空实现；
 *       b. 进程内拦 NotificationManager.notify：渠道/tag/extras/文案含 tryout / 试用 / trial 的直接丢弃。
 *   4) 所有主题强制显示试用入口
 *       hook 主题预览/字体预览的刷新方法，执行后反射把 isEnableTryout 置 true，
 *       并调用 info 包装器上的 (boolean,boolean) 方法传 (true,true) 强制 VISIBLE
 *       （字体侧直接改 setTryOutButtonVisibility 的两个入参）。
 *   5) 解除「同时只能试用一个资源」互斥
 *       LocalThemePreviewActivity.hadTryoutFont()Z       → false
 *       BaseOnlineFontPreviewActivity.hadTryoutTheme()Z  → false
 *       OnlineWallpaperPreviewActivity.showWarnTryoutApplyThemeDialog()Z → false
 *       OnlineThemePreviewActivity.isTimeAutoSettingsOpen()Z → true（不再因「时间未自动」拒绝试用）
 *   6) 试用倒计时彻底不显示
 *       主题预览页底栏「剩余时间：mm:ss / 试用到期时间：yyyy-MM-dd」由
 *       BottomComponentFlotView.G(J)V 每秒刷新（tw6.t() → ch6.a(J)）。
 *       类名方法名都是混淆名，改为拦本进程 TextView.setText：
 *       文案含「剩余时间」「试用到期时间」→ 置空 + 控件 GONE（父容器只有图标+该文案时连父容器一起隐藏）。
 *
 * 所有 hook 都逐项 try/catch，任何类/方法在对不上的版本上缺失都只影响自己那一项。
 */
public final class ThemeHooks {

    private static final String TAG = "[OneKey][Theme] ";

    private static final String[] KEYWORDS = {
            "check", "valid", "author", "restrict", "verify", "need"
    };

    // ---- com.huawei.android.thememanager ----
    private static final String C_SERVICE =
            "com.huawei.android.thememanager.mvp.model.helper.tryout.TryOutTimeFenceService";
    private static final String C_LOCAL =
            "com.huawei.android.thememanager.mvp.view.activity.onlinetheme.LocalThemePreviewActivity";
    private static final String C_ONLINE =
            "com.huawei.android.thememanager.mvp.view.activity.onlinetheme.OnlineThemePreviewActivity";
    private static final String C_FONT =
            "com.huawei.android.thememanager.mvp.view.activity.onlinefont.BaseOnlineFontPreviewActivity";
    private static final String C_WALL =
            "com.huawei.android.thememanager.mvp.view.activity.onlinewallpaper.OnlineWallpaperPreviewActivity";

    /** 试用总开关所在的混淆工具类候选名（12.0.44.300 = qy9） */
    private static final String[] C_TRYOUT_UTIL = {"qy9", "qp9", "qq9"};

    /** 试用总开关候选方法名（g1=主题, e1=字体） */
    private static final String[] M_TRYOUT_ENABLE = {
            "g1", "e1", "isTryoutThemeEnable", "isTryoutFontEnable"
    };

    /** 到期执行体里要废掉的方法（精确名 + releaseTryOut* 前缀） */
    private static final String[] M_TIMEFENCE = {
            "showNotification", "clearTryoutNotification",
            "timeFenceIsArrived", "startIntentActionEvent",
            "showProgressAndReleaseTheme",
            "releaseTryOutThemeMain", "releaseTryOutFontMain", "releaseTryOutWallpaperMain",
            "tryOutThemeReleaseFinished"
    };

    /** 需要「执行后强制试用控件可见」的 Activity 方法 */
    private static final String[] M_FORCE_VISIBLE = {
            "showTaskAd", "showTryOutButton", "initToolbarLayout", "tryOutAfterCheck",
            "updateTryoutState", "refreshTryoutState"
    };

    private ThemeHooks() {
    }

    // ==================================================================
    // 入口：唯一开关
    // ==================================================================

    public static void install(XC_LoadPackage.LoadPackageParam lp) {
        if (lp == null || lp.packageName == null) {
            return;
        }
        if (!HookFlags.enabled(HookFlags.K_THEME)) {
            log("开关关闭（hook_theme=false），不安装任何主题 hook");
            return;
        }
        try {
            if ("android".equals(lp.packageName)) {
                int n = hookSystemTheme(lp.classLoader);
                log("system_server HwThemeManager hooked=" + n);
            } else if ("com.huawei.android.thememanager".equals(lp.packageName)) {
                int enable = hookTryoutEnable(lp.classLoader);
                int service = hookTimeFenceService(lp.classLoader);
                int notify = hookNotification(lp.classLoader);
                int preview = hookPreviews(lp.classLoader);
                int countdown = hookCountdownText(lp.classLoader);
                log("thememanager: enable=" + enable + " service=" + service
                        + " notify=" + notify + " preview=" + preview
                        + " countdown=" + countdown);
            }
        } catch (Throwable t) {
            log("install 异常: " + t);
        }
    }

    // ==================================================================
    // A. system_server：android.hwtheme.HwThemeManager
    // ==================================================================

    private static int hookSystemTheme(ClassLoader cl) {
        int hooked = 0;
        try {
            Class<?> c = Class.forName("android.hwtheme.HwThemeManager", false, cl);
            for (Method m : c.getDeclaredMethods()) {
                if (m.getReturnType() != boolean.class) {
                    continue;
                }
                if (!matchesKeyword(m.getName().toLowerCase(Locale.ROOT))) {
                    continue;
                }
                try {
                    XposedBridge.hookMethod(m, TRUE_RESULT);
                    hooked++;
                } catch (Throwable ignored) {
                }
            }
        } catch (Throwable t) {
            log("HwThemeManager 不可用: " + t);
        }
        return hooked;
    }

    private static boolean matchesKeyword(String lowerName) {
        for (String k : KEYWORDS) {
            if (lowerName.contains(k)) {
                return true;
            }
        }
        return false;
    }

    // ==================================================================
    // B1. 试用总开关 qy9.g1() / qy9.e1()
    // ==================================================================

    private static int hookTryoutEnable(ClassLoader cl) {
        int n = 0;
        for (String cn : C_TRYOUT_UTIL) {
            Class<?> c;
            try {
                c = Class.forName(cn, false, cl);
            } catch (Throwable t) {
                continue;
            }
            for (Method m : c.getDeclaredMethods()) {
                if (m.getReturnType() != boolean.class || m.getParameterTypes().length != 0) {
                    continue;
                }
                if (!isTryoutSwitch(m.getName())) {
                    continue;
                }
                try {
                    XposedBridge.hookMethod(m, TRUE_RESULT);
                    n++;
                } catch (Throwable ignored) {
                }
            }
        }
        if (n == 0) {
            // 混淆名变了也没关系：下面 Activity 兜底会把 isEnableTryout 置 true
            log("试用总开关注入失败（候选类未命中），依赖 Activity 兜底");
        }
        return n;
    }

    private static boolean isTryoutSwitch(String name) {
        for (String k : M_TRYOUT_ENABLE) {
            if (k.equals(name)) {
                return true;
            }
        }
        return false;
    }

    // ==================================================================
    // B2. 永久试用：废掉 TryOutTimeFenceService
    // ==================================================================

    private static int hookTimeFenceService(ClassLoader cl) {
        Class<?> c;
        try {
            c = Class.forName(C_SERVICE, false, cl);
        } catch (Throwable t) {
            log("TryOutTimeFenceService 不存在: " + t);
            return 0;
        }
        int n = 0;
        for (Method m : c.getDeclaredMethods()) {
            String name = m.getName();
            if ("<init>".equals(name) || "<clinit>".equals(name)) {
                continue;
            }
            if (!needNeuter(name)) {
                continue;
            }
            Class<?> rt = m.getReturnType();
            XC_MethodHook hook;
            if (rt == void.class) {
                hook = VOID_RESULT;
            } else if (rt == boolean.class) {
                hook = FALSE_RESULT;
            } else if (rt == int.class) {
                hook = INT_NOT_STICKY;
            } else {
                continue;
            }
            try {
                XposedBridge.hookMethod(m, hook);
                n++;
            } catch (Throwable ignored) {
            }
        }
        return n;
    }

    private static boolean needNeuter(String name) {
        if (name.startsWith("releaseTryOut") || name.startsWith("releaseTryout")) {
            return true;
        }
        if ("onStartCommand".equals(name) || "onHandleWork".equals(name)) {
            return true;
        }
        for (String k : M_TIMEFENCE) {
            if (k.equals(name)) {
                return true;
            }
        }
        return false;
    }

    // ==================================================================
    // B3. 通知栏不显示「正在试用」
    // ==================================================================

    private static int hookNotification(ClassLoader cl) {
        int n = 0;
        try {
            Class<?> nm = Class.forName("android.app.NotificationManager", false, cl);
            for (Method m : nm.getDeclaredMethods()) {
                if (!"notify".equals(m.getName())) {
                    continue;
                }
                if (m.getReturnType() != void.class) {
                    continue;
                }
                boolean hasNotification = false;
                for (Class<?> p : m.getParameterTypes()) {
                    if (Notification.class.equals(p)) {
                        hasNotification = true;
                    }
                }
                if (!hasNotification) {
                    continue;
                }
                try {
                    XposedBridge.hookMethod(m, SUPPRESS_TRYOUT_NOTIFY);
                    n++;
                } catch (Throwable ignored) {
                }
            }
        } catch (Throwable t) {
            log("NotificationManager hook 失败: " + t);
        }
        return n;
    }

    private static boolean isTryoutNotification(Object tag, Notification noti) {
        if (tag != null && String.valueOf(tag).toLowerCase(Locale.ROOT).contains("tryout")) {
            return true;
        }
        if (noti == null) {
            return false;
        }
        try {
            String ch = noti.getChannelId();
            if (ch != null && ch.toLowerCase(Locale.ROOT).contains("tryout")) {
                return true;
            }
        } catch (Throwable ignored) {
        }
        try {
            Bundle ex = noti.extras;
            if (ex != null) {
                for (String k : ex.keySet()) {
                    if (k != null && k.toLowerCase(Locale.ROOT).contains("tryout")) {
                        return true;
                    }
                }
                if (hasTryoutWord(ex.getCharSequence(Notification.EXTRA_TITLE))
                        || hasTryoutWord(ex.getCharSequence(Notification.EXTRA_TEXT))
                        || hasTryoutWord(ex.getCharSequence(Notification.EXTRA_BIG_TEXT))) {
                    return true;
                }
            }
        } catch (Throwable ignored) {
        }
        return false;
    }

    private static boolean hasTryoutWord(CharSequence cs) {
        if (cs == null) {
            return false;
        }
        String s = cs.toString();
        return s.contains("试用") || s.toLowerCase(Locale.ROOT).contains("trial");
    }

    // ==================================================================
    // B4 + B5. 预览页：试用入口常显 + 解除互斥
    // ==================================================================

    private static int hookPreviews(ClassLoader cl) {
        int n = 0;

        Class<?> local = findClass(C_LOCAL, cl);
        if (local != null) {
            n += hookReturned(local, "hadTryoutFont", Boolean.FALSE);
            n += hookForceVisible(local);
        }

        Class<?> online = findClass(C_ONLINE, cl);
        if (online != null) {
            n += hookReturned(online, "isTimeAutoSettingsOpen", Boolean.TRUE);
            n += hookForceVisible(online);
        }

        Class<?> font = findClass(C_FONT, cl);
        if (font != null) {
            n += hookReturned(font, "hadTryoutTheme", Boolean.FALSE);
            n += hookFontTryButton(font);
        }

        Class<?> wall = findClass(C_WALL, cl);
        if (wall != null) {
            n += hookReturned(wall, "showWarnTryoutApplyThemeDialog", Boolean.FALSE);
        }
        return n;
    }

    /** 把指定名字的 boolean 方法固定成某个返回值 */
    private static int hookReturned(Class<?> owner, String name, final Object value) {
        int n = 0;
        try {
            for (Method m : owner.getDeclaredMethods()) {
                if (!name.equals(m.getName()) || m.getReturnType() != boolean.class) {
                    continue;
                }
                try {
                    XposedBridge.hookMethod(m, new XC_MethodHook() {
                        @Override
                        protected void beforeHookedMethod(MethodHookParam param) {
                            param.setResult(value);
                        }
                    });
                    n++;
                } catch (Throwable ignored) {
                }
            }
        } catch (Throwable t) {
            log(owner.getSimpleName() + "." + name + " 失败: " + t);
        }
        return n;
    }

    /** 预览页刷新方法执行完后，强制一次「试用控件可见」 */
    private static int hookForceVisible(Class<?> owner) {
        int n = 0;
        for (String mn : M_FORCE_VISIBLE) {
            try {
                for (Method m : owner.getDeclaredMethods()) {
                    if (!mn.equals(m.getName())) {
                        continue;
                    }
                    try {
                        XposedBridge.hookMethod(m, FORCE_VISIBLE_HOOK);
                        n++;
                    } catch (Throwable ignored) {
                    }
                }
            } catch (Throwable ignored) {
            }
        }
        return n;
    }

    /** 字体预览 setTryOutButtonVisibility(show, enable) → 入参强制 (true, true) */
    private static int hookFontTryButton(Class<?> owner) {
        int n = 0;
        try {
            for (Method m : owner.getDeclaredMethods()) {
                if (!"setTryOutButtonVisibility".equals(m.getName())) {
                    continue;
                }
                Class<?>[] pt = m.getParameterTypes();
                if (pt.length != 2 || pt[0] != boolean.class || pt[1] != boolean.class) {
                    continue;
                }
                try {
                    XposedBridge.hookMethod(m, new XC_MethodHook() {
                        @Override
                        protected void beforeHookedMethod(MethodHookParam param) {
                            param.args[0] = Boolean.TRUE;
                            param.args[1] = Boolean.TRUE;
                            setBoolean(param.thisObject, "isEnableTryout", true);
                        }
                    });
                    n++;
                } catch (Throwable ignored) {
                }
            }
        } catch (Throwable ignored) {
        }
        return n;
    }

    /**
     * 反射把 Activity 的 isEnableTryout 置 true，并让信息面板上的试用控件 VISIBLE。
     * mInfoWraper 的类型（helper.h）与它的 Q(ZZ)V 都是混淆名，只按「字段名 + 参数签名」定位。
     */
    private static void forceTrialVisible(Object activity) {
        if (activity == null) {
            return;
        }
        setBoolean(activity, "isEnableTryout", true);
        Object wrapper = getField(activity, "mInfoWraper");
        if (wrapper == null) {
            return;
        }
        Method q = findMethod(wrapper.getClass(), void.class, boolean.class, boolean.class);
        if (q == null) {
            return;
        }
        try {
            q.setAccessible(true);
            q.invoke(wrapper, Boolean.TRUE, Boolean.TRUE);
        } catch (Throwable ignored) {
        }
    }

    // ==================================================================
    // B6. 试用倒计时彻底不显示（不动布局文件，运行期过滤文本）
    // ==================================================================

    /**
     * 主题预览页底栏的「剩余时间：mm:ss」/「试用到期时间：yyyy-MM-dd」由
     * BottomComponentFlotView.G(J)V 拼好后 setText 到自己的 HwTextView 上，
     * 每秒由 tw6.t() 回调 a(J) 刷新一次。这些类名/方法名都是混淆名，
     * 所以这里不去碰具体类，而是拦本进程内 TextView.setText：
     * 文本里含「剩余时间」或「试用到期时间」就直接置空并把控件 GONE
     * （父容器只剩图标+这段文字时，连父容器一起 GONE，避免留空行）。
     *
     * 只影响主题商店进程里这两个词，其它文案（如「剩余支付时间」「剩余 3 分钟」）不受影响。
     */
    private static int hookCountdownText(ClassLoader cl) {
        int n = 0;
        try {
            Class<?> tv = Class.forName("android.widget.TextView", false, cl);
            for (Method m : tv.getDeclaredMethods()) {
                if (!"setText".equals(m.getName())) {
                    continue;
                }
                Class<?>[] pt = m.getParameterTypes();
                if (pt.length != 1 || pt[0] != CharSequence.class) {
                    continue;
                }
                try {
                    XposedBridge.hookMethod(m, DROP_COUNTDOWN_TEXT);
                    n++;
                } catch (Throwable ignored) {
                }
            }
        } catch (Throwable t) {
            log("TextView.setText hook 失败: " + t);
        }
        return n;
    }

    /** 倒计时文案特征词 */
    private static boolean isCountdownText(CharSequence cs) {
        if (cs == null) {
            return false;
        }
        String s = cs.toString();
        return s.contains("剩余时间") || s.contains("试用到期时间");
    }

    private static final XC_MethodHook DROP_COUNTDOWN_TEXT = new XC_MethodHook() {
        @Override
        protected void beforeHookedMethod(MethodHookParam param) {
            try {
                if (param.args == null || param.args.length != 1) {
                    return;
                }
                Object a0 = param.args[0];
                if (!(a0 instanceof CharSequence) || !isCountdownText((CharSequence) a0)) {
                    return;
                }
                String raw = a0.toString();
                param.args[0] = "";
                if (param.thisObject instanceof View) {
                    hideCountdownView((View) param.thisObject);
                }
                if (HIDDEN_LOGGED < 5) {
                    HIDDEN_LOGGED++;
                    log("已隐藏倒计时文案[" + HIDDEN_LOGGED + "]: " + raw);
                }
            } catch (Throwable ignored) {
            }
        }
    };

    /** 只在前几次打印，避免每秒刷日志 */
    private static int HIDDEN_LOGGED = 0;

    /** 把倒计时文字控件（以及「图标+文字」这种两子控件的父容器）整体隐藏 */
    private static void hideCountdownView(View v) {
        v.setVisibility(View.GONE);
        try {
            Object parent = v.getParent();
            if (parent instanceof android.view.ViewGroup) {
                android.view.ViewGroup g = (android.view.ViewGroup) parent;
                if (g.getChildCount() <= 2) {
                    g.setVisibility(View.GONE);
                }
            }
        } catch (Throwable ignored) {
        }
    }

    // ==================================================================
    // hook 回调
    // ==================================================================

    private static final XC_MethodHook TRUE_RESULT = new XC_MethodHook() {
        @Override
        protected void afterHookedMethod(MethodHookParam param) {
            param.setResult(Boolean.TRUE);
        }
    };

    private static final XC_MethodHook FALSE_RESULT = new XC_MethodHook() {
        @Override
        protected void beforeHookedMethod(MethodHookParam param) {
            param.setResult(Boolean.FALSE);
        }
    };

    private static final XC_MethodHook VOID_RESULT = new XC_MethodHook() {
        @Override
        protected void beforeHookedMethod(MethodHookParam param) {
            param.setResult(null);
        }
    };

    /** Service.START_NOT_STICKY = 2：不执行原逻辑，也不要系统反复重启 */
    private static final XC_MethodHook INT_NOT_STICKY = new XC_MethodHook() {
        @Override
        protected void beforeHookedMethod(MethodHookParam param) {
            param.setResult(Integer.valueOf(2));
        }
    };

    private static final XC_MethodHook FORCE_VISIBLE_HOOK = new XC_MethodHook() {
        @Override
        protected void afterHookedMethod(MethodHookParam param) {
            forceTrialVisible(param.thisObject);
        }
    };

    private static final XC_MethodHook SUPPRESS_TRYOUT_NOTIFY = new XC_MethodHook() {
        @Override
        protected void beforeHookedMethod(MethodHookParam param) {
            try {
                Object tag = null;
                Notification noti = null;
                for (Object a : param.args) {
                    if (a instanceof Notification) {
                        noti = (Notification) a;
                    } else if (a instanceof String && tag == null) {
                        tag = a;
                    }
                }
                if (isTryoutNotification(tag, noti)) {
                    param.setResult(null);
                }
            } catch (Throwable ignored) {
            }
        }
    };

    // ==================================================================
    // 反射小工具
    // ==================================================================

    private static Class<?> findClass(String name, ClassLoader cl) {
        try {
            return Class.forName(name, false, cl);
        } catch (Throwable t) {
            log("类不存在: " + name);
            return null;
        }
    }

    private static Field findField(Class<?> c, String name) {
        for (Class<?> k = c; k != null && k != Object.class; k = k.getSuperclass()) {
            try {
                Field f = k.getDeclaredField(name);
                f.setAccessible(true);
                return f;
            } catch (Throwable ignored) {
            }
        }
        return null;
    }

    private static Object getField(Object target, String name) {
        try {
            Field f = findField(target.getClass(), name);
            return f == null ? null : f.get(target);
        } catch (Throwable ignored) {
            return null;
        }
    }

    private static void setBoolean(Object target, String name, boolean value) {
        try {
            Field f = findField(target.getClass(), name);
            if (f != null && f.getType() == boolean.class) {
                f.setBoolean(target, value);
            }
        } catch (Throwable ignored) {
        }
    }

    private static Method findMethod(Class<?> c, Class<?> ret, Class<?>... params) {
        for (Class<?> k = c; k != null && k != Object.class; k = k.getSuperclass()) {
            for (Method m : k.getDeclaredMethods()) {
                if (m.getReturnType() != ret) {
                    continue;
                }
                Class<?>[] pt = m.getParameterTypes();
                if (pt.length != params.length) {
                    continue;
                }
                boolean ok = true;
                for (int i = 0; i < pt.length; i++) {
                    if (pt[i] != params[i]) {
                        ok = false;
                        break;
                    }
                }
                if (ok) {
                    return m;
                }
            }
        }
        return null;
    }

    private static void log(String s) {
        try {
            XposedBridge.log(TAG + s);
        } catch (Throwable ignored) {
        }
    }
}