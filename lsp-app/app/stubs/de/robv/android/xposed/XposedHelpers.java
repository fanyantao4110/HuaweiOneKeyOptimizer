package de.robv.android.xposed;

/**
 * 编译期桩：XposedHelpers 里本工程用到的几个方法（运行期由 LSPosed 提供真实实现）。
 * d8 会排除 de/robv/** 的 class，不会进 dex。
 */
public final class XposedHelpers {

    public static Class<?> findClass(String className, ClassLoader classLoader) {
        return null;
    }

    public static Object callMethod(Object obj, String methodName, Object... args) {
        return null;
    }

    public static Object callStaticMethod(Class<?> clazz, String methodName, Object... args) {
        return null;
    }

    public static XC_MethodHook.Unhook findAndHookMethod(Class<?> clazz, String methodName,
                                                         Object... parameterTypesAndCallback) {
        return null;
    }

    public static XC_MethodHook.Unhook findAndHookMethod(String className, ClassLoader classLoader,
                                                         String methodName,
                                                         Object... parameterTypesAndCallback) {
        return null;
    }

    public static Object newInstance(Class<?> clazz, Object... args) {
        return null;
    }

    public static Object getObjectField(Object obj, String fieldName) {
        return null;
    }

    public static int getIntField(Object obj, String fieldName) {
        return 0;
    }

    public static float getFloatField(Object obj, String fieldName) {
        return 0f;
    }

    public static boolean getBooleanField(Object obj, String fieldName) {
        return false;
    }

    public static void setObjectField(Object obj, String fieldName, Object value) {
    }

    public static void setIntField(Object obj, String fieldName, int value) {
    }

    public static void setBooleanField(Object obj, String fieldName, boolean value) {
    }
}