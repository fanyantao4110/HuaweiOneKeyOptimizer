# lsp-app —— LSPosed 模块 App 源代码

纯命令行构建（不用 Gradle）：`aapt2` 编资源 → `javac` → `d8` → 合并第三方 smali 的 `classes2.dex` → `zipalign` → `apksigner`。

## 目录

```
lsp-app/
├── app/
│   ├── AndroidManifest.xml      # 入口 = LauncherEntry(桌面别名) + InfoEntry(兜底入口) + MainActivity + AdvancedActivity
│   ├── java/com/huawei/onekey/optimizer/
│   │   ├── MainActivity / AdvancedActivity   # MD3 UI（纯手写 View，无 XML 依赖负担）
│   │   ├── core/                             # Prefs、RootShell、ModuleOps、LauncherIconCtl
│   │   └── hook/
│   │       ├── HookEntry.java                # LSPosed 入口（IXposedHookLoadPackage）
│   │       ├── launcher/                     # 华为桌面：角标、应用详情、双击锁屏、模糊、图标字体
│   │       ├── systemui/                     # 状态栏：长按时间显示秒
│   │       ├── installer/                    # 安装器净化
│   │       └── framework/                     # 主题解锁、系统限制、无障碍倒计时
│   ├── res/                     # 布局、字符串、图标（含鸿蒙风格矢量 ic_onekey_appinfo.xml）
│   ├── assets/  stubs/          # 编译期占位（系统类 stub）
├── build/                       # 构建脚本
│   ├── aar_resolve.py           # 无 Gradle 拉取 Material/AndroidX 的 AAR（jar + res）
│   ├── 01_smali.sh              # 第三方 smali → classes2.dex
│   ├── 02_apk.sh                # 资源 + 代码 + 签名 → dist/*.apk
│   ├── 03_module.sh             # 把 apk 打进 Magisk 模块 zip
│   └── 04_deploy.sh             # 本地直投 /data/adb/modules 实测
├── thirdparty/pi-cleaner/       # 安装器净化（PI-Cleaner 1.0.1）smali 源码
└── tools/
```

## 构建步骤

```bash
# 依赖：aapt2 / zipalign / apksigner / d8（build-tools 34.0.0）、JDK 17、python3、zip、unzip
export ANDROID_SDK=/root/android-sdk        # 可选，默认就是它

python3 build/aar_resolve.py                # 首次：下载依赖
sh build/01_smali.sh                        # 生成 build/dex2 里的 classes2.dex 输入
sh build/02_apk.sh                          # → dist/HuaweiOneKeyOptimizer.apk
sh build/03_module.sh                       # → dist/HuaweiOneKeyOptimizer-Magisk-v<ver>.zip
```

## 签名

`02_apk.sh` 默认使用工程根的 `onekey.jks`（**仓库里不含 keystore**）。请自行生成并修改脚本中的：

```sh
KS=$ROOT/onekey.jks
KS_PASS=你的密码
KEY_ALIAS=你的别名
"$SIGNJAR" sign --ks "$KS" --ks-pass pass:$KS_PASS --key-pass pass:$KS_PASS \
    --ks-key-alias "$KEY_ALIAS" --out "$DIST/HuaweiOneKeyOptimizer.apk" "$BUILD/aligned.apk"
```

或者跳过签名，手动 `apksigner sign --ks my.jks ...`。

## 关键实现备注

- **桌面图标显隐**：桌面入口是 `activity-alias LauncherEntry`，`LauncherIconCtl.setHidden()` 只切换该别名的 `COMPONENT_ENABLED_STATE`；`MainActivity` 永不隐藏，另有 `InfoEntry`（`CATEGORY_INFO`）保证 `getLaunchIntentForPackage()` 非空，所以隐藏后 LSPosed / 设置 / adb 都能进。
- **应用详情菜单**：Hook `PopupContainerWithArrow#initDropActionViews` + `DropActionCommand$UninstallCommand` 占位实例（实例身份比对，原厂卸载不受影响）；图标优先用模块内置鸿蒙风格矢量图，失败再退到桌面自带 `ic_public_*`。
- 所有 Hook 都包在 try/catch + `Kit.once/err` 日志里，异常不会传染到宿主进程。