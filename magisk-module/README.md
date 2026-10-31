# magisk-module —— Magisk 模块源代码

刷入包（Releases 里的 `HuaweiOneKeyOptimizer-Magisk-vX.Y.Z.zip`）= 本目录 + `onekey.apk`（构建时由 `lsp-app/build/03_module.sh` 塞进根目录）。

## 文件说明

| 文件 | 作用 |
|---|---|
| `module.prop` | 模块信息（id：`huawei_onekey`） |
| `customize.sh` | 刷入时执行：设置权限、从 `onekey.apk` 里取版本号、写入 `common/apk.version` |
| `post-fs-data.sh` | 开机最早阶段（`post-fs-data`）执行：调用 `common/apply.sh` 写入只读属性 / flags |
| `service.sh` | 开机完成（`late_start service`）执行：复查属性、启动 `common/watch.sh` 守护 |
| `uninstall.sh` | 卸载时清理残留（属性、临时文件） |
| `common/apply.sh` | 核心：读取 `/data/adb/huawei_onekey/flags`（由 App 写入）→ `resetprop` 写 `persist.sys.*`、`ro.config.*`、平行视界/分身/小窗/内存显示等 |
| `common/watch.sh` | 守护进程：持续监听 flags 变化并重新应用；同时保证 App 进程可按需拉起 |
| `common/flags.default` | flags 默认值（全关） |
| `META-INF/` | Magisk 安装器入口（`update-binary` / `updater-script`） |

## flags 约定

`/data/adb/huawei_onekey/flags` 每行 `key=1|0`，键名与 App 里 `core/Prefs.java` 的 `K_*` 常量一一对应：

```
installer=1      # 安装器净化（Hook 侧读取，仅落盘）
theme=1          # 主题解锁
mxx=1            # 系统限制解锁
parallel=1       # 全应用平行视界
clone=1          # 全应用分身
freeform=1       # 小窗数量解锁
meminfo=1        # 多任务显示内存
```

改完 flags 后执行 `su -c sh /data/adb/modules/huawei_onekey/common/apply.sh` 即可立即应用（App 的「应用并立即生效」按钮就是干这个）。

## 单独打包（不经过完整 App 构建）

```bash
cd magisk-module
# 需要先把打好签名的 apk 放进来
cp /path/to/HuaweiOneKeyOptimizer.apk ./onekey.apk
zip -q -r -9 ../HuaweiOneKeyOptimizer-Magisk-custom.zip . -x 'onekey.apk'
zip -q -9 ../HuaweiOneKeyOptimizer-Magisk-custom.zip onekey.apk
```

> 注意：`customize.sh` 会 `chmod 0755` 若干脚本，打包时保持 `update-binary` / `*.sh` 的可执行权限更稳妥（或由 Magisk 安装时自动修正）。
