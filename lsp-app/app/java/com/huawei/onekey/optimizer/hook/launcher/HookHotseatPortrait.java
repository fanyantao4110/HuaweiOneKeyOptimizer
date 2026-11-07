package com.huawei.onekey.optimizer.hook.launcher;

import android.view.View;
import android.view.ViewGroup;

import com.huawei.onekey.optimizer.hook.launcher.Kit;

import de.robv.android.xposed.XC_MethodHook;

/**
 * 功能 5：竖屏保留右侧（dock 与桌面布局解耦后的重排）。
 *
 * 对应教程【五】：转屏时 launcher 只改网格大小，不重新绑定图标，
 * 所以必须直接改「child 的 layoutParams.cellX」+「ItemInfo.cellX」再 requestLayout()。
 *
 * 重排规则与原教程一致：offset = 竖屏 ? max(0, 图标数 - 8) : 0，cellX = max(0, i - offset)。
 * 横屏 offset=0 → 恢复 0..10；竖屏把最后 8 个（右侧）对齐显示。
 */
public final class HookHotseatPortrait {

    private static final String CLS = "com.huawei.android.launcher.hotseat.NormalHotseatImpl";

    /** 竖屏可见列数 */
    private static final int PORTRAIT_VISIBLE = 8;

    private HookHotseatPortrait() {
    }

    public static void install(ClassLoader cl) {
        Class<?> c = Kit.load(cl, CLS);
        if (c == null) {
            return;
        }
        Kit.hook(c, "setHotseatGrid", 0, new XC_MethodHook() {
            @Override
            protected void afterHookedMethod(MethodHookParam p) {
                relayout(p.thisObject);
            }
        });
        // 原厂还有 relayoutHotseat() 路径，一并跟上，保证转屏后位置立即正确
        Kit.hook(c, "relayoutHotseat", 0, new XC_MethodHook() {
            @Override
            protected void afterHookedMethod(MethodHookParam p) {
                relayout(p.thisObject);
            }
        });
    }

    private static void relayout(Object hotseat) {
        try {
            Object layout = Kit.call(hotseat, "getLayout");
            if (layout == null) {
                layout = Kit.get(hotseat, "mContent");   // 教程同款字段（CellLayout，protected）
            }
            if (!(layout instanceof ViewGroup)) {
                Kit.once("hotseat.nocontent", "竖屏重排：未取到 dock 的 CellLayout");
                return;
            }
            ViewGroup container = iconContainer((ViewGroup) layout);
            if (container == null) {
                return;
            }

            int count = container.getChildCount();
            boolean portrait = Kit.portrait();
            int offset = portrait ? Math.max(0, count - PORTRAIT_VISIBLE) : 0;

            int changed = 0;
            for (int i = 0; i < count; i++) {
                View child = container.getChildAt(i);
                if (child == null) {
                    continue;
                }
                int cellX = Math.max(0, i - offset);
                Object tag = child.getTag();          // ItemInfo
                if (tag != null && Kit.setInt(tag, "cellX", cellX)) {
                    changed++;
                }
                ViewGroup.LayoutParams lp = child.getLayoutParams();
                if (lp != null && Kit.setInt(lp, "cellX", cellX)) {
                    changed++;
                }
            }
            container.requestLayout();
            Kit.once("hotseat.done", "竖屏保留右侧：图标数=" + count + " 偏移=" + offset
                    + " 改写字段=" + changed + "（" + (portrait ? "竖屏" : "横屏") + "）");
        } catch (Throwable t) {
            Kit.err("dock 重排失败", t);
        }
    }

    /** 优先取 ShortcutAndWidgetContainer（真正放图标的容器），取不到时递归找「子视图带 tag」的容器 */
    private static ViewGroup iconContainer(ViewGroup layout) {
        Object sc = Kit.call(layout, "getShortcutsAndWidgets");
        if (sc instanceof ViewGroup) {
            return (ViewGroup) sc;
        }
        for (int i = 0; i < layout.getChildCount(); i++) {
            View child = layout.getChildAt(i);
            if (!(child instanceof ViewGroup)) {
                continue;
            }
            ViewGroup g = (ViewGroup) child;
            if (g.getChildCount() > 0 && g.getChildAt(0) != null && g.getChildAt(0).getTag() != null) {
                return g;
            }
        }
        return null;
    }
}
