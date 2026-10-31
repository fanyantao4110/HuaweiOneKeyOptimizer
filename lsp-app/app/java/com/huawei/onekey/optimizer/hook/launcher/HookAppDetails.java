package com.huawei.onekey.optimizer.hook.launcher;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.res.Resources;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.provider.Settings;
import android.widget.ImageView;

import com.huawei.onekey.optimizer.hook.launcher.Kit;

import java.lang.reflect.Constructor;
import java.util.WeakHashMap;

import de.robv.android.xposed.XC_MethodHook;

/**
 * 功能 6：长按图标气泡里添加「应用详情」。
 *
 * 对应教程【六】，但做法针对本版 APK（14.0.0.921）做了精确适配，全部签名已从真实 dex 核对：
 *
 *  A. PopupContainerWithArrow#initDropActionViews()   （private void，气泡菜单装配处）
 *     → 在 after 钩子里取 mHeaderView，调用 PopupContainerHeader#addDropActionView(DropActionCommand)
 *  B. DropActionCommand 是【抽象类】，没法用动态代理造对象；教程是新建一个 smali 类，
 *     这里改为：借 DropActionCommand$UninstallCommand 的公开无参构造造一个「占位实例」，
 *     并用【实例身份比对】拦截它的 doAction —— 只有我们自己造的那个实例才会被替换成打开应用详情，
 *     原厂其它命令实例（真卸载等）完全不受影响。
 *  C. PopupContainerHeader#initActionView(DropActionCommand) → 给我们的菜单项强制写上文字和图标。
 *
 * 安全兜底：只有 doAction 钩子挂载成功（sReady）后才会注入菜单项，
 * 否则宁可什么都不加，也不会出现「点了却真的去卸载」的情况。
 */
public final class HookAppDetails {

    private static final String CLS_POPUP = "com.huawei.android.launcher.popup.PopupContainerWithArrow";
    private static final String CLS_HEADER = "com.huawei.android.launcher.popup.PopupContainerHeader";
    private static final String CLS_UNINSTALL =
            "com.huawei.android.launcher.model.DropActionCommand$UninstallCommand";

    private static final String LABEL = "应用详情";
    private static final int ACTION_ID = 21;   // 0x15：教程选用的未占用 action id

    private static volatile Object sCommand;
    private static volatile Class<?> sPopupClass;
    private static volatile boolean sReady;

    /** popup -> 已注入过的 header，避免同一次弹出重复添加菜单项 */
    private static final WeakHashMap<Object, Object> INJECTED = new WeakHashMap<Object, Object>();

    private HookAppDetails() {
    }

    public static void install(ClassLoader cl) {
        final Class<?> uninstall = Kit.load(cl, CLS_UNINSTALL);
        Class<?> header = Kit.load(cl, CLS_HEADER);
        Class<?> popup = Kit.load(cl, CLS_POPUP);
        if (uninstall == null || header == null || popup == null) {
            return;
        }
        sPopupClass = popup;

        // ---- A. 造一个占位命令对象 ----
        try {
            Constructor<?> ctor = uninstall.getDeclaredConstructor();
            ctor.setAccessible(true);
            Object cmd = ctor.newInstance();
            Kit.set(cmd, "mAction", ACTION_ID);
            Kit.set(cmd, "mTitleId", android.R.string.ok);                       // 占位，真实文字在 C 步强制写入
            Kit.set(cmd, "mIconId", android.R.drawable.ic_menu_info_details);
            sCommand = cmd;
            Kit.log("已创建「" + LABEL + "」命令占位实例：" + cmd.getClass().getName() + " action=" + ACTION_ID);
        } catch (Throwable t) {
            Kit.err("创建命令占位实例失败，功能 6 跳过", t);
            return;
        }

        // ---- B. 只拦截我们自己那个实例的 doAction ----
        int n = Kit.hook(uninstall, "doAction", 2, new XC_MethodHook() {
            @Override
            protected void beforeHookedMethod(MethodHookParam p) {
                if (p.thisObject != sCommand) {
                    return;    // 原厂命令（真卸载等）一律放行
                }
                p.setResult(null);   // void：跳过原厂实现
                Object launcher = (p.args != null && p.args.length > 0) ? p.args[0] : null;
                Object itemInfo = (p.args != null && p.args.length > 1) ? p.args[1] : null;
                openAppDetails(itemInfo, launcher);
            }
        });
        if (n == 0) {
            Kit.log("doAction 未挂钩成功：为安全起见不注入「应用详情」菜单项");
            return;
        }
        sReady = true;

        // ---- C. 菜单项文字 / 图标 ----
        Kit.hook(header, "initActionView", 1, new XC_MethodHook() {
            @Override
            protected void afterHookedMethod(MethodHookParam p) {
                Object arg = (p.args != null && p.args.length > 0) ? p.args[0] : null;
                if (arg != sCommand) {
                    return;
                }
                Kit.setTextIfTextView(Kit.get(p.thisObject, "mActionName"), LABEL);
                Object icon = Kit.get(p.thisObject, "mActionIcon");
                if (icon instanceof ImageView) {
                    applyIcon((ImageView) icon, Kit.get(p.thisObject, "mActionName"));
                }
                Kit.log("「" + LABEL + "」菜单项已初始化（文字/图标已写入）");
            }
        });

        // ---- D. 注入菜单项 ----
        Kit.hook(popup, "initDropActionViews", 0, new XC_MethodHook() {
            @Override
            protected void afterHookedMethod(MethodHookParam p) {
                inject(p.thisObject);
            }
        });
    }

    private static void inject(Object popup) {
        if (!sReady || sCommand == null || popup == null) {
            return;
        }
        try {
            // 仅普通图标（教程：itemType==0）；卡片 / 服务卡片 / 组合文件夹不注入，避免打乱原厂布局
            if (isTrue(popup, "mIsCard") || isTrue(popup, "mIsAbilityFormStack") || isTrue(popup, "mIsFormCombinationGroupView")
                    || isTrue(popup, "mIsRecommendInFormStack") || isTrue(popup, "mIsSceneCardInFormStack")) {
                Kit.once("appdetails.skip", "当前气泡不是普通图标（卡片/服务卡片/组合），跳过「应用详情」注入");
                return;
            }

            final Object header = Kit.get(popup, "mHeaderView");
            if (header == null) {
                Kit.once("appdetails.noheader", "未取到 PopupContainerWithArrow.mHeaderView，无法注入「应用详情」");
                return;
            }
            synchronized (INJECTED) {
                if (INJECTED.get(popup) == header) {
                    return;   // 同一次弹出，已经加过了
                }
                INJECTED.put(popup, header);
            }
            Kit.call(header, "addDropActionView", sCommand);
            Kit.once("appdetails.inject", "已在长按气泡中注入「" + LABEL + "」菜单项");
        } catch (Throwable t) {
            Kit.err("注入「应用详情」菜单失败", t);
        }
    }

    private static boolean isTrue(Object target, String field) {
        return Boolean.TRUE.equals(Kit.getBool(target, field));
    }

    // ------------------------------------------------------------------ 图标（鸿蒙图标库风格）
    /**
     * 原先是 android.R.drawable.ic_menu_info_details —— 一张 2010 年的位图，
     * 在鸿蒙的圆角菜单里又糊又违和。这里按优先级换掉：
     *   1) 模块内置的鸿蒙风格矢量图标（24dp 网格、1.6dp 圆头描边、可着色）
     *   2) 系统桌面自带的鸿蒙公共图标库 ic_public_* / ic_settings
     *   3) 实在没有才退回系统位图
     * 并用菜单文字的当前颜色做 SRC_IN 着色，浅色/深色主题都不会突兀。
     */
    private static final String[] SYS_ICONS = {
            "ic_public_app_info", "ic_public_info", "ic_settings",
            "ic_public_desktop_settings", "ic_infosign_1",
    };

    private static void applyIcon(ImageView iv, Object nameView) {
        int tint = 0xFF000000;
        try {
            if (nameView instanceof android.widget.TextView) {
                tint = ((android.widget.TextView) nameView).getCurrentTextColor();
            }
        } catch (Throwable ignored) {
        }
        Drawable d = pickDrawable(iv.getContext());
        if (d == null) {
            try {
                iv.setImageResource(android.R.drawable.ic_menu_info_details);
            } catch (Throwable ignored) {
            }
            return;
        }
        try {
            d = d.mutate();
            d.setColorFilter(tint, android.graphics.PorterDuff.Mode.SRC_IN);
        } catch (Throwable ignored) {
        }
        try {
            iv.setScaleType(ImageView.ScaleType.CENTER_INSIDE);
        } catch (Throwable ignored) {
        }
        iv.setImageDrawable(d);
    }

    private static Drawable pickDrawable(Context ctx) {
        if (ctx == null) {
            return null;
        }
        // 1) 模块内置矢量图标
        try {
            Context mod = ctx.createPackageContext("com.huawei.onekey.optimizer",
                    Context.CONTEXT_IGNORE_SECURITY);
            int id = mod.getResources().getIdentifier("ic_onekey_appinfo", "drawable",
                    "com.huawei.onekey.optimizer");
            if (id != 0) {
                Drawable d = mod.getResources().getDrawable(id, mod.getTheme());
                if (d != null) {
                    Kit.once("appdetails.icon.mod", "「应用详情」使用模块内置鸿蒙风格矢量图标");
                    return d;
                }
            }
        } catch (Throwable ignored) {
        }
        // 2) 桌面自带的鸿蒙公共图标库
        try {
            Resources r = ctx.getResources();
            for (String name : SYS_ICONS) {
                int id = r.getIdentifier(name, "drawable", "com.huawei.android.launcher");
                if (id == 0) {
                    continue;
                }
                Drawable d = r.getDrawable(id, ctx.getTheme());
                if (d != null) {
                    Kit.once("appdetails.icon.sys", "「应用详情」使用系统图标: " + name);
                    return d;
                }
            }
        } catch (Throwable ignored) {
        }
        return null;
    }

    // ------------------------------------------------------------------ 打开应用详情

    private static void openAppDetails(Object itemInfo, Object launcher) {
        try {
            Context ctx = Kit.contextOf(launcher);
            if (ctx == null) {
                ctx = Kit.appContext();
            }
            String pkg = packageOf(itemInfo);
            if (ctx == null || pkg == null || pkg.length() == 0) {
                Kit.log("「" + LABEL + "」：未能取得包名/上下文，取消本次跳转");
                return;
            }
            Intent intent = new Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS);
            intent.setData(Uri.fromParts("package", pkg, null));
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
            Kit.log("打开应用详情：" + pkg);
            try {
                // 详情页有独立 taskAffinity，用父栈 TaskStackBuilder 才能正常上滑返回桌面（教程血泪教训）
                android.app.TaskStackBuilder builder = android.app.TaskStackBuilder.create(ctx);
                builder.addNextIntentWithParentStack(intent);
                builder.startActivities();
            } catch (Throwable t) {
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                ctx.startActivity(intent);
            }
            closePopup(launcher);
        } catch (Throwable t) {
            Kit.err("打开应用详情失败", t);
        }
    }

    /** 从 ItemInfo 里取包名：ShortcutInfo.componentName 字段 -> getComponent() -> getTargetComponent() -> Intent -> 包名字段 */
    private static String packageOf(Object itemInfo) {
        if (itemInfo == null) {
            return null;
        }
        Object field = Kit.get(itemInfo, "componentName");
        if (field instanceof ComponentName) {
            return ((ComponentName) field).getPackageName();
        }
        Object c1 = Kit.call(itemInfo, "getComponent");
        if (c1 instanceof ComponentName) {
            return ((ComponentName) c1).getPackageName();
        }
        Object c2 = Kit.call(itemInfo, "getTargetComponent");
        if (c2 instanceof ComponentName) {
            return ((ComponentName) c2).getPackageName();
        }
        Object intent = Kit.call(itemInfo, "getIntent");
        if (intent instanceof Intent) {
            ComponentName cn = ((Intent) intent).getComponent();
            if (cn != null) {
                return cn.getPackageName();
            }
            String p = ((Intent) intent).getPackage();
            if (p != null && p.length() > 0) {
                return p;
            }
        }
        Object pkg = Kit.call(itemInfo, "getInfoPackageName");
        if (pkg instanceof String && ((String) pkg).length() > 0) {
            return (String) pkg;
        }
        return null;
    }

    /** 关掉长按气泡，避免返回桌面后气泡还留着 */
    private static void closePopup(Object launcher) {
        try {
            Class<?> pc = sPopupClass;
            if (pc == null || launcher == null) {
                return;
            }
            Object open = Kit.callStatic(pc, "getOpen", launcher);
            if (open != null) {
                Kit.call(open, "closeComplete");
            }
        } catch (Throwable ignored) {
            // 关闭失败不影响详情页跳转
        }
    }
}