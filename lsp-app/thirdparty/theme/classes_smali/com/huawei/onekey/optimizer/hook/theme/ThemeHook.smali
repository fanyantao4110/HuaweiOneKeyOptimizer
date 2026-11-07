.class public Lcom/huawei/onekey/optimizer/hook/theme/ThemeHook;
.super Ljava/lang/Object;
.source "ThemeHook.java"

# interfaces
.implements Lde/robv/android/xposed/IXposedHookLoadPackage;


# static fields
.field private static final TAG:Ljava/lang/String; = "MatepadTC"


# direct methods
.method public constructor <init>()V
    .registers 1

    .line 11
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public handleLoadPackage(Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;)V
    .registers 15
    .annotation system Ldalvik/annotation/Throws;
        value = {
            Ljava/lang/Throwable;
        }
    .end annotation

    .line 19
    iget-object v0, p1, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;->packageName:Ljava/lang/String;

    const-string v1, "android"

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    const/4 v1, 0x0

    if-eqz v0, :cond_6a

    .line 21
    :try_start_b
    iget-object v0, p1, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;->classLoader:Ljava/lang/ClassLoader;

    const-string v2, "android.hwtheme.HwThemeManager"

    invoke-virtual {v0, v2}, Ljava/lang/ClassLoader;->loadClass(Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v0

    .line 22
    invoke-virtual {v0}, Ljava/lang/Class;->getDeclaredMethods()[Ljava/lang/reflect/Method;

    move-result-object v0

    array-length v2, v0

    const/4 v3, 0x0

    :goto_19
    if-ge v3, v2, :cond_69

    aget-object v4, v0, v3

    .line 23
    invoke-virtual {v4}, Ljava/lang/reflect/Method;->getName()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/String;->toLowerCase()Ljava/lang/String;

    move-result-object v5

    .line 24
    invoke-virtual {v4}, Ljava/lang/reflect/Method;->getReturnType()Ljava/lang/Class;

    move-result-object v6

    sget-object v7, Ljava/lang/Boolean;->TYPE:Ljava/lang/Class;

    if-ne v6, v7, :cond_65

    const-string v6, "check"

    .line 25
    invoke-virtual {v5, v6}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v6

    if-nez v6, :cond_5d

    const-string v6, "valid"

    invoke-virtual {v5, v6}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v6

    if-nez v6, :cond_5d

    const-string v6, "author"

    invoke-virtual {v5, v6}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v6

    if-nez v6, :cond_5d

    const-string v6, "restrict"

    .line 26
    invoke-virtual {v5, v6}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v6

    if-nez v6, :cond_5d

    const-string v6, "verify"

    invoke-virtual {v5, v6}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v6

    if-nez v6, :cond_5d

    const-string v6, "need"

    invoke-virtual {v5, v6}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v5

    if-eqz v5, :cond_65

    .line 27
    :cond_5d
    new-instance v5, Lcom/huawei/onekey/optimizer/hook/theme/ThemeHook$1;

    invoke-direct {v5, p0}, Lcom/huawei/onekey/optimizer/hook/theme/ThemeHook$1;-><init>(Lcom/huawei/onekey/optimizer/hook/theme/ThemeHook;)V

    invoke-static {v4, v5}, Lde/robv/android/xposed/XposedBridge;->hookMethod(Ljava/lang/reflect/Member;Lde/robv/android/xposed/XC_MethodHook;)Lde/robv/android/xposed/XC_MethodHook$Unhook;
    :try_end_65
    .catchall {:try_start_b .. :try_end_65} :catchall_68

    .line 22
    :cond_65
    add-int/lit8 v3, v3, 0x1

    goto :goto_19

    .line 32
    :catchall_68
    move-exception v0

    :cond_69
    nop

    .line 36
    :cond_6a
    iget-object v0, p1, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;->packageName:Ljava/lang/String;

    const-string v2, "com.huawei.android.thememanager"

    invoke-virtual {v0, v2}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_f8

    .line 37
    iget-object p1, p1, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;->classLoader:Ljava/lang/ClassLoader;

    .line 38
    nop

    .line 41
    const/4 v0, 0x3

    new-array v2, v0, [Ljava/lang/String;

    const-string v3, "com.huawei.android.thememanager.mvp.model.helper.tryout.TryOutTimeFenceService"

    aput-object v3, v2, v1

    const-string v3, "com.huawei.android.thememanager.mvp.model.helper.pay.PayedManagerServiceImpl"

    const/4 v4, 0x1

    aput-object v3, v2, v4

    const-string v3, "com.huawei.android.thememanager.mvp.bean.TrialBackInfo"

    const/4 v4, 0x2

    aput-object v3, v2, v4

    .line 47
    const/4 v3, 0x0

    const/4 v4, 0x0

    :goto_8a
    if-ge v3, v0, :cond_e2

    aget-object v5, v2, v3

    .line 49
    :try_start_8e
    invoke-static {v5, v1, p1}, Ljava/lang/Class;->forName(Ljava/lang/String;ZLjava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v5

    .line 50
    nop

    .line 51
    invoke-virtual {v5}, Ljava/lang/Class;->getDeclaredMethods()[Ljava/lang/reflect/Method;

    move-result-object v6

    array-length v7, v6

    const/4 v8, 0x0

    const/4 v9, 0x0

    :goto_9a
    if-ge v8, v7, :cond_b7

    aget-object v10, v6, v8

    .line 52
    invoke-virtual {v10}, Ljava/lang/reflect/Method;->getReturnType()Ljava/lang/Class;

    move-result-object v11

    sget-object v12, Ljava/lang/Boolean;->TYPE:Ljava/lang/Class;
    :try_end_a4
    .catchall {:try_start_8e .. :try_end_a4} :catchall_dd

    if-eq v11, v12, :cond_a7

    goto :goto_b4

    .line 54
    :cond_a7
    :try_start_a7
    new-instance v11, Lcom/huawei/onekey/optimizer/hook/theme/ThemeHook$2;

    invoke-direct {v11, p0}, Lcom/huawei/onekey/optimizer/hook/theme/ThemeHook$2;-><init>(Lcom/huawei/onekey/optimizer/hook/theme/ThemeHook;)V

    invoke-static {v10, v11}, Lde/robv/android/xposed/XposedBridge;->hookMethod(Ljava/lang/reflect/Member;Lde/robv/android/xposed/XC_MethodHook;)Lde/robv/android/xposed/XC_MethodHook$Unhook;
    :try_end_af
    .catchall {:try_start_a7 .. :try_end_af} :catchall_b2

    .line 59
    add-int/lit8 v9, v9, 0x1

    .line 60
    :goto_b1
    goto :goto_b4

    :catchall_b2
    move-exception v10

    goto :goto_b1

    .line 51
    :goto_b4
    add-int/lit8 v8, v8, 0x1

    goto :goto_9a

    .line 62
    :cond_b7
    :try_start_b7
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6}, Ljava/lang/StringBuilder;-><init>()V

    const-string v7, "MatepadTC: "

    invoke-virtual {v6, v7}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v6

    invoke-virtual {v5}, Ljava/lang/Class;->getSimpleName()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v6, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    const-string v6, "="

    invoke-virtual {v5, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5, v9}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-static {v5}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/String;)V
    :try_end_db
    .catchall {:try_start_b7 .. :try_end_db} :catchall_dd

    .line 63
    add-int/2addr v4, v9

    goto :goto_de

    .line 64
    :catchall_dd
    move-exception v5

    :goto_de
    nop

    .line 47
    add-int/lit8 v3, v3, 0x1

    goto :goto_8a

    .line 67
    :cond_e2
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "MatepadTC: v10 total="

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p1}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/String;)V

    .line 69
    :cond_f8
    return-void
.end method
