.class Lcom/hook/packageinstaller/features/RiskBypassFeature$2;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "RiskBypassFeature.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/hook/packageinstaller/features/RiskBypassFeature;->hookConfirmation(Lcom/hook/packageinstaller/core/HookContext;Lcom/hook/packageinstaller/profiles/ProfileClasses;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$classes:Lcom/hook/packageinstaller/profiles/ProfileClasses;

.field final synthetic val$context:Lcom/hook/packageinstaller/core/HookContext;


# direct methods
.method constructor <init>(Lcom/hook/packageinstaller/core/HookContext;Lcom/hook/packageinstaller/profiles/ProfileClasses;)V
    .registers 3

    .line 93
    iput-object p1, p0, Lcom/hook/packageinstaller/features/RiskBypassFeature$2;->val$context:Lcom/hook/packageinstaller/core/HookContext;

    iput-object p2, p0, Lcom/hook/packageinstaller/features/RiskBypassFeature$2;->val$classes:Lcom/hook/packageinstaller/profiles/ProfileClasses;

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 6

    .line 97
    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    array-length v0, v0

    const/4 v1, 0x0

    if-lez v0, :cond_18

    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    aget-object v0, v0, v1

    instance-of v0, v0, Ljava/lang/Boolean;

    if-eqz v0, :cond_18

    .line 98
    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    aget-object v0, v0, v1

    check-cast v0, Ljava/lang/Boolean;

    invoke-virtual {v0}, Ljava/lang/Boolean;->booleanValue()Z

    move-result v1

    .line 100
    :cond_18
    iget-object v0, p0, Lcom/hook/packageinstaller/features/RiskBypassFeature$2;->val$context:Lcom/hook/packageinstaller/core/HookContext;

    const/4 v2, 0x0

    invoke-virtual {v0, v2}, Lcom/hook/packageinstaller/core/HookContext;->clean(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    if-nez v0, :cond_22

    return-void

    .line 104
    :cond_22
    iget-object v3, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;

    iget-object p0, p0, Lcom/hook/packageinstaller/features/RiskBypassFeature$2;->val$classes:Lcom/hook/packageinstaller/profiles/ProfileClasses;

    iget-object p0, p0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->piaSetViewMethod:Ljava/lang/String;

    .line 105
    invoke-static {v1}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v1

    filled-new-array {v0, v1}, [Ljava/lang/Object;

    move-result-object v0

    .line 104
    invoke-static {v3, p0, v0}, Lde/robv/android/xposed/XposedHelpers;->callMethod(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 106
    invoke-virtual {p1, v2}, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->setResult(Ljava/lang/Object;)V

    .line 107
    const-string p0, "PI-Cleaner/Risk"

    const-string p1, "Confirmation risk skipped, applied clean result"

    invoke-static {p0, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method
