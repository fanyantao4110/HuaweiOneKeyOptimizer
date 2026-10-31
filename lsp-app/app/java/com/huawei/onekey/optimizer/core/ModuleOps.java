package com.huawei.onekey.optimizer.core;

/**
 * Magisk 模块侧（系统层）操作：平行视界 / 应用分身 / 模块自身状态。
 *
 * 重要：部分 Root 管理器会给 App 的 su 会话分配独立的 mount namespace，
 * 在里面 bind mount 系统进程根本看不到。所以「立即生效」优先走
 * /data/adb/huawei_onekey/apply.request → 模块开机启动的 watch.sh（全局命名空间）
 * 来执行 apply.sh；只有守护不在时才回退为直接执行。
 */
public final class ModuleOps {

    public static final String MODULE_DIR = Prefs.MODULE_DIR;
    public static final String APPLY_SH = MODULE_DIR + "/common/apply.sh";
    private static final String DATA_DIR = "/data/adb/huawei_onekey";
    private static final String REQ = DATA_DIR + "/apply.request";
    private static final String DONE = DATA_DIR + "/apply.done";
    private static final String WATCH_PID = DATA_DIR + "/watch.pid";

    private ModuleOps() {
    }

    public static boolean isModuleInstalled() {
        RootShell.Result r = RootShell.exec("[ -f " + MODULE_DIR + "/module.prop ] && echo YES || echo NO", 15);
        return r.output.contains("YES");
    }

    public static boolean isLsposedActive() {
        RootShell.Result r = RootShell.exec(
                "[ -d /data/adb/modules/zygisk_lsposed ] || [ -d /data/adb/modules/riru_lsposed ]"
                        + " || [ -d /data/adb/lspd ] && echo YES || echo NO", 15);
        return r.output.contains("YES");
    }

    public static boolean isApkInstalledByModule() {
        RootShell.Result r = RootShell.exec("pm path " + Prefs.PKG + " 2>/dev/null", 15);
        return r.output.contains("package:");
    }

    private static boolean daemonAlive() {
        RootShell.Result r = RootShell.exec(
                "p=$(cat " + WATCH_PID + " 2>/dev/null); "
                        + "if [ -n \"$p\" ] && kill -0 $p 2>/dev/null; then echo YES; else echo NO; fi", 15);
        return r.output.contains("YES");
    }

    /** 应用系统层开关（平行视界 / 应用分身）。 */
    public static RootShell.Result apply() {
        RootShell.Result exist = RootShell.exec("[ -f " + APPLY_SH + " ] && echo YES || echo NO", 15);
        if (!exist.output.contains("YES")) {
            return new RootShell.Result(1, "缺少 " + APPLY_SH + "（模块未安装）");
        }

        if (daemonAlive()) {
            RootShell.exec("rm -f " + DONE, 10);
            RootShell.writeFile(REQ, "apply\n");
            for (int i = 0; i < 30; i++) {
                sleep(1000);
                RootShell.Result c = RootShell.exec("[ -f " + DONE + " ] && echo YES || echo NO", 10);
                if (c.output.contains("YES")) {
                    return RootShell.exec("tail -n 12 " + DATA_DIR + "/apply.log", 10);
                }
            }
            return new RootShell.Result(2, "守护进程未响应，请重启设备后再试");
        }

        // 没有守护进程（例如刚装模块还没重启）：直接执行，尽力生效
        return RootShell.exec("sh " + APPLY_SH + " 2>&1", 90);
    }

    /**
     * 重启整机。
     *
     * 平行视界 XML 由 system_server 开机读一次、hw_mc.freeform.max_num / ro.config.hide_meminfo
     * 也只在对应进程启动时被读取，因此「真正生效」的唯一可靠方式是重启整机。
     * 用 (sleep 2; reboot) 让接口先返回，避免 su 会话被重启打断导致 App 报错。
     */
    public static RootShell.Result rebootSystem() {
        RootShell.exec("sync", 15);
        return RootShell.exec("(sleep 2; reboot) >/dev/null 2>&1 & echo REBOOTING", 15);
    }

    private static void sleep(long ms) {
        try {
            Thread.sleep(ms);
        } catch (InterruptedException ignored) {
        }
    }
}