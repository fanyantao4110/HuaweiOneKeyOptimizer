package de.robv.android.xposed;

import de.robv.android.xposed.callbacks.XC_LoadPackage;

/**
 * 仅编译期使用的桩接口：运行期由 LSPosed 提供真实实现。
 * 注意：该目录（app/stubs）不参与 d8 打包，避免与 LSPosed 的框架类冲突。
 */
public interface IXposedHookLoadPackage {

    void handleLoadPackage(XC_LoadPackage.LoadPackageParam lpparam) throws Throwable;
}