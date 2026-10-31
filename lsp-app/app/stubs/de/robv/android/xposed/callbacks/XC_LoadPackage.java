package de.robv.android.xposed.callbacks;

/**
 * 编译期桩：只保留 Hook 代码真正会读的字段。
 */
public class XC_LoadPackage {

    public static class LoadPackageParam {
        public String packageName;
        public ClassLoader classLoader;
        public Object appInfo;
        public boolean isFirstApplication;
    }
}