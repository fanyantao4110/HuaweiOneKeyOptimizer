.class Lcom/harmony/ccvolume/HookEntry$6;
.super Ljava/lang/Object;
.source "HookEntry.java"

# interfaces
.implements Landroid/widget/SeekBar$OnSeekBarChangeListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/harmony/ccvolume/HookEntry;->bindVolume(Landroid/content/Context;Landroid/widget/SeekBar;Landroid/widget/ImageView;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$icon:Landroid/widget/ImageView;

.field final synthetic val$maxLevel:I


# direct methods
.method constructor <init>(Landroid/widget/ImageView;I)V
    .registers 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 498
    iput-object p1, p0, Lcom/harmony/ccvolume/HookEntry$6;->val$icon:Landroid/widget/ImageView;

    iput p2, p0, Lcom/harmony/ccvolume/HookEntry$6;->val$maxLevel:I

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onProgressChanged(Landroid/widget/SeekBar;IZ)V
    .registers 6

    .line 501
    invoke-static {p1, p2}, Lcom/harmony/ccvolume/HookEntry;->access$1600(Landroid/widget/SeekBar;I)I

    move-result p1

    .line 502
    iget-object v0, p0, Lcom/harmony/ccvolume/HookEntry$6;->val$icon:Landroid/widget/ImageView;

    iget v1, p0, Lcom/harmony/ccvolume/HookEntry$6;->val$maxLevel:I

    invoke-static {v0, p1, v1}, Lcom/harmony/ccvolume/HookEntry;->access$1700(Landroid/widget/ImageView;II)V

    .line 503
    invoke-static {}, Lcom/harmony/ccvolume/HookEntry;->access$1800()Z

    move-result v0

    if-eqz v0, :cond_16

    .line 504
    iget v0, p0, Lcom/harmony/ccvolume/HookEntry$6;->val$maxLevel:I

    invoke-static {p2, p1, v0}, Lcom/harmony/ccvolume/HookEntry;->access$1900(III)V

    :cond_16
    if-nez p3, :cond_19

    return-void

    .line 509
    :cond_19
    invoke-static {}, Lcom/harmony/ccvolume/HookEntry;->access$1308()I

    .line 510
    invoke-static {}, Lcom/harmony/ccvolume/HookEntry;->access$1300()I

    move-result p2

    const/4 p3, 0x2

    if-lt p2, p3, :cond_26

    .line 511
    invoke-static {}, Lcom/harmony/ccvolume/HookEntry;->access$2000()V

    .line 513
    :cond_26
    invoke-static {}, Lcom/harmony/ccvolume/HookEntry;->access$2100()I

    move-result p2

    if-ne p1, p2, :cond_2d

    return-void

    .line 516
    :cond_2d
    invoke-static {p1}, Lcom/harmony/ccvolume/HookEntry;->access$2102(I)I

    .line 517
    invoke-static {p1}, Lcom/harmony/ccvolume/HookEntry;->access$2200(I)V

    return-void
.end method

.method public onStartTrackingTouch(Landroid/widget/SeekBar;)V
    .registers 2

    const/4 p1, 0x1

    .line 522
    invoke-static {p1}, Lcom/harmony/ccvolume/HookEntry;->access$1202(Z)Z

    const/4 p1, 0x0

    .line 523
    invoke-static {p1}, Lcom/harmony/ccvolume/HookEntry;->access$1302(I)I

    return-void
.end method

.method public onStopTrackingTouch(Landroid/widget/SeekBar;)V
    .registers 5

    const/4 v0, 0x0

    .line 528
    invoke-static {v0}, Lcom/harmony/ccvolume/HookEntry;->access$1202(Z)Z

    .line 529
    invoke-static {v0}, Lcom/harmony/ccvolume/HookEntry;->access$1302(I)I

    .line 530
    invoke-static {}, Lcom/harmony/ccvolume/HookEntry;->access$2300()V

    .line 532
    :try_start_a
    invoke-static {}, Lcom/harmony/ccvolume/HookEntry;->access$2400()Landroid/media/AudioManager;

    move-result-object v0

    const/4 v1, 0x3

    invoke-virtual {v0, v1}, Landroid/media/AudioManager;->getStreamVolume(I)I

    move-result v0

    .line 533
    invoke-static {v0}, Lcom/harmony/ccvolume/HookEntry;->access$2102(I)I

    .line 534
    invoke-virtual {p1}, Landroid/widget/SeekBar;->getProgress()I

    move-result v1

    mul-int/lit8 v2, v0, 0x64

    if-eq v1, v2, :cond_28

    .line 535
    invoke-virtual {p1, v2}, Landroid/widget/SeekBar;->setProgress(I)V

    .line 536
    iget-object p1, p0, Lcom/harmony/ccvolume/HookEntry$6;->val$icon:Landroid/widget/ImageView;

    iget v1, p0, Lcom/harmony/ccvolume/HookEntry$6;->val$maxLevel:I

    invoke-static {p1, v0, v1}, Lcom/harmony/ccvolume/HookEntry;->access$1700(Landroid/widget/ImageView;II)V
    :try_end_28
    .catchall {:try_start_a .. :try_end_28} :catchall_28

    :catchall_28
    :cond_28
    return-void
.end method
