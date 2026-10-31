.class public final Lcom/hook/packageinstaller/core/HookContext;
.super Ljava/lang/Object;
.source "HookContext.java"


# static fields
.field private static final TAG:Ljava/lang/String; = "PI-Cleaner"


# instance fields
.field public final application:Landroid/app/Application;

.field public final classLoader:Ljava/lang/ClassLoader;

.field public final config:Lcom/hook/packageinstaller/config/FeatureConfig;

.field public final profile:Lcom/hook/packageinstaller/profiles/InstallerProfile;

.field public final version:Lcom/hook/packageinstaller/core/InstallerVersion;


# direct methods
.method public constructor <init>(Landroid/app/Application;Ljava/lang/ClassLoader;Lcom/hook/packageinstaller/core/InstallerVersion;Lcom/hook/packageinstaller/config/FeatureConfig;Lcom/hook/packageinstaller/profiles/InstallerProfile;)V
    .registers 6

    .line 23
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 24
    iput-object p1, p0, Lcom/hook/packageinstaller/core/HookContext;->application:Landroid/app/Application;

    .line 25
    iput-object p2, p0, Lcom/hook/packageinstaller/core/HookContext;->classLoader:Ljava/lang/ClassLoader;

    .line 26
    iput-object p3, p0, Lcom/hook/packageinstaller/core/HookContext;->version:Lcom/hook/packageinstaller/core/InstallerVersion;

    .line 27
    iput-object p4, p0, Lcom/hook/packageinstaller/core/HookContext;->config:Lcom/hook/packageinstaller/config/FeatureConfig;

    .line 28
    iput-object p5, p0, Lcom/hook/packageinstaller/core/HookContext;->profile:Lcom/hook/packageinstaller/profiles/InstallerProfile;

    return-void
.end method


# virtual methods
.method public classExists(Ljava/lang/String;)Z
    .registers 2

    .line 36
    iget-object p0, p0, Lcom/hook/packageinstaller/core/HookContext;->classLoader:Ljava/lang/ClassLoader;

    invoke-static {p0, p1}, Lcom/hook/packageinstaller/core/SafeXposed;->classExists(Ljava/lang/ClassLoader;Ljava/lang/String;)Z

    move-result p0

    return p0
.end method

.method public classes()Lcom/hook/packageinstaller/profiles/ProfileClasses;
    .registers 1

    .line 32
    iget-object p0, p0, Lcom/hook/packageinstaller/core/HookContext;->profile:Lcom/hook/packageinstaller/profiles/InstallerProfile;

    invoke-interface {p0}, Lcom/hook/packageinstaller/profiles/InstallerProfile;->classes()Lcom/hook/packageinstaller/profiles/ProfileClasses;

    move-result-object p0

    return-object p0
.end method

.method public clean(Ljava/lang/Object;)Ljava/lang/Object;
    .registers 2

    .line 49
    invoke-static {p0, p1}, Lcom/hook/packageinstaller/core/ResultSanitizer;->clean(Lcom/hook/packageinstaller/core/HookContext;Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    return-object p0
.end method

.method public varargs hook(Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Object;)Z
    .registers 4

    .line 40
    iget-object p0, p0, Lcom/hook/packageinstaller/core/HookContext;->classLoader:Ljava/lang/ClassLoader;

    invoke-static {p0, p1, p2, p3}, Lcom/hook/packageinstaller/core/SafeXposed;->hookMethod(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Object;)Z

    move-result p0

    return p0
.end method

.method public hookAll(Ljava/lang/String;Ljava/lang/String;Lde/robv/android/xposed/XC_MethodHook;)Z
    .registers 4

    .line 45
    iget-object p0, p0, Lcom/hook/packageinstaller/core/HookContext;->classLoader:Ljava/lang/ClassLoader;

    invoke-static {p0, p1, p2, p3}, Lcom/hook/packageinstaller/core/SafeXposed;->hookAllMethods(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Lde/robv/android/xposed/XC_MethodHook;)Z

    move-result p0

    return p0
.end method

.method public log(Ljava/lang/String;)V
    .registers 2

    .line 53
    const-string p0, "PI-Cleaner"

    invoke-static {p0, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method public warn(Ljava/lang/String;Ljava/lang/Throwable;)V
    .registers 3

    .line 57
    const-string p0, "PI-Cleaner"

    invoke-static {p0, p1, p2}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    return-void
.end method
