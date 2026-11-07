#!/system/bin/sh
# service.sh —— 开机完成（late_start service）后：安装/升级控制 App，并应用系统层开关
MODDIR=${0%/*}
DATA=/data/adb/huawei_onekey
LOG=$DATA/apply.log
APK=$MODDIR/onekey.apk
PKG=com.huawei.onekey.optimizer

mkdir -p "$DATA"

i=0
while [ "$(getprop sys.boot_completed)" != "1" ] && [ $i -lt 300 ]; do
    sleep 2
    i=$((i + 2))
done
sleep 5

WANT=$(cat "$MODDIR/common/apk.version" 2>/dev/null)
if [ -f "$APK" ] && [ -n "$WANT" ]; then
    HAVE=$(dumpsys package "$PKG" 2>/dev/null | grep -m1 versionName | sed 's/.*=//')
    if [ "$HAVE" != "$WANT" ]; then
        echo "[$(date '+%m-%d %H:%M:%S')] 补装控制 App: have=$HAVE want=$WANT" >> "$LOG"
        # pm 由 system_server 执行，读不到 /data/adb 下的文件，先搬到 /data/local/tmp
        TMPAPK=/data/local/tmp/onekey_install.apk
        if cp -f "$APK" "$TMPAPK" 2>/dev/null; then
            chmod 0644 "$TMPAPK" 2>/dev/null
            restorecon "$TMPAPK" 2>/dev/null
            pm install -r -g -d "$TMPAPK" >> "$LOG" 2>&1
            rm -f "$TMPAPK"
            sleep 3
        else
            echo "[$(date '+%m-%d %H:%M:%S')] 无法写入 /data/local/tmp，跳过补装" >> "$LOG"
        fi
    fi
fi

export MODDIR
sh "$MODDIR/common/apply.sh" >> "$LOG" 2>&1

# 启动常驻守护：App 的「立即生效」通过 apply.request 交给它，在全局命名空间内执行
if [ -f "$MODDIR/common/watch.sh" ]; then
    ( sh "$MODDIR/common/watch.sh" >/dev/null 2>&1 & )
fi