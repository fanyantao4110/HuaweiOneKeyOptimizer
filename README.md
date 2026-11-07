# 华为一键优化（OneKey，EMUI / HarmonyOS 通用）

> 版本 **v1.0.33**（versionCode 10034） · 许可 **MIT** · 验证设备 **MatePad 11 / DBY-W09 / HarmonyOS 4.2 / APatch + Zygisk-LSPosed**
> · 所有功能均为**运行期注入或系统属性**，不重打包任何系统应用 · 模块内不内置 Xposed API（否则 LSPosed 会拒绝加载）

把原本 7 个第三方模块（安装器净化 / 主题破解 / 跳转解锁 / 平行视界 / 应用分身 / 小窗数量 / 内存显示）
加上本项目原创的一批 hook（状态栏长按秒数 / 灵动岛 / 控制中心音量条 / 桌面增强 / 桌面模糊 / 双击锁屏 /
无障碍免读秒 / 主题试用深度解锁），合并成**一个 Magisk/APatch 模块 + 一个控制 App**：

| 原模块 | 类型 | 合并后位置 | 开关 |
|---|---|---|---|
| 华为应用安装器净化 2.0 | Xposed | `hook/installer`（classes2.dex） | 安装器净化 |
| MatePad 主题破解 | Xposed | `hook/theme`（classes2.dex） | 主题试用解锁 |
| play 商店应用跳转解锁（MxxHook） | Xposed | `hook/mxx`（classes2.dex） | 系统限制解锁 |
| 全应用平行视界 for HarmonyOS 4.2 | Magisk 脚本 | `common/apply.sh` | 全应用平行视界 |
| 动态应用分身 HarmonyOS 4.2 | Magisk 脚本 | `common/apply.sh` | 全应用分身 |
| HarmonyOS-FreeformUnlock（①） | 系统属性 | `common/apply.sh` + `post-fs-data.sh` | 小窗数量解锁 |
| HarmonyOS-FreeformUnlock（②） | 系统属性 | `common/apply.sh` + `post-fs-data.sh` | 多任务显示内存 |
| 桌面双击锁屏（教程 F2 的 Hook 版） | Xposed | `hook/DoubleTapLockHooks`（launcher 作用域） | 双击锁屏 |

产物（`dist/`）：

- `HuaweiOneKeyOptimizer.apk` —— 控制 App（含 Xposed Hook 宿主，`assets/xposed_init`）
- `HuaweiOneKeyOptimizer-Magisk-v<版本>.zip` —— 模块包，**内含上面那个 APK**，刷入即自动安装控制 App
  （当前：`v1.0.33` / `versionCode 10034`）

> 这个仓库是「个人自用 + 开源备份」性质：所有 hook 都写成**运行期注入**，不修改、不内置任何华为官方 APK / 资源 / dex，
> 仓库里也不含任何华为私有文件。详见文末「开源与免责声明」。

### 30 秒上手

```sh
# 1) 刷模块（zip 内置控制 App，刷入过程中就会装上，无需等重启）
#    Magisk / APatch → 安装 → 选 dist/HuaweiOneKeyOptimizer-Magisk-v1.0.33.zip → 重启

# 2) LSPosed：启用「华为一键优化」→ 勾作用域（见「一、安装步骤」里的对照表）

# 3) 只想验一个功能？主题试用相关全部收在 hook_theme 一个开关里
su -c 'setprop persist.sys.onekey.theme 1'
su -c 'am force-stop com.huawei.android.thememanager'

# 4) 看效果 / 排查
grep -a OneKey /data/adb/lspd/log/verbose_*.log | tail -20
```

## 功能总览

### A. Hook 类（Xposed / LSPosed，需在管理器里勾作用域）

| 开关 | 目标进程（作用域） | 行为 | 默认 |
|---|---|---|---|
| 安装器净化 | `com.android.packageinstaller` | 纯净模式 / 风险与安全检测拦截 / 未知来源 / 匿名来源 / 本地密码校验 / 广告与推广位清理 / 安装界面旋转跟随 / 结果净化（10 项） | 开 |
| 主题解锁 | `android`（system_server）+ `com.huawei.android.thememanager` | 系统侧 `HwThemeManager` 校验放行 + 主题商店**试用总开关 / 永久试用 / 去「正在试用」通知 / 试用入口常显 / 解除主题·字体·壁纸试用互斥 / 试用倒计时不显示**（详见第二十八章） | 开 |
| 系统限制解锁 | `android` | play / 应用市场跳转链路放行（`com.android.server.mxx.*`，HarmonyOS 4 已移除 → 自动跳过） | 开 |
| 状态栏长按显示秒 | `com.android.systemui` | 长按状态栏时钟切换「显示秒」，下拉面板时钟同步跳秒 | 开 |
| 控制中心音量条 | `com.android.systemui` | 亮度条下方克隆一根音量条（真控媒体音量，图标随档位变化） | 开 |
| 灵动岛 | `com.android.systemui`（+华为时钟 / 百度地图 / 高德地图） | 媒体、导航、充电、手电筒、录屏、实况通知、秒表上岛；USB 弹窗改由岛上切换 | 开 |
| 跳过无障碍授权倒计时 | `com.android.settings` | 无障碍下载类弹窗跳过 10 秒读秒与勾选门槛 | 开 |
| 屏幕休眠 20/30/60 分钟 | `com.android.settings` | `HwTimeoutPreferenceController` 增加长档位 | 开 |
| 双击锁屏 | `com.huawei.android.launcher` | 桌面空白处双击熄屏（`Workspace.onInterceptTouchEvent`） | 关 |
| 桌面增强 | `com.huawei.android.launcher` | 图标角标、主页布局格数、抽屉、Dock 数量、竖屏、无文字、卡片文件夹、表单标题等 | 部分开 |
| 桌面模糊 | `com.huawei.android.launcher` | ColorOS 风格转场模糊，半径由系统属性驱动，改完下一次转场生效 | 开 |

### B. 系统层（Magisk / APatch 脚本与属性，不改 APK）

| 开关 | 实现 | 关闭 |
|---|---|---|
| 全应用平行视界 | 生成 `magic_window_application_list.xml`（`window_mode=1001`）→ bind mount | 原厂文件 bind 回去 |
| 全应用分身 | 生成 `hw_clone_app_list.xml` → bind mount + 重启 `com.huawei.systemmanager` | 同上 |
| 小窗数量解锁 | `resetprop -n hw_mc.freeform.max_num 64` | `resetprop -d`（不能置 0） |
| 多任务显示内存 | `resetprop -n ro.config.hide_meminfo false` | 写回 `true` |

### C. 开关的存储与生效

所有开关都走同一套三通道：`SharedPreferences`（控制 App 写入）→ `persist.sys.onekey.*` → `/data/adb/huawei_onekey/flags.sh`，
Hook 进程用 `HookFlags` 依次读取（XSharedPreferences → getprop → flags.sh），三处都没有时用各功能的默认值。

## 一、安装步骤

1. 用 APatch / Magisk 刷入 `HuaweiOneKeyOptimizer-Magisk-v1.0.33.zip`。
   **刷入过程中 `customize.sh` 就会自动安装控制 App**（不需要等重启）；若安装失败（例如在 recovery 里刷），
   开机后 `service.sh` 会自动补装，也可以手动安装模块目录里的 `onekey.apk`。
2. 打开「华为一键优化」，首次会请求 Root，请点允许。
3. 打开 LSPosed 管理器 → 模块 → 启用「华为一键优化」→ **勾选作用域**（按你要用的功能勾，不勾的功能不会加载）：

   | 作用域 | 必须勾哪个功能 |
   |---|---|
   | 系统框架 `android` | 主题解锁（系统侧）、系统限制解锁 |
   | 华为主题 `com.huawei.android.thememanager` | 主题解锁（试用体系部分） |
   | 软件包安装程序 `com.android.packageinstaller` | 安装器净化 |
   | 系统界面 `com.android.systemui` | 状态栏秒数、控制中心音量条、灵动岛 |
   | 设置 `com.android.settings` | 无障碍免读秒、屏幕休眠长档位、USB 弹窗上岛 |
   | 桌面 `com.huawei.android.launcher` | 双击锁屏、桌面增强、桌面模糊 |
   | 华为时钟 / 百度地图 / 高德地图（可选） | 灵动岛的秒表 / 导航 |

4. 强制停止目标应用（或重启一次），Hook 生效。system_server 侧（主题、系统限制）必须**重启整机**才会加载。
5. 出问题先看日志：`/data/adb/lspd/log/verbose_*.log` 里搜 `OneKey`，
   每个功能都会打印一行安装结果（例如 `[OneKey][Theme] thememanager: enable=2 service=13 notify=2 preview=10 countdown=1`）。
## 二、七个开关的实际行为

> 历史章节：这是 v1.0.5 时代的「七个开关」。现在功能已经扩到 20+ 项（见上「功能总览」），
> 下面这段只用来解释**系统层**那几个开关的底层动作，仍然准确。


- **安装器净化 / 主题解锁 / 系统限制解锁**：改 `SharedPreferences` + `persist.sys.onekey.*` + `/data/adb/huawei_onekey/flags.sh`，
  Hook 进程通过 `HookFlags` 三通道读取（XSharedPreferences → getprop → flags.sh），默认 `true`（刷完即生效）。
- **全应用平行视界**：读 `/data/system/packages.list` 取第三方应用，剔除游戏关键词，
  生成带 `window_mode="1001"` 的 XML → bind mount 覆盖
  `/hw_product/region_comm/china/xml/magic_window_application_list.xml`（本机根节点是 `<package_config>`，脚本会动态识别闭合标签）。
- **全应用分身**：生成 `<AppClone><package name="..."/></AppClone>` → bind mount 覆盖
  `/system/emui/base/xml/hw_clone_app_list.xml`，然后 `am force-stop com.huawei.systemmanager`。
- **关闭 = 完全还原**：关闭时把首次运行备份的原厂文件重新 bind 回去（不是简单 umount，避免 EBUSY）。
- **小窗数量解锁**：`resetprop -n hw_mc.freeform.max_num 64`（原模块同款），关闭时用 `resetprop -d` **删除属性**（不是置 0，
  置 0 会让系统认为「最多 0 个小窗」）。属性不落盘，重启即消失，所以不需要备份。
- **多任务显示内存**：`resetprop -n ro.config.hide_meminfo false`，关闭时写回 `true`。
  SystemUI 只在启动时读这个属性 → 切换后需点 App 里的「重启系统」。

## 三、为什么要 `watch.sh` 常驻守护

实测环境是 **APatch**：App 通过 `su -c` 执行的 mount 落在**独立的 mount namespace**，
系统进程看不到，"立即生效"会假成功。因此：

```
App 点按钮 → 写 /data/adb/huawei_onekey/apply.request
          → 开机由 service.sh 启动的 watch.sh（全局命名空间）执行 apply.sh
          → 写 apply.done，App 轮询到后把日志回显
```

守护没启动（刚装模块未重启）时，App 会回退成直接执行 `apply.sh`。

## 四、目录结构

仓库按「两个源码目录 + 根目录文档」组织，刷入用的 Magisk 模块与 LSPosed 模块 App 完全分开，互不依赖：

```
README.md               本文件（总览 / 功能总览 / 版本历史 / 开源说明）
LICENSE                 MIT
.gitignore

lsp-app/                LSPosed 模块 App（控制 App + 全部 hook 源码）
  README.md             编译说明
  app/
    AndroidManifest.xml  xposedmodule / xposeddescription / xposedscope 声明
    assets/xposed_init   入口：com.huawei.onekey.optimizer.hook.HookEntry
    java/.../core/       RootShell（su 封装）、Prefs（三通道开关）、ModuleOps、LauncherIconCtl
    java/.../hook/
      HookEntry.java     总入口：按包名 + 开关分发
      HookFlags.java     目标进程内读开关（XSharedPreferences → getprop → flags.sh）
      impl/              ThemeHooks / MxxHooks / InstallerResultHooks / StatusBarSecondsHooks /
                         SystemTimeoutHooks / AccessibilitySkipHooks / DoubleTapLockHooks
      island/            灵动岛（IslandHook / IslandView / IslandController / NavReporter / StopwatchReporter / GpuBlur）
      launcher/          桌面增强 8 项 + LauncherAdvanced
      blur/              桌面模糊（BlurCfg / LauncherBlurHooks / LauncherBlurController）
      ccvolume/          控制中心音量条（CcVolumeRes 资源解析）
    java/.../ui/         MainActivity（分组开关 + 状态 + 日志）、AdvancedActivity（桌面高级设置）
    stubs/               de.robv.android.xposed 编译期桩（构建时排除，不进 dex）
    res/                 values / layout / drawable / mipmap
  build/
    01_smali.sh          把 thirdparty/ 四套 smali 汇编成 build/dex2/classes2.dex
    02_apk.sh            aapt2 → javac → d8 → 合 dex → zipalign → apksigner
    03_module.sh         打包模块 zip（默认取 ../magisk-module，可用 MODULE_SRC 覆盖）
    04_deploy.sh         以 root 直接部署到 /data/adb/modules 便于实测
    aar_resolve.py       「迷你 Gradle」：按 POM 递归下载 AAR/JAR（无 gradle/maven）
  thirdparty/            上游 Xposed 模块的 smali 源码（已改统一包名，自包含）
    pi-cleaner/          安装器净化（PI-Cleaner 1.0.1，55 个类）
    theme/ theme-smali/  主题破解 smali 兜底
    mxx/ mxx-smali/      应用跳转 / 系统限制解锁 smali 兜底
    ccvolume/            控制中心音量条（CCVolume，11 个类）
  tools/scan_missing_deps.py

magisk-module/          刷入用的 Magisk / APatch 模块（只有脚本，没有预编译 APK）
  module.prop id / name / version / author
  customize.sh           刷入时立即安装控制 App（复制到 /data/local/tmp 再 pm install）
  post-fs-data.sh        开机前挂载平行视界 XML（用上次生成的缓存）
  service.sh             开机后按最新应用列表重生成，并做 APK 版本比对补装
  uninstall.sh           卸载时还原 bind mount
  common/apply.sh        系统层开关的全部动作（平行视界 / 分身 / 小窗 / 内存）
  common/watch.sh        apply.request 守护（避免 APatch 命名空间问题）
  common/flags.default    默认开关
  META-INF/              刷入器入口（update-binary / updater-script）

install.sh               一键本地构建 + 部署的便捷脚本（可选）
```

> 本地开发也可以直接把 `app/` 当成 Android 工程根目录扔进 Android Studio（无 Gradle 依赖，纯 SDK + Material 资源），
> 但本仓库的官方构建路径是 `build/*.sh`（不依赖 Gradle，见下一节）。

## 五、重新构建（从零开始）

依赖：JDK 8+、`python3`、Android SDK（`platforms/android-34` + 任意较新 `build-tools`）、
`aapt2`、`zipalign`（Ubuntu 上可直接 `apt install aapt zipalign`）、`smali`/`baksmali`（dexlib2）。

```sh
cd lsp-app/build
python3 aar_resolve.py   # 首次：下载 Material / androidx 依赖（国内走阿里云镜像）
sh 01_smali.sh           # thirdparty 四套 smali → build/dex2/classes2.dex
sh 02_apk.sh             # 编译签名 → dist/HuaweiOneKeyOptimizer.apk
sh 03_module.sh          # 打包 → dist/HuaweiOneKeyOptimizer-Magisk-v<ver>.zip（模块脚本取 ../magisk-module）
sh 04_deploy.sh          # 可选：本机 root 直接部署到 /data/adb/modules 便于实测
```

`03_module.sh` 默认把 `lsp-app/../magisk-module` 当作模块脚本来源，也可以用环境变量指到别处：

```sh
MODULE_SRC=/path/to/magisk-module sh 03_module.sh
```

环境变量（都可省略，脚本会自动探测）：

| 变量 | 默认 | 说明 |
| --- | --- | --- |
| `ANDROID_SDK` | `/root/android-sdk` | SDK 根目录 |
| `BUILD_TOOLS` | `$ANDROID_SDK/build-tools/` 下最新一版 | d8.jar / apksigner.jar 所在 |
| `ANDROID_JAR` | `$ANDROID_SDK/platforms/android-*/android.jar` 最新一版 | 编译用 |
| `MODULE_SRC` | `lsp-app/../magisk-module` | 打包时使用的模块脚本目录 |

签名密钥：`onekey.jks`（storepass / keypass 均为 `onekey123`，**不要提交到仓库**；
`02_apk.sh` 发现缺失会自动生成一个新密钥）。

## 六、已在真机（DBY-W09 / HarmonyOS 4.2 / APatch + Zygisk-LSPosed）验证

- APK 安装、启动、UI 渲染正常（无 androidx，无崩溃）
- 状态区正确显示：Root 已授权 / LSPosed 已激活 / 模块已安装
- 「全部关闭」→ `flags.sh` 五项全 0、`persist.sys.onekey.*` 全 0、两个系统 XML 回到原厂（331 字节白名单 / 4123 行配置）
- 「一键全开」→ 生成并挂载：平行视界新增 17 个应用（4139 个 `<package>`，无重复）、分身白名单 23 个应用
- 生成的 XML 通过 Python `ElementTree` 解析校验（根节点 `package_config` / `AppClone`）
- classes2.dex 内已无旧包名残留（`com/muxmu`、`com/matepad`、`com/workbuddy`）

## 七、已知限制 / 注意事项

1. **Hook 类开关需要 LSPosed 作用域**（上面第 4 步），否则 Hook 不会加载；
   `HookEntry` 会按 `HookFlags` 判断开关，关闭时直接不分发。
2. 系统层开关改动后建议点「重启系统」，因为属性与 XML 只在对应进程启动时读一次。
3. 原三个旧 APK 请卸载（本机已卸载 `com.muxmu.install.optimizer`），避免重复 Hook。
4. 首次运行会自动把两份原厂 XML 备份到 `/data/adb/huawei_onekey/orig_*.xml`，**不要删**，
   否则「关闭」无法还原原厂配置（重启后卸载模块也能恢复）。
5. 平行视界会跳过游戏包（`tencent.game`、`miHoYo`、`bilibili.game` 等关键词），避免游戏被分屏。

## 八、v1.0.1 修复记录（真机定位）

### 1. Hook 完全没效果的真正原因：LSPosed 拒绝加载模块

LSPosed 日志（`/data/adb/lspd/log/verbose_*.log`）里每个目标进程都在报：

```
E/LSPosedFramework  Cannot load module: com.huawei.onekey.optimizer
E/LSPosedFramework  The Xposed API classes are compiled into the module's APK.
```

原因：`app/stubs` 里 `de.robv.android.xposed.*` 只是**编译期桩**，但构建脚本把它们一起交给 d8，
导致 `de.robv.android.xposed.XposedBridge` 等类被打进了 `classes.dex`，LSPosed 一旦检测到
「模块自带 Xposed API」就直接拒绝加载（这是硬性检查，不是警告）。

修复：`02_apk.sh` 里给 d8 的类列表加上 `grep -v '/de/robv/android/xposed/'`。
现在 `classes.dex` 只有 32 个业务类、`de.robv.*` 定义数为 0。

修复后实测日志：

```
(com.android.packageinstaller)[com.huawei.onekey.optimizer] [InstallOptimizer] ✅ 应用推广拦截 Hook成功
(com.android.packageinstaller)[com.huawei.onekey.optimizer] [OneKey] 安装器净化 已加载
(com.huawei.android.thememanager)[com.huawei.onekey.optimizer] [OneKey][Theme] TryOutTimeFenceService=0
```

### 2. 主题 / 系统限制的逻辑已按 smali 重写进源码

- `hook/impl/ThemeHooks.java`
  - `android`：反射 `android.hwtheme.HwThemeManager`，对「返回 boolean 且方法名含
    check/valid/author/restrict/verify/need」的方法 `afterHookedMethod → setResult(true)`
    （等价 MainHook$1）
  - `com.huawei.android.thememanager`：`TryOutTimeFenceService` / `PayedManagerServiceImpl` /
    `TrialBackInfo` 三个类的所有 boolean 方法同样返回 true（等价 MainHook$2）
- `hook/impl/MxxHooks.java`
  - `HOOK_FALSE` 10 条 + `HOOK_TRUE` 1 条，按原 smali 的 clinit 顺序逐条
    `Class.forName("com.android.server.mxx."+cls)` + `hookAllMethods` 常量替换，
    末尾打印 `hooked/missed`（等价 MxxHook）
- 安装器模块（24 个类 / 2000+ 行 smali）仍以反射调用原实现；
  Java 版抛异常时会自动回退到 smali 版，不会“静默失效”。

> 说明：本机 EMUI 14 里 `com.huawei.android.thememanager.mvp.model.helper.pay.PayedManagerServiceImpl`
> 与 `…bean.TrialBackInfo` 已不存在（日志里是 ClassNotFoundException，与原模块同样的限制）；
> 主题解锁主要依赖 system_server 侧的 `HwThemeManager` 分支。

### 3. 平行视界“重启也不生效”的原因：挂载时机太晚

`magic_window_application_list.xml` 是 **system_server 开机时读取**的。
原来只在 `service.sh`（late_start，开机完成才跑）里 bind mount，等于每次都要等到**下一次**重启才生效。

修复：`post-fs-data.sh` 增加 `sh common/apply.sh early`，
用**上一次生成的缓存**在 system_server 启动**之前**就把 XML 挂上去；
`service.sh` 仍然负责按最新的 `packages.list` 重新生成，供下次开机组装。
（分身白名单由 `com.huawei.systemmanager` 读取，所以原来就能立即生效。）

### 4. 其它

- 版本升到 `1.0.1`（versionCode 2），`service.sh` 会在开机时自动升级已安装的 APK。

## 九、v1.0.2 变更：合并 HarmonyOS-FreeformUnlock（拆成两个开关）

原模块 `HarmonyOS-FreeformUnlock.zip` 只有 3 个文件（`module.prop` / `system.prop` / `post-fs-data.sh`），
本体就是两条 `resetprop`。合并时**拆成两个独立开关**：

| 开关 | 动作 | 关闭 |
|---|---|---|
| 小窗数量解锁 `sw_freeform` | `resetprop -n hw_mc.freeform.max_num 64` | `resetprop -d hw_mc.freeform.max_num` |
| 多任务显示内存 `sw_meminfo` | `resetprop -n ro.config.hide_meminfo false` | `resetprop -n ro.config.hide_meminfo true` |

实现要点：

1. **`resetprop` 必须找绝对路径**：本机是 APatch，二进制在 `/data/adb/ap/bin/resetprop`，
   `PATH` 里没有裸名。`apply.sh` 按 `/data/adb/ap/bin` → `magisk` → `ksu` → `/system/bin` → `command -v` 顺序探测。
2. **关闭不是置 0**：`hw_mc.freeform.max_num=0` 会被系统当成「一个都不许开」，所以用 `--delete` 真删掉属性。
3. **两条属性都不落盘**，重启自动消失，因此不需要像 XML 那样做 `orig_*` 备份 → 也不会出现 EBUSY 问题。
4. **内存显示要重启 SystemUI**：`ro.config.hide_meminfo` 只在 SystemUI 启动时读取，
   点「重启系统」即可；小窗数量由多任务框架实时读取，一般即刻生效（个别场景需重启）。
5. `post-fs-data.sh` 里也会跑一次（`apply.sh early`），保证开机时属性在 SystemUI 起来之前就已经写好。

同步修改的位置：`strings.xml`（分组名 + 4 条文案）、`activity_main.xml`（新分组卡片）、
`Prefs.java`（`K_FREEFORM` / `K_MEMINFO`、`ALL_KEYS`、`propKey`、`flags.sh` 两行）、
`HookFlags.java`（常量）、`MainActivity.java`（两个 Switch 的绑定 / 一键全开 / label）、
`flags.default`（默认 `=1`）、`customize.sh`（安装提示）。

## 十、v1.0.3：把「重启系统界面」改为「重启系统」

实测发现 `killall systemui` 只对「多任务内存显示」这类 SystemUI 自己读取的配置有效，
而**平行视界 XML、`hw_mc.freeform.max_num` 等是 system_server / framework 开机时读一次**，
重启系统界面根本不会重新加载 → 用户看到「点了没反应」。

改动：

- `strings.xml`：按钮文案 `重启系统界面` → `重启系统`；新增二次确认标题/正文/按钮；
  `sw_meminfo_desc`、`footer_tip` 里的「重启系统界面」改为「重启系统」。
- `ModuleOps`：`restartSystemUi()`（killall systemui + launcher）→ **`rebootSystem()`**：
  先 `sync`，再 `(sleep 2; reboot) >/dev/null 2>&1 &`，让 `su` 会话先返回，避免重启打断命令导致 App 报错。
- `MainActivity`：`btn_reboot` 现在弹确认框（文案说明「只有重启整机才生效」），
  确认后调用 `rebootSystem()`；取消则什么都不做。
- 版本 `1.0.3`（versionCode 4），模块 `versionCode=10003`。

真机验证：按钮文本已是「重启系统」，点击弹出「重启系统 / 立即重启 / 稍后」确认框，
正文为「平行视界、小窗数量、多任务内存显示等选项只在系统启动时被读取一次，必须重启整机才会生效」。

## 十一、v1.0.4：处理 `cmd: Failure calling service activity: Failed transaction` 日志

日志里偶尔出现的这一行来自 `am force-stop com.huawei.systemmanager`（为了让分身白名单立即重新加载）：

- **原因**：root 的 `am` 客户端与 system_server 之间的 **binder 事务一次性失败**
  （`2147483646` = `-2` = `FAILED_TRANSACTION`）。典型诱因是刚写完 1.2 MB 的 XML + 做完 bind mount，
  system_server 正忙，或目标进程恰好在这一刻重启。
- **影响**：**没有**。它只表示「让系统管理器立刻刷新白名单」这一步没成功；
  bind mount 已经完成，文件内容已经是新的，系统管理器下次启动（或重启整机）就会读到新白名单。
  平行视界、小窗数量、内存显示等功能都不经过这条命令。
- **修法**：`apply.sh` 新增 `restart_sysmanager()`，把裸调用换成「重试 3 次 + PID 校验」，
  并把 `am` 的 stdout/stderr 全部丢弃：
  - PID 变了 → `应用分身：com.huawei.systemmanager 已重启（PID a -> b），白名单立即生效`（静默成功）
  - 进程不在了 → `已停止，下次启动即读取新白名单`
  - 3 次都没重启 → 输出一句人话说明「挂载已完成，等它下次启动/重启生效，其它功能不受影响」

版本 `1.0.4`（versionCode 5），模块 `versionCode=10004`。

## 十二、v1.0.5：作者改为 fanyantao + 刷入即安装控制 App

1. **作者**：`module.prop` 的 `author` 由 `Operit` 改为 **`fanyantao`**。
2. **刷入时就装 App**：安装逻辑从「`service.sh` 开机后安装」提前到 **`customize.sh` 刷入过程中安装**：

   ```sh
   TMPAPK=/data/local/tmp/onekey_install.apk
   cp -f "$MODPATH/onekey.apk" "$TMPAPK"      # 关键：pm 读不到 /data/adb 下的文件
   chmod 0644 "$TMPAPK"; restorecon "$TMPAPK"
   pm install -r -g -d "$TMPAPK"
   rm -f "$TMPAPK"
   ```

   - 为什么必须拷到 `/data/local/tmp`：`pm` 实际由 **system_server** 执行，它没有权限读
     `/data/adb/modules(_update)`（会报 `Can't open file`）；`/data/local/tmp` 是 `shell_data_file`，安装器可读。
   - `-r` 覆盖安装、`-g` 默认授予全部运行权限、`-d` 允许版本回退（方便反复刷测试包）。
   - 失败兜底：没有 `pm`（recovery 里刷）或安装失败时，`ui_print` 会明确提示，并由
     `service.sh` 在开机后补装 —— 补装同样改成「先拷到 `/data/local/tmp` 再 `pm install`」，
     修掉了原来直接 `pm install /data/adb/...` 必然失败的问题。
3. 版本 `1.0.5`（versionCode 6），模块 `versionCode=10005`。

真机验证（直接以 `MODPATH=/data/adb/modules/huawei_onekey` 执行 `customize.sh` 模拟刷入）：

```
- 安装控制 App
✓ 控制 App 已安装，刷完打开「华为一键优化」即可
✓ 模块安装完成
```

执行后 `dumpsys package com.huawei.onekey.optimizer` → `versionName=1.0.5`，`module.prop` → `author=fanyantao`。

## 十三、v1.0.6：UI 改成 Material Design

原来用的是 `Theme.DeviceDefault.Light.NoActionBar`，在 EMUI 上就是 Android 5 那套控件（灰绿 Switch、方角按钮），
现在整体换成 **Material Design**，且**不引入任何 androidx/material 依赖**（仍用 aapt2 + android.jar 直编）。

### 1. 主题

```xml
<style name="AppTheme" parent="@android:style/Theme.Material.Light.NoActionBar">
    <item name="android:colorPrimary">@color/primary</item>
    <item name="android:colorAccent">@color/primary</item>
    <item name="android:colorControlHighlight">@color/primary_soft</item>
    <item name="android:colorEdgeEffect">@color/primary</item>
    <item name="android:statusBarColor">@color/primary_dark</item>
    ...
</style>
```

好处：Switch 自动变成 MD 样式（不是 EMUI 灰绿）、Button 有 state 动画、AlertDialog 变圆角 MD 弹窗、
滚动有 stretch 效果，全部由系统主题提供。

### 2. 视觉结构

- **Hero 卡片**：`@drawable/hero_bg` 蓝紫渐变（#0A59F7 → #5A2BF0）、圆角 24dp、elevation 6dp，
  白色标题 + 半透明副标题 + 胶囊 chip（机型 / 系统 / API）。
- **卡片**：白底、圆角 20dp、1dp 极淡描边、elevation 2dp，卡片之间留 10dp。
- **分组标题**：12sp、加粗、letterSpacing 0.08，做成 MD 的 section label。
- **条目**：15sp `sans-serif-medium` 标题 + 12sp 次要色描述（行距 +3dp）。
- **按钮**：主按钮 = 胶囊（圆角 26dp）+ `ripple` 白色水波；次按钮 = 描边胶囊 + 蓝色水波。
- **运行环境**：每行前面加 8dp 圆点（`@drawable/dot`），比原来纯文字更像列表。
- **日志区**：内层浅灰底 `#F7F9FC`、圆角 14dp、等宽字体 11sp。

### 3. 真机像素级校验（`screencap` + 手写 PNG 解码取样）

| 取样点 | 实测 RGB | 说明 |
|---|---|---|
| 状态栏 | `(7,62,174)` | `primary_dark` #073EAE ✓ |
| Hero 左侧 | `(10,89,247)` | 渐变起点 #0A59F7 ✓ |
| Hero 右侧 | `(87,45,240)` | 渐变终点 #5A2BF0 ✓ |
| 页面背景 | `(243,245,249)` | `bg` #F3F5F9 ✓ |
| 卡片 | `(255,255,255)` | 卡片白底 ✓ |
| 主按钮 | `(10,89,247)` | 填充胶囊 ✓ |
| 次按钮 | `(233,238,249)` | 描边 ghost 底色 ✓ |
| 日志区 | `(247,249,252)` | 日志浅底 ✓ |

分组、7 个开关、按钮、日志区的文本也都通过 `uiautomator dump` 确认完整渲染（无遮挡、无 NPE）。

版本 `1.0.6`（versionCode 7），模块 `versionCode=10006`。

## 十四、v1.0.7：真正引入 Material Components（不靠系统主题凑）

v1.0.6 只是把系统主题换成 `Theme.Material.Light`，控件仍是平台的旧款（MD1）。v1.0.7 直接引入
**`com.google.android.material:material:1.11.0`（Material Design 3）**，按钮/开关/卡片/弹窗都是真正的 MD3 组件。

### 1. 没有 Gradle 怎么拉依赖

项目是 aapt2 + javac + d8 手写流水线（proot 里跑不了 AGP 的 aapt2 二进制），所以写了
`build/aar_resolve.py` 当"迷你 Gradle"：

1. 从 `material:1.11.0` 的 POM 开始递归解析 transitive 依赖（跳过 test/provided/optional）；
2. **两轮 BFS** 做版本冲突消解：第一轮收集每个 `group:artifact` 的最高版本，第二轮按统一版本重新展开，
   避免 `androidx.core` 1.3/1.6/1.8/1.9 同时存在导致 d8 报 `defined multiple times`；
3. 下载 AAR → 解出 `classes.jar` + `res/`，并读 AAR 的 `AndroidManifest.xml` 拿包名（生成 R 用）；
4. 剪掉 `kotlin-stdlib-jdk7/jdk8`（1.8 起已并入 `kotlin-stdlib`，同时保留会重复类）。

**国内镜像**（`REPOS` 顺序，先阿里云，再官方兜底）：

```
https://maven.aliyun.com/repository/google     # androidx / material 走这个，0.8s 拿到 POM
https://maven.aliyun.com/repository/central
https://maven.aliyun.com/repository/public
https://dl.google.com/dl/android/maven2
https://repo1.maven.org/maven2
```

产物：**55 个 jar / 25 个 res 目录 / 9.6 MB classes**，8 线程并发下载，缓存到 `build/m2`（可重复构建不再联网）。

### 2. 流水线需要的三处改造（`build/02_apk.sh`）

| 步骤 | 改造 |
|---|---|
| aapt2 compile | 每个库的 `res/` 单独 `compile --dir` 成 `res_lib/libN.zip` |
| aapt2 link | 额外 `-R libN.zip ...` + `--extra-packages`（25 个库包名，用于生成 `androidx.*.R`，否则运行期 `NoClassDefFoundError`） |
| javac / d8 | classpath 拼上 55 个 `classes.jar`；d8 输入里加上这些 jar **和原来的 `classes2.dex`（smali 迁移代码）**，一次性合并成 4 个 dex |
| 打包 | dex 改用 `zip -9` 压缩（之前 `-0` 不压缩 → APK 13.6 MB，现在 5.6 MB） |

### 3. 界面组件（全部来自 material 依赖）

- `MaterialToolbar`：顶栏 title + subtitle（`textAppearanceTitleLarge`），不再是手写标题块；
- `MaterialCardView`：`cardCornerRadius=16dp`、`cardElevation=0`、`strokeWidth=1dp` + `?attr/colorOutlineVariant`（MD3 描边卡片）；
- `MaterialSwitch`：MD3 新款开关（带图标滑块），替代平台 `Switch`；
- `MaterialButton`：`Widget.Material3.Button.TextButton`（一键全开/全部关闭，扁平文字按钮）、
  默认 filled（应用并立即生效，26dp 胶囊）、`Widget.Material3.Button.OutlinedButton`（重启系统）；
- `MaterialAlertDialogBuilder`：重启确认框变成 MD3 圆角弹窗；
- `AppCompatActivity` + `SwitchCompat` 基类，主题 `Theme.Material3.Light.NoActionBar`，
  配色用 MD3 基线 token（primary `#0B57D0`、background `#F7F9FC`、onSurfaceVariant `#44474E`、outlineVariant `#C4C6D0`）。

### 4. 验证

| 取样点 | 实测 RGB | 期望 |
|---|---|---|
| 状态栏 / 页面背景 | `(247,249,252)` | `#F7F9FC` ✓ |
| 卡片 | `(255,255,255)` | `#FFFFFF` ✓ |
| 主按钮（filled） | `(11,87,208)` | `#0B57D0` ✓ |
| 次按钮（outlined） | 与背景同色 + 1dp 描边 | 透明底 ✓ |

`uiautomator dump` 里 7 个开关都是 `android.widget.Switch` 可访问类（MaterialSwitch 的基类报告名），
6 个卡片是 `androidx.cardview.widget.CardView`（MaterialCardView 的父类），文字全部完整、无重叠。
启动无 `FATAL EXCEPTION`。

### 5. 体积变化（代价）

| 版本 | APK | 模块 zip |
|---|---|---|
| 1.0.6（纯系统主题） | 79 KB | 48 KB |
| **1.0.7（Material3）** | **5.6 MB** | **4.5 MB** |

多出来的就是 material + androidx 的 dex（4 个 dex，未压缩 12 MB）。要再瘦身可以上 R8 裁剪，
但 XML 里 inflated 的类名是反射加载，keep 规则容易漏，暂时保留完整依赖换取稳定。

**重建顺序**：`python3 build/aar_resolve.py` → `sh build/02_apk.sh` → `sh build/03_module.sh` → `sh build/04_deploy.sh`。
- `apply.sh` 支持 `early` 模式，并在挂载后用 `cmp` 校验内容、失败重试 3 次。

## 十五、v1.0.8：桌面双击锁屏（Hook 实现，不再改 APK）

### 1. 为什么不走「改 APK」
`华为桌面/修改教程.txt` 的做法是：反编译 `/system/app/HwLauncher6/base-master.apk` → 往
`Workspace.smali` 注入 3 行调用 + 新增 `DoubleTapLocker.smali` → 重打包签名 → 覆盖系统分区文件、
删掉 `oat/` 缓存 → 刷 `super.img`。

代价很明确：改系统分区、破坏原签名（OTA / 校验）、每次系统更新都要重做一遍、做完还不能关掉。

现在改成 **LSPosed Hook**，运行时挂在同一个方法上，效果等价：

| 对比项 | 改 APK（教程方案） | 本模块 v1.0.8 |
|---|---|---|
| 系统分区 | 覆盖 `base-master.apk` | 完全不碰 |
| 签名 | 必须重签 | 不动原 APK |
| 生效方式 | 刷 super.img / 重启 | 重启桌面（或重启系统） |
| 可开关 | 不能 | App 里一个开关 |
| 系统更新后 | 要重做 | 仍然有效 |

### 2. 实现
- 新增 `app/java/.../hook/impl/DoubleTapLockHooks.java`
- 目标：`com.huawei.android.launcher`（HwLauncher6 `14.0.0.513`）的
  `Workspace.onInterceptTouchEvent(MotionEvent)`，用 `hookAllMethods` 挂在 `beforeHookedMethod`
  （不改变原返回值，纯粹旁路监听，不会影响桌面原有手势）
- 判定（对齐教程 v10 成品）：
  - `ACTION_DOWN` 记录起点
  - `ACTION_MOVE` 位移超过 `ViewConfiguration.getScaledTouchSlop()` → 标记为滑动
  - `ACTION_UP` 若不是滑动，且与上一次「纯点击」间隔 `<= 300ms` → 锁屏
  - 滑动结束 / CANCEL 清空双击计数，避免「滑一下再点一下」误触发
- 锁屏调用：`PowerManager.goToSleep(long)` 单参（华为只有这个重载，双参会 `NoSuchMethodError`，
  教程踩过的坑），失败再回退标准 AOSP 双参重载
- 开关链路：`hook_doubletap_lock` → `persist.sys.onekey.doubletap_lock` /
  `flags.sh` 里的 `onekey_doubletap_lock`
- 作用域：LSPosed 需要勾选「华为桌面」。已在
  `/data/adb/lspd/config/modules_config.db` 的 `scope` 表补上
  `com.huawei.onekey.optimizer → com.huawei.android.launcher (user 0)`，
  改完 `am force-stop com.huawei.android.launcher` 再回桌面即可生效（无需重启整机）。

### 3. 验证
- LSPosed 日志（`/data/adb/lspd/log/modules_*.log`）：
  `(com.huawei.android.launcher) [OneKey][DblTap] 双击锁屏已挂载 → com.huawei.android.launcher.Workspace.onInterceptTouchEvent`
- 真机双击桌面空白处 → 立即熄屏 ✓
- App 新增「桌面手势」分组 + 「双击锁屏」MaterialCardView（`sw_doubletap`），
  `uiautomator dump` 里 `resource-id=.../id/sw_doubletap` `checked="true"`
- 版本 `1.0.8`（versionCode 9），模块 `versionCode=10008`，`common/apk.version=1.0.8`

### 4. 注意
- Hook 在**进程启动时**安装，切换开关后要 `am force-stop com.huawei.android.launcher`
  （或直接重启系统）才生效
- 若以后系统更新换了类名，日志会打 `未找到 com.huawei.android.launcher.Workspace`，
  改 `DoubleTapLockHooks.CLS_WORKSPACE` 常量即可，无需改逻辑
- 双击只认「点」：手指移动超过 touchSlop 就不算点击，滑动翻页不会误锁屏
## 十六、v1.0.9：屏幕休眠 20/30/60 分钟档位（Hook）

教程 `平板管家，系统设置/系统设置修改教程.txt` 的做法是反编译 `Settings.apk`，在
`HwTimeoutPreferenceController.setScreenTimeoutEntriesAndArrow()` 里把 LCD 分支的
7 项数组换成 10 项再重签名。这里同样只做 Hook：

- 目标：`com.android.settings`（`HwSettings 14.0.0.xxx`）的
  `com.android.settings.display.HwTimeoutPreferenceController#setScreenTimeoutEntriesAndArrow`
- 挂在 `afterHookedMethod`：读当前 `ListPreference` 的 `getEntries()/getEntryValues()`，
  保留前 6 项（15 秒 / 30 秒 / 1 / 2 / 5 / 10 分钟），插入 20 / 30 / 60 分钟三项，
  末项「永不」保留，再 `setEntries/setEntryValues` 写回
- 新条目文案由第 6 项「10 分钟」把数字 `10` 换成 `20/30/60` 推导，value 用
  `1200000 / 1800000 / 3600000` 毫秒；`values.length == 10` 时直接跳过防重复套娃
- 开关：`hook_screen_timeout` → `persist.sys.onekey.screen_timeout`；作用域勾选「系统设置」
- 真机日志：`[OneKey][Timeout] 已注入 10 档（15秒/30秒/1/2/5/10/20/30/60分钟/永不）`

## 十七、v1.0.10：桌面增强（按 `HwLauncherTweak` 源码移植）+ 高级设置二级界面

参照 `华为桌面/HwLauncherTweak.zip`（com.nma.hwlaunchertweak）的 Java 源码，把 10 项桌面
增强全部**用 Hook 重写**进本模块（`hook/launcher/` 包，TAG `HwLT`），不改系统 APK：

- 主页 2 项（默认开，参与「一键全开」）
  - **去除管控角标**：`BadgeUtils.getCloneOrTrustAppMark(ShortcutInfo)` 恒返回 `null`
  - **长按气泡「应用详情」**：借 `DropActionCommand$UninstallCommand` 造占位命令（`mAction=21`），
    按实例身份拦截 `doAction`，`initDropView`/`initActionView` 注入菜单项，
    点击后用 `TaskStackBuilder` 打开系统应用信息页（保证上滑能回桌面）
- 底部「高级设置」→ `AdvancedActivity`，8 项**默认关闭且不受主页一键全开影响**：
  新增布局 7×5/8×5、抽屉去应用建议、dock 自适应 11/8、竖屏保留右侧、无字模式、
  大文件夹服务卡片入口、布局去重、服务卡片标题无字
- 双轨开关：`Prefs.ALL_KEYS`（12 项，`setAll` 只改这些）与 `Prefs.ADV_KEYS`（8 个 `adv_*`），
  `adv_xxx` 的属性名去掉 `adv_` 前缀 → `persist.sys.onekey.xxx`
- 布局 Hook 的坑（照抄 `HwLauncherTweak` v1.2 的教训）：只在 getter 后追加会让界面出现 7×5/8×5
  但内部清单仍是 3 项，选中时 index 越界回退 6×4；必须同时补
  `Settings.sDesktopLayoutCells`、`Settings.sLayoutCellsBefore`、
  `DefaultLayoutCellsReader.mDesktopLayoutCells`，并把 `mCellNumY/mCellNumMaxY` 抬到 ≥5；
  追加项只放末尾（第一项决定 `favorites{列}x{行}` 数据表名），`7x6/8x6` 必须剔除

## 十八、v1.0.11：修复高级设置永远读 false + 移除自定义充电档位

### 1. 高级设置不生效（真机定位）

现象：高级设置里打开「新增布局 7×5/8×5」等，重启桌面后 `[HwLT] 桌面配置` 里仍是
`cells=false`，功能完全不生效。

根因：`HookFlags.fromXSharedPreferences()` 在 key 不存在时直接返回**默认值**（默认 false 是非 null），
于是 `read()` 认为「已读到」而不再走 `getprop` / `flags.sh` 这两个通道。主页那批开关默认 `true`
刚好和属性值碰巧一致，所以一直没暴露。

修复：调用 `XSharedPreferences.contains(key)` 判定，key 不存在时返回 `null` 继续往下读属性。
验证（重启桌面后）：

```
[HwLT] 桌面配置 cells=true dedupe=true drawer=false dock=true portrait=false notext=true cardFolder=true formTitle=false badge=true appDetails=true
[HwLT] DefaultLayoutCellsReader.mDesktopLayoutCells 补全: "6x4,6x5,5x5" -> "6x4,6x5,5x5,7x5,8x5"
[HwLT] mCellNumY 4 -> 5
[HwLT] getHotseatMaxIconNum@ProductivityDeviceResource: 9 -> 8（竖屏）
[HwLT] 无字模式：BubbleTextView.setDropedName 已恒置空文本
```

### 2. 移除「自定义充电 95% 档位」

放弃了这一项（UI 开关与 Hook 代码已删除，`hook_charge_limit` 键不再使用）。
失败原因记录在这里，避免以后重复踩：

- 目标类的字段/方法与本机版本一致（`a:int`、`b:HwSeekBar`、`e:TextView`、`h/i/k/onClick/onBindViewHolder`），
  `hookAllMethods` 命中数全是 1，`onClick` 也确实能拦到（日志 `点击 id=0x7f0a03c5`）
- 真正卡住的是 `HwSeekBar` 的**吸附步进**：`setProgress(12)` 会被吸到 `10`、`setProgress(25)` 吸到 `30`，
  也就是 `max=30` 时只有 0/10/20/30 四个刻度（70/80/90/100）
- 试过把 `max` 放大到 60 做 ×2 映射：布局还没完成时 `setProgress` 精确生效，一旦视图就绪
  吸附步进变成 `max/3 = 20`（实测 `5->0 10->20 25->20 30->40 50->60`），仍然只有 4 档，拿不到 95%
- `HwSeekBar` / `SeekBar` / `AbsSeekBar` 里没有任何 `*step*` 字段或方法，`setStepSize` 之类入口不存在，
  纯 Hook 无法改变吸附粒度 → 结论：要么改 APK（教程路线），要么不做


## 十九、v1.0.12：入口改名与分组微调

- 底部按钮「高级设置」→「桌面高级设置」，并从页面底部移到「系统应用增强」卡片**上方**
  （紧跟「桌面手势」卡片，进入路径更顺）
- 二级页标题同步改成「桌面高级设置」
- 二级页分组调整：「dock 自适应 11 / 8」从「桌面与抽屉」移到第一组「布局与网格」，
  现在第一组是：新增布局 7×5/8×5 → 布局去重 → dock 自适应 11/8
- 版本：APK `1.0.12`（versionCode 13），模块 `versionCode=10012`


## 二十、v1.0.13：状态栏时钟显示秒 + 作用域默认勾选修复

### 1. 新增「状态栏时钟显示秒」（Hook，不改 SystemUI）
源码来自 `状态栏秒数/classes_smali`（作者 com.Str9527.statusbarseconds 的 Xposed 模块），
逐个方法重写成 `hook/impl/StatusBarSecondsHooks.java`，只对 `com.android.systemui` 生效。
三条通道 + 一条校验：

| 通道 | 类 / 方法 | 做法 | 作用 |
|---|---|---|---|
| 主 | `TimeManagerImpl#formatAmAndPm(Context,long)` | after 里 `setResult(格式化字符串)` | 把 `HH:mm` 变成 `HH:mm:ss` |
| 刷新 | `TimeManagerImpl#updateNextData(long)` | before 里 `args[0] = 1000L` | 让 SystemUI 每秒刷新，**不做这步秒数不会跳** |
| 备用 | `HwNotchUtils#getDateTime(Context)` | after 里结果非 null 才覆盖 | 挖孔屏取时间的路径 |
| 校验 | `HwStatusBarClock#onTimeChange(long,String)` | after 里只检查文案含 `:` | 仅打异常日志，不影响功能 |

- 时间格式跟随系统：24 小时制 `HH:mm:ss`，12 小时制 `h:mm:ss a`（`DateFormat.is24HourFormat`）
- 三处各自 try/catch，任一失败只打日志，不影响其它两项（原 smali 只捕 ClassNotFoundError / NoSuchMethodError，这里放宽到 Throwable）
- 日志前缀 `[OneKey][Seconds]`，命中时输出：
  `已挂钩 TimeManagerImpl#formatAmAndPm(Context,long)` / `...updateNextData(long) → 1000ms` /
  `已挂钩 HwNotchUtils#getDateTime(Context)（备用通道）` / `状态栏秒数已启用`
- 开关：首页「系统应用增强」→「状态栏时钟显示秒」，`hook_status_seconds` / `persist.sys.onekey.status_seconds`，
  已加入 `ALL_KEYS`（参与「一键全开」）
- 编译注意：本工程用自建编译期桩（`app/stubs`），桩里**没有 `XposedHelpers`**，
  所以统一写成 `Class.forName(name,false,cl)` + `getDeclaredMethod` + `XposedBridge.hookMethod`，
  否则 `02_apk.sh` 会报 `cannot find symbol: XposedHelpers`

验证：`setprop persist.sys.onekey.status_seconds 1` → 重启 SystemUI → 状态栏显示 `HH:mm:ss` 并每秒跳动。

### 2. 修复 LSPosed 作用域「默认勾选不全」
现象：装完模块后 `com.huawei.android.launcher`（桌面）、`com.android.settings`（设置）没有自动勾选，要手动加。
根因：`AndroidManifest.xml` 里 `<meta-data name="xposedscope" resource="@array/xposed_scope"/>`，
而 `res/values/arrays.xml` 的 `xposed_scope` 只列了 5 个包 —— LSPosed 只把数组里的包当作推荐作用域，
数组里没有的包自然不会默认勾上。

修法：数组从 5 项补到 8 项
`android`、`com.android.packageinstaller`、`com.huawei.appmarket`、`com.huawei.android.thememanager`、
`com.huawei.systemmanager`、`com.huawei.android.launcher`、`com.android.settings`、`com.android.systemui`。

注意事项（重要）：
- LSPosed 只在**模块首次被识别/启用**时读这个数组填充 scope，改数组不会自动刷新已经存过的配置；
  升级后要重新启用模块（或卸载重装让 LSPosed 重建条目）才会按新数组勾选
- LSPosed 的配置在 `/data/adb/lspd/config/modules_config.db`：
  `modules_state(module_pkg_name,user_id,enabled,scope_request_blocked)` 控制启用，
  `scope(module_pkg_name,app_pkg_name,user_id)` 保存勾选项，系统框架记为 `system`（对应数组里的 `android`）
- 本次改完 db 后**必须重启整机**才生效（lspd 只在开机时读配置，kill 掉不会自启）

### 3. 版本
APK `1.0.13`（versionCode 14），模块 `version=v1.0.13` / `versionCode=10013`。
产物：`dist/HuaweiOneKeyOptimizer.apk`、`dist/HuaweiOneKeyOptimizer-Magisk-v1.0.13.zip`。

## 二十一、v1.0.14：无障碍授权弹窗免读秒

### 1. 现象
给应用开无障碍服务时，新版设置会弹「安全提醒」，要求先勾选
「我已知晓如上风险，并自愿承担可能导致的后果。(10 秒)」，并且「开启」按钮
要等 10 秒倒计时走完且已勾选才可点；旧版只弹一个确认框，点确定即可。

### 2. 定位（反编译 `平板管家，系统设置/设置`）
弹窗不是 AlertDialog，而是 `com.android.settings.accessibility` 里的自定义 Dialog：

| 位置 | 作用 |
|---|---|
| `AccessibilityServiceWarning.b(Context,AccessibilityServiceInfo,OnClickListener)` | 入口，转调 `AccessibilityDownloadServicesDialogActivity.k(...)` 后 `show()` |
| `AccessibilityDownloadServicesDialogActivity` | 弹窗本体，字段 `k`=勾选框、`p`=「开启」按钮、`q`=原始文案、`v`=倒计时是否完成 |
| `AccessibilityDownloadServicesDialogActivity$2` | `CountDownTimer(10000ms, 1000ms)`：`onTick` 每秒把「(N 秒)」写进勾选框文本，`onFinish` 收尾 |
| `AccessibilityDownloadServicesDialogActivity$3` | 勾选框点击：只有「已勾选 && v」才 `p.setEnabled(true)` |

### 3. 实现（`hook/impl/AccessibilitySkipHooks.java`，仅 `com.android.settings`）
- hook `android.app.Dialog#show()`，只处理 `AccessibilityDownloadServicesDialogActivity`：
  - `v` 置 true；勾选框 `k` 先 `setChecked(true)` 再整行 `GONE`（不再显示读秒文案）
  - 「开启」按钮 `p` 置 `setEnabled(true)`，并调用其私有 `l(true)` 把文字颜色刷成可用色
  - 给 `q` 兜底写一句「我已知晓如上风险…」，防止 `onFinish` 的 `split()` 空指针
- hook `$2#onTick(long)` 与 `$2#onFinish()`，都用 `setResult(null)` 跳过原实现
- 开关：首页「系统应用增强」→「跳过无障碍授权倒计时」，键 `hook_accessibility_skip` /
  `persist.sys.onekey.accessibility_skip`，**默认开启**，也参与「一键全开」

### 4. 踩坑记录（必看）
- 最初只跳过 `onTick` 不够：`q`（原始文案）只在 `onTick` 里赋值，10 秒后 `onFinish`
  执行 `q.split("\\(")` 直接 NPE，设置会**反复崩溃**（`logcat -b crash` 里能看到
  `NullPointerException ... AccessibilityDownloadServicesDialogActivity$2.onFinish`）。
  修法：`onFinish` 一并跳过 + 给 `q` 写兜底值（双保险）。
- 一开始想 hook 私有构造 `<init>(Context,int)`，真机报 `NoSuchMethodException`（版本差异），
  改用父类 `Dialog.show()` 做挂载点最稳，再用类名过滤。
- `show()` 时机下勾选框文案还没填（`setText` 拿到空串），所以不要自己拼文案，直接隐藏整行。

### 5. 版本
APK `1.0.14`（versionCode 15），模块 `version=v1.0.14` / `versionCode=10014`。
产物：`dist/HuaweiOneKeyOptimizer.apk`、`dist/HuaweiOneKeyOptimizer-Magisk-v1.0.14.zip`。

## 二十二、v1.0.15：状态栏秒数改成「长按切换」

### 1. 需求变更
v1.0.13 是「打开开关就一直显示秒」。现在改成：**默认不显示秒**，长按状态栏左侧时间 → 显示秒，
再长按 → 隐藏秒。App 里的开关语义变成「启用长按切换」开关（默认开）。

### 2. 关键发现
反编译 `状态栏秒数/classes2_smali` 后发现本机 SystemUI 的状态栏时钟是
`com.android.systemui.time.HwStatusBarClock`（父类 `TintTextView`），它自己不做格式化，
秒数完全靠 `TimeManagerImpl#formatAmAndPm(Context,long)` 产出的字符串（`onTimeChange(long,String)` 里直接 `setText`）。
同一份 smali 里的 AOSP `statusbar/policy/Clock` 原生支持 `clock_seconds`（TunerService）的 `mShowSeconds`，
但 HarmonyOS 状态栏用的是前者，所以还是走 `HwStatusBarClock` 这条路。

### 3. 实现（重写 `hook/impl/StatusBarSecondsHooks.java`）
- 状态：`static volatile boolean sShowSeconds = false` —— **默认关**
- `TimeManagerImpl#formatAmAndPm`：只有 `sShowSeconds` 为 true 才 `setResult("HH:mm:ss")`，否则原样返回（HH:mm）
- `HwNotchUtils#getDateTime`：同上，备用通道
- `HwStatusBarClock#onAttachedToWindow` after：给时钟 `setOnLongClickListener`，长按 → 切换状态 + 立刻刷新
- 秒刷新不再依赖系统：显示秒时自己用该 View 的 Handler 每 1000ms `postDelayed` 一次 `setText`；
  隐藏时 `removeCallbacks`，省电
- **删掉了 `updateNextData` 的 hook**：它会把系统整体的时间刷新节奏改成 1 秒，现在不需要了
- 长按加了 800ms 防抖：状态栏里会挂到 5 个时钟实例（状态栏/面板/锁屏等重叠），同一次长按会被触发两次

### 4. 真机验证（截图 + 日志）
```
重启 SystemUI 后：               状态栏 12:24        ← 无秒
长按左侧时间后：                 状态栏 12:24:41    ← 有秒且逐秒跳
再长按：                         状态栏 12:24        ← 秒消失
[OneKey][Seconds] 长按状态栏时间 → 显示秒数
[OneKey][Seconds] 长按状态栏时间 → 隐藏秒数
```

### 5. 版本
APK `1.0.15`（versionCode 16），模块 `version=v1.0.15` / `versionCode=10015`。
产物：`dist/HuaweiOneKeyOptimizer.apk`、`dist/HuaweiOneKeyOptimizer-Magisk-v1.0.15.zip`。

## 二十三、v1.0.16：修「下拉面板时间不跳秒」

### 1. 现象（用户反馈）
长按显示秒后，下拉状态栏展开，面板顶部的时间"不会变"（卡在展开那一刻的秒数）。

### 2. 原因
下拉面板/控制中心的时间不是 `HwStatusBarClock`，而是另一个类：
`com.android.systemui.statusbar.phone.HwStatusBarHeaderClock`（`extends TextView`）。
它的取时间方式也不一样：

```java
// onAttachedToWindow()
setText(HwNotchUtils.getDateTime(ctx));
registerTimeChangeCallback(this);

// onTimeChange(long, String) —— 注意：忽略传入的字符串，自己重新取 + setText(HwNotchUtils.getDateTime(ctx));
```

`HwNotchUtils.getDateTime` 被我们改成"显示秒时返回带秒"，但那两处调用只在
**attach 时**和**每分钟**发生一次 → 面板上的秒自然不动。

### 3. 修法
- 新增 `hookHeaderClock(cl)`：hook `HwStatusBarHeaderClock#onAttachedToWindow`，
  把它也 `track()` 进「每秒刷新列表」（不加重写长按，长按仍只归状态栏那个时钟）
- 抽出 `track(TextView)`：去重 + 清理已被 GC 的弱引用，避免每次 attach 都往列表里堆

### 4. 验证
| 状态 | 状态栏 | 下拉面板 |
|---|---|---|
| 显示秒（间隔 3 秒两次截图） | 12:41:12 → 12:41:15 | 12:41:12 → 12:41:15 |
| 长按关闭秒 | 12:41 | 12:41 |

日志：`已挂钩 HwStatusBarHeaderClock#onAttachedToWindow()` / `已接管下拉面板时钟的每秒刷新`

### 5. 版本
APK `1.0.16`（versionCode 17），模块 `v1.0.16` / `10016`。

## 二十四、v1.0.28：灵动岛（LiveIsland 整合版）

### 1. 位置与默认值
- App 里位于「**系统与体验**」分组下方（`系统与体验 → 全应用平行视界 / 全应用分身 → 灵动岛`）。
- **总开关默认开启**：SP 无值时 `Prefs.K_ISLAND` / `IslandPrefs.K_ENABLED` 都返回 `1`，
  `flags.default` 也写了 `onekey_hook_island=1`，刷完即生效，不用手动点。
- 总开关已加入 `ALL_KEYS`，因此「一键全部开启 / 全部关闭」会带着它一起动。

### 2. 即时生效
开关写 SP + `persist.sys.onekey.*` + `flags.sh` 后，会向 `com.android.systemui` 发
`com.huawei.onekey.optimizer.ISLAND_PREFS_CHANGED` 广播，岛上立刻 reload，**不需要重启 SystemUI**。

```bash
setprop persist.sys.onekey.hook_island 0   # 关
am broadcast -a com.huawei.onekey.optimizer.ISLAND_PREFS_CHANGED -p com.android.systemui
```

### 3. 两个自检入口
- **预览灵动岛**：推一条模拟外卖实况（`...hook.island.DEMO`），回桌面能看到胶囊即正常。
- **重启系统界面**：升级模块后只杀 `com.android.systemui`，不重启整机。

### 4. 作用域
LSPosed 里必须勾 `com.android.systemui`；要导航/秒表上岛再勾 `百度地图` / `高德地图` / `华为时钟`。

### 5. 版本
APK `1.0.28`（versionCode 29），模块 `v1.0.28` / `10028`。
产物：`dist/HuaweiOneKeyOptimizer.apk`、`dist/HuaweiOneKeyOptimizer-Magisk-v1.0.28.zip`。

## 二十五、v1.0.29：控制中心音量条（CCVolume 整合版）

### 1. 功能
控制中心里，亮度条下方多出一根**音量条**：拖动直接改媒体音量（STREAM_MUSIC），
图标随音量档位在「静音 / 低 / 中 / 高」之间切换；音量被其它应用改掉时，
滑块与图标会跟着同步（动态注册 `VOLUME_CHANGED_ACTION`）。

App 里「系统应用增强 → 控制中心音量条」一个开关控制，默认开启。
**开关是在 SystemUI 启动时读取的，切完请点灵动岛卡片里的「重启 SystemUI」**（或重启整机）。

### 2. 实现方式
- 原模块（`com.harmony.ccvolume`）是独立 Xposed 模块 + 独立 App。这里把它整份 smali
  内置到 `thirdparty/ccvolume/`，`01_smali.sh` 在构建时把包名重定向到
  `com.huawei.onekey.optimizer.hook.ccvolume`，再和安装器净化一起汇编进 `classes2.dex`。
- 它不重画音量控件，而是 hook `com.huawei.controlcenter.qs.ControlCenterQs`：
  用 SystemUI 自己的 `hw_status_bar_toggle_slider` 布局克隆一行，插到亮度行下面，
  再用 `ToggleSlider` 的 `onPanelUiModeChanged` 跟着面板折叠/展开显隐。
- 开关来源改成 `HookFlags.enabled("hook_ccvolume", true)`（原来是查它自己 App 的
  `content://com.harmony.ccvolume.config/enabled`），三通道与其它开关一致；
  属性名 `persist.sys.onekey.ccvolume`，也对应 `flags.sh` 里的 `onekey_ccvolume`。
- 原来从自己 App 的 `R$drawable` 取 4 个音量图标和音量条底色；整合后这些资源放在
  本 App 的 `res/drawable/`（`cc_ic_volume_mute/low/medium/high`、`cc_mirror_bg`），
  smali 改为调用 `CcVolumeRes` 在运行时按名字解析资源 ID，避免写死 R 常量。

### 3. 实测（MatePad 11 / HarmonyOS 4.2）
```
CCVolume: slider look copied / left slot synced, w=70 marginStart=45
CCVolume: mirror row aligned / volume mirror ready
CCVolume: volume row installed, rowHeight=80
CCVolume: icon tint applied=99000000
```
`uiautomator dump` 里能看到两根 SeekBar（亮度 + 音量，y=871..951 / 951..1031）；
点击音量条左侧 → 音量 1→0，点右侧 → 0、15，说明真的在控媒体音量。
把开关属性置 0 重启 SystemUI 后只剩 1 根 SeekBar，开关有效。

### 4. 说明
- 设备上如果还装着原来的 `com.harmony.ccvolume`，请到 LSPosed 里把它停用，
  否则两套 hook 会同时往控制中心插行。
- 音量条跟随的是「媒体音量」；通话音量/铃声仍走系统音量键的默认流。
- 产物：`dist/HuaweiOneKeyOptimizer-Magisk-v1.0.29.zip`（APK `1.0.29` / `versionCode 30`，
  模块 `v1.0.29` / `10029`）。

## 二十六、v1.0.30：把 smali 全部收进仓库（可独立开源构建）

### 1. 问题
`build/01_smali.sh` 原来的 theme / mxx 两段是从仓库外的
`../matepad11-resources-master/modules/...` 拷贝再改包名的。那个目录一旦缺失
（换电脑、clone 到别处、开源时忘带），构建不会报错，但 `classes2.dex` 里
只会有安装器净化 + 音量条，`hook.theme.*` / `hook.mxx.*` 悄悄消失 ——
Java 版（`ThemeHooks` / `MxxHooks`）还能跑，smali 兜底就没了。

### 2. 做法
从 `v1.0.28` 的 `classes4.dex` 里反编译出已经改好包名的那几个类，直接入库：

```
thirdparty/theme/classes_smali/com/huawei/onekey/optimizer/hook/theme/
    ThemeHook.smali  ThemeHook$1.smali  ThemeHook$2.smali
thirdparty/mxx/classes_smali/com/huawei/onekey/optimizer/hook/mxx/
    MxxHook.smali    MxxHook$1.smali
```

`01_smali.sh` 相应改成「本地 cp」，不再依赖 `$SRC_MOD`；构建日志会打印
`copied 3 (thirdparty/theme…)` / `copied 2 (thirdparty/mxx…)`。
现在四套 smali 全部自包含：

| 目录 | 内容 |
| --- | --- |
| `thirdparty/pi-cleaner` | 安装器净化（PI-Cleaner 1.0.1，55 个类）|
| `thirdparty/theme` | 主题破解 smali 兜底（3 个类）|
| `thirdparty/mxx` | 应用跳转/系统限制解锁 smali 兜底（2 个类）|
| `thirdparty/ccvolume` | 控制中心音量条（11 个类）|

校验：`baksmali list classes classes4.dex` 里应能看到
`hook/pi/HookEntry`、`hook/theme/ThemeHook`、`hook/mxx/MxxHook`、`hook/ccvolume/HookEntry` 四组。

### 3. 产物
`dist/HuaweiOneKeyOptimizer-Magisk-v1.0.30.zip`（APK `1.0.30` / `versionCode 31`）。

## 二十七、跨设备兼容（为开源做的加固）

原来的脚本相当一部分是按 MatePad 11 / HarmonyOS 4.2 写的硬编码，换台机器
就会「能装但没效果」。这一版把判断都改成探测式，任何一项找不到只跳过自己，
不影响其它功能：

1. **smali 自包含**：见第二十六章，clone 下来就能编。
2. **构建环境探测**（`02_apk.sh`）：`ANDROID_SDK` / `BUILD_TOOLS` / `ANDROID_JAR`
   都可用环境变量覆盖；`android.jar` 取 `platforms/android-*` 最新一版，
   `build-tools` 取最新一版；`aapt2` / `zipalign` 先找 PATH 再回退 build-tools；
   缺东西时明确提示缺什么，而不是让 aapt2 报一行看不懂的错。
3. **白名单路径探测**（`apply.sh` + `customize.sh`）：
   平行视界会依次试 `hw_product` / `product` 分区的 `region_comm/{china,oversea}`
   以及 `system/emui/base/xml`、`system/etc`；分身白名单同理。
   刷入时直接告诉用户「命中的是哪个文件」，没命中就说明该开关在本机无效。
4. **应用列表来源回退**（`apply.sh`）：优先 `/data/system/packages.list`，
   没有就 `/data/system/users/0/packages.list`，再没有就用 `pm list packages -3`；
   拿不到就跳过对应功能并写日志。
5. **华为专有属性**：`hw_mc.freeform.max_num` / `ro.config.hide_meminfo`
   写完后回读一次，读不到就记「本机没有该属性（非华为设备），已跳过」，
   避免用户以为开关坏了。
6. **日志可诊断**：每次 apply 都会写一行
   `设备: brand=… model=… sdk=…  packages=…` 和
   `目标文件: 平行视界=… 分身白名单=…`，别人反馈问题时贴日志即可定位。
7. **Hook 入口按包名分流**：`HookEntry` 只在
   `com.android.packageinstaller` / `android` / `com.android.settings` /
   `com.android.systemui` / 华为桌面·主题·时钟·地图包 里安装 hook，
   其它品牌设备上这些包不存在 → 整段自然跳过；`MxxHooks` 还会先探测
   `com.android.server.mxx.*` 是否存在，不存在就一行日志退出（HarmonyOS 4 已移除）。

### 已知边界
- 非华为设备上「平行视界 / 应用分身 / 小窗数量 / 内存显示 / 主题破解 / 安装器净化」
  这几项本质依赖华为系统组件，装了也不会有行为变化（会写日志说明）。
- 华为设备上的「桌面增强 / 模糊 / 灵动岛 / 状态栏秒数 / 双击锁屏 / 音量条」
  依赖具体类名与方法名，EMUI/HarmonyOS 大版本升级后可能全部对不上
  —— 每个模块都会在日志里打印 `hooked=… missed=…`，对不上就是那一项静默失效，不会崩系统。

## 二十八、v1.0.31 ~ v1.0.33：主题试用深度解锁（不改主题 APK）

### 1. 出发点

`v1.0.1` 时代的主题解锁只有两段：system_server 的 `HwThemeManager` 校验放行，以及
`TryOutTimeFenceService` / `PayedManagerServiceImpl` / `TrialBackInfo` 三个类「所有 boolean 方法返回 true」。
实际用起来的体感是：试用按钮能点，但

- 到期照样把主题还原回去（回滚执行体没被拦住，`releaseTryOutTheme()Z` 返回 true 只是让上层以为成功）；
- 通知栏一直挂一条「正在试用」；
- 预览页底部「剩余时间：mm:ss」照跳；
- 正在试用主题时不能再试用字体，反之亦然；
- 部分主题按钮点下去提示「时间未设置为自动」而不给试用。

这一版按真机 `com.huawei.android.thememanager 12.0.44.300` 的 smali 逐点定位后重写，
**全部是运行期 hook，不修改、不重打包主题 APK**，并且统一收在**一个开关**（`hook_theme`）之下。

### 2. 逆向结论与对应处理

| 需求 | 真实实现（12.0.44.300） | 本模块处理 |
|---|---|---|
| 试用总开关 | `qy9.g1()` 读 `client_support_tryout_theme`；`qy9.e1()` 读 `client_support_tryout_font` | 两者 hook 为 `true`（候选类名表 `qy9/qp9/qq9`，方法名 `g1/e1`） |
| 永久试用（到期不回滚） | `tryout.TryOutTimeFenceService`：AwarenessKit 时间围栏 → 服务 → `timeFenceIsArrived / showProgressAndReleaseTheme / releaseTryOutTheme*` | 按语义逐个废：`void` → 空实现、`boolean` → `false`、`onStartCommand` → `START_NOT_STICKY`；`releaseTryOut*` 前缀全覆盖 |
| 不显示「正在试用」通知 | 同服务的 `showNotification / clearTryoutNotification` + 进程内 `NotificationManager.notify` | 方法空实现 + `notify` 里按 channel / tag / extras / 文案含 `tryout`·`试用`·`trial` 丢弃（下载进度等其它通知不受影响） |
| 所有主题强制显示试用入口 | Activity 字段 `isEnableTryout` + 信息面板 `mInfoWraper.Q(ZZ)V`（两者都 true 才 VISIBLE） | 预览页刷新方法执行后用反射置 `isEnableTryout=true`，并以 `(true,true)` 调 `Q`；字体侧直接改 `setTryOutButtonVisibility(show, enable)` 入参 |
| 解除「同时只能试用一个」互斥 | `LocalThemePreviewActivity.hadTryoutFont()`、`BaseOnlineFontPreviewActivity.hadTryoutTheme()`、`OnlineWallpaperPreviewActivity.showWarnTryoutApplyThemeDialog()` | 全部返回 `false` |
| 「时间未自动设置」也允许试用 | `OnlineThemePreviewActivity.isTimeAutoSettingsOpen()` | 返回 `true` |
| 底部倒计时不再显示 | `widget.bottomcomponent.BottomComponentFlotView.G(J)V` 每秒拼 `show_remaining_time`（"剩余时间：%1$s"）后 `setText` | **不按混淆名 hook**：拦本进程 `TextView.setText(CharSequence)`，命中「剩余时间 / 试用到期时间」→ 置空 + 控件 `GONE`（父容器只有「图标+该文案」时连父容器一起隐藏） |

### 3. 工程取舍

- **单一开关**：`HookEntry` 只判断 `HookFlags.enabled(HookFlags.K_THEME)`；
  关掉它，system_server 侧与主题商店侧的 hook 全部不安装，日志会打一行「开关关闭」。
- **不赌混淆名**：`qy9 / tw6 / G(J) / a(J) / b()` 这类名字只当候选与兜底，
  真正的行为锁定用「字段名 + 方法签名」或不依赖类名的 `TextView.setText` 过滤，
  版本一变也不会整段失效；候选没命中时日志会明确提示。
- **逐项独立**：每段 hook 都单独 try/catch 并统计条数，一项对不上不影响其它项。
- **删掉旧实现**：原来的「三各类 boolean 全 true」的暴力逻辑、以及 smali 版 `ThemeHook` 回退分支都已移除，
  避免「两套逻辑互相打架」和 `releaseTryOutTheme()` 被强制返回 true 的副作用。

### 4. 真机验证日志

```
[OneKey][Theme] thememanager: enable=2 service=13 notify=2 preview=10 countdown=1
[OneKey][Theme] 已隐藏倒计时文案[4]: 剩余时间：00: 57
[OneKey][Theme] 已隐藏倒计时文案[5]: 剩余时间：00: 56
```

- `enable=2`：`g1` / `e1` 都命中；
- `service=13`：到期执行体废掉 13 个入口；
- `notify=2`：`NotificationManager.notify` 两个重载都拦上；
- `preview=10`：预览页常显 + 字体/壁纸互斥；
- `countdown=1`：`TextView.setText` 过滤生效（随后两行就是被拦下来的现场记录）。

`uiautomator dump` 复核：界面上已搜不到任何「剩余时间」节点，底部栏只剩「<主题名>：试用中」和「立即购买」。

### 5. 版本

APK `1.0.33`（versionCode 34），模块 `v1.0.33` / `10034`。
产物：`dist/HuaweiOneKeyOptimizer.apk`、`dist/HuaweiOneKeyOptimizer-Magisk-v1.0.33.zip`。

## 二十九、已知限制

1. 所有「解锁」都是**客户端侧**行为：服务端下发的试用次数、资源本身是否免费、账号权益等不受影响，
   试用次数用尽后仍需购买。
2. 主题商店若大版本升级（例如 13.x），混淆名会变：`g1/e1` 需要更新候选表；
   `countdown`（`TextView.setText` 过滤）与 Activity 侧字段反射通常仍然有效。
3. 到期执行体被拦住后，本地数据库里的试用到期时间仍然存在：
   部分入口可能显示「试用已结束」文案，但主题不会被还原，也不会再有通知与倒计时。
4. `HookEntry` 只在 `com.android.packageinstaller` / `android` / `com.android.settings` /
   `com.android.systemui` / 华为桌面·主题·时钟·地图包里安装 hook，其它包不注入。
5. 系统层开关（平行视界 / 分身 / 小窗 / 内存）改动后建议点 App 里的「重启系统」，
   因为对应属性与 XML 只在目标进程启动时读一次。

## 三十、开源说明

### 1. 许可证

本项目以 **MIT License** 发布，见仓库根目录 `LICENSE`。

### 2. 仓库里有什么 / 没有什么

- **有**：控制 App 的全部 Java 源码、hook 实现、构建脚本（`build/*.sh`）、模块脚本（`build/module/`）、
  上游 Xposed 模块的 smali 源码（`thirdparty/`，已改统一包名，可独立构建）。
- **没有**：任何华为官方 APK / dex / 资源 / 私有配置文件。所有功能都是**运行时注入**，
  不需要、也不包含被修改的系统应用；`dist/` 与 `onekey.jks` 已在 `.gitignore` 中排除。

### 3. 免责声明

- 本项目仅供**个人学习研究与自用**，请在下载后 24 小时内自行删除；
- 使用 Root / Xposed 类工具修改系统行为存在**变砖、数据丢失、保修失效**的风险，一切后果由使用者自行承担；
- 请勿将本项目用于商业用途、二次售卖或任何侵犯第三方权益的场景；
- 主题、字体、壁纸等资源的版权归原作者与华为所有，**喜欢请购买正版**，本项目不提供任何绕过付费获取资源的途径，
  仅作用于客户端侧的试用判定逻辑；
- 本项目与华为技术有限公司无任何关联，未获其授权或背书。

### 4. 致谢（上游模块作者）

| 来源 | 用途 |
|---|---|
| PI-Cleaner 1.0.1 | 安装器净化的 10 项能力（`thirdparty/pi-cleaner`） |
| MatePad 主题破解模块 | 主题解锁的初始思路与 smali 兜底（`thirdparty/theme`） |
| MxxHook / 应用跳转解锁 | 系统限制解锁（`thirdparty/mxx`） |
| HarmonyOS-FreeformUnlock | 小窗数量 / 内存显示两条属性 |
| CCVolume | 控制中心音量条（`thirdparty/ccvolume`） |
| LiveIsland | 灵动岛的交互与动画参考 |
| HwLauncherTweak | 桌面增强 8 项的实现参考 |
| LSPosed / Magisk / APatch | 运行与刷入环境 |

### 5. 反馈与贡献

提交 issue 时请附上：

1. 机型 + 系统版本（`getprop ro.product.model` / `ro.build.display.id`）；
2. 模块版本（App 内显示或 `cat /data/adb/modules/huawei_onekey/module.prop`）；
3. LSPosed 日志里带 `OneKey` 的片段：`grep -a OneKey /data/adb/lspd/log/verbose_*.log | tail -50`；
4. 系统层功能出问题时附 `/data/adb/huawei_onekey/apply.log`。

提交 PR 时请在说明里写清：hook 的**目标类 + 方法签名**、**真机验证方式（日志/截图）**，
以及「对不上时是否安全跳过」——本仓库的硬性约定是**任何一项 hook 失败都不能影响其它功能与系统稳定性**。