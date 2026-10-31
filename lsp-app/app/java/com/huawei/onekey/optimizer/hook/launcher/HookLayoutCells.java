package com.huawei.onekey.optimizer.hook.launcher;

import com.huawei.onekey.optimizer.hook.launcher.LCfg;
import com.huawei.onekey.optimizer.hook.launcher.Kit;

import java.util.ArrayList;
import java.util.Collection;
import java.util.List;
import java.util.Map;

import de.robv.android.xposed.XC_MethodHook;

/**
 * 功能 1 + 功能 11：桌面布局列表（v1.2 修正"7x5/8x5 选中后跳回 6x4"）。
 *
 * ── v1.1 为什么不行 ──────────────────────────────────────────
 * launcher 内部认可的布局清单并不来自 getter，而是来自配置文件
 * /system/etc/xml/hw_launcher_default_config.xml（也就是教程里说的 hw_product 层配置），
 * 由 DefaultLayoutCellsReader 读进 mDesktopLayoutCells，Settings 侧另有静态字段
 * sDesktopLayoutCells / sDefaultDeskLayoutConfigMap，选中项按【index】保存
 * （Settings.setDefaultCellOptionIndex(int)）。
 *
 * v1.1 只在 getter 返回值后面追加，于是：
 *   界面上出现 7 项（我们追加的）  ← 来自 getter
 *   内部清单仍然 3 项（6x4,6x5,5x5）← 来自配置文件
 * 选第 4/5 项时 index 越界 → launcher 判为无效 → 回退到第 0 项，也就是 6x4。
 * 这正对应日志里那句 `getDefaultDesktopLayoutCell() Invalid index = %d, key = %s`。
 *
 * ── v1.2 的做法 ──────────────────────────────────────────────
 * 追加项一律【追加在末尾】，绝不改动前 3 项的顺序与内容（教程血泪教训 #3：
 * 第一项决定 launcher 数据表名 favorites{列}x{行}，改了会桌面全空）。
 *  1. getter 返回值追加（界面能看到 7x5/8x5）；
 *  2. DefaultLayoutCellsReader.readCellsDefaultConfig* 之后，把 mDesktopLayoutCells 补全；
 *  3. Settings.setDesktopLayoutCells / setDesktopLayoutCellsByConfig 的入参补全，
 *     这样由它派生出来的 sDefaultDeskLayoutConfigMap 也会包含新布局；
 *  4. 每次读布局清单时顺手把 Settings.sDesktopLayoutCells / sLayoutCellsBefore
 *     这两个内部字段补全（幂等）。
 */
public final class HookLayoutCells {

    private static final String CLS_SETTINGS = "com.huawei.android.launcher.Settings";
    private static final String CLS_READER =
            "com.huawei.android.launcher.dynamiccells.DefaultLayoutCellsReader";

    /** getDesktopLayoutCells() 的追加项（与教程一致） */
    private static final String[] EXTRA_CELLS = {"7x5", "8x5", "3x3", "3x4"};
    /** getDesktopLayoutCellsList() 的追加项（与教程一致） */
    private static final String[] EXTRA_LIST = {"7x5", "8x5"};
    /** 内部清单只补桌面布局本身（3x3/3x4 是教程里给另一个用途的，不混进内部布局校验） */
    private static final String[] INTERNAL_EXTRA = {"7x5", "8x5"};

    /** 列数 > MORE_COLUMN_NUM(6) 的 7x6/8x6 会触发多列小图标分支，横屏 dock 失配，直接剔除 */
    private static final String[] DROP = {"7x6", "8x6"};

    /** 内部清单已经补全过（有新的 setter 写入时会被重置） */
    private static volatile boolean sInternalOk = false;

    private HookLayoutCells() {
    }

    public static void install(ClassLoader cl, final LCfg cfg) {
        final Class<?> settings = Kit.load(cl, CLS_SETTINGS);
        final Class<?> reader = Kit.load(cl, CLS_READER);

        if (settings == null) {
            return;
        }

        // ---- 1) 界面列表（v1.1 行为保留）----
        Kit.hook(settings, "getDesktopLayoutCells", 0, new XC_MethodHook() {
            @Override
            protected void afterHookedMethod(MethodHookParam p) {
                Object r = p.getResult();
                if (r instanceof String) {
                    String now = normalize((String) r, cfg.cells ? EXTRA_CELLS : new String[0], cfg.dedupe);
                    if (!now.equals(r)) {
                        Kit.once("cells", "getDesktopLayoutCells: \"" + r + "\" -> \"" + now + "\"");
                        p.setResult(now);
                    }
                }
            }
        });

        Kit.hook(settings, "getDesktopLayoutCellsList", 0, new XC_MethodHook() {
            @Override
            protected void afterHookedMethod(MethodHookParam p) {
                Object r = p.getResult();
                if (r instanceof String) {
                    String now = normalize((String) r, cfg.cells ? EXTRA_LIST : new String[0], cfg.dedupe);
                    if (!now.equals(r)) {
                        Kit.once("cellslist", "getDesktopLayoutCellsList: \"" + r + "\" -> \"" + now + "\"");
                        p.setResult(now);
                    }
                }
                ensureInternal(settings, reader);
            }
        });

        // ---- 2) 内部清单：读配置之后补全 ----
        if (reader != null) {
            XC_MethodHook patchReader = new XC_MethodHook() {
                @Override
                protected void afterHookedMethod(MethodHookParam p) {
                    ensureInternal(settings, reader);
                }
            };
            Kit.hook(reader, "readCellsDefaultConfig", null, patchReader);
        }

        // ---- 3) 内部清单：被 setter 写入时补全入参 ----
        XC_MethodHook extendArg = new XC_MethodHook() {
            @Override
            protected void beforeHookedMethod(MethodHookParam p) {
                if (p.args == null || p.args.length == 0 || !(p.args[0] instanceof String)) {
                    return;
                }
                String before = (String) p.args[0];
                String after = extend(before, INTERNAL_EXTRA, cfg.dedupe);
                if (after != null && !after.equals(before)) {
                    p.args[0] = after;
                    Kit.log("写入内部布局清单前补全: \"" + before + "\" -> \"" + after + "\"");
                }
                sInternalOk = false;   // 有新写入，下次读列表时重新检查
            }
        };
        Kit.hook(settings, "setDesktopLayoutCells", 1, extendArg);
        Kit.hook(settings, "setDesktopLayoutCellsByConfig", 1, extendArg);

        // ---- 4) 每次读列表顺手把内部字段补齐（幂等）----
        Kit.hook(settings, "getDesktopLayoutCells", 0, new XC_MethodHook() {
            @Override
            protected void afterHookedMethod(MethodHookParam p) {
                ensureInternal(settings, reader);
            }
        });
    }

    /**
     * 把 launcher 内部的那份布局清单补上 7x5/8x5。
     * 全部是「末尾追加 + 幂等」，不会改变已有索引的含义。
     */
    static void ensureInternal(Class<?> settings, Class<?> reader) {
        if (sInternalOk) {
            return;   // 已经补过且没有新的写入，直接跳过（避免高频调用时反复反射）
        }
        boolean allOk = true;
        try {
            if (settings != null) {
                allOk &= fixStaticString(settings, "sDesktopLayoutCells");
                allOk &= fixStaticString(settings, "sLayoutCellsBefore");
            }
        } catch (Throwable t) {
            Kit.err("补全 Settings 内部布局清单失败", t);
            allOk = false;
        }
        try {
            if (reader != null) {
                Object instance = Kit.callStatic(reader, "getInstance");
                if (instance != null) {
                    Object cur = Kit.get(instance, "mDesktopLayoutCells");
                    if (cur instanceof String) {
                        String now = extend((String) cur, INTERNAL_EXTRA, true);
                        if (now != null && !now.equals(cur)) {
                            Kit.set(instance, "mDesktopLayoutCells", now);
                            Kit.log("DefaultLayoutCellsReader.mDesktopLayoutCells 补全: \""
                                    + cur + "\" -> \"" + now + "\"");
                        }
                    }
                    // 行数上限兜底（新布局是 5 行）
                    Integer maxY = Kit.getInt(instance, "mCellNumMaxY");
                    if (maxY != null && maxY < 5) {
                        Kit.setInt(instance, "mCellNumMaxY", 5);
                        Kit.log("mCellNumMaxY " + maxY + " -> 5");
                    }
                    Integer y = Kit.getInt(instance, "mCellNumY");
                    if (y != null && y < 5) {
                        Kit.setInt(instance, "mCellNumY", 5);
                        Kit.log("mCellNumY " + y + " -> 5");
                    }
                }
            }
        } catch (Throwable t) {
            Kit.err("补全 DefaultLayoutCellsReader 布局清单失败", t);
            allOk = false;
        }
        sInternalOk = allOk;
    }

    /** 返回该字段补全后是否已包含全部追加项 */
    private static boolean fixStaticString(Class<?> c, String field) {
        Object cur = Kit.getStatic(c, field);
        if (!(cur instanceof String)) {
            return true;   // 字段不存在或不是字符串，不算失败
        }
        String now = extend((String) cur, INTERNAL_EXTRA, true);
        if (now != null && !now.equals(cur)) {
            Kit.setStatic(c, field, now);
            Kit.log("Settings." + field + " 补全: \"" + cur + "\" -> \"" + now + "\"");
        }
        return containsAll(now);
    }

    private static boolean containsAll(String value) {
        if (value == null) {
            return false;
        }
        for (String e : INTERNAL_EXTRA) {
            if (!value.contains(e)) {
                return false;
            }
        }
        return true;
    }

    // ------------------------------------------------------------------ 字符串处理

    /** 只做「保持顺序的去重 + 剔除 7x6/8x6 + 末尾追加」 */
    static String normalize(String src, String[] extra, boolean dedupe) {
        return extend(src, extra, dedupe);
    }

    static String extend(String src, String[] extra, boolean dedupe) {
        if (src == null) {
            return null;
        }
        String[] parts = src.split(",");
        List<String> out = new ArrayList<String>();
        for (String part : parts) {
            String v = part.trim();
            if (v.length() == 0) {
                continue;
            }
            if (dedupe) {
                boolean drop = false;
                for (String d : DROP) {
                    if (d.equals(v)) {
                        drop = true;
                        break;
                    }
                }
                if (drop || out.contains(v)) {
                    continue;
                }
            }
            out.add(v);
        }
        for (String e : extra) {
            if (!out.contains(e)) {
                out.add(e);
            }
        }
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < out.size(); i++) {
            if (i > 0) {
                sb.append(',');
            }
            sb.append(out.get(i));
        }
        return sb.toString();
    }

    static String listToString(Collection<?> c) {
        if (c == null) {
            return "null";
        }
        StringBuilder sb = new StringBuilder("[");
        for (Object o : c) {
            sb.append(o).append(' ');
        }
        return sb.append(']').toString();
    }

    static String mapToString(Map<?, ?> m) {
        if (m == null) {
            return "null";
        }
        StringBuilder sb = new StringBuilder("{");
        for (Map.Entry<?, ?> e : m.entrySet()) {
            sb.append(e.getKey()).append('=').append(e.getValue()).append(" | ");
        }
        return sb.append('}').toString();
    }
}
