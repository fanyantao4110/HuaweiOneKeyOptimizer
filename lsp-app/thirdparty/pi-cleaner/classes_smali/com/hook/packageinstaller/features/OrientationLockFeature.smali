.class public final Lcom/hook/packageinstaller/features/OrientationLockFeature;
.super Ljava/lang/Object;
.source "OrientationLockFeature.java"

# interfaces
.implements Lcom/hook/packageinstaller/features/Feature;


# static fields
.field private static final TAG:Ljava/lang/String; = "PI-Cleaner/Orientation"


# direct methods
.method static bridge synthetic -$$Nest$smisRotationLocked(Landroid/content/Context;)Z
    .registers 1

    invoke-static {p0}, Lcom/hook/packageinstaller/features/OrientationLockFeature;->isRotationLocked(Landroid/content/Context;)Z

    move-result p0

    return p0
.end method

.method public constructor <init>()V
    .registers 1

    .line 23
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static isRotationLocked(Landroid/content/Context;)Z
    .registers 4

    const/4 v0, 0x0

    .line 66
    :try_start_1
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object p0

    .line 67
    const-string v1, "accelerometer_rotation"

    const/4 v2, 0x1

    invoke-static {p0, v1, v2}, Landroid/provider/Settings$System;->getInt(Landroid/content/ContentResolver;Ljava/lang/String;I)I

    move-result p0
    :try_end_c
    .catchall {:try_start_1 .. :try_end_c} :catchall_f

    if-nez p0, :cond_f

    move v0, v2

    :catchall_f
    :cond_f
    return v0
.end method


# virtual methods
.method public id()Ljava/lang/String;
    .registers 1

    .line 28
    const-string p0, "orientation_lock_fix"

    return-object p0
.end method

.method public install(Lcom/hook/packageinstaller/core/HookContext;)V
    .registers 6

    .line 34
    :try_start_0
    const-class v0, Landroid/app/Activity;

    const-string v1, "setRequestedOrientation"

    sget-object v2, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    new-instance v3, Lcom/hook/packageinstaller/features/OrientationLockFeature$1;

    invoke-direct {v3, p0, p1}, Lcom/hook/packageinstaller/features/OrientationLockFeature$1;-><init>(Lcom/hook/packageinstaller/features/OrientationLockFeature;Lcom/hook/packageinstaller/core/HookContext;)V

    filled-new-array {v2, v3}, [Ljava/lang/Object;

    move-result-object p0

    invoke-static {v0, v1, p0}, Lde/robv/android/xposed/XposedHelpers;->findAndHookMethod(Ljava/lang/Class;Ljava/lang/String;[Ljava/lang/Object;)Lde/robv/android/xposed/XC_MethodHook$Unhook;
    :try_end_12
    .catchall {:try_start_0 .. :try_end_12} :catchall_13

    goto :goto_1b

    :catchall_13
    move-exception p0

    .line 60
    const-string p1, "PI-Cleaner/Orientation"

    const-string v0, "Unable to hook Activity.setRequestedOrientation"

    invoke-static {p1, v0, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :goto_1b
    return-void
.end method
