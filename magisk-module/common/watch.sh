#!/system/bin/sh
# watch.sh —— 常驻守护：让 App 的「立即生效」能在**全局挂载命名空间**里执行。
# 背景：某些 Root 管理器给 App 的 su 会话分配了独立的 mount namespace，
# 直接在里面 mount 不会影响系统进程看到的文件；而本脚本由 service.sh 在
# 开机时启动，处于全局命名空间，因此它做的 bind mount 才能被系统读到。

DATA=/data/adb/huawei_onekey
MODDIR=${MODDIR:-/data/adb/modules/huawei_onekey}
REQ=$DATA/apply.request
DONE=$DATA/apply.done

mkdir -p "$DATA"
echo $$ > "$DATA/watch.pid"

while true; do
    if [ -f "$REQ" ]; then
        rm -f "$REQ"
        rm -f "$DONE"
        sh "$MODDIR/common/apply.sh" >> "$DATA/apply.log" 2>&1
        date +%s > "$DONE"
    fi
    sleep 2
done