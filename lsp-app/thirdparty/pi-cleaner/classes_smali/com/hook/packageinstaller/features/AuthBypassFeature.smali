.class public final Lcom/hook/packageinstaller/features/AuthBypassFeature;
.super Ljava/lang/Object;
.source "AuthBypassFeature.java"

# interfaces
.implements Lcom/hook/packageinstaller/features/Feature;


# static fields
.field private static final TAG:Ljava/lang/String; = "PI-Cleaner/Auth"


# direct methods
.method public constructor <init>()V
    .registers 1

    .line 23
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static hookAuthEntry(Lcom/hook/packageinstaller/core/HookContext;Lcom/hook/packageinstaller/profiles/ProfileClasses;)V
    .registers 16

    .line 66
    iget-object v0, p1, Lcom/hook/packageinstaller/profiles/ProfileClasses;->authEntryClass:Ljava/lang/String;

    if-eqz v0, :cond_cf

    iget-object v0, p1, Lcom/hook/packageinstaller/profiles/ProfileClasses;->authEntryMethod:Ljava/lang/String;

    if-nez v0, :cond_a

    goto/16 :goto_cf

    .line 69
    :cond_a
    iget-object p0, p0, Lcom/hook/packageinstaller/core/HookContext;->classLoader:Ljava/lang/ClassLoader;

    iget-object v0, p1, Lcom/hook/packageinstaller/profiles/ProfileClasses;->authEntryClass:Ljava/lang/String;

    invoke-static {p0, v0}, Lcom/hook/packageinstaller/core/SafeXposed;->findClass(Ljava/lang/ClassLoader;Ljava/lang/String;)Ljava/lang/Class;

    move-result-object p0

    if-nez p0, :cond_15

    return-void

    .line 75
    :cond_15
    invoke-virtual {p0}, Ljava/lang/Class;->getDeclaredMethods()[Ljava/lang/reflect/Method;

    move-result-object p0

    array-length v0, p0

    const/4 v1, 0x0

    move v2, v1

    move v3, v2

    :goto_1d
    const-string v4, "PI-Cleaner/Auth"

    if-ge v2, v0, :cond_ad

    aget-object v5, p0, v2

    .line 76
    invoke-virtual {v5}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object v6

    iget-object v7, p1, Lcom/hook/packageinstaller/profiles/ProfileClasses;->authEntryMethod:Ljava/lang/String;

    invoke-virtual {v6, v7}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v6

    if-nez v6, :cond_31

    goto/16 :goto_a9

    .line 79
    :cond_31
    invoke-virtual {v5}, Ljava/lang/reflect/Method;->getParameterTypes()[Ljava/lang/Class;

    move-result-object v6

    .line 80
    array-length v7, v6

    const/4 v8, 0x3

    if-lt v7, v8, :cond_a9

    array-length v7, v6

    const/16 v8, 0x8

    if-le v7, v8, :cond_40

    goto/16 :goto_a9

    .line 83
    :cond_40
    const-class v7, Ljava/lang/String;

    aget-object v8, v6, v1

    invoke-virtual {v7, v8}, Ljava/lang/Class;->isAssignableFrom(Ljava/lang/Class;)Z

    move-result v7

    if-nez v7, :cond_4b

    goto :goto_a9

    .line 88
    :cond_4b
    array-length v7, v6

    move v8, v1

    move v9, v8

    move v10, v9

    :goto_4f
    const/4 v11, 0x1

    if-ge v8, v7, :cond_6d

    aget-object v12, v6, v8

    .line 89
    const-class v13, Landroid/app/Activity;

    invoke-virtual {v13, v12}, Ljava/lang/Class;->isAssignableFrom(Ljava/lang/Class;)Z

    move-result v13

    if-eqz v13, :cond_5d

    move v9, v11

    .line 92
    :cond_5d
    invoke-virtual {v12}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v12

    const-string v13, "InstallationControlResult"

    invoke-virtual {v12, v13}, Ljava/lang/String;->endsWith(Ljava/lang/String;)Z

    move-result v12

    if-eqz v12, :cond_6a

    move v10, v11

    :cond_6a
    add-int/lit8 v8, v8, 0x1

    goto :goto_4f

    :cond_6d
    if-eqz v9, :cond_a9

    if-nez v10, :cond_72

    goto :goto_a9

    .line 101
    :cond_72
    :try_start_72
    new-instance v6, Lcom/hook/packageinstaller/features/AuthBypassFeature$3;

    invoke-direct {v6, v5}, Lcom/hook/packageinstaller/features/AuthBypassFeature$3;-><init>(Ljava/lang/reflect/Method;)V

    invoke-static {v5, v6}, Lde/robv/android/xposed/XposedBridge;->hookMethod(Ljava/lang/reflect/Member;Lde/robv/android/xposed/XC_MethodHook;)Lde/robv/android/xposed/XC_MethodHook$Unhook;
    :try_end_7a
    .catchall {:try_start_72 .. :try_end_7a} :catchall_93

    .line 117
    :try_start_7a
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v6, "Hooked auth entry: "

    invoke-virtual {v3, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v4, v3}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_90
    .catchall {:try_start_7a .. :try_end_90} :catchall_91

    goto :goto_a8

    :catchall_91
    move-exception v3

    goto :goto_96

    :catchall_93
    move-exception v6

    move v11, v3

    move-object v3, v6

    .line 119
    :goto_96
    new-instance v6, Ljava/lang/StringBuilder;

    const-string v7, "Auth entry hook failed: "

    invoke-direct {v6, v7}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v6, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v4, v5, v3}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :goto_a8
    move v3, v11

    :cond_a9
    :goto_a9
    add-int/lit8 v2, v2, 0x1

    goto/16 :goto_1d

    :cond_ad
    if-nez v3, :cond_cf

    .line 124
    new-instance p0, Ljava/lang/StringBuilder;

    const-string v0, "No auth entry matched: "

    invoke-direct {p0, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v0, p1, Lcom/hook/packageinstaller/profiles/ProfileClasses;->authEntryClass:Ljava/lang/String;

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    const-string v0, "#"

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    iget-object p1, p1, Lcom/hook/packageinstaller/profiles/ProfileClasses;->authEntryMethod:Ljava/lang/String;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v4, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    :cond_cf
    :goto_cf
    return-void
.end method


# virtual methods
.method public id()Ljava/lang/String;
    .registers 1

    .line 28
    const-string p0, "auth_bypass"

    return-object p0
.end method

.method public install(Lcom/hook/packageinstaller/core/HookContext;)V
    .registers 8

    .line 33
    invoke-virtual {p1}, Lcom/hook/packageinstaller/core/HookContext;->classes()Lcom/hook/packageinstaller/profiles/ProfileClasses;

    move-result-object v0

    .line 36
    iget-object v1, p1, Lcom/hook/packageinstaller/core/HookContext;->classLoader:Ljava/lang/ClassLoader;

    iget-object v2, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->installationControlResult:Ljava/lang/String;

    new-instance v3, Lcom/hook/packageinstaller/features/AuthBypassFeature$1;

    invoke-direct {v3, p0}, Lcom/hook/packageinstaller/features/AuthBypassFeature$1;-><init>(Lcom/hook/packageinstaller/features/AuthBypassFeature;)V

    filled-new-array {v3}, [Ljava/lang/Object;

    move-result-object v3

    const-string v4, "isNeedPwdVerify"

    invoke-static {v1, v2, v4, v3}, Lcom/hook/packageinstaller/core/SafeXposed;->hookMethod(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Object;)Z

    .line 45
    iget-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->authChildClass:Ljava/lang/String;

    if-eqz v1, :cond_57

    iget-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->authChildCheckMethod:Ljava/lang/String;

    if-eqz v1, :cond_57

    .line 46
    iget-object v1, p1, Lcom/hook/packageinstaller/core/HookContext;->classLoader:Ljava/lang/ClassLoader;

    iget-object v2, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->authChildClass:Ljava/lang/String;

    iget-object v3, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->authChildCheckMethod:Ljava/lang/String;

    const-class v4, Landroid/content/Context;

    new-instance v5, Lcom/hook/packageinstaller/features/AuthBypassFeature$2;

    invoke-direct {v5, p0}, Lcom/hook/packageinstaller/features/AuthBypassFeature$2;-><init>(Lcom/hook/packageinstaller/features/AuthBypassFeature;)V

    filled-new-array {v4, v5}, [Ljava/lang/Object;

    move-result-object p0

    invoke-static {v1, v2, v3, p0}, Lcom/hook/packageinstaller/core/SafeXposed;->hookMethod(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_57

    .line 55
    new-instance p0, Ljava/lang/StringBuilder;

    const-string v1, "Child-mode check not hooked: "

    invoke-direct {p0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->authChildClass:Ljava/lang/String;

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    const-string v1, "#"

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    iget-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->authChildCheckMethod:Ljava/lang/String;

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string v1, "PI-Cleaner/Auth"

    invoke-static {v1, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 62
    :cond_57
    invoke-static {p1, v0}, Lcom/hook/packageinstaller/features/AuthBypassFeature;->hookAuthEntry(Lcom/hook/packageinstaller/core/HookContext;Lcom/hook/packageinstaller/profiles/ProfileClasses;)V

    return-void
.end method
