package com.huawei.onekey.optimizer.core;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.util.concurrent.TimeUnit;

/**
 * 极简 RootShell：所有需要 root 的操作都走 su -c。
 * 不依赖任何第三方库（无 libsu），保证在无 GMS 的 HarmonyOS 上可用。
 */
public final class RootShell {

    public static final class Result {
        public final int code;
        public final String output;

        Result(int code, String output) {
            this.code = code;
            this.output = output == null ? "" : output;
        }

        public boolean ok() {
            return code == 0;
        }
    }

    private static volatile Boolean sHasRoot = null;

    private RootShell() {
    }

    public static Result exec(String cmd) {
        return exec(cmd, 20);
    }

    public static Result exec(String cmd, int timeoutSec) {
        Process p = null;
        try {
            p = new ProcessBuilder("su", "-c", cmd).redirectErrorStream(true).start();
            boolean finished = p.waitFor(timeoutSec, TimeUnit.SECONDS);
            if (!finished) {
                p.destroy();
            }
            StringBuilder sb = new StringBuilder();
            BufferedReader r = new BufferedReader(new InputStreamReader(p.getInputStream(), "UTF-8"));
            String line;
            while ((line = r.readLine()) != null) {
                sb.append(line).append('\n');
            }
            r.close();
            int code = finished ? p.exitValue() : -1;
            return new Result(code, sb.toString());
        } catch (Throwable t) {
            return new Result(-1, "exec error: " + t);
        } finally {
            if (p != null) {
                try {
                    p.destroy();
                } catch (Throwable ignored) {
                }
            }
        }
    }

    /** 用 root 写入文本文件（走 base64，避免引号转义问题）。 */
    public static Result writeFile(String path, String content) {
        try {
            String b64 = android.util.Base64.encodeToString(content.getBytes("UTF-8"), android.util.Base64.NO_WRAP);
            String cmd = "mkdir -p " + dirOf(path) + "; echo '" + b64 + "' | base64 -d > " + path
                    + "; chmod 644 " + path + "; echo OK";
            return exec(cmd, 20);
        } catch (Throwable t) {
            return new Result(-1, "write error: " + t);
        }
    }

    private static String dirOf(String path) {
        int i = path.lastIndexOf('/');
        return i > 0 ? path.substring(0, i) : "/";
    }

    public static void resetRootCache() {
        sHasRoot = null;
    }

    public static boolean hasRoot() {
        Boolean cached = sHasRoot;
        if (cached != null) {
            return cached;
        }
        boolean ok = false;
        try {
            Result r = exec("id", 15);
            String out = r.output;
            ok = out.contains("uid=0");
        } catch (Throwable ignored) {
        }
        sHasRoot = ok;
        return ok;
    }
}