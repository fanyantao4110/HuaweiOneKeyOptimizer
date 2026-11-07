# magisk-module —— 刷入用的 Magisk / APatch 模块

只有**脚本与配置**，不含预编译 APK：`onekey.apk` 由 `lsp-app/build/03_module.sh` 打包时现场合入。
独立刷入时若目录里没有 `onekey.apk`，模块仍会生效（系统层功能可用），但没有控制 App。

## 文件

| 文件 | 作用 |
|---|---|
| `module.prop` | 模块 id / 版本 / 作者（`version` 与 `versionCode` 打包时跟随 APK 自动同步） |
| `customize.sh` | 刷入阶段：把 `onekey.apk` 复制到 `/data/local/tmp` 再 `pm install -r -g -d`（`pm` 由 system_server 执行，读不到 `/data/adb`），失败则留待开机补装 |
| `post-fs-data.sh` | 开机 `system_server` 启动**之前**用上次生成的缓存 bind mount 平行视界 XML，避免"改了要等下一次重启" |
| `service.sh` | 开机 `late_start`：按最新 `packages.list` 重生成 XML 供下次开机组装；对比版本号补装/升级 APK；启动 `watch.sh` |
| `uninstall.sh` | 卸载时把原厂文件 bind 回去并清理 `/data/adb/huawei_onekey` |
| `common/apply.sh` | 系统层开关的全部动作：平行视界 / 应用分身 / 小窗数量 / 多任务内存显示 |
| `common/watch.sh` | 在**全局命名空间**里执行 `apply.request`（APatch 下 App 的 `su` 在独立 mount namespace，直接 mount 系统进程看不见） |
| `common/flags.default` | 默认开关（刷完即生效） |
| `META-INF/` | 刷入器入口（`update-binary` / `updater-script`） |

## 开关与文件

| 开关 | 动作 | 关闭 |
|---|---|---|
| 全应用平行视界 | 生成 `magic_window_application_list.xml`（`window_mode="1001"`）→ bind mount | 原厂文件 bind 回去 |
| 全应用分身 | 生成 `hw_clone_app_list.xml` → bind mount + 重启 `com.huawei.systemmanager` | 同上 |
| 小窗数量解锁 | `resetprop -n hw_mc.freeform.max_num 64` | `resetprop -d`（**不能置 0**，否则系统认为最多 0 个小窗） |
| 多任务显示内存 | `resetprop -n ro.config.hide_meminfo false` | 写回 `true` |

## 自检

```sh
cat /data/adb/modules/huawei_onekey/module.prop
sh /data/adb/modules/huawei_onekey/common/apply.sh          # 手动执行一次
grep -E 'magic_window|hw_clone' /proc/mounts                # 挂载是否生效
getprop persist.sys.onekey.theme                             # 开关值
ls /data/adb/huawei_onekey/                                  # flags.sh / apply.log / orig_*.xml
```

> 备份文件 `/data/adb/huawei_onekey/orig_*.xml` **不要删**，否则「关闭」无法还原原厂配置。
