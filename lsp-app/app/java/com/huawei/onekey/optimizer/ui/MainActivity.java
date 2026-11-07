package com.huawei.onekey.optimizer.ui;

import androidx.appcompat.app.AppCompatActivity;
import com.google.android.material.dialog.MaterialAlertDialogBuilder;
import android.content.DialogInterface;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Looper;
import android.view.View;
import android.widget.Button;
import android.widget.CompoundButton;
import androidx.appcompat.widget.SwitchCompat;
import android.widget.TextView;
import android.widget.Toast;

import com.huawei.onekey.optimizer.R;
import com.huawei.onekey.optimizer.core.LauncherIconCtl;
import com.huawei.onekey.optimizer.core.ModuleOps;
import com.huawei.onekey.optimizer.core.Prefs;
import com.huawei.onekey.optimizer.core.RootShell;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;

public class MainActivity extends AppCompatActivity {

    private SwitchCompat swInstaller;
    private SwitchCompat swTheme;
    private SwitchCompat swMxx;
    private SwitchCompat swParallel;
    private SwitchCompat swClone;
    private SwitchCompat swFreeform;
    private SwitchCompat swMeminfo;
    private SwitchCompat swDoubleTap;
    private SwitchCompat swSeconds;
    private SwitchCompat swAccSkip;
    private SwitchCompat swCcVolume;
    private SwitchCompat swTimeout;
    private SwitchCompat swBadge;
    private SwitchCompat swAppDetails;
    private SwitchCompat swBlur;
    private com.google.android.material.slider.Slider sliderBlur;
    private TextView tvBlurValue;
    private com.google.android.material.materialswitch.MaterialSwitch swHideIcon;

    // ===== 灵动岛 =====
    private com.google.android.material.materialswitch.MaterialSwitch swIsland;
    private com.google.android.material.materialswitch.MaterialSwitch swIslandFollow;
    private com.google.android.material.materialswitch.MaterialSwitch swIslandMedia;
    private com.google.android.material.materialswitch.MaterialSwitch swIslandNav;
    private com.google.android.material.materialswitch.MaterialSwitch swIslandCapsule;
    private com.google.android.material.materialswitch.MaterialSwitch swIslandStopwatch;
    private com.google.android.material.materialswitch.MaterialSwitch swIslandUsb;
    private com.google.android.material.materialswitch.MaterialSwitch swIslandCharge;
    private com.google.android.material.materialswitch.MaterialSwitch swIslandFlash;
    private com.google.android.material.materialswitch.MaterialSwitch swIslandRecord;
    private com.google.android.material.button.MaterialButtonToggleGroup tgIslandBg;

    private TextView tvRoot;
    private TextView tvXposed;
    private TextView tvModule;
    private TextView tvLog;

    private final Handler ui = new Handler(Looper.getMainLooper());
    private final SimpleDateFormat fmt = new SimpleDateFormat("HH:mm:ss", Locale.US);
    private boolean binding = false;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        swInstaller = (SwitchCompat) findViewById(R.id.sw_installer);
        swTheme = (SwitchCompat) findViewById(R.id.sw_theme);
        swMxx = (SwitchCompat) findViewById(R.id.sw_mxx);
        swParallel = (SwitchCompat) findViewById(R.id.sw_parallel);
        swClone = (SwitchCompat) findViewById(R.id.sw_clone);
        swFreeform = (SwitchCompat) findViewById(R.id.sw_freeform);
        swMeminfo = (SwitchCompat) findViewById(R.id.sw_meminfo);
        swDoubleTap = (SwitchCompat) findViewById(R.id.sw_doubletap);
        swSeconds = (SwitchCompat) findViewById(R.id.sw_seconds);
        swAccSkip = (SwitchCompat) findViewById(R.id.sw_accskip);
        swCcVolume = (SwitchCompat) findViewById(R.id.sw_ccvolume);
        swTimeout = (SwitchCompat) findViewById(R.id.sw_timeout);
        swBadge = (SwitchCompat) findViewById(R.id.sw_badge);
        swAppDetails = (SwitchCompat) findViewById(R.id.sw_appdetails);
        swBlur = (SwitchCompat) findViewById(R.id.sw_blur);
        sliderBlur = (com.google.android.material.slider.Slider) findViewById(R.id.slider_blur);
        tvBlurValue = (TextView) findViewById(R.id.tv_blur_value);

        tvRoot = (TextView) findViewById(R.id.tv_root);
        tvXposed = (TextView) findViewById(R.id.tv_xposed);
        tvModule = (TextView) findViewById(R.id.tv_module);
        tvLog = (TextView) findViewById(R.id.tv_log);

        swHideIcon = (com.google.android.material.materialswitch.MaterialSwitch) findViewById(R.id.sw_hideicon);
        bindHideIcon();

        bindIsland();

        bindSwitch(swInstaller, Prefs.K_INSTALLER);
        bindSwitch(swTheme, Prefs.K_THEME);
        bindSwitch(swMxx, Prefs.K_MXX);
        bindSwitch(swParallel, Prefs.K_PARALLEL);
        bindSwitch(swClone, Prefs.K_CLONE);
        bindSwitch(swFreeform, Prefs.K_FREEFORM);
        bindSwitch(swMeminfo, Prefs.K_MEMINFO);
        bindSwitch(swDoubleTap, Prefs.K_DOUBLETAP);
        bindSwitch(swSeconds, Prefs.K_SECONDS);
        bindSwitch(swAccSkip, Prefs.K_ACC_SKIP);
        bindSwitch(swCcVolume, Prefs.K_CCVOLUME);
        bindSwitch(swTimeout, Prefs.K_TIMEOUT);
        bindSwitch(swBadge, Prefs.K_BADGE);
        bindSwitch(swAppDetails, Prefs.K_APP_DETAILS);
        bindBlur();

        findViewById(R.id.btn_advanced).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                startActivity(new Intent(MainActivity.this, AdvancedActivity.class));
            }
        });

        findViewById(R.id.btn_all_on).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                setAll(true);
            }
        });
        findViewById(R.id.btn_all_off).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                setAll(false);
            }
        });
        findViewById(R.id.btn_apply).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                applyNow();
            }
        });
        findViewById(R.id.btn_reboot).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                confirmReboot();
            }
        });

        tvLog.setText(R.string.log_empty);
        log("应用已启动");
        refreshStatusAsync();
    }

    @Override
    protected void onResume() {
        super.onResume();
        RootShell.resetRootCache();
        syncHideIcon();
        refreshStatusAsync();
    }

    // ================= 开关 =================

    private void bindSwitch(final SwitchCompat sw, final String key) {
        binding = true;
        sw.setChecked(Prefs.isOn(this, key));
        binding = false;
        sw.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (binding) {
                    return;
                }
                Prefs.set(MainActivity.this, key, isChecked);
                log(label(key) + " -> " + (isChecked ? "开启" : "关闭"));
                pushFlags(true);
            }
        });
    }

    /** 桌面模糊：一个总开关 + 一条模糊程度滑条 */
    private void bindBlur() {
        if (swBlur == null) {
            return;
        }
        binding = true;
        swBlur.setChecked(Prefs.isOn(this, Prefs.K_BLUR, false));
        binding = false;
        swBlur.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (binding) {
                    return;
                }
                Prefs.set(MainActivity.this, Prefs.K_BLUR, isChecked);
                log("桌面模糊 -> " + (isChecked ? "开启" : "关闭"));
                schedulePush();
            }
        });

        if (sliderBlur != null) {
            int r = Prefs.blurRadius(this);
            sliderBlur.setValue((float) r);
            updateBlurValue(r);
            sliderBlur.addOnChangeListener(new com.google.android.material.slider.Slider.OnChangeListener() {
                @Override
                public void onValueChange(com.google.android.material.slider.Slider slider, float value, boolean fromUser) {
                    int v = (int) value;
                    updateBlurValue(v);
                    if (!fromUser) {
                        return;
                    }
                    Prefs.setInt(MainActivity.this, Prefs.K_BLUR_RADIUS, v);
                    schedulePush();
                }
            });
        }
    }

    private void updateBlurValue(int v) {
        if (tvBlurValue != null) {
            tvBlurValue.setText(getString(R.string.blur_level_value, Integer.valueOf(v)));
        }
    }

    // ================= 灵动岛 =================

    private void bindIsland() {
        swIsland = (com.google.android.material.materialswitch.MaterialSwitch) findViewById(R.id.sw_island);
        swIslandFollow = (com.google.android.material.materialswitch.MaterialSwitch) findViewById(R.id.sw_island_follow);
        swIslandMedia = (com.google.android.material.materialswitch.MaterialSwitch) findViewById(R.id.sw_island_media);
        swIslandNav = (com.google.android.material.materialswitch.MaterialSwitch) findViewById(R.id.sw_island_nav);
        swIslandCapsule = (com.google.android.material.materialswitch.MaterialSwitch) findViewById(R.id.sw_island_capsule);
        swIslandStopwatch = (com.google.android.material.materialswitch.MaterialSwitch) findViewById(R.id.sw_island_stopwatch);
        swIslandUsb = (com.google.android.material.materialswitch.MaterialSwitch) findViewById(R.id.sw_island_usb);
        swIslandCharge = (com.google.android.material.materialswitch.MaterialSwitch) findViewById(R.id.sw_island_charge);
        swIslandFlash = (com.google.android.material.materialswitch.MaterialSwitch) findViewById(R.id.sw_island_flash);
        swIslandRecord = (com.google.android.material.materialswitch.MaterialSwitch) findViewById(R.id.sw_island_record);
        tgIslandBg = (com.google.android.material.button.MaterialButtonToggleGroup) findViewById(R.id.tg_island_bg);

        bindIslandSwitch(swIsland, Prefs.K_ISLAND, true);
        bindIslandSwitch(swIslandFollow, Prefs.K_ISLAND_FOLLOW, true);
        bindIslandSwitch(swIslandMedia, Prefs.K_ISLAND_MEDIA, true);
        bindIslandSwitch(swIslandNav, Prefs.K_ISLAND_NAV, true);
        bindIslandSwitch(swIslandCapsule, Prefs.K_ISLAND_CAPSULE, true);
        bindIslandSwitch(swIslandStopwatch, Prefs.K_ISLAND_STOPWATCH, true);
        bindIslandSwitch(swIslandUsb, Prefs.K_ISLAND_USB, true);
        bindIslandSwitch(swIslandCharge, Prefs.K_ISLAND_CHARGE, true);
        bindIslandSwitch(swIslandFlash, Prefs.K_ISLAND_FLASH, true);
        bindIslandSwitch(swIslandRecord, Prefs.K_ISLAND_RECORD, true);

        if (tgIslandBg != null) {
            binding = true;
            tgIslandBg.check(Prefs.islandBg(this) == Prefs.ISLAND_BG_FROSTED
                    ? R.id.btn_bg_frosted : R.id.btn_bg_black);
            binding = false;
            tgIslandBg.addOnButtonCheckedListener(
                    new com.google.android.material.button.MaterialButtonToggleGroup.OnButtonCheckedListener() {
                        @Override
                        public void onButtonChecked(
                                com.google.android.material.button.MaterialButtonToggleGroup group,
                                int checkedId, boolean isChecked) {
                            if (!isChecked || binding) {
                                return;
                            }
                            boolean frosted = checkedId == R.id.btn_bg_frosted;
                            Prefs.setIslandBg(MainActivity.this, frosted
                                    ? Prefs.ISLAND_BG_FROSTED : Prefs.ISLAND_BG_BLACK);
                            log("灵动岛背景 -> " + (frosted ? "毛玻璃" : "纯黑"));
                            pushIsland();
                        }
                    });
        }

        android.view.View restart = findViewById(R.id.btn_restart_sysui);
        if (restart != null) {
            restart.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    restartSystemUi();
                }
            });
        }

        android.view.View preview = findViewById(R.id.btn_island_preview);
        if (preview != null) {
            preview.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View v) {
                    previewIsland();
                }
            });
        }
    }

    /**
     * 推一条模拟实况到岛上，用来确认「装好了、能显示」。
     * 走 root 的 am broadcast，避免普通应用给 SystemUI 发广播被拦。
     */
    private void previewIsland() {
        toast(R.string.toast_island_preview);
        log("推送灵动岛预览…");
        new Thread(new Runnable() {
            @Override
            public void run() {
                String cmd = "am broadcast -a "
                        + "com.huawei.onekey.optimizer.hook.island.DEMO "
                        + "-p com.android.systemui "
                        + "--es title '预计13:36送达' "
                        + "--es content '骑手已到店，正在派送' "
                        + "--ei pct 62";
                RootShell.Result r = RootShell.exec(cmd, 25);
                log("预览广播 [" + r.code + "] " + r.output.trim());
            }
        }, "island-preview").start();
    }

    /** 灵动岛开关：默认值各自不同，所以单独绑定 */
    private void bindIslandSwitch(final com.google.android.material.materialswitch.MaterialSwitch sw,
                                  final String key, final boolean def) {
        if (sw == null) {
            return;
        }
        binding = true;
        sw.setChecked(Prefs.isOn(this, key, def));
        binding = false;
        sw.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (binding) {
                    return;
                }
                Prefs.set(MainActivity.this, key, isChecked);
                log("灵动岛：" + islandLabel(key) + " -> " + (isChecked ? "开" : "关"));
                pushIsland();
            }
        });
    }

    private String islandLabel(String key) {
        if (Prefs.K_ISLAND.equals(key)) {
            return "总开关";
        }
        if (Prefs.K_ISLAND_FOLLOW.equals(key)) {
            return "背景反色";
        }
        if (Prefs.K_ISLAND_MEDIA.equals(key)) {
            return "音乐";
        }
        if (Prefs.K_ISLAND_NAV.equals(key)) {
            return "导航";
        }
        if (Prefs.K_ISLAND_CAPSULE.equals(key)) {
            return "实况通知";
        }
        if (Prefs.K_ISLAND_STOPWATCH.equals(key)) {
            return "秒表";
        }
        if (Prefs.K_ISLAND_USB.equals(key)) {
            return "USB";
        }
        if (Prefs.K_ISLAND_CHARGE.equals(key)) {
            return "充电提示";
        }
        if (Prefs.K_ISLAND_FLASH.equals(key)) {
            return "手电筒";
        }
        if (Prefs.K_ISLAND_RECORD.equals(key)) {
            return "录屏";
        }
        return key;
    }

    /**
     * 灵动岛的开关只走「写 flags.sh / setprop + 广播」，
     * 不触发 apply.sh（那些是平行视界 / 分身用的，和岛无关，没必要每次挂载）。
     */
    private void pushIsland() {
        Prefs.notifyIsland(this);
        new Thread(new Runnable() {
            @Override
            public void run() {
                if (!RootShell.hasRoot()) {
                    return;
                }
                RootShell.Result r = Prefs.push(MainActivity.this);
                if (!r.ok()) {
                    log("灵动岛开关写入失败");
                }
            }
        }, "island-push").start();
    }

    private void restartSystemUi() {
        toast(R.string.toast_sysui_restarting);
        log("正在重启系统界面…");
        new Thread(new Runnable() {
            @Override
            public void run() {
                RootShell.Result r = ModuleOps.restartSystemUi();
                log("重启系统界面 [" + r.code + "] " + r.output.trim());
            }
        }, "sysui").start();
    }

    // ================= 隐藏桌面图标 =================

    /** 与 PackageManager 里的真实状态对齐：开关 ON = 图标已隐藏，OFF = 图标可见 */
    private void syncHideIcon() {
        if (swHideIcon == null) {
            return;
        }
        binding = true;
        swHideIcon.setChecked(LauncherIconCtl.isHidden(this));
        binding = false;
    }

    private void setHideSwitchQuiet(boolean checked) {
        if (swHideIcon == null) {
            return;
        }
        binding = true;
        swHideIcon.setChecked(checked);
        binding = false;
    }

    private void bindHideIcon() {
        if (swHideIcon == null) {
            return;
        }
        syncHideIcon();
        swHideIcon.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (binding) {
                    return;
                }
                if (isChecked) {
                    // 先把开关复位到 OFF，用户点“取消”就不会改系统状态
                    setHideSwitchQuiet(false);
                    confirmHideIcon();
                } else {
                    boolean ok = LauncherIconCtl.setHidden(MainActivity.this, false);
                    setHideSwitchQuiet(false);
                    toast(ok ? R.string.toast_icon_shown : R.string.toast_icon_fail);
                    log(ok ? "桌面图标 -> 已恢复" : "桌面图标恢复失败");
                }
            }
        });
    }

    private void confirmHideIcon() {
        new MaterialAlertDialogBuilder(this)
                .setTitle(R.string.hideicon_dialog_title)
                .setMessage(R.string.hideicon_dialog_msg)
                .setNegativeButton(R.string.hideicon_dialog_cancel, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        setHideSwitchQuiet(false);
                    }
                })
                .setPositiveButton(R.string.hideicon_dialog_ok, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        boolean ok = LauncherIconCtl.setHidden(MainActivity.this, true);
                        setHideSwitchQuiet(ok);
                        toast(ok ? R.string.toast_icon_hidden : R.string.toast_icon_fail);
                        log(ok ? "桌面图标 -> 已隐藏（可从 LSPosed / 设置 / adb 重新进入本页恢复）"
                                : "桌面图标隐藏失败");
                    }
                })
                .setOnCancelListener(new DialogInterface.OnCancelListener() {
                    @Override
                    public void onCancel(DialogInterface dialog) {
                        setHideSwitchQuiet(false);
                    }
                })
                .show();
    }

    private final Runnable pushTask = new Runnable() {
        @Override
        public void run() {
            pushFlags(true);
        }
    };

    /** 滑条拖动会连发多次，合并成一次写入，避免刷 root 命令。 */
    private void schedulePush() {
        ui.removeCallbacks(pushTask);
        ui.postDelayed(pushTask, 500L);
    }

    private void setAll(boolean on) {
        binding = true;
        swInstaller.setChecked(on);
        swTheme.setChecked(on);
        swMxx.setChecked(on);
        swParallel.setChecked(on);
        swClone.setChecked(on);
        swFreeform.setChecked(on);
        swMeminfo.setChecked(on);
        swDoubleTap.setChecked(on);
        swSeconds.setChecked(on);
        swAccSkip.setChecked(on);
        swTimeout.setChecked(on);
        swBadge.setChecked(on);
        swAppDetails.setChecked(on);
        binding = false;
        Prefs.setAll(this, on);
        log(on ? "已一键全开" : "已全部关闭");
        pushFlags(true);
    }

    private String label(String key) {
        if (Prefs.K_INSTALLER.equals(key)) {
            return "安装器净化";
        }
        if (Prefs.K_THEME.equals(key)) {
            return "主题解锁";
        }
        if (Prefs.K_MXX.equals(key)) {
            return "系统限制解锁";
        }
        if (Prefs.K_PARALLEL.equals(key)) {
            return "全应用平行视界";
        }
        if (Prefs.K_CLONE.equals(key)) {
            return "全应用分身";
        }
        if (Prefs.K_FREEFORM.equals(key)) {
            return "小窗数量解锁";
        }
        if (Prefs.K_MEMINFO.equals(key)) {
            return "多任务显示内存";
        }
        if (Prefs.K_SECONDS.equals(key)) {
            return "状态栏长按显示秒";
        }
        if (Prefs.K_ACC_SKIP.equals(key)) {
            return "跳过无障碍授权倒计时";
        }
        return key;
    }

    // ================= 状态 =================

    private void refreshStatusAsync() {
        new Thread(new Runnable() {
            @Override
            public void run() {
                final boolean root = RootShell.hasRoot();
                final boolean xposed = root && ModuleOps.isLsposedActive();
                final boolean module = root && ModuleOps.isModuleInstalled();
                ui.post(new Runnable() {
                    @Override
                    public void run() {
                        tvRoot.setText(root ? R.string.status_root_ok : R.string.status_root_no);
                        tvXposed.setText(xposed ? R.string.status_xposed_ok : R.string.status_xposed_no);
                        tvModule.setText(module ? R.string.status_module_ok : R.string.status_module_no);
                    }
                });
            }
        }, "status").start();
    }

    // ================= 应用 =================

    private void pushFlags(final boolean applyAfter) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                if (!RootShell.hasRoot()) {
                    toast(R.string.toast_no_root);
                    return;
                }
                RootShell.Result r = Prefs.push(MainActivity.this);
                log("开关已写入（flags.sh / setprop）" + (r.ok() ? "" : " [失败]"));
                if (applyAfter) {
                    doApply();
                }
            }
        }, "push").start();
    }

    private void applyNow() {
        if (!RootShell.hasRoot()) {
            toast(R.string.toast_no_root);
            return;
        }
        toast(R.string.toast_saved);
        new Thread(new Runnable() {
            @Override
            public void run() {
                Prefs.push(MainActivity.this);
                doApply();
                toast(R.string.toast_applied);
            }
        }, "apply").start();
    }

    /** 只能在工作线程调用 */
    private void doApply() {
        MainActivity.this.runOnUiThread(new Runnable() {
            @Override
            public void run() {
                log("开始应用系统层设置…");
            }
        });
        RootShell.Result r = ModuleOps.apply();
        log("apply.sh [" + r.code + "] " + lastLines(r.output, 6));
    }

    private void confirmReboot() {
        new MaterialAlertDialogBuilder(this)
                .setTitle(R.string.reboot_title)
                .setMessage(R.string.reboot_message)
                .setNegativeButton(R.string.reboot_cancel, null)
                .setPositiveButton(R.string.reboot_ok, new DialogInterface.OnClickListener() {
                    @Override
                    public void onClick(DialogInterface dialog, int which) {
                        rebootNow();
                    }
                })
                .show();
    }

    private void rebootNow() {
        toast(R.string.toast_rebooting);
        log("正在重启系统…");
        new Thread(new Runnable() {
            @Override
            public void run() {
                RootShell.Result r = ModuleOps.rebootSystem();
                log("重启指令 [" + r.code + "] " + r.output.trim());
            }
        }, "reboot").start();
    }

    // ================= 日志 =================

    private void log(final String line) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                String old = tvLog.getText().toString();
                if (old.equals(getString(R.string.log_empty))) {
                    old = "";
                }
                String now = fmt.format(new Date());
                String text = old + "[" + now + "] " + line + "\n";
                if (text.length() > 8000) {
                    text = text.substring(text.length() - 8000);
                }
                tvLog.setText(text);
            }
        });
    }

    private void toast(final int res) {
        runOnUiThread(new Runnable() {
            @Override
            public void run() {
                Toast.makeText(MainActivity.this, res, Toast.LENGTH_SHORT).show();
            }
        });
    }

    private static String lastLines(String s, int n) {
        if (s == null) {
            return "";
        }
        String[] arr = s.trim().split("\n");
        StringBuilder sb = new StringBuilder();
        for (int i = Math.max(0, arr.length - n); i < arr.length; i++) {
            sb.append(arr[i]).append('\n');
        }
        return sb.toString().trim();
    }
}