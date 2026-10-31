#!/system/bin/sh
# customize.sh —— 刷入时执行（Magisk 原生安装器 / 通用安装器都会调用）

# 通用安装器（如 APatch）可能不提供这些函数，这里做兜底
command -v ui_print >/dev/null 2>&1 || ui_print() { echo "$1"; }
command -v set_perm >/dev/null 2>&1 || set_perm() { chown "$2:$3" "$4" 2>/dev/null; chmod "$5" "$4" 2>/dev/null; }
command -v set_perm_recursive >/dev/null 2>&1 || set_perm_recursive() {
    chown -R "$2:$3" "$1" 2>/dev/null
    chmod -R "$5" "$1" 2>/dev/null
    find "$1" -type d -exec chmod "$4" {} \; 2>/dev/null
}
ARCH=${ARCH:-$(getprop ro.product.cpu.abi)}
API=${API:-$(getprop ro.build.version.sdk)}

ui_print "********************************************"
ui_print "  华为一键优化（MatePad 11 整合版）"
ui_print "  安装器净化 / 主题解锁 / 系统限制解锁"
ui_print "  全应用平行视界 / 全应用分身"
ui_print "  小窗数量解锁 / 多任务内存显示"
ui_print "********************************************"
ui_print "- 设备架构: $ARCH  API: $API"

PW_XML=/hw_product/region_comm/china/xml/magic_window_application_list.xml
CL_XML=/system/emui/base/xml/hw_clone_app_list.xml

if [ -f "$PW_XML" ]; then
    ui_print "✓ 平行视界配置存在"
else
    ui_print "! 未找到 $PW_XML（平行视界开关将无效）"
fi

if [ -f "$CL_XML" ]; then
    ui_print "✓ 应用分身白名单存在"
else
    ui_print "! 未找到 $CL_XML（分身开关将无效）"
fi

ui_print "- 设置文件权限"
set_perm_recursive "$MODPATH" 0 0 0755 0644
set_perm "$MODPATH/service.sh" 0 0 0755
set_perm "$MODPATH/post-fs-data.sh" 0 0 0755
set_perm_recursive "$MODPATH/common" 0 0 0755 0755

ui_print "- 初始化开关配置目录"
mkdir -p /data/adb/huawei_onekey
chmod 0755 /data/adb/huawei_onekey
if [ ! -f /data/adb/huawei_onekey/flags.sh ]; then
    cp -f "$MODPATH/common/flags.default" /data/adb/huawei_onekey/flags.sh
fi
chmod 0644 /data/adb/huawei_onekey/flags.sh

ui_print "- 清理旧日志"
rm -f /data/adb/huawei_onekey/apply.log

# ===== 刷入时就安装控制 App（不用等到重启）=====
# 关键：pm 由 system_server 执行，它读不到 /data/adb 下的文件（会报 Can't open file），
# 所以先复制到 /data/local/tmp（shell_data_file，安装器可读）再 pm install。
ui_print "- 安装控制 App"
if [ ! -f "$MODPATH/onekey.apk" ]; then
    ui_print "! 模块内缺少 onekey.apk，开机后 service.sh 会自动补装"
elif ! command -v pm >/dev/null 2>&1; then
    ui_print "! 当前环境没有 pm（像是在 recovery 里刷入），开机后 service.sh 会自动补装"
else
    TMPAPK=/data/local/tmp/onekey_install.apk
    if cp -f "$MODPATH/onekey.apk" "$TMPAPK" 2>/dev/null; then
        chmod 0644 "$TMPAPK" 2>/dev/null
        restorecon "$TMPAPK" 2>/dev/null
        OUT=$(pm install -r -g -d "$TMPAPK" 2>&1)
        rm -f "$TMPAPK"
        if echo "$OUT" | grep -qi 'Success'; then
            ui_print "✓ 控制 App 已安装，刷完打开「华为一键优化」即可"
        else
            ui_print "! 控制 App 安装失败：$(echo "$OUT" | tr '\n' ' ' | cut -c1-100)"
            ui_print "  开机后 service.sh 会再试一次；也可手动安装 $MODPATH/onekey.apk"
        fi
    else
        ui_print "! 无法写入 /data/local/tmp，开机后 service.sh 会自动补装"
    fi
fi

ui_print "✓ 模块安装完成"
ui_print "- 控制 App 随模块一起安装（失败则开机后自动补装，也可手动装 onekey.apk）"
ui_print "- 首次打开 App 请允许 Root 权限，LSPosed 中启用本模块并勾选："
ui_print "  系统框架 / 软件包安装程序 / 华为主题 / 华为应用市场"