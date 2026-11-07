#!/system/bin/sh
# uninstall.sh —— 卸载模块时清理：卸载 bind mount、删配置、清系统属性
umount /hw_product/region_comm/china/xml/magic_window_application_list.xml 2>/dev/null
umount /system/emui/base/xml/hw_clone_app_list.xml 2>/dev/null

rm -rf /data/adb/huawei_onekey

for p in installer theme mxx parallel clone; do
    resetprop --delete "persist.sys.onekey.$p" 2>/dev/null
done