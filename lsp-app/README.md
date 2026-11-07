# lsp-app —— LSPosed 模块 App（控制 App + 全部 hook 源码）

这是「华为一键优化」的**模块 App 侧**源码：一个 APK 同时干两件事

1. 作为**控制 App**：分组开关、状态检测（Root / LSPosed / 模块已装）、日志区、重启入口；
2. 作为**Xposed 模块宿主**：`assets/xposed_init` → `com.huawei.onekey.optimizer.hook.HookEntry`，
   按包名分发到各 hook 实现。

> 刷入用的 Magisk 模块脚本在仓库根的 `magisk-module/`，与这里互相独立（这里不含预编译 APK）。

## 代码结构

| 路径 | 作用 |
|---|---|
| `app/java/.../core/` | `RootShell`（su 封装）、`Prefs`（三通道开关）、`ModuleOps`（系统层操作）、`LauncherIconCtl`（桌面图标显隐） |
| `app/java/.../hook/HookEntry.java` | 总入口：按包名 + 开关决定是否安装 hook |
| `app/java/.../hook/HookFlags.java` | 目标进程内读开关：XSharedPreferences → `persist.sys.onekey.*` → `flags.sh` |
| `app/java/.../hook/impl/` | 主题解锁 / 系统限制 / 安装器 / 状态栏秒数 / 屏幕休眠 / 无障碍免读秒 / 双击锁屏 |
| `app/java/.../hook/island/` | 灵动岛（视图、控制器、导航与秒表上报、GPU 模糊） |
| `app/java/.../hook/launcher/` | 桌面增强 8 项 + 桌面高级设置注册器 |
| `app/java/.../hook/blur/` | 桌面模糊（转场驱动渐出） |
| `app/java/.../hook/ccvolume/` | 控制中心音量条（资源按名字运行时解析） |
| `app/java/.../ui/` | `MainActivity`（开关 + 状态 + 日志）、`AdvancedActivity`（桌面高级设置） |
| `app/stubs/` | `de.robv.android.xposed.*` 编译期桩，**构建时排除**（模块自带 Xposed API 会被 LSPosed 拒绝加载） |
| `thirdparty/` | 上游模块的 smali 源码，已改统一包名，自包含 |
| `build/` | 不依赖 Gradle 的构建脚本 |

## 编译

依赖：JDK 8+、`python3`、Android SDK（`platforms/android-34`）、`aapt2`、`zipalign`、
`smali`/`baksmali`（dexlib2）。

```sh
cd build
python3 aar_resolve.py   # 首次：拉 Material / androidx 依赖（迷你 Gradle，走阿里云镜像）
sh 01_smali.sh           # thirdparty 四套 smali → build/dex2/classes2.dex
sh 02_apk.sh             # → dist/HuaweiOneKeyOptimizer.apk
sh 03_module.sh          # 与 ../magisk-module 合成 zip → dist/HuaweiOneKeyOptimizer-Magisk-v<ver>.zip
sh 04_deploy.sh          # 可选：root 设备直接部署到 /data/adb/modules
```

环境变量：`ANDROID_SDK`、`BUILD_TOOLS`、`ANDROID_JAR`、`MODULE_SRC`（见根 README 第五节）。

## 两个必踩的坑

1. **不能把 `de.robv.android.xposed.*` 打进 dex**：LSPosed 检测到「模块自带 Xposed API」会直接拒绝加载
   （日志：`The Xposed API classes are compiled into the module's APK`）。`02_apk.sh` 里已用
   `grep -v '/de/robv/android/xposed/'` 过滤。
2. **开关要在目标进程读得到**：App 写 SharedPreferences 在目标进程不可见（未开
   `MODE_WORLD_READABLE`），所以同时写 `persist.sys.onekey.*` 与 `flags.sh`，`HookFlags` 三通道兜底。

## 作用域（LSPosed）

`android`（主题/系统限制）、`com.huawei.android.thememanager`、`com.android.packageinstaller`、
`com.android.systemui`（秒数/音量条/灵动岛）、`com.android.settings`（免读秒/休眠档位/USB 上岛）、
`com.huawei.android.launcher`（双击锁屏/桌面增强/模糊），可选华为时钟·百度地图·高德地图（灵动岛秒表/导航）。
