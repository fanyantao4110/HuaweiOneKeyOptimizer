.class public final Lcom/hook/packageinstaller/core/ResultSanitizer;
.super Ljava/lang/Object;
.source "ResultSanitizer.java"


# static fields
.field private static final TAG:Ljava/lang/String; = "PI-Cleaner/Result"


# direct methods
.method private constructor <init>()V
    .registers 1

    .line 15
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static call(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;
    .registers 3

    const/4 v0, 0x0

    .line 97
    :try_start_1
    new-array v0, v0, [Ljava/lang/Object;

    invoke-static {p0, p1, v0}, Lde/robv/android/xposed/XposedHelpers;->callMethod(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0
    :try_end_7
    .catchall {:try_start_1 .. :try_end_7} :catchall_8

    return-object p0

    :catchall_8
    const/4 p0, 0x0

    return-object p0
.end method

.method public static clean(Lcom/hook/packageinstaller/core/HookContext;Ljava/lang/Object;)Ljava/lang/Object;
    .registers 7

    if-nez p1, :cond_6

    .line 20
    invoke-static {p0}, Lcom/hook/packageinstaller/core/ResultSanitizer;->newResult(Lcom/hook/packageinstaller/core/HookContext;)Ljava/lang/Object;

    move-result-object p1

    :cond_6
    const/4 v0, 0x0

    if-nez p1, :cond_a

    return-object v0

    .line 26
    :cond_a
    invoke-static {p0}, Lcom/hook/packageinstaller/core/ResultSanitizer;->newResult(Lcom/hook/packageinstaller/core/HookContext;)Ljava/lang/Object;

    move-result-object p0

    if-nez p0, :cond_11

    move-object p0, p1

    .line 31
    :cond_11
    const-string v1, "getPkgName"

    const-string v2, "setPkgName"

    invoke-static {p1, p0, v1, v2}, Lcom/hook/packageinstaller/core/ResultSanitizer;->copyString(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)V

    .line 33
    const-string v1, "setAppId"

    const-string v2, ""

    invoke-static {p0, v1, v2}, Lcom/hook/packageinstaller/core/ResultSanitizer;->setString(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)V

    .line 34
    const-string v1, "setDetailId"

    invoke-static {p0, v1, v2}, Lcom/hook/packageinstaller/core/ResultSanitizer;->setString(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)V

    .line 35
    const-string v1, "getDisplayPolicy"

    const-string v3, "setDisplayPolicy"

    invoke-static {p1, p0, v1, v3}, Lcom/hook/packageinstaller/core/ResultSanitizer;->copyInt(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)V

    .line 37
    const-string v1, "setForwardBtnType"

    const/4 v3, 0x1

    invoke-static {p0, v1, v3}, Lcom/hook/packageinstaller/core/ResultSanitizer;->setInt(Ljava/lang/Object;Ljava/lang/String;I)V

    .line 39
    const-string v1, "setControlType"

    const-string v4, "0"

    invoke-static {p0, v1, v4}, Lcom/hook/packageinstaller/core/ResultSanitizer;->setString(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)V

    .line 40
    const-string v1, "setControlByteCode"

    invoke-static {p0, v1, v4}, Lcom/hook/packageinstaller/core/ResultSanitizer;->setString(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)V

    .line 41
    const-string v1, "setTitle"

    invoke-static {p0, v1, v2}, Lcom/hook/packageinstaller/core/ResultSanitizer;->setString(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)V

    .line 42
    const-string v1, "setTipText"

    invoke-static {p0, v1, v2}, Lcom/hook/packageinstaller/core/ResultSanitizer;->setString(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)V

    .line 43
    const-string v1, "setVirusDetail"

    invoke-static {p0, v1, v2}, Lcom/hook/packageinstaller/core/ResultSanitizer;->setString(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)V

    .line 44
    const-string v1, "setVirusType"

    const/4 v2, 0x0

    invoke-static {p0, v1, v2}, Lcom/hook/packageinstaller/core/ResultSanitizer;->setInt(Ljava/lang/Object;Ljava/lang/String;I)V

    .line 45
    const-string v1, "setRiskType"

    invoke-static {p0, v1, v2}, Lcom/hook/packageinstaller/core/ResultSanitizer;->setInt(Ljava/lang/Object;Ljava/lang/String;I)V

    .line 46
    const-string v1, "setPwdCheckType"

    invoke-static {p0, v1, v2}, Lcom/hook/packageinstaller/core/ResultSanitizer;->setInt(Ljava/lang/Object;Ljava/lang/String;I)V

    .line 47
    const-string v1, "setBootInstall"

    invoke-static {p0, v1, v2}, Lcom/hook/packageinstaller/core/ResultSanitizer;->setInt(Ljava/lang/Object;Ljava/lang/String;I)V

    .line 48
    const-string v1, "setPureModeExempt"

    invoke-static {p0, v1, v3}, Lcom/hook/packageinstaller/core/ResultSanitizer;->setBoolean(Ljava/lang/Object;Ljava/lang/String;Z)V

    .line 49
    const-string v1, "setAbiUnCompatibility"

    invoke-static {p0, v1, v2}, Lcom/hook/packageinstaller/core/ResultSanitizer;->setBoolean(Ljava/lang/Object;Ljava/lang/String;Z)V

    .line 50
    const-string v1, "setPendingIntent"

    invoke-static {p0, v1, v0}, Lcom/hook/packageinstaller/core/ResultSanitizer;->setObject(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/Object;)V

    .line 51
    const-string v1, "setWashAppInfo"

    invoke-static {p0, v1, v0}, Lcom/hook/packageinstaller/core/ResultSanitizer;->setObject(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/Object;)V

    .line 55
    const-string v1, "controlByteCodeNum"

    invoke-static {p0, v1, v2}, Lcom/hook/packageinstaller/core/ResultSanitizer;->setIntField(Ljava/lang/Object;Ljava/lang/String;I)V

    if-ne p0, p1, :cond_90

    .line 57
    const-string v1, "pwdCheckType"

    invoke-static {p0, v1, v2}, Lcom/hook/packageinstaller/core/ResultSanitizer;->setIntField(Ljava/lang/Object;Ljava/lang/String;I)V

    .line 58
    const-string v1, "isPureModeExempt"

    invoke-static {p0, v1, v3}, Lcom/hook/packageinstaller/core/ResultSanitizer;->setBooleanField(Ljava/lang/Object;Ljava/lang/String;Z)V

    .line 59
    const-string v1, "mPendingIntent"

    invoke-static {p0, v1, v0}, Lcom/hook/packageinstaller/core/ResultSanitizer;->setObjectField(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/Object;)V

    .line 60
    const-string v1, "mWashAppInfo"

    invoke-static {p0, v1, v0}, Lcom/hook/packageinstaller/core/ResultSanitizer;->setObjectField(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/Object;)V

    .line 63
    :cond_90
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "Sanitized result: "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-static {p1}, Lcom/hook/packageinstaller/core/ResultSanitizer;->describe(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p1

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v0, " -> "

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-static {p0}, Lcom/hook/packageinstaller/core/ResultSanitizer;->describe(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string v0, "PI-Cleaner/Result"

    invoke-static {v0, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-object p0
.end method

.method private static copyInt(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)V
    .registers 4

    .line 89
    invoke-static {p0, p2}, Lcom/hook/packageinstaller/core/ResultSanitizer;->call(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p0

    .line 90
    instance-of p2, p0, Ljava/lang/Number;

    if-eqz p2, :cond_11

    .line 91
    check-cast p0, Ljava/lang/Number;

    invoke-virtual {p0}, Ljava/lang/Number;->intValue()I

    move-result p0

    invoke-static {p1, p3, p0}, Lcom/hook/packageinstaller/core/ResultSanitizer;->setInt(Ljava/lang/Object;Ljava/lang/String;I)V

    :cond_11
    return-void
.end method

.method private static copyString(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)V
    .registers 4

    .line 82
    invoke-static {p0, p2}, Lcom/hook/packageinstaller/core/ResultSanitizer;->call(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p0

    .line 83
    instance-of p2, p0, Ljava/lang/String;

    if-eqz p2, :cond_d

    .line 84
    check-cast p0, Ljava/lang/String;

    invoke-static {p1, p3, p0}, Lcom/hook/packageinstaller/core/ResultSanitizer;->setString(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)V

    :cond_d
    return-void
.end method

.method private static describe(Ljava/lang/Object;)Ljava/lang/String;
    .registers 6

    if-nez p0, :cond_5

    .line 154
    const-string p0, "null"

    return-object p0

    .line 156
    :cond_5
    const-string v0, "getControlType"

    invoke-static {p0, v0}, Lcom/hook/packageinstaller/core/ResultSanitizer;->call(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v0

    .line 157
    const-string v1, "getPkgName"

    invoke-static {p0, v1}, Lcom/hook/packageinstaller/core/ResultSanitizer;->call(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    .line 158
    const-string v2, "isNeedPwdVerify"

    invoke-static {p0, v2}, Lcom/hook/packageinstaller/core/ResultSanitizer;->call(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v2

    .line 159
    const-string v3, "isPureModeExempt"

    invoke-static {p0, v3}, Lcom/hook/packageinstaller/core/ResultSanitizer;->call(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p0

    .line 160
    new-instance v3, Ljava/lang/StringBuilder;

    const-string v4, "{pkg="

    invoke-direct {v3, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v1

    const-string v3, ", controlType="

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, ", needPwd="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v1, ", pureExempt="

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object p0

    const-string v0, "}"

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static newResult(Lcom/hook/packageinstaller/core/HookContext;)Ljava/lang/Object;
    .registers 4

    const/4 v0, 0x0

    .line 69
    :try_start_1
    iget-object v1, p0, Lcom/hook/packageinstaller/core/HookContext;->classLoader:Ljava/lang/ClassLoader;

    .line 70
    invoke-virtual {p0}, Lcom/hook/packageinstaller/core/HookContext;->classes()Lcom/hook/packageinstaller/profiles/ProfileClasses;

    move-result-object p0

    iget-object p0, p0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->installationControlResult:Ljava/lang/String;

    .line 69
    invoke-static {v1, p0}, Lcom/hook/packageinstaller/core/SafeXposed;->findClass(Ljava/lang/ClassLoader;Ljava/lang/String;)Ljava/lang/Class;

    move-result-object p0

    if-nez p0, :cond_10

    return-object v0

    :cond_10
    const/4 v1, 0x0

    .line 74
    new-array v1, v1, [Ljava/lang/Object;

    invoke-static {p0, v1}, Lde/robv/android/xposed/XposedHelpers;->newInstance(Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0
    :try_end_17
    .catchall {:try_start_1 .. :try_end_17} :catchall_18

    return-object p0

    :catchall_18
    move-exception p0

    .line 76
    const-string v1, "PI-Cleaner/Result"

    const-string v2, "Cannot construct InstallationControlResult"

    invoke-static {v1, v2, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    return-object v0
.end method

.method private static setBoolean(Ljava/lang/Object;Ljava/lang/String;Z)V
    .registers 3

    .line 119
    :try_start_0
    invoke-static {p2}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object p2

    filled-new-array {p2}, [Ljava/lang/Object;

    move-result-object p2

    invoke-static {p0, p1, p2}, Lde/robv/android/xposed/XposedHelpers;->callMethod(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_b
    .catchall {:try_start_0 .. :try_end_b} :catchall_b

    :catchall_b
    return-void
.end method

.method private static setBooleanField(Ljava/lang/Object;Ljava/lang/String;Z)V
    .registers 3

    .line 140
    :try_start_0
    invoke-static {p0, p1, p2}, Lde/robv/android/xposed/XposedHelpers;->setBooleanField(Ljava/lang/Object;Ljava/lang/String;Z)V
    :try_end_3
    .catchall {:try_start_0 .. :try_end_3} :catchall_3

    :catchall_3
    return-void
.end method

.method private static setInt(Ljava/lang/Object;Ljava/lang/String;I)V
    .registers 3

    .line 112
    :try_start_0
    invoke-static {p2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p2

    filled-new-array {p2}, [Ljava/lang/Object;

    move-result-object p2

    invoke-static {p0, p1, p2}, Lde/robv/android/xposed/XposedHelpers;->callMethod(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_b
    .catchall {:try_start_0 .. :try_end_b} :catchall_b

    :catchall_b
    return-void
.end method

.method private static setIntField(Ljava/lang/Object;Ljava/lang/String;I)V
    .registers 3

    .line 133
    :try_start_0
    invoke-static {p0, p1, p2}, Lde/robv/android/xposed/XposedHelpers;->setIntField(Ljava/lang/Object;Ljava/lang/String;I)V
    :try_end_3
    .catchall {:try_start_0 .. :try_end_3} :catchall_3

    :catchall_3
    return-void
.end method

.method private static setObject(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/Object;)V
    .registers 3

    .line 126
    :try_start_0
    filled-new-array {p2}, [Ljava/lang/Object;

    move-result-object p2

    invoke-static {p0, p1, p2}, Lde/robv/android/xposed/XposedHelpers;->callMethod(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_7
    .catchall {:try_start_0 .. :try_end_7} :catchall_7

    :catchall_7
    return-void
.end method

.method private static setObjectField(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/Object;)V
    .registers 3

    .line 147
    :try_start_0
    invoke-static {p0, p1, p2}, Lde/robv/android/xposed/XposedHelpers;->setObjectField(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/Object;)V
    :try_end_3
    .catchall {:try_start_0 .. :try_end_3} :catchall_3

    :catchall_3
    return-void
.end method

.method private static setString(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)V
    .registers 3

    .line 105
    :try_start_0
    filled-new-array {p2}, [Ljava/lang/Object;

    move-result-object p2

    invoke-static {p0, p1, p2}, Lde/robv/android/xposed/XposedHelpers;->callMethod(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_7
    .catchall {:try_start_0 .. :try_end_7} :catchall_7

    :catchall_7
    return-void
.end method
