#!/bin/sh
# 01_smali.sh —— 把三个原始 Xposed 模块的 smali 迁移到统一包名，并汇编成 classes2.dex
set -u
ROOT=$(cd "$(dirname "$0")/.." && pwd)
# 三个上游模块的 smali 已全部内置到 thirdparty/（pi-cleaner / theme / mxx / ccvolume），
# 构建不再依赖仓库外的任何目录。

# 安装器净化：原作者 1.0.1（PI-Cleaner）全功能 smali，已内置到 thirdparty/pi-cleaner
SRC_PI="$ROOT/thirdparty/pi-cleaner/classes_smali/com/hook/packageinstaller"
BUILD=$ROOT/build
STAGE=$BUILD/smali/com/huawei/onekey/optimizer/hook

rm -rf "$BUILD/smali" "$BUILD/dex2"
mkdir -p "$STAGE/pi" "$STAGE/theme" "$STAGE/mxx" "$BUILD/dex2"

echo "== installer (安装器净化 · PI-Cleaner 1.0.1 全功能整合) =="
n=0
for f in $(find "$SRC_PI" -name '*.smali' | sort); do
    rel=${f#"$SRC_PI"/}
    d=$(dirname "$rel")
    mkdir -p "$STAGE/pi/$d"
    sed -e 's|com/hook/packageinstaller|com/huawei/onekey/optimizer/hook/pi|g' \
        -e 's|com\.hook\.packageinstaller|com.huawei.onekey.optimizer.hook.pi|g' \
        "$f" > "$STAGE/pi/$rel"
    n=$((n + 1))
done
echo "  copied $n (pi包名已重定向到 hook.pi)"

# ===== 关键修复：作者 profile 里的 "defpackage.xx" 类名是 jadx 对「默认包」的臆造包名 =====
# 系统安装器被 ProGuard -repackageclasses '' 重打包后，这些类的真实名字就是 cv / dd / ek ...
# （dex 里只有 "Lcv;"，根本没有 defpackage）。原作者按 jadx 输出写成 "defpackage.cv"，
# 于是 SafeXposed.classExists 全部失败 → ProfileResolver 只能回退 GenericProfile
# （一张全 null 的映射表）→ 10 项 hook 一个都装不上（logcat 里 profile=PI_GENERIC），
# 这就是「装了模块还是照样查验」的根本原因。这里统一去掉前缀，让类名与真机一致。
sed -i 's/defpackage\.//g' "$STAGE"/pi/profiles/*.smali
echo "  patched profiles: 已去掉 defpackage. 前缀（真机为默认包类名）"

echo "== ccvolume (控制中心音量条) =="
SRC_CC="$ROOT/thirdparty/ccvolume/classes_smali/com/harmony/ccvolume"
mkdir -p "$STAGE/cvolume"
n=0
for f in "$SRC_CC"/*.smali; do
    b=$(basename "$f")
    sed -e 's|com/harmony/ccvolume|com/huawei/onekey/optimizer/hook/ccvolume|g' \
        -e 's|com\.harmony\.ccvolume|com.huawei.onekey.optimizer|g' \
        "$f" > "$STAGE/cvolume/$b"
    n=$((n + 1))
done
echo "  copied $n (ccvolume包名已重定向到 hook.ccvolume)"
# 说明：原作者靠自己的 App 提供 content://com.harmony.ccvolume.config/enabled 开关，
# 这里已经改成 HookFlags.enabled("hook_ccvolume")；四个音量图标 + 音量条背景
# 也从原 App 的 R$drawable 换成 CcVolumeRes 运行时按名字取本模块资源。

# 下面 theme / mxx 的 smali 已经以「迁移后包名」的形式内置在 thirdparty/ 里，
# 不再依赖任何外部模块目录（开源后单独 clone 本仓库即可完整构建）。
echo "== theme (主题破解) =="
SRC_TH="$ROOT/thirdparty/theme/classes_smali/com/huawei/onekey/optimizer/hook/theme"
n=0
for f in "$SRC_TH"/*.smali; do
    b=$(basename "$f")
    cp "$f" "$STAGE/theme/$b"
    n=$((n + 1))
done
echo "  copied $n (thirdparty/theme，包名已是 hook.theme)"

echo "== mxx (跳转解锁) =="
SRC_MXX="$ROOT/thirdparty/mxx/classes_smali/com/huawei/onekey/optimizer/hook/mxx"
n=0
for f in "$SRC_MXX"/*.smali; do
    b=$(basename "$f")
    cp "$f" "$STAGE/mxx/$b"
    n=$((n + 1))
done
echo "  copied $n (thirdparty/mxx，包名已是 hook.mxx)"

echo "== assemble =="
smali assemble "$BUILD/smali" -o "$BUILD/dex2/classes2.dex" || exit 1
ls -l "$BUILD/dex2/classes2.dex"
echo "== 旧包名残留检查（应为空） =="
strings "$BUILD/dex2/classes2.dex" | grep -E 'com/(muxmu|matepad|workbuddy)' || echo "  clean"