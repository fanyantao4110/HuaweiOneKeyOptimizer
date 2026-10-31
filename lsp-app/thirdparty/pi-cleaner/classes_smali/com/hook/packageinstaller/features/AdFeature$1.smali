.class Lcom/hook/packageinstaller/features/AdFeature$1;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "AdFeature.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/hook/packageinstaller/features/AdFeature;->install(Lcom/hook/packageinstaller/core/HookContext;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/hook/packageinstaller/features/AdFeature;


# direct methods
.method constructor <init>(Lcom/hook/packageinstaller/features/AdFeature;)V
    .registers 2

    .line 38
    iput-object p1, p0, Lcom/hook/packageinstaller/features/AdFeature$1;->this$0:Lcom/hook/packageinstaller/features/AdFeature;

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected afterHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 2

    const/4 p0, 0x0

    .line 41
    invoke-static {p0}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object p0

    invoke-virtual {p1, p0}, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->setResult(Ljava/lang/Object;)V

    .line 42
    const-string p0, "PI-Cleaner/Ad"

    const-string p1, "Blocked AGD ad presentation"

    invoke-static {p0, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method
