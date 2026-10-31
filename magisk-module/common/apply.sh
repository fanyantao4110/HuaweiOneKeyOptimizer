#!/system/bin/sh
# apply.sh —— 系统层开关执行器
#
# 用法：
#   sh apply.sh           正常模式：按当前 /data/system/packages.list 重新生成并挂载
#   sh apply.sh early     开机早期模式（post-fs-data 调用）：直接挂载上一次生成的缓存，
#                         必须在 system_server 读取 magic_window 配置**之前**完成，
#                         否则平行视界要等到下次重启才生效。
#
# 关闭 = 把首次运行备份的原厂文件重新 bind 回去（比 umount 稳，避免 EBUSY）。

MODDIR=${MODDIR:-/data/adb/modules/huawei_onekey}
DATA=/data/adb/huawei_onekey
FLAGS=$DATA/flags.sh
LOG=$DATA/apply.log

PW_TARGET=/hw_product/region_comm/china/xml/magic_window_application_list.xml
PW_ORIG=$DATA/orig_magic_window.xml
PW_GEN=$DATA/magic_window_generated.xml

CL_TARGET=/system/emui/base/xml/hw_clone_app_list.xml
CL_ORIG=$DATA/orig_clone_app_list.xml
CL_GEN=$DATA/auto_clone_list.xml

PKG_LIST=/data/system/packages.list
GAME_KW="tencent\.game|tencent\.tmgp|com\.netease\.|miHoYo|hypergryph|bilibili\.game|game\.|games\.|king\.|supercell|playrix|gameloft|genshin|arknights|bluearchive"

MODE=${1:-normal}

log() {
    echo "[$(date '+%m-%d %H:%M:%S')] $*" >> "$LOG"
}

# 用 $1 覆盖挂载到 $2；先尝试卸载旧层，失败也没关系（bind 会叠到最上层），
# 挂载后用 cmp 校验内容，最多重试 3 次。
rebind() {
    _src=$1
    _dst=$2
    chmod 0644 "$_src" 2>/dev/null
    chown 0:0 "$_src" 2>/dev/null
    chcon u:object_r:system_file:s0 "$_src" 2>/dev/null
    _try=0
    while [ $_try -lt 3 ]; do
        umount "$_dst" 2>/dev/null || umount -l "$_dst" 2>/dev/null
        mount -o bind "$_src" "$_dst" 2>>"$LOG"
        if cmp -s "$_src" "$_dst" 2>/dev/null; then
            return 0
        fi
        _try=$((_try + 1))
        sleep 1
    done
    log "挂载校验失败: $_dst"
    return 1
}

# 首次运行时备份原厂文件（备份前先卸载我们自己的层）
save_orig() {
    _target=$1
    _orig=$2
    if [ ! -f "$_orig" ]; then
        umount "$_target" 2>/dev/null || umount -l "$_target" 2>/dev/null
        if cp -f "$_target" "$_orig" 2>/dev/null; then
            log "已备份原厂文件: $(basename "$_target")"
        else
            log "备份失败: $_target"
        fi
    fi
}

# 让 com.huawei.systemmanager 重新读取 <AppClone> 白名单。
#
# 注意：在 HarmonyOS 上 am 偶尔会打印
#   cmd: Failure calling service activity: Failed transaction (2147483646)
# 这是 root 的 am 客户端与 system_server 之间的 binder 事务瞬时失败
# （生成 1.2 MB XML + bind mount 之后 system_server 正忙，或目标进程正好在重启），
# **只影响「立即刷新白名单」这一步**：bind mount 已经完成，配置已经是新的，
# 系统管理器下次启动（或重启整机）就会读到新白名单，其它功能完全不受影响。
# 所以这里做「重试 + PID 校验」：成功就静默，真失败也只输出一句人话。
restart_sysmanager() {
    _pkg=com.huawei.systemmanager
    _i=0
    _after=""
    while [ $_i -lt 3 ]; do
        _before=$(pidof "$_pkg" 2>/dev/null | awk '{print $1}')
        am force-stop "$_pkg" >/dev/null 2>&1
        sleep 2
        _after=$(pidof "$_pkg" 2>/dev/null | awk '{print $1}')
        if [ -z "$_after" ]; then
            log "应用分身：$_pkg 已停止，下次启动即读取新白名单"
            return 0
        fi
        if [ "$_before" != "$_after" ]; then
            log "应用分身：$_pkg 已重启（PID $_before -> $_after），白名单立即生效"
            return 0
        fi
        _i=$((_i + 1))
    done
    log "应用分身：$_pkg 暂未重启成功（PID $_after 未变），白名单会在它下次启动或重启整机后生效；挂载本身已完成，其它功能不受影响"
    return 0
}

mkdir -p "$DATA"
[ -f "$FLAGS" ] || cp -f "$MODDIR/common/flags.default" "$FLAGS"
. "$FLAGS" 2>/dev/null
onekey_parallel=${onekey_parallel:-1}
onekey_clone=${onekey_clone:-1}
onekey_freeform=${onekey_freeform:-1}
onekey_meminfo=${onekey_meminfo:-1}

log "===== apply 开始 (mode=$MODE parallel=$onekey_parallel clone=$onekey_clone freeform=$onekey_freeform meminfo=$onekey_meminfo) ====="

if [ "$MODE" != "early" ]; then
    i=0
    while [ ! -f "$PKG_LIST" ] && [ $i -lt 60 ]; do
        sleep 1
        i=$((i + 1))
    done
fi

########## 1. 全应用平行视界 ##########
if [ -f "$PW_TARGET" ]; then
    save_orig "$PW_TARGET" "$PW_ORIG"
    if [ "$onekey_parallel" = "1" ]; then
        if [ "$MODE" = "early" ]; then
            # 早期模式：直接用上次生成的缓存，抢在 system_server 读配置之前挂上
            if [ -f "$PW_GEN" ]; then
                rebind "$PW_GEN" "$PW_TARGET" && log "平行视界：early 挂载缓存完成"
            else
                log "平行视界：early 模式无缓存，跳过（本次开机后点一次应用即可生成）"
            fi
        elif [ -f "$PKG_LIST" ] && [ -f "$PW_ORIG" ]; then
            EXISTING=$(grep -o 'name="[^"]*"' "$PW_ORIG" | sed 's/name="//;s/"//')
            USER_PKGS=$(awk '!/@system/ {print $1}' "$PKG_LIST" | sort -u | grep -viE "$GAME_KW")
            ROOT_CLOSE=$(tail -n 1 "$PW_ORIG" | tr -d '\r')
            case "$ROOT_CLOSE" in
                '</'*'>')
                    sed '$d' "$PW_ORIG" > "$PW_GEN"
                    ;;
                *)
                    ROOT_CLOSE='</package_config>'
                    cp -f "$PW_ORIG" "$PW_GEN"
                    log "未识别根闭合标签，按默认 </package_config> 处理"
                    ;;
            esac
            n=0
            for pkg in $USER_PKGS; do
                if echo "$EXISTING" | grep -qx "$pkg"; then
                    continue
                fi
                cat >> "$PW_GEN" <<EOF
    <package
        window_mode="1001"
        support_multi_resume="true"
        support_fullscreen_video="true"
        support_camera_preview="true"
        is_scaled="false"
        need_relaunch="false"
        default_setting="false"
        is_dragable="true"
        notch_adapt="false"
        drag_to_fullscreen="true"
        support_lock="true"
        home=""
        name="$pkg"/>
EOF
                n=$((n + 1))
            done
            echo "$ROOT_CLOSE" >> "$PW_GEN"
            rebind "$PW_GEN" "$PW_TARGET"
            log "平行视界：新增适配 $n 个应用（重启后对整个桌面生效）"
        else
            log "平行视界：缺少 packages.list 或原厂备份，跳过"
        fi
    else
        if [ -f "$PW_ORIG" ]; then
            rebind "$PW_ORIG" "$PW_TARGET"
            log "平行视界：已关闭（原厂文件已重新挂载）"
        fi
    fi
else
    log "平行视界：原厂配置不存在，跳过"
fi

########## 2. 全应用分身 ##########
if [ -f "$CL_TARGET" ]; then
    save_orig "$CL_TARGET" "$CL_ORIG"
    if [ "$onekey_clone" = "1" ]; then
        if [ "$MODE" = "early" ]; then
            if [ -f "$CL_GEN" ]; then
                rebind "$CL_GEN" "$CL_TARGET" && log "应用分身：early 挂载缓存完成"
            fi
        elif [ -f "$PKG_LIST" ]; then
            {
                echo '<?xml version="1.0" encoding="UTF-8"?>'
                echo '<AppClone>'
                awk '!/@system/ {print "    <package name=\"" $1 "\" />"}' "$PKG_LIST"
                echo '</AppClone>'
            } > "$CL_GEN"
            rebind "$CL_GEN" "$CL_TARGET"
            log "应用分身：白名单已生成"
        fi
    else
        if [ -f "$CL_ORIG" ]; then
            rebind "$CL_ORIG" "$CL_TARGET"
            log "应用分身：已关闭（原厂白名单已重新挂载）"
        fi
    fi
    if [ "$MODE" != "early" ]; then
        sleep 1
        restart_sysmanager
    fi
else
    log "应用分身：原厂配置不存在，跳过"
fi

########## 3. 自由窗口 / 多任务内存显示（系统属性） ##########
# 这两个开关改的是系统属性而不是文件，所以：
#   开启 -> resetprop 写入目标值
#   关闭 -> 自由窗口用 resetprop -d 删除；内存显示写回 true（=隐藏）
# 注意：APatch 的 resetprop 在 /data/adb/ap/bin 下，本机 PATH 里没有，必须显式找路径。
RP=""
for _c in /data/adb/ap/bin/resetprop /data/adb/magisk/resetprop /data/adb/ksu/bin/resetprop /system/bin/resetprop; do
    if [ -x "$_c" ]; then
        RP=$_c
        break
    fi
done
if [ -z "$RP" ]; then
    _w=$(command -v resetprop 2>/dev/null)
    [ -n "$_w" ] && RP=$_w
fi

if [ -n "$RP" ]; then
    if [ "$onekey_freeform" = "1" ]; then
        "$RP" -n hw_mc.freeform.max_num 64 >/dev/null 2>&1 \
            && log "小窗数量解锁：hw_mc.freeform.max_num=64（当前 $(getprop hw_mc.freeform.max_num)）"
    else
        "$RP" -d hw_mc.freeform.max_num >/dev/null 2>&1
        log "小窗数量解锁：已关闭（属性已删除，当前 '$(getprop hw_mc.freeform.max_num)'）"
    fi
    if [ "$onekey_meminfo" = "1" ]; then
        "$RP" -n ro.config.hide_meminfo false >/dev/null 2>&1 \
            && log "多任务内存显示：ro.config.hide_meminfo=false"
    else
        "$RP" -n ro.config.hide_meminfo true >/dev/null 2>&1 \
            && log "多任务内存显示：已关闭（hide_meminfo=true）"
    fi
else
    log "自由窗口/内存显示：未找到 resetprop，跳过（$RP）"
fi

log "===== apply 结束 ====="
echo "APPLY_DONE"