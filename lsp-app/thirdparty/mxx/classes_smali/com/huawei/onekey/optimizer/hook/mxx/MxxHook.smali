.class public Lcom/huawei/onekey/optimizer/hook/mxx/MxxHook;
.super Ljava/lang/Object;
.source "MxxHook.java"

# interfaces
.implements Lde/robv/android/xposed/IXposedHookLoadPackage;


# static fields
.field private static final HOOK_FALSE:[[Ljava/lang/String;

.field private static final HOOK_TRUE:[[Ljava/lang/String;

.field private static final PKG:Ljava/lang/String; = "com.android.server.mxx."

.field private static final TAG:Ljava/lang/String; = "[MxxHook] "


# direct methods
.method static constructor <clinit>()V
    .registers 12

    .line 27
    const-string v0, "shouldPreventMxxCalled"

    const-string v1, "HwMxxFilterAmsPolicyScene"

    filled-new-array {v1, v0}, [Ljava/lang/String;

    move-result-object v2

    const-string v0, "shouldPreventMxxCalledInAnco"

    filled-new-array {v1, v0}, [Ljava/lang/String;

    move-result-object v3

    const-string v0, "shouldPreventMxxInitiativeCall"

    filled-new-array {v1, v0}, [Ljava/lang/String;

    move-result-object v4

    const-string v0, "shouldManageByPolicy"

    filled-new-array {v1, v0}, [Ljava/lang/String;

    move-result-object v5

    const-string v6, "isChinaTimezone"

    filled-new-array {v1, v6}, [Ljava/lang/String;

    move-result-object v1

    const-string v7, "shouldFilterByManagePolicy"

    const-string v8, "HwMxxFilterPolicyScene"

    filled-new-array {v8, v7}, [Ljava/lang/String;

    move-result-object v7

    const-string v9, "shouldFilterInAnco"

    filled-new-array {v8, v9}, [Ljava/lang/String;

    move-result-object v9

    filled-new-array {v8, v0}, [Ljava/lang/String;

    move-result-object v8

    const-string v10, "HwMxxManagerPolicyController"

    filled-new-array {v10, v0}, [Ljava/lang/String;

    move-result-object v10

    const-string v0, "HwMxxManagerPolicyUtils"

    filled-new-array {v0, v6}, [Ljava/lang/String;

    move-result-object v11

    move-object v6, v9

    move-object v9, v8

    move-object v8, v6

    move-object v6, v1

    filled-new-array/range {v2 .. v11}, [[Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/huawei/onekey/optimizer/hook/mxx/MxxHook;->HOOK_FALSE:[[Ljava/lang/String;

    .line 41
    const-string v0, "HwMxxManagerPolicyParser"

    const-string v1, "isInAllowlist"

    filled-new-array {v0, v1}, [Ljava/lang/String;

    move-result-object v0

    filled-new-array {v0}, [[Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/huawei/onekey/optimizer/hook/mxx/MxxHook;->HOOK_TRUE:[[Ljava/lang/String;

    return-void
.end method

.method public constructor <init>()V
    .registers 1

    .line 21
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private hookConst(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Object;)Z
    .registers 8

    .line 69
    const-string v0, "#"

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "com.android.server.mxx."

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    .line 71
    const/4 v1, 0x0

    :try_start_16
    invoke-static {p2, v1, p1}, Ljava/lang/Class;->forName(Ljava/lang/String;ZLjava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object p1

    .line 72
    new-instance v2, Lcom/huawei/onekey/optimizer/hook/mxx/MxxHook$1;

    invoke-direct {v2, p0, p4}, Lcom/huawei/onekey/optimizer/hook/mxx/MxxHook$1;-><init>(Lcom/huawei/onekey/optimizer/hook/mxx/MxxHook;Ljava/lang/Object;)V

    invoke-static {p1, p3, v2}, Lde/robv/android/xposed/XposedBridge;->hookAllMethods(Ljava/lang/Class;Ljava/lang/String;Lde/robv/android/xposed/XC_MethodHook;)Ljava/util/Set;

    .line 78
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "[MxxHook] OK   "

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v2, " -> "

    invoke-virtual {p1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, p4}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p1}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/String;)V
    :try_end_4a
    .catchall {:try_start_16 .. :try_end_4a} :catchall_4c

    .line 79
    const/4 p1, 0x1

    return p1

    .line 80
    :catchall_4c
    move-exception p1

    .line 81
    new-instance p4, Ljava/lang/StringBuilder;

    invoke-direct {p4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "[MxxHook] MISS "

    invoke-virtual {p4, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p4

    invoke-virtual {p4, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    const-string p3, " : "

    invoke-virtual {p2, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p1}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/String;)V

    .line 82
    return v1
.end method


# virtual methods
.method public handleLoadPackage(Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;)V
    .registers 13

    .line 47
    const-string v0, "android"

    iget-object v1, p1, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;->packageName:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_b

    .line 48
    return-void

    .line 51
    :cond_b
    const-string v0, "[MxxHook] ==== system_server loaded, installing Mxx hooks ===="

    invoke-static {v0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/String;)V

    .line 53
    nop

    .line 54
    sget-object v0, Lcom/huawei/onekey/optimizer/hook/mxx/MxxHook;->HOOK_FALSE:[[Ljava/lang/String;

    array-length v1, v0

    const/4 v2, 0x0

    move v3, v2

    move v4, v3

    move v5, v4

    :goto_18
    const/4 v6, 0x1

    if-ge v3, v1, :cond_33

    aget-object v7, v0, v3

    .line 55
    iget-object v8, p1, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;->classLoader:Ljava/lang/ClassLoader;

    aget-object v9, v7, v2

    aget-object v6, v7, v6

    sget-object v7, Ljava/lang/Boolean;->FALSE:Ljava/lang/Boolean;

    invoke-direct {p0, v8, v9, v6, v7}, Lcom/huawei/onekey/optimizer/hook/mxx/MxxHook;->hookConst(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Object;)Z

    move-result v6

    if-eqz v6, :cond_2e

    add-int/lit8 v5, v5, 0x1

    goto :goto_30

    :cond_2e
    add-int/lit8 v4, v4, 0x1

    .line 54
    :goto_30
    add-int/lit8 v3, v3, 0x1

    goto :goto_18

    .line 57
    :cond_33
    sget-object v0, Lcom/huawei/onekey/optimizer/hook/mxx/MxxHook;->HOOK_TRUE:[[Ljava/lang/String;

    array-length v1, v0

    move v3, v2

    :goto_37
    if-ge v3, v1, :cond_51

    aget-object v7, v0, v3

    .line 58
    iget-object v8, p1, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;->classLoader:Ljava/lang/ClassLoader;

    aget-object v9, v7, v2

    aget-object v7, v7, v6

    sget-object v10, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    invoke-direct {p0, v8, v9, v7, v10}, Lcom/huawei/onekey/optimizer/hook/mxx/MxxHook;->hookConst(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Object;)Z

    move-result v7

    if-eqz v7, :cond_4c

    add-int/lit8 v5, v5, 0x1

    goto :goto_4e

    :cond_4c
    add-int/lit8 v4, v4, 0x1

    .line 57
    :goto_4e
    add-int/lit8 v3, v3, 0x1

    goto :goto_37

    .line 61
    :cond_51
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v0, "[MxxHook] ==== done: hooked="

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v0, " missed="

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1, v4}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v0, " ===="

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p1}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/String;)V

    .line 62
    return-void
.end method
