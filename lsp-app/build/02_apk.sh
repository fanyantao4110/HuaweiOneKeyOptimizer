#!/bin/sh
# 02_apk.sh —— 资源编译 + javac + d8 + 合并 classes2.dex + 对齐签名
set -u

ROOT=$(cd "$(dirname "$0")/.." && pwd)
APP=$ROOT/app
BUILD=$ROOT/build
DIST=$ROOT/dist
SDK=${ANDROID_SDK:-/root/android-sdk}

# android.jar：取 platforms 下最新一版（默认 android-34）
AJ=${ANDROID_JAR:-}
if [ -z "$AJ" ]; then
    for _a in "$SDK"/platforms/android-*/android.jar; do
        [ -f "$_a" ] && AJ=$_a
    done
fi

# build-tools：未显式指定时取 sdk 下最新一版
BT=${BUILD_TOOLS:-}
if [ -z "$BT" ]; then
    for _b in "$SDK"/build-tools/*/; do
        [ -d "$_b" ] && BT=${_b%/}
    done
fi

# aapt2 / zipalign：优先用命令行里的（Linux 发行版 / Ubuntu proot 一般都装了），
# 找不到再回退到 build-tools，方便别人在 macOS / 别的 Linux 上构建。
pick_tool() {
    if command -v "$1" >/dev/null 2>&1; then
        command -v "$1"
    else
        echo "${BT:-/nonexistent}/$1"
    fi
}
AAPT2=$(pick_tool aapt2)
ZIPALIGN=$(pick_tool zipalign)
D8JAR=${BT:-/nonexistent}/lib/d8.jar
SIGNJAR=${BT:-/nonexistent}/lib/apksigner.jar

MISS=""
[ -n "$AJ" ] && [ -f "$AJ" ] || MISS="$MISS android.jar"
[ -f "$D8JAR" ] || MISS="$MISS d8.jar"
[ -f "$SIGNJAR" ] || MISS="$MISS apksigner.jar"
[ -x "$AAPT2" ] || MISS="$MISS aapt2"
[ -x "$ZIPALIGN" ] || MISS="$MISS zipalign"
if [ -n "$MISS" ]; then
    echo "缺少构建依赖:$MISS"
    echo "  - Android SDK 用环境变量 ANDROID_SDK 指定（默认 /root/android-sdk）"
    echo "  - build-tools 用 BUILD_TOOLS 指定（默认自动取 \$ANDROID_SDK/build-tools 下最新一版）"
    echo "  - aapt2 / zipalign 不在 build-tools 里时请装到 PATH（Ubuntu: apt install aapt zipalign）"
    exit 1
fi
echo "== 构建环境 =="
echo "  SDK=$SDK"
echo "  android.jar=$AJ"
echo "  build-tools=${BT:-<PATH 自带>}"
echo "  aapt2=$AAPT2"
echo "  zipalign=$ZIPALIGN"

mkdir -p "$BUILD/res" "$BUILD/gen" "$BUILD/classes" "$BUILD/dex1" "$BUILD/pkg" "$DIST"
rm -rf "$BUILD/res" "$BUILD/gen" "$BUILD/classes" "$BUILD/dex1" "$BUILD/pkg"
mkdir -p "$BUILD/res" "$BUILD/gen" "$BUILD/classes" "$BUILD/dex1" "$BUILD/pkg"

echo "== aapt2 compile =="
"$AAPT2" compile --dir "$APP/res" -o "$BUILD/res/resources.zip" || exit 1

# ===== 依赖库资源（Material Components + androidx，来自 aar_resolve.py）=====
if [ ! -f "$BUILD/libs.txt" ]; then
    echo "缺少 build/libs.txt，请先运行: python3 build/aar_resolve.py"
    exit 1
fi
echo "== aapt2 compile libs =="
rm -rf "$BUILD/res_lib"
mkdir -p "$BUILD/res_lib"
i=0
while read -r r; do
    [ -d "$r" ] || continue
    i=$((i + 1))
    "$AAPT2" compile --dir "$r" -o "$BUILD/res_lib/lib$i.zip" || exit 1
done < "$BUILD/aarres.txt"
echo "  lib res: $i 个"

RFLAGS=""
for z in "$BUILD"/res_lib/lib*.zip; do
    [ -f "$z" ] || continue
    RFLAGS="$RFLAGS -R $z"
done
EXTRAPKG=""
while read -r p; do
    [ -n "$p" ] && EXTRAPKG="$EXTRAPKG:$p"
done < "$BUILD/rpackages.txt"
EXTRAPKG=${EXTRAPKG#:}

echo "== aapt2 link =="
"$AAPT2" link \
    -I "$AJ" \
    --manifest "$APP/AndroidManifest.xml" \
    -R "$BUILD/res/resources.zip" \
    $RFLAGS \
    --extra-packages "$EXTRAPKG" \
    -A "$APP/assets" \
    --java "$BUILD/gen" \
    --min-sdk-version 26 \
    --target-sdk-version 33 \
    --auto-add-overlay \
    -o "$BUILD/base.apk" || exit 1
echo "== javac =="
CP="$AJ"
while read -r j; do
    [ -n "$j" ] && CP="$CP:$j"
done < "$BUILD/libs.txt"
find "$APP/java" "$BUILD/gen" "$APP/stubs" -name '*.java' > "$BUILD/sources.txt"
javac -encoding UTF-8 -nowarn -source 8 -target 8 -bootclasspath "$AJ" -cp "$CP" \
    -d "$BUILD/classes" @"$BUILD/sources.txt" || exit 1

echo "== d8 =="
# 关键：Xposed API 桩类绝对不能打进 dex（否则 LSPosed 会拒绝加载：Cannot load module）
# 依赖库的 classes.jar 必须一起 dex 进来（Material / androidx 会随 APK 分发）
{
    find "$BUILD/classes" -name '*.class' | grep -v '/de/robv/android/xposed/'
    cat "$BUILD/libs.txt"
    [ -f "$BUILD/dex2/classes2.dex" ] && echo "$BUILD/dex2/classes2.dex"
} > "$BUILD/d8inputs.txt"
echo "  输入条目: $(wc -l < "$BUILD/d8inputs.txt")"
java -Xmx2g -cp "$D8JAR" com.android.tools.r8.D8 --min-api 26 --lib "$AJ" \
    --output "$BUILD/dex1" @"$BUILD/d8inputs.txt" || exit 1
ls -l "$BUILD/dex1"

echo "== package =="
rm -f "$BUILD"/pkg/*.dex
for d in "$BUILD"/dex1/classes*.dex; do
    cp "$d" "$BUILD/pkg/" || exit 1
done
ls -l "$BUILD/pkg"
cp "$BUILD/base.apk" "$BUILD/unsigned.apk"
(cd "$BUILD/pkg" && zip -q -X -9 "$BUILD/unsigned.apk" classes*.dex) || exit 1

echo "== zipalign =="
"$ZIPALIGN" -f -p 4 "$BUILD/unsigned.apk" "$BUILD/aligned.apk" || exit 1

echo "== keystore =="
KS=$ROOT/onekey.jks
if [ ! -f "$KS" ]; then
    keytool -genkeypair -keystore "$KS" -alias onekey -storepass onekey123 \
        -keypass onekey123 -keyalg RSA -keysize 2048 -validity 10000 \
        -dname "CN=OneKey, OU=Dev, O=HuaweiOneKey, L=NA, ST=NA, C=CN" >/dev/null 2>&1 || exit 1
fi

echo "== sign =="
java -jar "$SIGNJAR" sign --ks "$KS" --ks-pass pass:onekey123 --key-pass pass:onekey123 \
    --min-sdk-version 26 \
    --out "$DIST/HuaweiOneKeyOptimizer.apk" "$BUILD/aligned.apk" || exit 1
java -jar "$SIGNJAR" verify --print-certs "$DIST/HuaweiOneKeyOptimizer.apk" | head -5
ls -l "$DIST/HuaweiOneKeyOptimizer.apk"