package com.huawei.onekey.optimizer.hook.launcher;

import android.content.Context;
import android.content.res.Configuration;
import android.content.res.Resources;
import android.view.View;
import android.widget.TextView;

import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import de.robv.android.xposed.XC_MethodHook;
import de.robv.android.xposed.XposedBridge;

/**
 * 反射 / 挂钩 / 日志工具。
 *
 * 设计原则：除了 XposedBridge.hookMethod，其余全部使用 java 原生反射，
 * 这样编译期只需要极小的 Xposed API 桩，运行期也不会因为某个辅助 API 版本差异而挂掉。
 */
public final class Kit {

    public static final String TAG = "HwLT";

    private static final Set<String> ONCE = Collections.synchronizedSet(new HashSet<String>());

    private static volatile Context sAppContext;

    /** 桌面端诊断日志文件（写在桌面自己的沙箱里，模块界面可用 root 读回来，便于没有 adb 时排查） */
    private static volatile java.io.File sLogFile;
    private static final Object LOG_LOCK = new Object();
    private static final long MAX_LOG_BYTES = 128 * 1024L;

    private Kit() {
    }

    /** 安装时记下的 Application context，供需要 Context 但又拿不到 View 的场景兜底 */
    public static void setAppContext(Context c) {
        sAppContext = c;
    }

    public static Context appContext() {
        return sAppContext;
    }

    /**
     * 在桌面进程里开一份文件日志：<桌面沙箱>/files/hwltweak.log。
     * 进程每次重启都会清空重写，并限制总大小，避免无限增长。
     */
    public static void initFileLog(Context ctx) {
        try {
            if (ctx == null) {
                return;
            }
            java.io.File dir = ctx.getFilesDir();
            if (dir == null) {
                return;
            }
            java.io.File f = new java.io.File(dir, "hwltweak.log");
            sLogFile = f;
            java.io.FileWriter w = new java.io.FileWriter(f, false);
            w.write("=== HwLauncherTweak 启动 " + new java.util.Date() + " ===\n");
            w.close();
            log("诊断日志文件：" + f.getAbsolutePath());
        } catch (Throwable t) {
            sLogFile = null;
        }
    }

    private static void toFile(String line) {
        java.io.File f = sLogFile;
        if (f == null) {
            return;
        }
        synchronized (LOG_LOCK) {
            try {
                if (f.length() > MAX_LOG_BYTES) {
                    return;
                }
                java.io.FileWriter w = new java.io.FileWriter(f, true);
                w.write(line);
                w.write('\n');
                w.close();
            } catch (Throwable ignored) {
                // 文件日志失败不影响功能
            }
        }
    }

    // ------------------------------------------------------------------ 日志

    public static void log(String msg) {
        XposedBridge.log("[" + TAG + "] " + msg);
        toFile("[" + TAG + "] " + msg);
    }

    public static void err(String msg, Throwable t) {
        String line = "[" + TAG + "] !! " + msg + " :: " + (t == null ? "null" : t.toString());
        XposedBridge.log(line);
        toFile(line);
        if (t != null) {
            XposedBridge.log(t);
        }
    }

    /** 只在首次打印，避免高频回调刷爆 logcat */
    public static void once(String key, String msg) {
        if (ONCE.add(key)) {
            log(msg);
        }
    }

    // ------------------------------------------------------------------ 环境

    public static boolean portrait() {
        try {
            return Resources.getSystem().getConfiguration().orientation == Configuration.ORIENTATION_PORTRAIT;
        } catch (Throwable t) {
            return false;
        }
    }

    public static Context contextOf(Object o) {
        if (o instanceof Context) {
            return (Context) o;
        }
        if (o instanceof View) {
            return ((View) o).getContext();
        }
        Object c = call(o, "getContext");
        return (c instanceof Context) ? (Context) c : null;
    }

    /** 解除隐藏 API 限制（PowerManager.goToSleep 等），失败不影响其它功能 */
    public static void bypassHiddenApi() {
        try {
            Class<?> vm = Class.forName("dalvik.system.VMRuntime");
            Method getRuntime = vm.getDeclaredMethod("getRuntime");
            getRuntime.setAccessible(true);
            Object runtime = getRuntime.invoke(null);
            Method setExemptions = vm.getDeclaredMethod("setHiddenApiExemptions", String[].class);
            setExemptions.setAccessible(true);
            setExemptions.invoke(runtime, (Object) new String[]{"L"});
            log("已申请隐藏 API 豁免（用于 PowerManager.goToSleep 等）");
        } catch (Throwable t) {
            log("隐藏 API 豁免不可用：" + t);
        }
    }

    // ------------------------------------------------------------------ 类 / 方法

    public static Class<?> load(ClassLoader cl, String name) {
        try {
            return Class.forName(name, false, cl);
        } catch (Throwable t) {
            log("跳过：类不存在 " + name);
            return null;
        }
    }

    /** 收集类及其父类中所有同名方法；arity 为参数个数（null=不限），param0 为单参数时的精确类型 */
    public static List<Method> find(Class<?> c, String name, Integer arity, Class<?> param0) {
        List<Method> out = new ArrayList<Method>();
        for (Class<?> k = c; k != null && k != Object.class; k = k.getSuperclass()) {
            Method[] ms;
            try {
                ms = k.getDeclaredMethods();
            } catch (Throwable t) {
                continue;
            }
            for (Method m : ms) {
                if (!m.getName().equals(name)) {
                    continue;
                }
                Class<?>[] ps = m.getParameterTypes();
                if (arity != null && ps.length != arity) {
                    continue;
                }
                if (param0 != null && (ps.length != 1 || !ps[0].equals(param0))) {
                    continue;
                }
                out.add(m);
            }
        }
        return out;
    }

    public static int hook(Class<?> c, String name, Integer arity, XC_MethodHook cb) {
        return hook(c, name, arity, null, cb);
    }

    /**
     * 挂钩：在类及父类中查找目标方法并挂钩，返回成功数量。
     * 找不到只记日志、不抛异常，保证单个功能失败不会影响其它功能。
     */
    public static int hook(Class<?> c, String name, Integer arity, Class<?> param0, XC_MethodHook cb) {
        if (c == null) {
            return 0;
        }
        int n = 0;
        for (Method m : find(c, name, arity, param0)) {
            try {
                int mod = m.getModifiers();
                if (Modifier.isAbstract(mod) || Modifier.isNative(mod)) {
                    continue;
                }
                m.setAccessible(true);
                XposedBridge.hookMethod(m, cb);
                n++;
                log("已挂钩 " + c.getName() + "#" + m.getName() + "(" + describe(m.getParameterTypes()) + ")");
            } catch (Throwable t) {
                err("挂钩失败 " + c.getName() + "#" + name, t);
            }
        }
        if (n == 0) {
            log("跳过：未找到可挂钩方法 " + c.getName() + "#" + name
                    + "(" + (arity == null ? "任意参数" : String.valueOf(arity) + " 个参数") + ")");
        }
        return n;
    }

    /** 挂钩所有「方法名前缀匹配」的方法（用于 lambda$xxx$1 这类名字带序号的合成方法） */
    public static int hookPrefix(Class<?> c, String prefix, XC_MethodHook cb) {
        if (c == null) {
            return 0;
        }
        int n = 0;
        for (Class<?> k = c; k != null && k != Object.class; k = k.getSuperclass()) {
            Method[] ms;
            try {
                ms = k.getDeclaredMethods();
            } catch (Throwable t) {
                continue;
            }
            for (Method m : ms) {
                if (!m.getName().startsWith(prefix)) {
                    continue;
                }
                int mod = m.getModifiers();
                if (Modifier.isAbstract(mod) || Modifier.isNative(mod)) {
                    continue;
                }
                try {
                    m.setAccessible(true);
                    XposedBridge.hookMethod(m, cb);
                    n++;
                    log("已挂钩 " + k.getName() + "#" + m.getName() + "(" + describe(m.getParameterTypes()) + ")");
                } catch (Throwable t) {
                    err("挂钩失败 " + k.getName() + "#" + m.getName(), t);
                }
            }
        }
        if (n == 0) {
            log("跳过：未找到前缀为 " + prefix + " 的方法 @ " + c.getName());
        }
        return n;
    }

    private static String describe(Class<?>[] ps) {        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < ps.length; i++) {
            if (i > 0) {
                sb.append(", ");
            }
            sb.append(ps[i].getSimpleName());
        }
        return sb.toString();
    }

    // ------------------------------------------------------------------ 字段

    public static Field field(Class<?> c, String name) {
        for (Class<?> k = c; k != null; k = k.getSuperclass()) {
            try {
                Field f = k.getDeclaredField(name);
                f.setAccessible(true);
                return f;
            } catch (Throwable ignored) {
                // 继续往父类找
            }
        }
        return null;
    }

    public static Object getStatic(Class<?> c, String name) {
        if (c == null) {
            return null;
        }
        Field f = field(c, name);
        if (f == null) {
            return null;
        }
        try {
            return f.get(null);
        } catch (Throwable t) {
            return null;
        }
    }

    public static Object get(Object target, String name) {        if (target == null || name == null) {
            return null;
        }
        Field f = field(target.getClass(), name);
        if (f == null) {
            return null;
        }
        try {
            return f.get(target);
        } catch (Throwable t) {
            return null;
        }
    }

    public static Integer getInt(Object target, String name) {
        Object v = get(target, name);
        return (v instanceof Integer) ? (Integer) v : null;
    }

    public static Boolean getBool(Object target, String name) {
        Object v = get(target, name);
        return (v instanceof Boolean) ? (Boolean) v : null;
    }

    public static boolean set(Object target, String name, Object value) {
        if (target == null || name == null) {
            return false;
        }
        Field f = field(target.getClass(), name);
        if (f == null) {
            return false;
        }
        try {
            f.set(target, value);
            return true;
        } catch (Throwable t) {
            return false;
        }
    }

    /** 写入 int 字段（ItemInfo.cellX / CellLayout.LayoutParams.cellX 都是 int） */
    public static boolean setInt(Object target, String name, int value) {
        if (target == null || name == null) {
            return false;
        }
        Field f = field(target.getClass(), name);
        if (f == null || f.getType() != int.class) {
            return false;
        }
        try {
            f.setInt(target, value);
            return true;
        } catch (Throwable t) {
            return false;
        }
    }

    /** 写入静态字段；若是 static final（如 RoPropConstant 的常量）会尝试清除 final 修饰符后再写 */
    public static boolean setStatic(Class<?> c, String name, Object value) {
        if (c == null) {
            return false;
        }
        Field f = field(c, name);
        if (f == null) {
            log("未找到静态字段 " + c.getName() + "." + name + "（该版本可能没有此项）");
            return false;
        }
        Object before;
        try {
            before = f.get(null);
        } catch (Throwable t) {
            before = "?";
        }
        try {
            f.set(null, value);
        } catch (Throwable t) {
            // final 静态字段：清掉 FINAL 再写
            try {
                Field acc = Field.class.getDeclaredField("accessFlags");
                acc.setAccessible(true);
                acc.setInt(f, acc.getInt(f) & ~Modifier.FINAL);
                f.set(null, value);
            } catch (Throwable t2) {
                err("写入静态字段失败 " + c.getName() + "." + name, t);
                return false;
            }
        }
        log("已改写 " + c.getSimpleName() + "." + name + " : " + before + " -> " + value);
        return true;
    }

    // ------------------------------------------------------------------ 调用

    private static Class<?> wrap(Class<?> c) {
        if (!c.isPrimitive()) {
            return c;
        }
        if (c == int.class) return Integer.class;
        if (c == boolean.class) return Boolean.class;
        if (c == long.class) return Long.class;
        if (c == float.class) return Float.class;
        if (c == double.class) return Double.class;
        if (c == short.class) return Short.class;
        if (c == byte.class) return Byte.class;
        if (c == char.class) return Character.class;
        return c;
    }

    private static boolean accepts(Class<?>[] ps, Object[] args) {
        for (int i = 0; i < ps.length; i++) {
            if (args[i] == null) {
                continue;
            }
            if (!wrap(ps[i]).isInstance(args[i])) {
                return false;
            }
        }
        return true;
    }

    /**
     * 按「参数个数 + 实参类型可赋值」匹配方法并调用（同名重载也能正确区分）。
     * 返回方法返回值；匹配不到返回 null。
     */
    public static Object call(Object target, String name, Object... args) {
        if (target == null) {
            return null;
        }
        Object[] a = (args == null) ? new Object[0] : args;
        for (Class<?> k = target.getClass(); k != null; k = k.getSuperclass()) {
            Method[] ms;
            try {
                ms = k.getDeclaredMethods();
            } catch (Throwable t) {
                continue;
            }
            for (Method m : ms) {
                if (!m.getName().equals(name) || m.getParameterTypes().length != a.length) {
                    continue;
                }
                if (!accepts(m.getParameterTypes(), a)) {
                    continue;
                }
                try {
                    m.setAccessible(true);
                    return m.invoke(target, a);
                } catch (Throwable t) {
                    err("调用失败 " + target.getClass().getSimpleName() + "#" + name, t);
                    return null;
                }
            }
        }
        return null;
    }

    public static Object callStatic(Class<?> c, String name, Object... args) {
        if (c == null) {
            return null;
        }
        Object[] a = (args == null) ? new Object[0] : args;
        for (Method m : c.getDeclaredMethods()) {
            if (!m.getName().equals(name) || m.getParameterTypes().length != a.length) {
                continue;
            }
            if (!accepts(m.getParameterTypes(), a)) {
                continue;
            }
            try {
                m.setAccessible(true);
                return m.invoke(null, a);
            } catch (Throwable t) {
                err("静态调用失败 " + c.getSimpleName() + "#" + name, t);
                return null;
            }
        }
        return null;
    }

    // ------------------------------------------------------------------ 视图

    public static void setTextIfTextView(Object view, String text) {
        if (view instanceof TextView) {
            ((TextView) view).setText(text);
        }
    }
}
