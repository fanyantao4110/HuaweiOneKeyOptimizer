package de.robv.android.xposed;

/**
 * 编译期桩：MethodHookParam / hook 回调骨架（运行期由 LSPosed 提供真实实现）。
 */
public abstract class XC_MethodHook {

    public static class MethodHookParam {
        public Object getResult() {
            return null;
        }

        public void setResult(Object result) {
        }

        public Throwable getThrowable() {
            return null;
        }

        public Object[] args;
        public Object thisObject;
        public java.lang.reflect.Member method;

        /** 运行时由 LSPosed 实现，这里只是编译期桩 */
        public void setObjectExtra(String key, Object value) {
        }

        public Object getObjectExtra(String key) {
            return null;
        }
    }

    public static class Unhook {
    }

    protected void beforeHookedMethod(MethodHookParam param) throws Throwable {
    }

    protected void afterHookedMethod(MethodHookParam param) throws Throwable {
    }
}