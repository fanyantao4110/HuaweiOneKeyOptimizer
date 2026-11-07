package com.huawei.onekey.optimizer.ui;

import android.os.Bundle;
import android.view.View;
import android.widget.CompoundButton;
import android.widget.Toast;

import androidx.appcompat.app.AppCompatActivity;
import androidx.appcompat.widget.SwitchCompat;

import com.huawei.onekey.optimizer.R;
import com.huawei.onekey.optimizer.core.Prefs;
import com.huawei.onekey.optimizer.core.RootShell;

/**
 * 高级设置（二级界面）。
 *
 * 这里的 8 项默认全部关闭，并且**不参与**主页的「一键全开 / 全部关闭」，
 * 只由本页的开关单独控制（Prefs.ADV_KEYS 与 ALL_KEYS 分开维护）。
 */
public class AdvancedActivity extends AppCompatActivity {

    private SwitchCompat swCells;
    private SwitchCompat swDedupe;
    private SwitchCompat swDrawer;
    private SwitchCompat swDock;
    private SwitchCompat swPortrait;
    private SwitchCompat swNoText;
    private SwitchCompat swCard;
    private SwitchCompat swFormTitle;

    private boolean binding;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_advanced);

        swCells = (SwitchCompat) findViewById(R.id.sw_cells);
        swDedupe = (SwitchCompat) findViewById(R.id.sw_dedupe);
        swDrawer = (SwitchCompat) findViewById(R.id.sw_drawer);
        swDock = (SwitchCompat) findViewById(R.id.sw_dock);
        swPortrait = (SwitchCompat) findViewById(R.id.sw_portrait);
        swNoText = (SwitchCompat) findViewById(R.id.sw_notext);
        swCard = (SwitchCompat) findViewById(R.id.sw_card);
        swFormTitle = (SwitchCompat) findViewById(R.id.sw_form_title);

        findViewById(R.id.btn_back).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });

        findViewById(R.id.btn_restart_launcher).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                restartLauncher();
            }
        });

        bindAdv(swCells, Prefs.K_ADV_CELLS);
        bindAdv(swDedupe, Prefs.K_ADV_DEDUPE);
        bindAdv(swDrawer, Prefs.K_ADV_DRAWER);
        bindAdv(swDock, Prefs.K_ADV_DOCK);
        bindAdv(swPortrait, Prefs.K_ADV_PORTRAIT);
        bindAdv(swNoText, Prefs.K_ADV_NOTEXT);
        bindAdv(swCard, Prefs.K_ADV_CARD_FOLDER);
        bindAdv(swFormTitle, Prefs.K_ADV_FORM_TITLE);
    }

    /** 高级项：默认关闭（isOnAdv），切换后写回三通道并提示重启桌面 */
    private void bindAdv(final SwitchCompat sw, final String key) {
        binding = true;
        sw.setChecked(Prefs.isOnAdv(this, key));
        binding = false;
        sw.setOnCheckedChangeListener(new CompoundButton.OnCheckedChangeListener() {
            @Override
            public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {
                if (binding) {
                    return;
                }
                Prefs.set(AdvancedActivity.this, key, isChecked);
                Prefs.push(AdvancedActivity.this);
                Toast.makeText(AdvancedActivity.this,
                        isChecked ? "已开启，重启桌面后生效" : "已关闭，重启桌面后生效",
                        Toast.LENGTH_SHORT).show();
            }
        });
    }

    private void restartLauncher() {
        RootShell.Result r = RootShell.exec("am force-stop com.huawei.android.launcher", 15);
        Toast.makeText(this, r.ok() ? "桌面已重启" : "重启失败，请手动重启桌面", Toast.LENGTH_SHORT).show();
    }
}