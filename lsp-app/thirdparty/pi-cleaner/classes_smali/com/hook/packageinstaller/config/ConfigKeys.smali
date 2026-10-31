.class public final Lcom/hook/packageinstaller/config/ConfigKeys;
.super Ljava/lang/Object;
.source "ConfigKeys.java"


# static fields
.field public static final ACTION_RELOAD_INSTALLER:Ljava/lang/String; = "com.hook.packageinstaller.action.RELOAD_INSTALLER"

.field public static final AD_CLEAN:Ljava/lang/String; = "ad_clean"

.field public static final ALL:[Ljava/lang/String;

.field public static final ANONYMOUS_SOURCE_BYPASS:Ljava/lang/String; = "anonymous_source_bypass"

.field public static final AUTHORITY:Ljava/lang/String; = "com.hook.packageinstaller.config"

.field public static final AUTH_BYPASS:Ljava/lang/String; = "auth_bypass"

.field public static final HIDE_LAUNCHER_ICON:Ljava/lang/String; = "hide_launcher_icon"

.field public static final METHOD_GET:Ljava/lang/String; = "get_config"

.field public static final MODULE_PACKAGE:Ljava/lang/String; = "com.hook.packageinstaller"

.field public static final ORIENTATION_LOCK_FIX:Ljava/lang/String; = "orientation_lock_fix"

.field public static final PREFS:Ljava/lang/String; = "config"

.field public static final PROMO_UI_CLEAN:Ljava/lang/String; = "promo_ui_clean"

.field public static final PURE_MODE_BYPASS:Ljava/lang/String; = "pure_mode_bypass"

.field public static final RISK_BYPASS:Ljava/lang/String; = "risk_bypass"

.field public static final RISK_UI_CLEAN:Ljava/lang/String; = "risk_ui_clean"

.field public static final STORE_CLEAN:Ljava/lang/String; = "store_clean"

.field public static final UNKNOWN_SOURCE_BYPASS:Ljava/lang/String; = "unknown_source_bypass"


# direct methods
.method static constructor <clinit>()V
    .registers 3

    const/16 v0, 0xa

    .line 24
    new-array v0, v0, [Ljava/lang/String;

    const/4 v1, 0x0

    const-string v2, "ad_clean"

    aput-object v2, v0, v1

    const/4 v1, 0x1

    const-string v2, "store_clean"

    aput-object v2, v0, v1

    const/4 v1, 0x2

    const-string v2, "auth_bypass"

    aput-object v2, v0, v1

    const/4 v1, 0x3

    const-string v2, "risk_bypass"

    aput-object v2, v0, v1

    const/4 v1, 0x4

    const-string v2, "risk_ui_clean"

    aput-object v2, v0, v1

    const/4 v1, 0x5

    const-string v2, "pure_mode_bypass"

    aput-object v2, v0, v1

    const/4 v1, 0x6

    const-string v2, "unknown_source_bypass"

    aput-object v2, v0, v1

    const/4 v1, 0x7

    const-string v2, "anonymous_source_bypass"

    aput-object v2, v0, v1

    const/16 v1, 0x8

    const-string v2, "promo_ui_clean"

    aput-object v2, v0, v1

    const/16 v1, 0x9

    const-string v2, "orientation_lock_fix"

    aput-object v2, v0, v1

    sput-object v0, Lcom/hook/packageinstaller/config/ConfigKeys;->ALL:[Ljava/lang/String;

    return-void
.end method

.method private constructor <init>()V
    .registers 1

    .line 37
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method
