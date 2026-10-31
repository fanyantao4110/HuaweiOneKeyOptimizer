package de.robv.android.xposed;

/**
 * 编译期桩：替换返回值用的 Hook 基类。
 */
public abstract class XC_MethodReplacement extends XC_MethodHook {

    protected abstract Object replaceHookedMethod(MethodHookParam param) throws Throwable;
}