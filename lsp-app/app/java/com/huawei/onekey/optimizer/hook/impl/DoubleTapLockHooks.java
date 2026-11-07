package com.huawei.onekey.optimizer.hook.impl;

import android.content.Context;
import android.os.PowerManager;
import android.os.SystemClock;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewConfiguration;

import java.lang.reflect.Method;

import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedBridge;
import de.robv.android.xposed.callbacks.XC_LoadPackage;

/**
 * 桌面双击锁屏（Hook 实现，不修改系统 APK）。
 *
 * 参照《华为桌面/修改教程.txt》里的 smali 注入方案，但改成了 LSPosed Hook：
 *   - 原方案：反编译 base-master.apk → 改 Workspace.smali + 新增 DoubleTapLocker.smali → 重签名 → 刷 super.img
 *   - 本方案：运行时 hook 同一个 Workspace.onInterceptTouchEvent(MotionEvent)，逻辑等价，零刷机、
 *     不动系统分区、不改签名、OTA 不失效，开关可随时切换。
 *
 * 判定规则（与 v10 成品一致）：
 *   DOWN 记录起点；MOVE 超出 touchSlop 记为滑动；UP 时若不是滑动，且与上一次点击间隔 <=300ms
 *   （ViewConfiguration.getDoubleTapTimeout()）→ 锁屏。
 *
 * 锁屏调用：PowerManager.goToSleep(long) 单参（华为只有这个重载，双参会 NoSuchMethodError），
 * 失败时回退双参重载。
 */
public final class DoubleTapLockHooks {

    private static final String TAG = "[OneKey][DblTap] ";
    private static final String CLS_WORKSPACE = "com.huawei.android.launcher.Workspace";

    /** 上一次“纯点击”抬起的时间（uptimeMillis），0 表示无 */
    private static long sLastUp;
    /** 本次手势是否已经变成滑动 */
    private static boolean sMoved;
    private static float sDownX;
    private static float sDownY;
    private static int sSlop = -1;
    private static long sTimeout = 300L;

    private DoubleTapLockHooks() {
    }

    public static void install(XC_LoadPackage.LoadPackageParam lp) {
        Class<?> workspace;
        try {
            workspace = Class.forName(CLS_WORKSPACE, false, lp.classLoader);
        } catch (Throwable t) {
            log("未找到 " + CLS_WORKSPACE + "，跳过: " + t);
            return;
        }
        XposedBridge.hookAllMethods(workspace, "onInterceptTouchEvent", new XC_MethodHook() {
            @Override
            protected void beforeHookedMethod(MethodHookParam param) {
                try {
                    if (param.args == null || param.args.length == 0) {
                        return;
                    }
                    if (!(param.args[0] instanceof MotionEvent) || !(param.thisObject instanceof View)) {
                        return;
                    }
                    onTouch((View) param.thisObject, (MotionEvent) param.args[0]);
                } catch (Throwable t) {
                    log("touch 异常: " + t);
                }
            }
        });
        log("双击锁屏已挂载 → " + CLS_WORKSPACE + ".onInterceptTouchEvent");
    }

    private static void onTouch(View v, MotionEvent ev) {
        Context ctx = v.getContext();
        if (ctx == null) {
            return;
        }
        if (sSlop < 0) {
            sSlop = ViewConfiguration.get(ctx).getScaledTouchSlop();
        }
        int action = ev.getActionMasked();
        switch (action) {
            case MotionEvent.ACTION_DOWN:
                sMoved = false;
                sDownX = ev.getRawX();
                sDownY = ev.getRawY();
                break;
            case MotionEvent.ACTION_MOVE:
                if (!sMoved) {
                    float dx = ev.getRawX() - sDownX;
                    float dy = ev.getRawY() - sDownY;
                    if (dx * dx + dy * dy > (float) sSlop * sSlop) {
                        sMoved = true;
                    }
                }
                break;
            case MotionEvent.ACTION_UP: {
                if (sMoved) {
                    // 滑动结束，重置双击计数（避免"滑一下再点一下"误触发）
                    sLastUp = 0L;
                    break;
                }
                long now = SystemClock.uptimeMillis();
                long last = sLastUp;
                sLastUp = 0L;
                if (last != 0L && now - last <= sTimeout) {
                    lock(ctx);
                } else {
                    sLastUp = now;
                }
                break;
            }
            default:
                // CANCEL / POINTER_DOWN 等：清状态
                sLastUp = 0L;
                sMoved = false;
                break;
        }
    }

    private static void lock(Context ctx) {
        PowerManager pm = (PowerManager) ctx.getSystemService(Context.POWER_SERVICE);
        if (pm == null) {
            log("PowerManager 不可用");
            return;
        }
        long when = SystemClock.uptimeMillis();
        // 华为 PowerManager 只有 goToSleep(J)V
        if (call(pm, "goToSleep", new Class<?>[]{long.class}, new Object[]{when})) {
            return;
        }
        // 标准 AOSP 双参重载兜底
        if (call(pm, "goToSleep", new Class<?>[]{long.class, int.class}, new Object[]{when, 0})) {
            return;
        }
        log("goToSleep 调用失败（无匹配重载）");
    }

    private static boolean call(Object target, String name, Class<?>[] sig, Object[] args) {
        try {
            Method m = target.getClass().getMethod(name, sig);
            m.setAccessible(true);
            m.invoke(target, args);
            return true;
        } catch (NoSuchMethodException e) {
            return false;
        } catch (Throwable t) {
            log(name + " 调用异常: " + t);
            return true;
        }
    }

    private static void log(String s) {
        try {
            XposedBridge.log(TAG + s);
        } catch (Throwable ignored) {
        }
    }
}