.class Lcom/hook/packageinstaller/features/RiskUiCleanFeature$2;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "RiskUiCleanFeature.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/hook/packageinstaller/features/RiskUiCleanFeature;->install(Lcom/hook/packageinstaller/core/HookContext;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/hook/packageinstaller/features/RiskUiCleanFeature;


# direct methods
.method constructor <init>(Lcom/hook/packageinstaller/features/RiskUiCleanFeature;)V
    .registers 2

    .line 57
    iput-object p1, p0, Lcom/hook/packageinstaller/features/RiskUiCleanFeature$2;->this$0:Lcom/hook/packageinstaller/features/RiskUiCleanFeature;

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected afterHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 2

    .line 60
    iget-object p0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;

    check-cast p0, Landroid/app/Activity;

    invoke-static {p0}, Lcom/hook/packageinstaller/features/RiskUiCleanFeature;->hide(Landroid/app/Activity;)V

    return-void
.end method
