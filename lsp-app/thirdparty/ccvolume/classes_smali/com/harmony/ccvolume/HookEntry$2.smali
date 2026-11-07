.class Lcom/harmony/ccvolume/HookEntry$2;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "HookEntry.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/harmony/ccvolume/HookEntry;->handleLoadPackage(Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/harmony/ccvolume/HookEntry;


# direct methods
.method constructor <init>(Lcom/harmony/ccvolume/HookEntry;)V
    .registers 2

    .line 85
    iput-object p1, p0, Lcom/harmony/ccvolume/HookEntry$2;->this$0:Lcom/harmony/ccvolume/HookEntry;

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected afterHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 4

    .line 88
    invoke-static {}, Lcom/harmony/ccvolume/HookEntry;->access$100()Landroid/view/View;

    move-result-object v0

    if-eqz v0, :cond_18

    .line 89
    invoke-static {}, Lcom/harmony/ccvolume/HookEntry;->access$100()Landroid/view/View;

    move-result-object v0

    iget-object p1, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    const/4 v1, 0x0

    aget-object p1, p1, v1

    check-cast p1, Ljava/lang/Float;

    invoke-virtual {p1}, Ljava/lang/Float;->floatValue()F

    move-result p1

    invoke-virtual {v0, p1}, Landroid/view/View;->setTranslationY(F)V

    :cond_18
    return-void
.end method
