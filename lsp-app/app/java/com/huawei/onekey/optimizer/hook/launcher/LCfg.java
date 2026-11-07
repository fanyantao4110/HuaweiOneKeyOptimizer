package com.huawei.onekey.optimizer.hook.launcher;

import com.huawei.onekey.optimizer.hook.HookFlags;

/**
 * 桌面增强功能的开关快照（从本模块的三通道开关里读一次，之后只读快照）。
 *
 * 主页开关：去除管控角标、长按气泡应用详情（默认开，跟「一键全开」联动）
 * 高级设置：7x5/8x5、抽屉去建议、dock 11/8、竖屏保留右侧、无字模式、
 *           大文件夹服务卡片入口、布局去重、服务卡片标题无字（默认关，不受一键全开影响）
 */
public final class LCfg {

    /** 高级设置 8 项 */
    public boolean cells;
    public boolean dedupe;
    public boolean drawer;
    public boolean dock;
    public boolean portrait;
    public boolean notext;
    public boolean card_folder;
    public boolean form_title;

    /** 主页 2 项 */
    public boolean badge;
    public boolean app_details;

    /** 内存信息（沿用主页已有的「多任务显示内存」开关，这里只用于 RoProp 兜底） */
    public boolean meminfo;

    private LCfg() {
    }

    public static LCfg load() {
        LCfg c = new LCfg();
        c.cells = HookFlags.enabled(HookFlags.K_ADV_CELLS, false);
        c.dedupe = HookFlags.enabled(HookFlags.K_ADV_DEDUPE, false);
        c.drawer = HookFlags.enabled(HookFlags.K_ADV_DRAWER, false);
        c.dock = HookFlags.enabled(HookFlags.K_ADV_DOCK, false);
        c.portrait = HookFlags.enabled(HookFlags.K_ADV_PORTRAIT, false);
        c.notext = HookFlags.enabled(HookFlags.K_ADV_NOTEXT, false);
        c.card_folder = HookFlags.enabled(HookFlags.K_ADV_CARD_FOLDER, false);
        c.form_title = HookFlags.enabled(HookFlags.K_ADV_FORM_TITLE, false);
        c.badge = HookFlags.enabled(HookFlags.K_BADGE, true);
        c.app_details = HookFlags.enabled(HookFlags.K_APP_DETAILS, true);
        c.meminfo = HookFlags.enabled(HookFlags.K_MEMINFO, true);
        return c;
    }

    @Override
    public String toString() {
        return "桌面配置 cells=" + cells + " dedupe=" + dedupe + " drawer=" + drawer
                + " dock=" + dock + " portrait=" + portrait + " notext=" + notext
                + " cardFolder=" + card_folder + " formTitle=" + form_title
                + " badge=" + badge + " appDetails=" + app_details;
    }
}