#!/system/bin/sh
# post-fs-data.sh —— 开机极早期（system_server 启动前）
#
# 1) 保证 flags.sh 存在，并把开关同步到 persist.sys.onekey.*
# 2) 用「上次生成的 XML 缓存」提前 bind mount 两份系统配置。
#    平行视界配置只在开机时被 framework 读取，晚于 system_server 启动再挂载，
#    要等到下次重启才生效 —— 所以必须放在这里先挂上。
MODDIR=${0%/*}
FLAGS=/data/adb/huawei_onekey/flags.sh

mkdir -p /data/adb/huawei_onekey
[ -f "$FLAGS" ] || cp -f "$MODDIR/common/flags.default" "$FLAGS"
chmod 0644 "$FLAGS"

. "$FLAGS" 2>/dev/null
onekey_installer=${onekey_installer:-1}
onekey_theme=${onekey_theme:-1}
onekey_mxx=${onekey_mxx:-1}
onekey_parallel=${onekey_parallel:-1}
onekey_clone=${onekey_clone:-1}
onekey_freeform=${onekey_freeform:-1}
onekey_meminfo=${onekey_meminfo:-1}

setprop persist.sys.onekey.installer "$onekey_installer"
setprop persist.sys.onekey.theme "$onekey_theme"
setprop persist.sys.onekey.mxx "$onekey_mxx"
setprop persist.sys.onekey.parallel "$onekey_parallel"
setprop persist.sys.onekey.clone "$onekey_clone"
setprop persist.sys.onekey.freeform "$onekey_freeform"
setprop persist.sys.onekey.meminfo "$onekey_meminfo"

if [ "$onekey_parallel" = "1" ] || [ "$onekey_clone" = "1" ] \
    || [ "$onekey_freeform" = "1" ] || [ "$onekey_meminfo" = "1" ]; then
    MODDIR="$MODDIR" sh "$MODDIR/common/apply.sh" early
fi