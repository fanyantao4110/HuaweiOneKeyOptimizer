.class Lcom/hook/packageinstaller/features/RiskBypassFeature$1;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "RiskBypassFeature.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/hook/packageinstaller/features/RiskBypassFeature;->hookStaging(Lcom/hook/packageinstaller/core/HookContext;Lcom/hook/packageinstaller/profiles/ProfileClasses;)V
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

    .line 61
    iput-object p1, p0, Lcom/hook/packageinstaller/features/RiskBypassFeature$1;->val$context:Lcom/hook/packageinstaller/core/HookContext;

    iput-object p2, p0, Lcom/hook/packageinstaller/features/RiskBypassFeature$1;->val$classes:Lcom/hook/packageinstaller/profiles/ProfileClasses;

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 5

    .line 64
    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;

    .line 65
    iget-object v1, p0, Lcom/hook/packageinstaller/features/RiskBypassFeature$1;->val$context:Lcom/hook/packageinstaller/core/HookContext;

    const/4 v2, 0x0

    invoke-virtual {v1, v2}, Lcom/hook/packageinstaller/core/HookContext;->clean(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v1

    if-nez v1, :cond_c

    return-void

    .line 69
    :cond_c
    iget-object p0, p0, Lcom/hook/packageinstaller/features/RiskBypassFeature$1;->val$classes:Lcom/hook/packageinstaller/profiles/ProfileClasses;

    iget-object p0, p0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->stagingContinueMethod:Ljava/lang/String;

    filled-new-array {v1}, [Ljava/lang/Object;

    move-result-object v1

    invoke-static {v0, p0, v1}, Lde/robv/android/xposed/XposedHelpers;->callMethod(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 70
    invoke-virtual {p1, v2}, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->setResult(Ljava/lang/Object;)V

    .line 71
    const-string p0, "PI-Cleaner/Risk"

    const-string p1, "Staging risk skipped, continued with clean result"

    invoke-static {p0, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method
