.class Lcom/harmony/ccvolume/HookEntry$5;
.super Ljava/lang/Object;
.source "HookEntry.java"

# interfaces
.implements Ljava/lang/Runnable;


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

.field final synthetic val$fctx:Landroid/content/Context;


# direct methods
.method constructor <init>(Lcom/harmony/ccvolume/HookEntry;Landroid/content/Context;)V
    .registers 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 216
    iput-object p1, p0, Lcom/harmony/ccvolume/HookEntry$5;->this$0:Lcom/harmony/ccvolume/HookEntry;

    iput-object p2, p0, Lcom/harmony/ccvolume/HookEntry$5;->val$fctx:Landroid/content/Context;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 3

    .line 219
    iget-object v0, p0, Lcom/harmony/ccvolume/HookEntry$5;->val$fctx:Landroid/content/Context;

    invoke-static {}, Lcom/harmony/ccvolume/HookEntry;->access$600()Landroid/widget/ImageView;

    move-result-object v1

    invoke-static {v0, v1}, Lcom/harmony/ccvolume/HookEntry;->access$700(Landroid/content/Context;Landroid/widget/ImageView;)V

    .line 220
    iget-object v0, p0, Lcom/harmony/ccvolume/HookEntry$5;->val$fctx:Landroid/content/Context;

    invoke-static {}, Lcom/harmony/ccvolume/HookEntry;->access$1400()Landroid/widget/ImageView;

    move-result-object v1

    invoke-static {v0, v1}, Lcom/harmony/ccvolume/HookEntry;->access$700(Landroid/content/Context;Landroid/widget/ImageView;)V

    .line 221
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "icon tint applied="

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v1, p0, Lcom/harmony/ccvolume/HookEntry$5;->val$fctx:Landroid/content/Context;

    invoke-static {v1}, Lcom/harmony/ccvolume/HookEntry;->access$1500(Landroid/content/Context;)I

    move-result v1

    invoke-static {v1}, Ljava/lang/Integer;->toHexString(I)Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/harmony/ccvolume/HookEntry;->access$900(Ljava/lang/String;)V

    return-void
.end method
