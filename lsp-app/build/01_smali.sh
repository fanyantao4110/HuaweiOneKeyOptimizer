#!/bin/sh
# 01_smali.sh —— 把三个原始 Xposed 模块的 smali 迁移到统一包名，并汇编成 classes2.dex
set -u

ROOT=$(cd "$(dirname "$0")/.." && pwd)
SRC_MOD=${SRC_MOD:-$(cd "$ROOT/.." && pwd)/matepad11-resources-master/modules}
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

echo "== theme (主题破解) =="
n=0
for f in "$SRC_MOD/MatePad 主题破解/classes_smali/com/matepad/themecrack/"*.smali; do
    b=$(basename "$f")
    if [ "$b" = "MainActivity.smali" ]; then
        echo "  skip $b (UI 由新工程提供)"
        continue
    fi
    sed -e 's|com/matepad/themecrack|com/huawei/onekey/optimizer/hook/theme|g' \
        -e 's|com\.matepad\.themecrack|com.huawei.onekey.optimizer|g' \
        -e 's|MainHook|ThemeHook|g' \
        "$f" > "$STAGE/theme/$b"
    n=$((n + 1))
done
echo "  copied $n"

echo "== mxx (跳转解锁) =="
n=0
for f in "$SRC_MOD/play商店应用跳转解锁/classes_smali/com/workbuddy/mxxhook/"*.smali; do
    b=$(basename "$f")
    if [ "$b" = "InfoActivity.smali" ]; then
        echo "  skip $b (原模块说明页，已废弃)"
        continue
    fi
    sed -e 's|com/workbuddy/mxxhook|com/huawei/onekey/optimizer/hook/mxx|g' \
        -e 's|com\.workbuddy\.mxxhook|com.huawei.onekey.optimizer|g' \
        "$f" > "$STAGE/mxx/$b"
    n=$((n + 1))
done
echo "  copied $n"

echo "== assemble =="
smali assemble "$BUILD/smali" -o "$BUILD/dex2/classes2.dex" || exit 1
ls -l "$BUILD/dex2/classes2.dex"
echo "== 旧包名残留检查（应为空） =="
strings "$BUILD/dex2/classes2.dex" | grep -E 'com/(muxmu|matepad|workbuddy)' || echo "  clean"