.class Lcom/harmony/ccvolume/HookEntry$9;
.super Ljava/lang/Object;
.source "HookEntry.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/harmony/ccvolume/HookEntry;->postVolume(I)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$level:I


# direct methods
.method constructor <init>(I)V
    .registers 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 786
    iput p1, p0, Lcom/harmony/ccvolume/HookEntry$9;->val$level:I

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 5

    .line 790
    :try_start_0
    invoke-static {}, Lcom/harmony/ccvolume/HookEntry;->access$2400()Landroid/media/AudioManager;

    move-result-object v0

    iget v1, p0, Lcom/harmony/ccvolume/HookEntry$9;->val$level:I

    const/4 v2, 0x0

    const/4 v3, 0x3

    invoke-virtual {v0, v3, v1, v2}, Landroid/media/AudioManager;->setStreamVolume(III)V
    :try_end_b
    .catchall {:try_start_0 .. :try_end_b} :catchall_c

    goto :goto_1f

    :catchall_c
    move-exception v0

    .line 792
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "setStreamVolume failed: "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/harmony/ccvolume/HookEntry;->access$900(Ljava/lang/String;)V

    :goto_1f
    return-void
.end method
