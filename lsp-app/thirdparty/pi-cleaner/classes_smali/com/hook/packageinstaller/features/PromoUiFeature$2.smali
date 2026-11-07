.class Lcom/hook/packageinstaller/features/PromoUiFeature$2;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "PromoUiFeature.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/hook/packageinstaller/features/PromoUiFeature;->install(Lcom/hook/packageinstaller/core/HookContext;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/hook/packageinstaller/features/PromoUiFeature;


# direct methods
.method constructor <init>(Lcom/hook/packageinstaller/features/PromoUiFeature;)V
    .registers 2

    .line 44
    iput-object p1, p0, Lcom/hook/packageinstaller/features/PromoUiFeature$2;->this$0:Lcom/hook/packageinstaller/features/PromoUiFeature;

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected afterHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 2

    .line 47
    iget-object p0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;

    check-cast p0, Landroid/app/Activity;

    invoke-static {p0}, Lcom/hook/packageinstaller/features/PromoUiFeature;->hide(Landroid/app/Activity;)V

    return-void
.end method
