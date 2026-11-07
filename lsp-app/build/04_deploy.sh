#!/system/bin/sh
# 04_deploy.sh —— 以 root 身份把模块文件直接放到 /data/adb/modules 下做本地实测（等同刷入后状态）
set -x
ROOT=$(cd "$(dirname "$0")/.." && pwd)
SRC=$ROOT/build/module_out
DST=/data/adb/modules/huawei_onekey

rm -rf "$DST"
mkdir -p "$DST"
cp -r "$SRC"/. "$DST"/
chmod 0755 "$DST" "$DST/common" "$DST/META-INF" "$DST/META-INF/com" \
    "$DST/META-INF/com/google" "$DST/META-INF/com/google/android"
chmod 0755 "$DST/common/watch.sh" "$DST/customize.sh" "$DST/service.sh" "$DST/post-fs-data.sh" \
    "$DST/uninstall.sh" "$DST/common/apply.sh" "$DST/META-INF/com/google/android/update-binary"
chmod 0644 "$DST/module.prop" "$DST/common/flags.default" "$DST/common/apk.version" \
    "$DST/onekey.apk" "$DST/META-INF/com/google/android/updater-script"

sh "$DST/post-fs-data.sh"
sh "$DST/common/apply.sh"

# 启动常驻守护（模拟 service.sh 的开机行为）
( sh "$DST/common/watch.sh" >/dev/null 2>&1 & )
sleep 1

echo "===== apply.log ====="
cat /data/adb/huawei_onekey/apply.log
echo "===== mounts ====="
grep -E 'magic_window|hw_clone' /proc/mounts
echo "===== generated pw head ====="
head -12 /data/adb/huawei_onekey/magic_window_generated.xml
echo "===== generated pw tail ====="
tail -6 /data/adb/huawei_onekey/magic_window_generated.xml
echo "===== clone head ====="
head -6 /data/adb/huawei_onekey/auto_clone_list.xml
echo "===== props ====="
getprop | grep onekey