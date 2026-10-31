#!/bin/sh
# 03_module.sh —— 打包 Magisk 模块 zip（内置控制 APK）
set -u

ROOT=$(cd "$(dirname "$0")/.." && pwd)
MODSRC=$ROOT/build/module
OUT=$ROOT/build/module_out
DIST=$ROOT/dist
APK=$DIST/HuaweiOneKeyOptimizer.apk
VER=$(/usr/bin/aapt dump badging "$APK" 2>/dev/null | sed -n "s/.*versionName='\([^']*\)'.*/\1/p" | head -1)
[ -n "$VER" ] || VER=1.0.0

rm -rf "$OUT"
mkdir -p "$OUT"
cp -r "$MODSRC"/* "$OUT"/
cp "$APK" "$OUT/onekey.apk"
echo "$VER" > "$OUT/common/apk.version"

# 权限：脚本 0755，其它 0644
find "$OUT" -type d -exec chmod 0755 {} \;
find "$OUT" -type f -exec chmod 0644 {} \;
chmod 0755 "$OUT/customize.sh" "$OUT/service.sh" "$OUT/post-fs-data.sh" \
    "$OUT/uninstall.sh" "$OUT/META-INF/com/google/android/update-binary" \
    "$OUT/common/apply.sh" "$OUT/common/watch.sh"

rm -f "$DIST/HuaweiOneKeyOptimizer-Magisk-v$VER.zip"
(cd "$OUT" && zip -q -r -9 "$DIST/HuaweiOneKeyOptimizer-Magisk-v$VER.zip" .)
echo "APK version: $VER"
unzip -l "$DIST/HuaweiOneKeyOptimizer-Magisk-v$VER.zip" | tail -18
ls -l "$DIST"