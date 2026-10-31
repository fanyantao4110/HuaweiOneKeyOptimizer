.class public final Lcom/hook/packageinstaller/HookEntry;
.super Ljava/lang/Object;
.source "HookEntry.java"

# interfaces
.implements Lde/robv/android/xposed/IXposedHookLoadPackage;


# static fields
.field private static final TAG:Ljava/lang/String; = "PI-Cleaner/Entry"

.field private static final TARGET_PACKAGE:Ljava/lang/String; = "com.android.packageinstaller"


# direct methods
.method public constructor <init>()V
    .registers 1

    .line 12
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public handleLoadPackage(Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;)V
    .registers 7

    .line 18
    const-string v0, "onCreate"

    const-string v1, "com.android.packageinstaller"

    iget-object v2, p1, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;->packageName:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v1

    if-nez v1, :cond_d

    return-void

    .line 22
    :cond_d
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "Loaded target package: "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v2, p1, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;->packageName:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v2, ", process="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    iget-object v2, p1, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;->processName:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    const-string v2, "PI-Cleaner/Entry"

    invoke-static {v2, v1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    const/4 v1, 0x0

    .line 27
    :try_start_30
    const-string v3, "com.android.packageinstaller.PackageInstallerApplication"

    iget-object v4, p1, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;->classLoader:Ljava/lang/ClassLoader;

    invoke-static {v3, v4}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v3

    .line 30
    new-instance v4, Lcom/hook/packageinstaller/HookEntry$1;

    invoke-direct {v4, p0, p1}, Lcom/hook/packageinstaller/HookEntry$1;-><init>(Lcom/hook/packageinstaller/HookEntry;Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;)V

    filled-new-array {v4}, [Ljava/lang/Object;

    move-result-object v4

    invoke-static {v3, v0, v4}, Lde/robv/android/xposed/XposedHelpers;->findAndHookMethod(Ljava/lang/Class;Ljava/lang/String;[Ljava/lang/Object;)Lde/robv/android/xposed/XC_MethodHook$Unhook;

    const/4 v1, 0x1

    .line 37
    const-string v3, "Hooked PackageInstallerApplication.onCreate"

    invoke-static {v2, v3}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_4a
    .catchall {:try_start_30 .. :try_end_4a} :catchall_4b

    goto :goto_51

    :catchall_4b
    move-exception v3

    .line 39
    const-string v4, "PackageInstallerApplication hook unavailable"

    invoke-static {v2, v4, v3}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :goto_51
    if-nez v1, :cond_70

    .line 44
    :try_start_53
    const-class v1, Landroid/app/Application;

    new-instance v3, Lcom/hook/packageinstaller/HookEntry$2;

    invoke-direct {v3, p0, p1}, Lcom/hook/packageinstaller/HookEntry$2;-><init>(Lcom/hook/packageinstaller/HookEntry;Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;)V

    filled-new-array {v3}, [Ljava/lang/Object;

    move-result-object p0

    invoke-static {v1, v0, p0}, Lde/robv/android/xposed/XposedHelpers;->findAndHookMethod(Ljava/lang/Class;Ljava/lang/String;[Ljava/lang/Object;)Lde/robv/android/xposed/XC_MethodHook$Unhook;

    .line 55
    const-string p0, "Using Application.onCreate fallback"

    invoke-static {v2, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_66
    .catchall {:try_start_53 .. :try_end_66} :catchall_67

    goto :goto_70

    :catchall_67
    move-exception p0

    .line 57
    const-string p1, "Unable to install bootstrap hook"

    invoke-static {v2, p1, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 58
    invoke-static {p0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/Throwable;)V

    :cond_70
    :goto_70
    return-void
.end method
