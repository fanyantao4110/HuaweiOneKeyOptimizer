.class Lcom/hook/packageinstaller/features/AuthBypassFeature$1;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "AuthBypassFeature.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/hook/packageinstaller/features/AuthBypassFeature;->install(Lcom/hook/packageinstaller/core/HookContext;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/hook/packageinstaller/features/AuthBypassFeature;


# direct methods
.method constructor <init>(Lcom/hook/packageinstaller/features/AuthBypassFeature;)V
    .registers 2

    .line 37
    iput-object p1, p0, Lcom/hook/packageinstaller/features/AuthBypassFeature$1;->this$0:Lcom/hook/packageinstaller/features/AuthBypassFeature;

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected afterHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 2

    const/4 p0, 0x0

    .line 40
    invoke-static {p0}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object p0

    invoke-virtual {p1, p0}, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->setResult(Ljava/lang/Object;)V

    return-void
.end method
