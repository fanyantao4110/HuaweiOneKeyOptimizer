package com.huawei.onekey.optimizer.hook.launcher;

import com.huawei.onekey.optimizer.hook.launcher.LCfg;
import com.huawei.onekey.optimizer.hook.launcher.Kit;

import de.robv.android.xposed.XC_MethodHook;

/**
 * 功能 7 + 功能 10：RoPropConstant 常量修正。
 *
 * 对应教程【七】【十】：
 *  - HIDE_MEMORY_INFO       保持 0x0（false）→ 最近任务显示内存占用
 *  - IS_ABILITY_FORM_ENABLE 保持正确默认      → 服务卡片入口正常（不会变成"窗口小工具"）
 *  - IS_CARD_FOLDER_ENABLE  保持正确默认      → 大文件夹正常
 *
 * 教程是在 smali 的 <clinit> 里用独立寄存器改默认值；运行时等价做法是
 * 在这个类的静态初始化之后直接改写静态字段（都是 public static final，会清 final 位再写）。
 * 另外顺手把 ro.config.hide_meminfo 这个系统属性读取也改成 0（双保险，教程【七】原本靠改属性）。
 */
public final class HookRoProp {

    private static final String CLS = "com.huawei.android.launcher.utils.RoPropConstant";
    private static final String PROP_HIDE_MEM = "ro.config.hide_meminfo";

    private HookRoProp() {
    }

    public static void install(ClassLoader cl, LCfg cfg) {
        Class<?> c = Kit.load(cl, CLS);
        if (c == null) {
            return;
        }

        // 先触发一次静态初始化，保证 <clinit> 跑过之后再改写字段
        try {
            Class.forName(CLS, true, cl);
        } catch (Throwable t) {
            Kit.err("初始化 RoPropConstant 失败", t);
        }

        if (cfg.meminfo) {
            Kit.setStatic(c, "HIDE_MEMORY_INFO", Boolean.FALSE);
            hookSystemProperty(cl);
        }
        if (cfg.card_folder) {
            Kit.setStatic(c, "IS_ABILITY_FORM_ENABLE", Boolean.TRUE);
            Kit.setStatic(c, "IS_CARD_FOLDER_ENABLE", Boolean.TRUE);
        }
    }

    /** 让 ro.config.hide_meminfo 恒为 0（不隐藏内存信息） */
    private static void hookSystemProperty(ClassLoader cl) {
        try {
            Class<?> sp = Class.forName("android.os.SystemProperties", false, cl);
            Kit.hook(sp, "get", 1, String.class, new XC_MethodHook() {
                @Override
                protected void beforeHookedMethod(MethodHookParam p) {
                    if (PROP_HIDE_MEM.equals(p.args[0])) {
                        p.setResult("0");
                    }
                }
            });
            Kit.hook(sp, "get", 2, String.class, new XC_MethodHook() {
                @Override
                protected void beforeHookedMethod(MethodHookParam p) {
                    if (PROP_HIDE_MEM.equals(p.args[0])) {
                        p.setResult("0");
                    }
                }
            });
            Kit.hook(sp, "getBoolean", 2, String.class, new XC_MethodHook() {
                @Override
                protected void beforeHookedMethod(MethodHookParam p) {
                    if (PROP_HIDE_MEM.equals(p.args[0])) {
                        p.setResult(Boolean.FALSE);
                    }
                }
            });
        } catch (Throwable t) {
            Kit.log("未挂钩 SystemProperties（可忽略）：" + t);
        }
    }
}
