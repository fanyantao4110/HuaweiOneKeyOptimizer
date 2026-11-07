.class Lcom/harmony/ccvolume/HookEntry$4;
.super Ljava/lang/Object;
.source "HookEntry.java"

# interfaces
.implements Landroid/view/View$OnAttachStateChangeListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/harmony/ccvolume/HookEntry;->install(Ljava/lang/Object;)V
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

    .line 198
    iput-object p1, p0, Lcom/harmony/ccvolume/HookEntry$4;->this$0:Lcom/harmony/ccvolume/HookEntry;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onViewAttachedToWindow(Landroid/view/View;)V
    .registers 2

    .line 201
    invoke-virtual {p1}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object p1

    invoke-static {p1}, Lcom/harmony/ccvolume/HookEntry;->access$1000(Landroid/content/Context;)V

    return-void
.end method

.method public onViewDetachedFromWindow(Landroid/view/View;)V
    .registers 3

    .line 206
    invoke-static {}, Lcom/harmony/ccvolume/HookEntry;->access$1100()V

    const/4 v0, 0x0

    .line 207
    invoke-static {v0}, Lcom/harmony/ccvolume/HookEntry;->access$1202(Z)Z

    .line 208
    invoke-static {v0}, Lcom/harmony/ccvolume/HookEntry;->access$1302(I)I

    .line 209
    invoke-static {}, Lcom/harmony/ccvolume/HookEntry;->access$100()Landroid/view/View;

    move-result-object v0

    if-ne v0, p1, :cond_14

    const/4 p1, 0x0

    .line 210
    invoke-static {p1}, Lcom/harmony/ccvolume/HookEntry;->access$102(Landroid/view/View;)Landroid/view/View;

    :cond_14
    return-void
.end method
