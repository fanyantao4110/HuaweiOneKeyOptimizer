.class public final Lcom/hook/packageinstaller/core/VersionDetector;
.super Ljava/lang/Object;
.source "VersionDetector.java"


# static fields
.field private static final TAG:Ljava/lang/String; = "PI-Cleaner/Version"

.field public static final TARGET_PACKAGE:Ljava/lang/String; = "com.android.packageinstaller"


# direct methods
.method private constructor <init>()V
    .registers 1

    .line 13
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static detect(Landroid/content/Context;)Lcom/hook/packageinstaller/core/InstallerVersion;
    .registers 13

    .line 17
    const-string v0, "PI-Cleaner/Version"

    const/4 v1, 0x0

    .line 20
    :try_start_3
    invoke-virtual {p0}, Landroid/content/Context;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object p0

    .line 21
    const-string v2, "com.android.packageinstaller"

    const/4 v3, 0x0

    invoke-virtual {p0, v2, v3}, Landroid/content/pm/PackageManager;->getPackageInfo(Ljava/lang/String;I)Landroid/content/pm/PackageInfo;

    move-result-object p0

    .line 22
    iget-object v1, p0, Landroid/content/pm/PackageInfo;->versionName:Ljava/lang/String;

    .line 24
    invoke-virtual {p0}, Landroid/content/pm/PackageInfo;->getLongVersionCode()J

    move-result-wide v2
    :try_end_14
    .catchall {:try_start_3 .. :try_end_14} :catchall_15

    goto :goto_1d

    :catchall_15
    move-exception p0

    .line 27
    const-string v2, "Unable to read PackageInstaller version"

    invoke-static {v0, v2, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    const-wide/16 v2, -0x1

    :goto_1d
    move-object v6, v1

    move-wide v7, v2

    .line 30
    new-instance p0, Lcom/hook/packageinstaller/core/InstallerVersion;

    sget v9, Landroid/os/Build$VERSION;->SDK_INT:I

    sget-object v10, Landroid/os/Build$VERSION;->RELEASE:Ljava/lang/String;

    sget-object v11, Landroid/os/Build;->DISPLAY:Ljava/lang/String;

    const-string v5, "com.android.packageinstaller"

    move-object v4, p0

    invoke-direct/range {v4 .. v11}, Lcom/hook/packageinstaller/core/InstallerVersion;-><init>(Ljava/lang/String;Ljava/lang/String;JILjava/lang/String;Ljava/lang/String;)V

    .line 37
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "Detected "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-object p0
.end method
