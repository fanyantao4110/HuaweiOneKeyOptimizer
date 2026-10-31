.class public final Lcom/hook/packageinstaller/HookBootstrap;
.super Ljava/lang/Object;
.source "HookBootstrap.java"


# static fields
.field private static final STARTED:Ljava/util/concurrent/atomic/AtomicBoolean;

.field private static final TAG:Ljava/lang/String; = "PI-Cleaner"


# direct methods
.method static constructor <clinit>()V
    .registers 2

    .line 24
    new-instance v0, Ljava/util/concurrent/atomic/AtomicBoolean;

    const/4 v1, 0x0

    invoke-direct {v0, v1}, Ljava/util/concurrent/atomic/AtomicBoolean;-><init>(Z)V

    sput-object v0, Lcom/hook/packageinstaller/HookBootstrap;->STARTED:Ljava/util/concurrent/atomic/AtomicBoolean;

    return-void
.end method

.method private constructor <init>()V
    .registers 1

    .line 26
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static start(Landroid/app/Application;Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;)V
    .registers 15

    .line 30
    const-string v0, "PI-Cleaner"

    .line 0
    const-string v1, "PI-Cleaner: "

    const-string v2, "PackageInstaller cleaner started: installer="

    .line 30
    sget-object v3, Lcom/hook/packageinstaller/HookBootstrap;->STARTED:Ljava/util/concurrent/atomic/AtomicBoolean;

    const/4 v4, 0x0

    const/4 v5, 0x1

    invoke-virtual {v3, v4, v5}, Ljava/util/concurrent/atomic/AtomicBoolean;->compareAndSet(ZZ)Z

    move-result v3

    if-nez v3, :cond_11

    return-void

    .line 34
    :cond_11
    :try_start_11
    invoke-static {p0}, Lcom/hook/packageinstaller/core/VersionDetector;->detect(Landroid/content/Context;)Lcom/hook/packageinstaller/core/InstallerVersion;

    move-result-object v3

    .line 35
    invoke-static {p0}, Lcom/hook/packageinstaller/config/ConfigRepository;->load(Landroid/content/Context;)Lcom/hook/packageinstaller/config/FeatureConfig;

    move-result-object v10

    .line 36
    iget-object v4, p1, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;->classLoader:Ljava/lang/ClassLoader;

    invoke-static {v3, v4}, Lcom/hook/packageinstaller/core/ProfileResolver;->resolve(Lcom/hook/packageinstaller/core/InstallerVersion;Ljava/lang/ClassLoader;)Lcom/hook/packageinstaller/profiles/InstallerProfile;

    move-result-object v11

    .line 38
    new-instance v12, Lcom/hook/packageinstaller/core/HookContext;

    iget-object v6, p1, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;->classLoader:Ljava/lang/ClassLoader;

    move-object v4, v12

    move-object v5, p0

    move-object v7, v3

    move-object v8, v10

    move-object v9, v11

    invoke-direct/range {v4 .. v9}, Lcom/hook/packageinstaller/core/HookContext;-><init>(Landroid/app/Application;Ljava/lang/ClassLoader;Lcom/hook/packageinstaller/core/InstallerVersion;Lcom/hook/packageinstaller/config/FeatureConfig;Lcom/hook/packageinstaller/profiles/InstallerProfile;)V

    .line 41
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 42
    invoke-virtual {v3}, Lcom/hook/packageinstaller/core/InstallerVersion;->displayName()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v2, ", os="

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    iget-object v2, v3, Lcom/hook/packageinstaller/core/InstallerVersion;->osRelease:Ljava/lang/String;

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v2, " (API "

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    iget v2, v3, Lcom/hook/packageinstaller/core/InstallerVersion;->sdkInt:I

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v2, "), profile="

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    .line 44
    invoke-interface {v11}, Lcom/hook/packageinstaller/profiles/InstallerProfile;->id()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v2, "/"

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-interface {v11}, Lcom/hook/packageinstaller/profiles/InstallerProfile;->label()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v2, ", auth="

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    iget-boolean v2, v10, Lcom/hook/packageinstaller/config/FeatureConfig;->authBypass:Z

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v2, ", risk="

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    iget-boolean v2, v10, Lcom/hook/packageinstaller/config/FeatureConfig;->riskBypass:Z

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v2, ", riskUi="

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    iget-boolean v2, v10, Lcom/hook/packageinstaller/config/FeatureConfig;->riskUiClean:Z

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    .line 48
    invoke-static {v0, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 49
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p1}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/String;)V

    .line 51
    invoke-static {v12}, Lcom/hook/packageinstaller/features/FeatureRegistry;->install(Lcom/hook/packageinstaller/core/HookContext;)V

    .line 52
    invoke-static {p0}, Lcom/hook/packageinstaller/core/RestartScopeReceiver;->register(Landroid/app/Application;)V
    :try_end_ad
    .catchall {:try_start_11 .. :try_end_ad} :catchall_ae

    goto :goto_b7

    :catchall_ae
    move-exception p0

    .line 54
    const-string p1, "Bootstrap failed"

    invoke-static {v0, p1, p0}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 55
    invoke-static {p0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/Throwable;)V

    :goto_b7
    return-void
.end method
