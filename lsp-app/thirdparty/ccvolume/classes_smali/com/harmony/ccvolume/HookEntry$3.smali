.class Lcom/harmony/ccvolume/HookEntry$3;
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

    .line 96
    iput-object p1, p0, Lcom/harmony/ccvolume/HookEntry$3;->this$0:Lcom/harmony/ccvolume/HookEntry;

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected afterHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 5

    .line 100
    :try_start_0
    iget-object p1, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;

    check-cast p1, Landroid/view/View;

    .line 101
    invoke-virtual {p1}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v0

    .line 102
    invoke-static {v0}, Lcom/harmony/ccvolume/HookEntry;->access$200(Landroid/content/Context;)Landroid/content/Context;

    move-result-object v1

    if-nez v1, :cond_f

    return-void

    .line 106
    :cond_f
    invoke-virtual {v1}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v2

    invoke-static {p1, v0, v2}, Lcom/harmony/ccvolume/HookEntry;->access$300(Landroid/view/View;Landroid/content/Context;Landroid/content/res/Resources;)V

    .line 108
    invoke-static {}, Lcom/harmony/ccvolume/HookEntry;->access$400()Landroid/view/View;

    move-result-object v2

    if-eqz v2, :cond_31

    invoke-static {}, Lcom/harmony/ccvolume/HookEntry;->access$400()Landroid/view/View;

    move-result-object v2

    if-ne p1, v2, :cond_31

    invoke-static {}, Lcom/harmony/ccvolume/HookEntry;->access$100()Landroid/view/View;

    move-result-object v2

    if-eqz v2, :cond_31

    .line 109
    invoke-static {}, Lcom/harmony/ccvolume/HookEntry;->access$100()Landroid/view/View;

    move-result-object v2

    check-cast v2, Landroid/view/ViewGroup;

    invoke-static {p1, v2, v0}, Lcom/harmony/ccvolume/HookEntry;->access$500(Landroid/view/View;Landroid/view/ViewGroup;Landroid/content/Context;)V

    .line 111
    :cond_31
    invoke-static {}, Lcom/harmony/ccvolume/HookEntry;->access$600()Landroid/widget/ImageView;

    move-result-object p1

    invoke-static {v0, p1}, Lcom/harmony/ccvolume/HookEntry;->access$700(Landroid/content/Context;Landroid/widget/ImageView;)V

    .line 113
    invoke-static {v0, v1}, Lcom/harmony/ccvolume/HookEntry;->access$800(Landroid/content/Context;Landroid/content/Context;)V

    .line 114
    const-string p1, "brightness restyled after theme change"

    invoke-static {p1}, Lcom/harmony/ccvolume/HookEntry;->access$900(Ljava/lang/String;)V
    :try_end_40
    .catchall {:try_start_0 .. :try_end_40} :catchall_41

    goto :goto_54

    :catchall_41
    move-exception p1

    .line 116
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "restyle failed: "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p1}, Lcom/harmony/ccvolume/HookEntry;->access$900(Ljava/lang/String;)V

    :goto_54
    return-void
.end method
