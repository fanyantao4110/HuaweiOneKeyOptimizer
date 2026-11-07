.class Lcom/harmony/ccvolume/HookEntry$10;
.super Landroid/content/BroadcastReceiver;
.source "HookEntry.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/harmony/ccvolume/HookEntry;->registerVolumeReceiver(Landroid/content/Context;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# direct methods
.method constructor <init>()V
    .registers 1

    .line 847
    invoke-direct {p0}, Landroid/content/BroadcastReceiver;-><init>()V

    return-void
.end method


# virtual methods
.method public onReceive(Landroid/content/Context;Landroid/content/Intent;)V
    .registers 4

    if-eqz p2, :cond_72

    .line 851
    :try_start_2
    const-string p1, "android.media.VOLUME_CHANGED_ACTION"

    invoke-virtual {p2}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p1, v0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-nez p1, :cond_f

    goto :goto_72

    .line 854
    :cond_f
    const-string p1, "android.media.EXTRA_VOLUME_STREAM_TYPE"

    const/4 v0, -0x1

    invoke-virtual {p2, p1, v0}, Landroid/content/Intent;->getIntExtra(Ljava/lang/String;I)I

    move-result p1

    const/4 p2, 0x3

    if-eq p1, p2, :cond_1a

    return-void

    .line 857
    :cond_1a
    invoke-static {}, Lcom/harmony/ccvolume/HookEntry;->access$2400()Landroid/media/AudioManager;

    move-result-object p1

    if-eqz p1, :cond_5e

    invoke-static {}, Lcom/harmony/ccvolume/HookEntry;->access$2600()Landroid/widget/SeekBar;

    move-result-object p1

    if-nez p1, :cond_27

    goto :goto_5e

    .line 860
    :cond_27
    invoke-static {}, Lcom/harmony/ccvolume/HookEntry;->access$1200()Z

    move-result p1

    if-eqz p1, :cond_2e

    return-void

    .line 863
    :cond_2e
    invoke-static {}, Lcom/harmony/ccvolume/HookEntry;->access$2400()Landroid/media/AudioManager;

    move-result-object p1

    invoke-virtual {p1, p2}, Landroid/media/AudioManager;->getStreamVolume(I)I

    move-result p1

    .line 864
    invoke-static {p1}, Lcom/harmony/ccvolume/HookEntry;->access$2102(I)I

    .line 865
    invoke-static {}, Lcom/harmony/ccvolume/HookEntry;->access$2600()Landroid/widget/SeekBar;

    move-result-object p2

    invoke-virtual {p2}, Landroid/widget/SeekBar;->getProgress()I

    move-result p2

    mul-int/lit8 v0, p1, 0x64

    if-eq p2, v0, :cond_72

    .line 866
    invoke-static {}, Lcom/harmony/ccvolume/HookEntry;->access$2600()Landroid/widget/SeekBar;

    move-result-object p2

    invoke-virtual {p2, v0}, Landroid/widget/SeekBar;->setProgress(I)V

    .line 867
    invoke-static {}, Lcom/harmony/ccvolume/HookEntry;->access$600()Landroid/widget/ImageView;

    move-result-object p2

    invoke-static {}, Lcom/harmony/ccvolume/HookEntry;->access$2600()Landroid/widget/SeekBar;

    move-result-object v0

    invoke-virtual {v0}, Landroid/widget/SeekBar;->getMax()I

    move-result v0

    div-int/lit8 v0, v0, 0x64

    invoke-static {p2, p1, v0}, Lcom/harmony/ccvolume/HookEntry;->access$1700(Landroid/widget/ImageView;II)V
    :try_end_5d
    .catchall {:try_start_2 .. :try_end_5d} :catchall_5f

    goto :goto_72

    :cond_5e
    :goto_5e
    return-void

    :catchall_5f
    move-exception p1

    .line 870
    new-instance p2, Ljava/lang/StringBuilder;

    const-string v0, "receiver failed: "

    invoke-direct {p2, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p1}, Lcom/harmony/ccvolume/HookEntry;->access$900(Ljava/lang/String;)V

    :cond_72
    :goto_72
    return-void
.end method
