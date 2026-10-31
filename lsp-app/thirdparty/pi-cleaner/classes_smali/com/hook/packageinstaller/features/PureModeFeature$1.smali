.class Lcom/hook/packageinstaller/features/PureModeFeature$1;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "PureModeFeature.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/hook/packageinstaller/features/PureModeFeature;->install(Lcom/hook/packageinstaller/core/HookContext;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/hook/packageinstaller/features/PureModeFeature;


# direct methods
.method constructor <init>(Lcom/hook/packageinstaller/features/PureModeFeature;)V
    .registers 2

    .line 31
    iput-object p1, p0, Lcom/hook/packageinstaller/features/PureModeFeature$1;->this$0:Lcom/hook/packageinstaller/features/PureModeFeature;

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected afterHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 2

    const/4 p0, -0x1

    .line 34
    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    invoke-virtual {p1, p0}, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->setResult(Ljava/lang/Object;)V

    return-void
.end method
