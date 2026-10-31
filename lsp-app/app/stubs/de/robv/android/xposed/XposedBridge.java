package de.robv.android.xposed;

import java.lang.reflect.Member;
import java.util.HashSet;
import java.util.Set;

/**
 * 编译期桩：只声明本工程真正会用到的 API（运行期由 LSPosed 提供）。
 */
public final class XposedBridge {

    public static void log(String text) {
    }

    public static void log(Throwable t) {
    }

    public static XC_MethodHook.Unhook hookMethod(Member hookMethod, XC_MethodHook callback) {
        return null;
    }

    public static Set<XC_MethodHook.Unhook> hookAllMethods(Class<?> hookClass, String methodName,
                                                           XC_MethodHook callback) {
        return new HashSet<XC_MethodHook.Unhook>();
    }
}