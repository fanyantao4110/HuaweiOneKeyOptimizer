package com.huawei.onekey.optimizer.hook.launcher;

/**
 * 华为桌面增强功能的安装入口（对照 HwLauncherTweak 的工具源码移植）。
 *
 * 每项独立 try/catch：某一项失败（比如该 ROM 版本换了方法名）只打日志，不影响其它项。
 */
public final class LauncherAdvanced {

    private static volatile boolean sInstalled;

    private LauncherAdvanced() {
    }

    public static void install(ClassLoader cl) {
        if (sInstalled) {
            return;
        }
        synchronized (LauncherAdvanced.class) {
            if (sInstalled) {
                return;
            }
            sInstalled = true;
        }
        LCfg cfg = LCfg.load();
        Kit.log("================ 桌面增强开始安装 ================");
        Kit.log(cfg.toString());
        Kit.bypassHiddenApi();

        // 主页：去除管控角标（克隆/信任空间应用的警告角标）
        step("去除管控角标", cfg.badge, new Step() {
            @Override
            public void run() {
                HookBadge.install(cl);
            }
        });
        // 主页：长按气泡「应用详情」
        step("长按气泡应用详情", cfg.app_details, new Step() {
            @Override
            public void run() {
                HookAppDetails.install(cl);
            }
        });
        // 高级：7x5 / 8x5 布局 + 布局去重（同一处代码）
        step("布局 7x5/8x5 + 去重", cfg.cells || cfg.dedupe, new Step() {
            @Override
            public void run() {
                HookLayoutCells.install(cl, cfg);
            }
        });
        step("抽屉去应用建议", cfg.drawer, new Step() {
            @Override
            public void run() {
                HookDrawer.install(cl);
            }
        });
        step("dock 自适应 11/8", cfg.dock, new Step() {
            @Override
            public void run() {
                HookDockCount.install(cl);
            }
        });
        step("竖屏保留右侧", cfg.portrait, new Step() {
            @Override
            public void run() {
                HookHotseatPortrait.install(cl);
            }
        });
        step("无字模式", cfg.notext, new Step() {
            @Override
            public void run() {
                HookNoText.install(cl);
            }
        });
        step("大文件夹服务卡片入口", cfg.card_folder || cfg.meminfo, new Step() {
            @Override
            public void run() {
                HookRoProp.install(cl, cfg);
            }
        });
        step("服务卡片标题无字", cfg.form_title, new Step() {
            @Override
            public void run() {
                HookFormTitle.install(cl);
            }
        });
        Kit.log("================ 桌面增强安装完成 ================");
    }

    private interface Step {
        void run();
    }

    private static void step(String name, boolean enabled, Step s) {
        if (!enabled) {
            Kit.log("已关闭 —— " + name);
            return;
        }
        try {
            Kit.log("---- 安装 " + name + " ----");
            s.run();
        } catch (Throwable t) {
            Kit.err(name + " 安装失败（已跳过）", t);
        }
    }
}