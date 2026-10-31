# 华为一键优化（HuaweiOneKeyOptimizer）

面向 **华为 MatePad 11 / HarmonyOS 4.2（EMUI 13 内核）** 的一键优化工具箱。
由两部分组成：一个 **Magisk 模块**（系统层 flags / 属性写入）+ 一个 **LSPosed 模块 App**（桌面、状态栏、安装器、系统服务 Hook）。

> 全部功能在本机执行，不联网、不收集任何数据；不改动系统 APK，全部通过 Hook / 属性注入实现，随时可关。

## 目录结构

```
.
├── magisk-module/     # ① Magisk 模块源代码（刷入包里的脚本与配置）
├── lsp-app/           # ② LSPosed 程序源代码（Android 工程 + 构建脚本）
├── README.md
└── LICENSE
```

| 目录 | 内容 |
|---|---|
| [`magisk-module/`](magisk-module/) | `module.prop`、`customize.sh`、`post-fs-data.sh`、`service.sh`、`uninstall.sh`、`common/apply.sh`、`common/watch.sh`、`common/flags.default` |
| [`lsp-app/`](lsp-app/) | `app/`（`AndroidManifest.xml` + `java/` + `res/`）、`build/`（一键构建脚本）、`thirdparty/`（第三方 smali 源码）、`tools/` |

## 功能

**Magisk 模块（系统层，需重启整机）**
- 全应用平行视界（`persist.sys.huawei.parallel.*`）
- 全应用应用分身
- 小窗数量解锁
- 多任务界面显示内存占用
- 系统限制解锁（`ro.config.*` 只读属性重写）

**LSPosed App（Hook，改完重开目标应用即可）**
- 鸿蒙应用安装器净化（关闭安装校验/推荐/广告，原作者 PI-Cleaner 1.0.1 全功能）
- 主题解锁（本地主题 / 第三方主题可用）
- 桌面双击锁屏
- 状态栏长按时间显示秒
- 跳过无障碍授权倒计时
- 去除桌面管控角标
- 长按图标气泡「应用详情」（图标使用鸿蒙图标库风格矢量图）
- 桌面打开/关闭模糊（ColorOS 风格，0–100 可调）
- **隐藏桌面图标（v1.0.26）**：可把本应用从桌面移除；应用本体始终可用，可从 LSPosed → 模块 → 打开、设置 → 应用管理 → 打开，或 `adb am start` 进入恢复

## 安装

### 1. 刷入 Magisk 模块

从 [Releases](../../releases) 下载最新 `HuaweiOneKeyOptimizer-Magisk-vX.Y.Z.zip`：

```bash
# Magisk App → 模块 → 从本地安装 → 选择该 zip → 重启
# 或命令行：
su -c magisk --install-module /sdcard/Download/HuaweiOneKeyOptimizer-Magisk-vX.Y.Z.zip
```

### 2. 安装并激活 LSPosed 模块

1. 安装模块包内自带的 `onekey.apk`（刷入后位于 `/data/adb/modules/huawei_onekey/onekey.apk`，也可从 Releases 单独下载）
2. LSPosed → 模块 → 启用「华为一键优化」
3. 作用域勾选：**华为桌面**、**系统界面(SystemUI)**、**打包安装程序**、**系统框架**（按需）
4. 重启桌面或重启整机

### 3. 使用

打开「华为一键优化」App → 打开需要的开关 → 「应用并立即生效」；标了系统层的项需重启整机。

## 构建

两套东西分开构建，都在 `lsp-app/build/` 里：

```bash
cd lsp-app

# 0) 解析依赖（首次，下载 Material Components / androidx 的 AAR 资源）
python3 build/aar_resolve.py

# 1) 汇编第三方 smali → classes2.dex（安装器净化等）
sh build/01_smali.sh

# 2) 编译资源 + javac + d8 + zipalign + 签名 → dist/HuaweiOneKeyOptimizer.apk
sh build/02_apk.sh

# 3) 打包 Magisk 模块 zip（把 apk 塞进 module）→ dist/*.zip
sh build/03_module.sh

# 4) 本地实测：直接铺到 /data/adb/modules/huawei_onekey（可选）
su -c sh build/04_deploy.sh
```

依赖环境：`aapt2`、`zipalign`、`apksigner`、`d8`（Android build-tools 34.0.0）、JDK 17、`zip`、`python3`。
SDK 路径可用 `ANDROID_SDK=/path/to/sdk` 覆盖，默认 `/root/android-sdk`。

> 签名：脚本使用 `onekey.jks`（未包含在本仓库中）。请自备 keystore 并按 `02_apk.sh` 里的 `apksigner` 参数替换路径；或者删掉签名步骤、自行 `apksigner sign`。

## 隐藏桌面图标后怎么进 App

| 方式 | 操作 |
|---|---|
| LSPosed | 模块 → 华为一键优化 → 打开 |
| 系统设置 | 设置 → 应用和服务 → 应用管理 → 华为一键优化 → 打开 |
| 终端 / adb | `su -c am start -n com.huawei.onekey.optimizer/.ui.MainActivity` |

（实现上桌面入口是独立的 `activity-alias`，隐藏只禁用该别名，应用本体从不被禁用；另有 `CATEGORY_INFO` 兜底入口保证 `getLaunchIntentForPackage()` 始终非空。）

## 兼容性

- 设备：华为 MatePad 11（HarmonyOS 4.2 / EMUI 13）
- 桌面版本适配基于 `com.huawei.android.launcher` 14.0.0.921 的真实签名与字段
- 其它华为机型/版本可能部分功能不生效，Hook 类功能全部带异常兜底，不会导致桌面崩溃

## 免责声明

仅供学习与个人设备研究使用。刷机、Hook 系统进程存在风险，请自行备份并承担后果。

## License

[MIT](LICENSE)
