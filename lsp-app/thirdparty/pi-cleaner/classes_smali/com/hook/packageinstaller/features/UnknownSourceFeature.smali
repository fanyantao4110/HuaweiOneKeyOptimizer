.class public final Lcom/hook/packageinstaller/features/UnknownSourceFeature;
.super Ljava/lang/Object;
.source "UnknownSourceFeature.java"

# interfaces
.implements Lcom/hook/packageinstaller/features/Feature;


# static fields
.field private static final TAG:Ljava/lang/String; = "PI-Cleaner/UnknownSource"


# direct methods
.method public constructor <init>()V
    .registers 1

    .line 13
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static hookAppOps(Lcom/hook/packageinstaller/core/HookContext;)V
    .registers 9

    .line 64
    iget-object p0, p0, Lcom/hook/packageinstaller/core/HookContext;->classLoader:Ljava/lang/ClassLoader;

    const-string v0, "android.app.AppOpsManager"

    invoke-static {p0, v0}, Lcom/hook/packageinstaller/core/SafeXposed;->findClass(Ljava/lang/ClassLoader;Ljava/lang/String;)Ljava/lang/Class;

    move-result-object p0

    if-nez p0, :cond_b

    return-void

    .line 69
    :cond_b
    invoke-virtual {p0}, Ljava/lang/Class;->getDeclaredMethods()[Ljava/lang/reflect/Method;

    move-result-object p0

    array-length v0, p0

    const/4 v1, 0x0

    move v2, v1

    :goto_12
    const-string v3, "PI-Cleaner/UnknownSource"

    if-ge v1, v0, :cond_4e

    aget-object v4, p0, v1

    .line 70
    const-string v5, "noteOpNoThrow"

    invoke-virtual {v4}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object v6

    invoke-virtual {v5, v6}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v5

    if-eqz v5, :cond_4b

    .line 71
    invoke-virtual {v4}, Ljava/lang/reflect/Method;->getReturnType()Ljava/lang/Class;

    move-result-object v5

    sget-object v6, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    if-eq v5, v6, :cond_2d

    goto :goto_4b

    .line 75
    :cond_2d
    :try_start_2d
    new-instance v5, Lcom/hook/packageinstaller/features/UnknownSourceFeature$3;

    invoke-direct {v5}, Lcom/hook/packageinstaller/features/UnknownSourceFeature$3;-><init>()V

    invoke-static {v4, v5}, Lde/robv/android/xposed/XposedBridge;->hookMethod(Ljava/lang/reflect/Member;Lde/robv/android/xposed/XC_MethodHook;)Lde/robv/android/xposed/XC_MethodHook$Unhook;
    :try_end_35
    .catchall {:try_start_2d .. :try_end_35} :catchall_38

    add-int/lit8 v2, v2, 0x1

    goto :goto_4b

    :catchall_38
    move-exception v5

    .line 83
    new-instance v6, Ljava/lang/StringBuilder;

    const-string v7, "AppOps hook failed: "

    invoke-direct {v6, v7}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v6, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v4

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-static {v3, v4, v5}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :cond_4b
    :goto_4b
    add-int/lit8 v1, v1, 0x1

    goto :goto_12

    .line 86
    :cond_4e
    new-instance p0, Ljava/lang/StringBuilder;

    const-string v0, "Hooked AppOps noteOpNoThrow methods: "

    invoke-direct {p0, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v3, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method

.method private static hookUserManager(Lcom/hook/packageinstaller/core/HookContext;)V
    .registers 7

    .line 28
    const-string v0, "PI-Cleaner/UnknownSource"

    const-string v1, "android.os.UserManager"

    new-instance v2, Lcom/hook/packageinstaller/features/UnknownSourceFeature$1;

    invoke-direct {v2}, Lcom/hook/packageinstaller/features/UnknownSourceFeature$1;-><init>()V

    .line 39
    :try_start_9
    iget-object v3, p0, Lcom/hook/packageinstaller/core/HookContext;->classLoader:Ljava/lang/ClassLoader;

    const-string v4, "hasUserRestriction"

    const-class v5, Ljava/lang/String;

    filled-new-array {v5, v2}, [Ljava/lang/Object;

    move-result-object v2

    invoke-static {v1, v3, v4, v2}, Lde/robv/android/xposed/XposedHelpers;->findAndHookMethod(Ljava/lang/String;Ljava/lang/ClassLoader;Ljava/lang/String;[Ljava/lang/Object;)Lde/robv/android/xposed/XC_MethodHook$Unhook;
    :try_end_16
    .catchall {:try_start_9 .. :try_end_16} :catchall_17

    goto :goto_1d

    :catchall_17
    move-exception v2

    .line 42
    const-string v3, "UserManager.hasUserRestriction hook failed"

    invoke-static {v0, v3, v2}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 46
    :goto_1d
    :try_start_1d
    iget-object p0, p0, Lcom/hook/packageinstaller/core/HookContext;->classLoader:Ljava/lang/ClassLoader;

    const-string v2, "getUserRestrictionSource"

    const-class v3, Ljava/lang/String;

    const-class v4, Landroid/os/UserHandle;

    new-instance v5, Lcom/hook/packageinstaller/features/UnknownSourceFeature$2;

    invoke-direct {v5}, Lcom/hook/packageinstaller/features/UnknownSourceFeature$2;-><init>()V

    filled-new-array {v3, v4, v5}, [Ljava/lang/Object;

    move-result-object v3

    invoke-static {v1, p0, v2, v3}, Lde/robv/android/xposed/XposedHelpers;->findAndHookMethod(Ljava/lang/String;Ljava/lang/ClassLoader;Ljava/lang/String;[Ljava/lang/Object;)Lde/robv/android/xposed/XC_MethodHook$Unhook;
    :try_end_31
    .catchall {:try_start_1d .. :try_end_31} :catchall_32

    goto :goto_38

    :catchall_32
    move-exception p0

    .line 59
    const-string v1, "UserManager.getUserRestrictionSource hook failed"

    invoke-static {v0, v1, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :goto_38
    return-void
.end method


# virtual methods
.method public id()Ljava/lang/String;
    .registers 1

    .line 18
    const-string p0, "unknown_source_bypass"

    return-object p0
.end method

.method public install(Lcom/hook/packageinstaller/core/HookContext;)V
    .registers 2

    .line 23
    invoke-static {p1}, Lcom/hook/packageinstaller/features/UnknownSourceFeature;->hookUserManager(Lcom/hook/packageinstaller/core/HookContext;)V

    .line 24
    invoke-static {p1}, Lcom/hook/packageinstaller/features/UnknownSourceFeature;->hookAppOps(Lcom/hook/packageinstaller/core/HookContext;)V

    return-void
.end method
