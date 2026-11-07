.class public Lcom/harmony/ccvolume/HookEntry;
.super Ljava/lang/Object;
.source "HookEntry.java"

# interfaces
.implements Lde/robv/android/xposed/IXposedHookLoadPackage;


# static fields
.field private static final ACTION_VOLUME_CHANGED:Ljava/lang/String; = "android.media.VOLUME_CHANGED_ACTION"

.field private static final CLS_CCQS:Ljava/lang/String; = "com.huawei.controlcenter.qs.ControlCenterQs"

.field private static final EXTRA_VOLUME_STREAM_TYPE:Ljava/lang/String; = "android.media.EXTRA_VOLUME_STREAM_TYPE"

.field private static final MODULE_PKG:Ljava/lang/String; = "com.harmony.ccvolume"

.field private static final PKG:Ljava/lang/String; = "com.android.systemui"

.field private static final STEP:I = 0x64

.field private static final STREAM:I = 0x3

.field private static final TAG:Ljava/lang/String; = "CCVolume"

.field private static sAppliedLevel:I = -0x1

.field private static sAudio:Landroid/media/AudioManager;

.field private static sBrightnessMirror:Landroid/view/View;

.field private static sBrightnessRow:Landroid/view/View;

.field private static sBrightnessToggle:Landroid/view/View;

.field private static sDragMoves:I

.field private static sIcon:Landroid/widget/ImageView;

.field private static sMirrorAnimator:Ljava/lang/Object;

.field private static sMirrorCard:Landroid/view/View;

.field private static sMirrorIcon:Landroid/widget/ImageView;

.field private static sMirrorPanel:Landroid/view/View;

.field private static sMirrorRoot:Landroid/view/View;

.field private static sMirrorRow:Landroid/view/ViewGroup;

.field private static sMirrorSeek:Landroid/widget/SeekBar;

.field private static sMirrorShown:Z

.field private static sMirrorWrap:Landroid/view/ViewGroup;

.field private static sModuleRes:Landroid/content/res/Resources;

.field private static sReceiver:Landroid/content/BroadcastReceiver;

.field private static sRegCtx:Landroid/content/Context;

.field private static sRow:Landroid/view/View;

.field private static sSeek:Landroid/widget/SeekBar;

.field private static sTracking:Z

.field private static sVolHandler:Landroid/os/Handler;


# direct methods
.method static constructor <clinit>()V
    .registers 0

    return-void
.end method

.method public constructor <init>()V
    .registers 1

    .line 34
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static synthetic access$000(Lcom/harmony/ccvolume/HookEntry;Ljava/lang/Object;)V
    .registers 2

    .line 34
    invoke-direct {p0, p1}, Lcom/harmony/ccvolume/HookEntry;->install(Ljava/lang/Object;)V

    return-void
.end method

.method static synthetic access$100()Landroid/view/View;
    .registers 1

    .line 34
    sget-object v0, Lcom/harmony/ccvolume/HookEntry;->sRow:Landroid/view/View;

    return-object v0
.end method

.method static synthetic access$1000(Landroid/content/Context;)V
    .registers 1

    .line 34
    invoke-static {p0}, Lcom/harmony/ccvolume/HookEntry;->registerVolumeReceiver(Landroid/content/Context;)V

    return-void
.end method

.method static synthetic access$102(Landroid/view/View;)Landroid/view/View;
    .registers 1

    .line 34
    sput-object p0, Lcom/harmony/ccvolume/HookEntry;->sRow:Landroid/view/View;

    return-object p0
.end method

.method static synthetic access$1100()V
    .registers 0

    .line 34
    invoke-static {}, Lcom/harmony/ccvolume/HookEntry;->unregisterVolumeReceiver()V

    return-void
.end method

.method static synthetic access$1200()Z
    .registers 1

    .line 34
    sget-boolean v0, Lcom/harmony/ccvolume/HookEntry;->sTracking:Z

    return v0
.end method

.method static synthetic access$1202(Z)Z
    .registers 1

    .line 34
    sput-boolean p0, Lcom/harmony/ccvolume/HookEntry;->sTracking:Z

    return p0
.end method

.method static synthetic access$1300()I
    .registers 1

    .line 34
    sget v0, Lcom/harmony/ccvolume/HookEntry;->sDragMoves:I

    return v0
.end method

.method static synthetic access$1302(I)I
    .registers 1

    .line 34
    sput p0, Lcom/harmony/ccvolume/HookEntry;->sDragMoves:I

    return p0
.end method

.method static synthetic access$1308()I
    .registers 2

    .line 34
    sget v0, Lcom/harmony/ccvolume/HookEntry;->sDragMoves:I

    add-int/lit8 v1, v0, 0x1

    sput v1, Lcom/harmony/ccvolume/HookEntry;->sDragMoves:I

    return v0
.end method

.method static synthetic access$1400()Landroid/widget/ImageView;
    .registers 1

    .line 34
    sget-object v0, Lcom/harmony/ccvolume/HookEntry;->sMirrorIcon:Landroid/widget/ImageView;

    return-object v0
.end method

.method static synthetic access$1500(Landroid/content/Context;)I
    .registers 1

    .line 34
    invoke-static {p0}, Lcom/harmony/ccvolume/HookEntry;->brightnessIconColor(Landroid/content/Context;)I

    move-result p0

    return p0
.end method

.method static synthetic access$1600(Landroid/widget/SeekBar;I)I
    .registers 2

    .line 34
    invoke-static {p0, p1}, Lcom/harmony/ccvolume/HookEntry;->impliedLevel(Landroid/widget/SeekBar;I)I

    move-result p0

    return p0
.end method

.method static synthetic access$1700(Landroid/widget/ImageView;II)V
    .registers 3

    .line 34
    invoke-static {p0, p1, p2}, Lcom/harmony/ccvolume/HookEntry;->updateIcon(Landroid/widget/ImageView;II)V

    return-void
.end method

.method static synthetic access$1800()Z
    .registers 1

    .line 34
    sget-boolean v0, Lcom/harmony/ccvolume/HookEntry;->sMirrorShown:Z

    return v0
.end method

.method static synthetic access$1900(III)V
    .registers 3

    .line 34
    invoke-static {p0, p1, p2}, Lcom/harmony/ccvolume/HookEntry;->syncMirror(III)V

    return-void
.end method

.method static synthetic access$200(Landroid/content/Context;)Landroid/content/Context;
    .registers 1

    .line 34
    invoke-static {p0}, Lcom/harmony/ccvolume/HookEntry;->moduleContext(Landroid/content/Context;)Landroid/content/Context;

    move-result-object p0

    return-object p0
.end method

.method static synthetic access$2000()V
    .registers 0

    .line 34
    invoke-static {}, Lcom/harmony/ccvolume/HookEntry;->showVolumeMirror()V

    return-void
.end method

.method static synthetic access$2100()I
    .registers 1

    .line 34
    sget v0, Lcom/harmony/ccvolume/HookEntry;->sAppliedLevel:I

    return v0
.end method

.method static synthetic access$2102(I)I
    .registers 1

    .line 34
    sput p0, Lcom/harmony/ccvolume/HookEntry;->sAppliedLevel:I

    return p0
.end method

.method static synthetic access$2200(I)V
    .registers 1

    .line 34
    invoke-static {p0}, Lcom/harmony/ccvolume/HookEntry;->postVolume(I)V

    return-void
.end method

.method static synthetic access$2300()V
    .registers 0

    .line 34
    invoke-static {}, Lcom/harmony/ccvolume/HookEntry;->hideVolumeMirror()V

    return-void
.end method

.method static synthetic access$2400()Landroid/media/AudioManager;
    .registers 1

    .line 34
    sget-object v0, Lcom/harmony/ccvolume/HookEntry;->sAudio:Landroid/media/AudioManager;

    return-object v0
.end method

.method static synthetic access$2500()V
    .registers 0

    .line 34
    invoke-static {}, Lcom/harmony/ccvolume/HookEntry;->syncMirrorWidth()V

    return-void
.end method

.method static synthetic access$2600()Landroid/widget/SeekBar;
    .registers 1

    .line 34
    sget-object v0, Lcom/harmony/ccvolume/HookEntry;->sSeek:Landroid/widget/SeekBar;

    return-object v0
.end method

.method static synthetic access$300(Landroid/view/View;Landroid/content/Context;Landroid/content/res/Resources;)V
    .registers 3

    .line 34
    invoke-static {p0, p1, p2}, Lcom/harmony/ccvolume/HookEntry;->styleToggleSlider(Landroid/view/View;Landroid/content/Context;Landroid/content/res/Resources;)V

    return-void
.end method

.method static synthetic access$400()Landroid/view/View;
    .registers 1

    .line 34
    sget-object v0, Lcom/harmony/ccvolume/HookEntry;->sBrightnessToggle:Landroid/view/View;

    return-object v0
.end method

.method static synthetic access$500(Landroid/view/View;Landroid/view/ViewGroup;Landroid/content/Context;)V
    .registers 3

    .line 34
    invoke-static {p0, p1, p2}, Lcom/harmony/ccvolume/HookEntry;->copySliderLook(Landroid/view/View;Landroid/view/ViewGroup;Landroid/content/Context;)V

    return-void
.end method

.method static synthetic access$600()Landroid/widget/ImageView;
    .registers 1

    .line 34
    sget-object v0, Lcom/harmony/ccvolume/HookEntry;->sIcon:Landroid/widget/ImageView;

    return-object v0
.end method

.method static synthetic access$700(Landroid/content/Context;Landroid/widget/ImageView;)V
    .registers 2

    .line 34
    invoke-static {p0, p1}, Lcom/harmony/ccvolume/HookEntry;->tintIcon(Landroid/content/Context;Landroid/widget/ImageView;)V

    return-void
.end method

.method static synthetic access$800(Landroid/content/Context;Landroid/content/Context;)V
    .registers 2

    .line 34
    invoke-static {p0, p1}, Lcom/harmony/ccvolume/HookEntry;->restyleMirror(Landroid/content/Context;Landroid/content/Context;)V

    return-void
.end method

.method static synthetic access$900(Ljava/lang/String;)V
    .registers 1

    .line 34
    invoke-static {p0}, Lcom/harmony/ccvolume/HookEntry;->log(Ljava/lang/String;)V

    return-void
.end method

.method private static alignLeftSlot(Landroid/view/View;Landroid/view/ViewGroup;Landroid/content/Context;)V
    .registers 7

    .line 293
    const-string v0, "brightness_indicator"

    .line 0
    const-string v1, "left slot synced, w="

    .line 293
    :try_start_4
    const-string v2, "brightness_bar_left"

    invoke-static {p2, v2}, Lcom/harmony/ccvolume/HookEntry;->id(Landroid/content/Context;Ljava/lang/String;)I

    move-result v2

    invoke-virtual {p0, v2}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v2

    .line 294
    invoke-static {p2, v0}, Lcom/harmony/ccvolume/HookEntry;->id(Landroid/content/Context;Ljava/lang/String;)I

    move-result v3

    invoke-virtual {p0, v3}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p0

    if-eqz v2, :cond_1f

    .line 295
    invoke-virtual {v2}, Landroid/view/View;->getVisibility()I

    move-result v3

    if-nez v3, :cond_1f

    goto :goto_20

    :cond_1f
    move-object v2, p0

    .line 296
    :goto_20
    invoke-static {p2, v0}, Lcom/harmony/ccvolume/HookEntry;->id(Landroid/content/Context;Ljava/lang/String;)I

    move-result p0

    invoke-virtual {p1, p0}, Landroid/view/ViewGroup;->findViewById(I)Landroid/view/View;

    move-result-object p0

    if-eqz v2, :cond_82

    if-nez p0, :cond_2d

    goto :goto_82

    .line 300
    :cond_2d
    invoke-virtual {v2}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object p1

    .line 301
    invoke-virtual {p0}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object p2

    .line 302
    instance-of v0, p1, Landroid/view/ViewGroup$MarginLayoutParams;

    if-eqz v0, :cond_82

    instance-of v0, p2, Landroid/view/ViewGroup$MarginLayoutParams;

    if-nez v0, :cond_3e

    goto :goto_82

    .line 306
    :cond_3e
    move-object v0, p1

    check-cast v0, Landroid/view/ViewGroup$MarginLayoutParams;

    .line 307
    move-object v2, p2

    check-cast v2, Landroid/view/ViewGroup$MarginLayoutParams;

    .line 308
    iget v3, p1, Landroid/view/ViewGroup$LayoutParams;->width:I

    if-lez v3, :cond_4c

    .line 309
    iget p1, p1, Landroid/view/ViewGroup$LayoutParams;->width:I

    iput p1, v2, Landroid/view/ViewGroup$MarginLayoutParams;->width:I

    .line 311
    :cond_4c
    invoke-virtual {v0}, Landroid/view/ViewGroup$MarginLayoutParams;->getMarginStart()I

    move-result p1

    invoke-virtual {v2, p1}, Landroid/view/ViewGroup$MarginLayoutParams;->setMarginStart(I)V

    .line 312
    invoke-virtual {p0, p2}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 313
    instance-of p1, p0, Landroid/widget/ImageView;

    if-eqz p1, :cond_61

    .line 315
    check-cast p0, Landroid/widget/ImageView;

    sget-object p1, Landroid/widget/ImageView$ScaleType;->CENTER:Landroid/widget/ImageView$ScaleType;

    invoke-virtual {p0, p1}, Landroid/widget/ImageView;->setScaleType(Landroid/widget/ImageView$ScaleType;)V

    .line 317
    :cond_61
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget p1, v2, Landroid/view/ViewGroup$MarginLayoutParams;->width:I

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p0

    const-string p1, " marginStart="

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {v2}, Landroid/view/ViewGroup$MarginLayoutParams;->getMarginStart()I

    move-result p1

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/harmony/ccvolume/HookEntry;->log(Ljava/lang/String;)V
    :try_end_81
    .catchall {:try_start_4 .. :try_end_81} :catchall_83

    goto :goto_96

    :cond_82
    :goto_82
    return-void

    :catchall_83
    move-exception p0

    .line 319
    new-instance p1, Ljava/lang/StringBuilder;

    const-string p2, "alignLeftSlot failed: "

    invoke-direct {p1, p2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/harmony/ccvolume/HookEntry;->log(Ljava/lang/String;)V

    :goto_96
    return-void
.end method

.method private static applyEndMargin(Landroid/view/View;Landroid/content/Context;I)V
    .registers 4

    .line 279
    :try_start_0
    const-string v0, "slider"

    invoke-static {p1, v0}, Lcom/harmony/ccvolume/HookEntry;->id(Landroid/content/Context;Ljava/lang/String;)I

    move-result p1

    invoke-virtual {p0, p1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p0

    if-eqz p0, :cond_34

    .line 280
    invoke-virtual {p0}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object p1

    instance-of p1, p1, Landroid/view/ViewGroup$MarginLayoutParams;

    if-eqz p1, :cond_34

    .line 282
    invoke-virtual {p0}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object p1

    check-cast p1, Landroid/view/ViewGroup$MarginLayoutParams;

    .line 283
    invoke-virtual {p1, p2}, Landroid/view/ViewGroup$MarginLayoutParams;->setMarginEnd(I)V

    .line 284
    invoke-virtual {p0, p1}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V
    :try_end_20
    .catchall {:try_start_0 .. :try_end_20} :catchall_21

    goto :goto_34

    :catchall_21
    move-exception p0

    .line 287
    new-instance p1, Ljava/lang/StringBuilder;

    const-string p2, "applyEndMargin failed: "

    invoke-direct {p1, p2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/harmony/ccvolume/HookEntry;->log(Ljava/lang/String;)V

    :cond_34
    :goto_34
    return-void
.end method

.method private static bindVolume(Landroid/content/Context;Landroid/widget/SeekBar;Landroid/widget/ImageView;)V
    .registers 5

    .line 490
    sget-object p0, Lcom/harmony/ccvolume/HookEntry;->sAudio:Landroid/media/AudioManager;

    const/4 v0, 0x3

    invoke-virtual {p0, v0}, Landroid/media/AudioManager;->getStreamMaxVolume(I)I

    move-result p0

    .line 491
    sget-object v1, Lcom/harmony/ccvolume/HookEntry;->sAudio:Landroid/media/AudioManager;

    invoke-virtual {v1, v0}, Landroid/media/AudioManager;->getStreamVolume(I)I

    move-result v0

    .line 492
    sput v0, Lcom/harmony/ccvolume/HookEntry;->sAppliedLevel:I

    const/4 v1, 0x0

    .line 493
    sput-boolean v1, Lcom/harmony/ccvolume/HookEntry;->sTracking:Z

    const/4 v1, 0x1

    .line 494
    invoke-static {p0, v1}, Ljava/lang/Math;->max(II)I

    move-result v1

    mul-int/lit8 v1, v1, 0x64

    invoke-virtual {p1, v1}, Landroid/widget/SeekBar;->setMax(I)V

    mul-int/lit8 v1, v0, 0x64

    .line 495
    invoke-virtual {p1, v1}, Landroid/widget/SeekBar;->setProgress(I)V

    .line 496
    invoke-static {p2, v0, p0}, Lcom/harmony/ccvolume/HookEntry;->updateIcon(Landroid/widget/ImageView;II)V

    .line 498
    new-instance v0, Lcom/harmony/ccvolume/HookEntry$6;

    invoke-direct {v0, p2, p0}, Lcom/harmony/ccvolume/HookEntry$6;-><init>(Landroid/widget/ImageView;I)V

    invoke-virtual {p1, v0}, Landroid/widget/SeekBar;->setOnSeekBarChangeListener(Landroid/widget/SeekBar$OnSeekBarChangeListener;)V

    return-void
.end method

.method private static brightnessIconColor(Landroid/content/Context;)I
    .registers 7

    .line 404
    :try_start_0
    invoke-static {p0}, Lcom/harmony/ccvolume/HookEntry;->sunView(Landroid/content/Context;)Landroid/view/View;

    move-result-object v0

    if-eqz v0, :cond_57

    const/4 v1, 0x2

    .line 407
    new-array v2, v1, [Ljava/lang/String;

    const-string v3, "mLinePaint"

    const/4 v4, 0x0

    aput-object v3, v2, v4

    const-string v3, "mRadiusPaint"

    const/4 v5, 0x1

    aput-object v3, v2, v5

    :goto_13
    if-ge v4, v1, :cond_2b

    aget-object v3, v2, v4
    :try_end_17
    .catchall {:try_start_0 .. :try_end_17} :catchall_44

    .line 409
    :try_start_17
    invoke-static {v0, v3}, Lde/robv/android/xposed/XposedHelpers;->getObjectField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v3

    .line 410
    instance-of v5, v3, Landroid/graphics/Paint;

    if-eqz v5, :cond_28

    .line 411
    check-cast v3, Landroid/graphics/Paint;

    invoke-virtual {v3}, Landroid/graphics/Paint;->getColor()I

    move-result v3
    :try_end_25
    .catchall {:try_start_17 .. :try_end_25} :catchall_28

    if-eqz v3, :cond_28

    return v3

    :catchall_28
    :cond_28
    add-int/lit8 v4, v4, 0x1

    goto :goto_13

    .line 419
    :cond_2b
    :try_start_2b
    invoke-virtual {v0}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v0

    .line 420
    invoke-virtual {v0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v1

    const-string v2, "brightness_bar_left_color"

    const-string v3, "color"

    const-string v4, "com.android.systemui"

    invoke-virtual {v1, v2, v3, v4}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result v1

    if-eqz v1, :cond_57

    .line 423
    invoke-virtual {v0, v1}, Landroid/content/Context;->getColor(I)I

    move-result p0
    :try_end_43
    .catchall {:try_start_2b .. :try_end_43} :catchall_44

    return p0

    :catchall_44
    move-exception v0

    .line 427
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "brightnessIconColor failed: "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/harmony/ccvolume/HookEntry;->log(Ljava/lang/String;)V

    .line 429
    :cond_57
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/res/Resources;->getConfiguration()Landroid/content/res/Configuration;

    move-result-object p0

    iget p0, p0, Landroid/content/res/Configuration;->uiMode:I

    and-int/lit8 p0, p0, 0x30

    const/16 v0, 0x20

    if-ne p0, v0, :cond_6b

    const p0, -0x221c17

    goto :goto_6e

    :cond_6b
    const p0, -0xa09c98

    :goto_6e
    return p0
.end method

.method private static centerMirrorOn(Landroid/view/View;)V
    .registers 8

    .line 753
    sget-object v0, Lcom/harmony/ccvolume/HookEntry;->sMirrorCard:Landroid/view/View;

    if-eqz v0, :cond_68

    if-nez p0, :cond_7

    goto :goto_68

    :cond_7
    const/4 v1, 0x0

    .line 756
    invoke-virtual {v0, v1}, Landroid/view/View;->setTranslationX(F)V

    .line 757
    sget-object v0, Lcom/harmony/ccvolume/HookEntry;->sMirrorCard:Landroid/view/View;

    invoke-virtual {v0, v1}, Landroid/view/View;->setTranslationY(F)V

    .line 758
    sget-object v0, Lcom/harmony/ccvolume/HookEntry;->sMirrorCard:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getWidth()I

    move-result v0

    if-lez v0, :cond_68

    invoke-virtual {p0}, Landroid/view/View;->getWidth()I

    move-result v0

    if-gtz v0, :cond_1f

    goto :goto_68

    :cond_1f
    const/4 v0, 0x2

    .line 761
    new-array v1, v0, [I

    .line 762
    new-array v0, v0, [I

    .line 763
    invoke-virtual {p0, v1}, Landroid/view/View;->getLocationInWindow([I)V

    .line 764
    sget-object v2, Lcom/harmony/ccvolume/HookEntry;->sMirrorCard:Landroid/view/View;

    invoke-virtual {v2, v0}, Landroid/view/View;->getLocationInWindow([I)V

    .line 765
    sget-object v2, Lcom/harmony/ccvolume/HookEntry;->sMirrorCard:Landroid/view/View;

    const/4 v3, 0x0

    aget v4, v1, v3

    int-to-float v4, v4

    .line 766
    invoke-virtual {p0}, Landroid/view/View;->getWidth()I

    move-result v5

    int-to-float v5, v5

    const/high16 v6, 0x40000000  # 2.0f

    div-float/2addr v5, v6

    add-float/2addr v4, v5

    aget v3, v0, v3

    int-to-float v3, v3

    sget-object v5, Lcom/harmony/ccvolume/HookEntry;->sMirrorCard:Landroid/view/View;

    invoke-virtual {v5}, Landroid/view/View;->getWidth()I

    move-result v5

    int-to-float v5, v5

    div-float/2addr v5, v6

    add-float/2addr v3, v5

    sub-float/2addr v4, v3

    .line 765
    invoke-virtual {v2, v4}, Landroid/view/View;->setTranslationX(F)V

    .line 767
    sget-object v2, Lcom/harmony/ccvolume/HookEntry;->sMirrorCard:Landroid/view/View;

    const/4 v3, 0x1

    aget v1, v1, v3

    int-to-float v1, v1

    .line 768
    invoke-virtual {p0}, Landroid/view/View;->getHeight()I

    move-result p0

    int-to-float p0, p0

    div-float/2addr p0, v6

    add-float/2addr v1, p0

    aget p0, v0, v3

    int-to-float p0, p0

    sget-object v0, Lcom/harmony/ccvolume/HookEntry;->sMirrorCard:Landroid/view/View;

    invoke-virtual {v0}, Landroid/view/View;->getHeight()I

    move-result v0

    int-to-float v0, v0

    div-float/2addr v0, v6

    add-float/2addr p0, v0

    sub-float/2addr v1, p0

    .line 767
    invoke-virtual {v2, v1}, Landroid/view/View;->setTranslationY(F)V

    :cond_68
    :goto_68
    return-void
.end method

.method private static copySliderLook(Landroid/view/View;Landroid/view/ViewGroup;Landroid/content/Context;)V
    .registers 8

    .line 325
    const-string v0, "mMinHeight"

    const-string v1, "mMaxHeight"

    const-string v2, "slider"

    :try_start_6
    invoke-static {p2, v2}, Lcom/harmony/ccvolume/HookEntry;->id(Landroid/content/Context;Ljava/lang/String;)I

    move-result v3

    invoke-virtual {p0, v3}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p0

    .line 326
    invoke-static {p2, v2}, Lcom/harmony/ccvolume/HookEntry;->id(Landroid/content/Context;Ljava/lang/String;)I

    move-result p2

    invoke-virtual {p1, p2}, Landroid/view/ViewGroup;->findViewById(I)Landroid/view/View;

    move-result-object p1

    .line 327
    instance-of p2, p0, Landroid/widget/SeekBar;

    if-eqz p2, :cond_84

    instance-of p2, p1, Landroid/widget/SeekBar;

    if-nez p2, :cond_1f

    goto :goto_84

    .line 330
    :cond_1f
    check-cast p0, Landroid/widget/SeekBar;

    .line 331
    check-cast p1, Landroid/widget/SeekBar;

    .line 333
    invoke-virtual {p0}, Landroid/widget/SeekBar;->getPaddingLeft()I

    move-result p2

    invoke-virtual {p0}, Landroid/widget/SeekBar;->getPaddingTop()I

    move-result v2

    .line 334
    invoke-virtual {p0}, Landroid/widget/SeekBar;->getPaddingRight()I

    move-result v3

    invoke-virtual {p0}, Landroid/widget/SeekBar;->getPaddingBottom()I

    move-result v4

    .line 333
    invoke-virtual {p1, p2, v2, v3, v4}, Landroid/widget/SeekBar;->setPadding(IIII)V

    .line 335
    invoke-virtual {p0}, Landroid/widget/SeekBar;->getSplitTrack()Z

    move-result p2

    invoke-virtual {p1, p2}, Landroid/widget/SeekBar;->setSplitTrack(Z)V

    const/4 p2, 0x0

    .line 337
    invoke-virtual {p1, p2}, Landroid/widget/SeekBar;->setProgressTintList(Landroid/content/res/ColorStateList;)V

    .line 338
    invoke-virtual {p1, p2}, Landroid/widget/SeekBar;->setProgressBackgroundTintList(Landroid/content/res/ColorStateList;)V

    .line 339
    invoke-virtual {p1, p2}, Landroid/widget/SeekBar;->setSecondaryProgressTintList(Landroid/content/res/ColorStateList;)V

    .line 340
    invoke-virtual {p1, p2}, Landroid/widget/SeekBar;->setThumbTintList(Landroid/content/res/ColorStateList;)V

    .line 342
    invoke-virtual {p0}, Landroid/widget/SeekBar;->getProgressDrawable()Landroid/graphics/drawable/Drawable;

    move-result-object p2

    if-eqz p2, :cond_6a

    .line 343
    invoke-virtual {p2}, Landroid/graphics/drawable/Drawable;->getConstantState()Landroid/graphics/drawable/Drawable$ConstantState;

    move-result-object v2

    if-eqz v2, :cond_6a

    .line 345
    invoke-virtual {p2}, Landroid/graphics/drawable/Drawable;->getConstantState()Landroid/graphics/drawable/Drawable$ConstantState;

    move-result-object p2

    invoke-virtual {p2}, Landroid/graphics/drawable/Drawable$ConstantState;->newDrawable()Landroid/graphics/drawable/Drawable;

    move-result-object p2

    invoke-virtual {p2}, Landroid/graphics/drawable/Drawable;->mutate()Landroid/graphics/drawable/Drawable;

    move-result-object p2

    const/16 v2, 0xff

    .line 346
    invoke-virtual {p2, v2}, Landroid/graphics/drawable/Drawable;->setAlpha(I)V

    .line 347
    invoke-virtual {p1, p2}, Landroid/widget/SeekBar;->setProgressDrawable(Landroid/graphics/drawable/Drawable;)V

    .line 350
    :cond_6a
    invoke-static {p0, v1}, Lde/robv/android/xposed/XposedHelpers;->getIntField(Ljava/lang/Object;Ljava/lang/String;)I

    move-result p2

    invoke-static {p1, v1, p2}, Lde/robv/android/xposed/XposedHelpers;->setIntField(Ljava/lang/Object;Ljava/lang/String;I)V

    .line 351
    invoke-static {p0, v0}, Lde/robv/android/xposed/XposedHelpers;->getIntField(Ljava/lang/Object;Ljava/lang/String;)I

    move-result p0

    invoke-static {p1, v0, p0}, Lde/robv/android/xposed/XposedHelpers;->setIntField(Ljava/lang/Object;Ljava/lang/String;I)V

    .line 353
    invoke-virtual {p1}, Landroid/widget/SeekBar;->requestLayout()V

    .line 354
    invoke-virtual {p1}, Landroid/widget/SeekBar;->invalidate()V

    .line 355
    const-string p0, "slider look copied"

    invoke-static {p0}, Lcom/harmony/ccvolume/HookEntry;->log(Ljava/lang/String;)V
    :try_end_83
    .catchall {:try_start_6 .. :try_end_83} :catchall_85

    goto :goto_98

    :cond_84
    :goto_84
    return-void

    :catchall_85
    move-exception p0

    .line 357
    new-instance p1, Ljava/lang/StringBuilder;

    const-string p2, "copySliderLook failed: "

    invoke-direct {p1, p2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/harmony/ccvolume/HookEntry;->log(Ljava/lang/String;)V

    :goto_98
    return-void
.end method

.method private static dimenPx(Landroid/content/Context;Ljava/lang/String;I)I
    .registers 6

    .line 939
    :try_start_0
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    .line 940
    const-string v1, "dimen"

    const-string v2, "com.android.systemui"

    invoke-virtual {v0, p1, v1, v2}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result p1

    if-eqz p1, :cond_13

    .line 942
    invoke-virtual {v0, p1}, Landroid/content/res/Resources;->getDimensionPixelSize(I)I

    move-result p0
    :try_end_12
    .catchall {:try_start_0 .. :try_end_12} :catchall_13

    return p0

    :catchall_13
    :cond_13
    int-to-float p1, p2

    .line 946
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object p0

    iget p0, p0, Landroid/util/DisplayMetrics;->density:F

    mul-float/2addr p1, p0

    invoke-static {p1}, Ljava/lang/Math;->round(F)I

    move-result p0

    return p0
.end method

.method private static gone(Landroid/view/ViewGroup;Landroid/content/Context;Ljava/lang/String;)V
    .registers 3

    .line 483
    invoke-static {p1, p2}, Lcom/harmony/ccvolume/HookEntry;->id(Landroid/content/Context;Ljava/lang/String;)I

    move-result p1

    invoke-virtual {p0, p1}, Landroid/view/ViewGroup;->findViewById(I)Landroid/view/View;

    move-result-object p0

    if-eqz p0, :cond_f

    const/16 p1, 0x8

    .line 485
    invoke-virtual {p0, p1}, Landroid/view/View;->setVisibility(I)V

    :cond_f
    return-void
.end method

.method private static hideRightIcon(Landroid/view/View;Landroid/content/Context;)I
    .registers 5

    const/4 v0, 0x0

    .line 255
    :try_start_1
    const-string v1, "brightness_bar_right"

    invoke-static {p1, v1}, Lcom/harmony/ccvolume/HookEntry;->id(Landroid/content/Context;Ljava/lang/String;)I

    move-result v1

    invoke-virtual {p0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p0

    if-eqz p0, :cond_42

    .line 257
    invoke-virtual {p0}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v1

    if-eqz v1, :cond_19

    .line 258
    iget v2, v1, Landroid/view/ViewGroup$LayoutParams;->width:I

    if-lez v2, :cond_19

    .line 259
    iget v0, v1, Landroid/view/ViewGroup$LayoutParams;->width:I

    .line 261
    :cond_19
    instance-of v2, v1, Landroid/view/ViewGroup$MarginLayoutParams;

    if-eqz v2, :cond_29

    .line 262
    check-cast v1, Landroid/view/ViewGroup$MarginLayoutParams;

    .line 263
    invoke-virtual {v1}, Landroid/view/ViewGroup$MarginLayoutParams;->getMarginStart()I

    move-result v2

    invoke-virtual {v1}, Landroid/view/ViewGroup$MarginLayoutParams;->getMarginEnd()I

    move-result v1

    add-int/2addr v2, v1

    add-int/2addr v0, v2

    :cond_29
    const/16 v1, 0x8

    .line 265
    invoke-virtual {p0, v1}, Landroid/view/View;->setVisibility(I)V
    :try_end_2e
    .catchall {:try_start_1 .. :try_end_2e} :catchall_2f

    goto :goto_42

    :catchall_2f
    move-exception p0

    .line 268
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "hideRightIcon failed: "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/harmony/ccvolume/HookEntry;->log(Ljava/lang/String;)V

    :cond_42
    :goto_42
    if-gtz v0, :cond_55

    .line 272
    invoke-virtual {p1}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object p0

    iget p0, p0, Landroid/util/DisplayMetrics;->density:F

    const/high16 p1, 0x42300000  # 44.0f

    mul-float/2addr p0, p1

    invoke-static {p0}, Ljava/lang/Math;->round(F)I

    move-result v0

    :cond_55
    return v0
.end method

.method private static hideVolumeMirror()V
    .registers 6

    .line 730
    sget-boolean v0, Lcom/harmony/ccvolume/HookEntry;->sMirrorShown:Z

    if-eqz v0, :cond_35

    sget-object v0, Lcom/harmony/ccvolume/HookEntry;->sMirrorCard:Landroid/view/View;

    if-nez v0, :cond_9

    goto :goto_35

    :cond_9
    const/4 v0, 0x0

    .line 733
    sput-boolean v0, Lcom/harmony/ccvolume/HookEntry;->sMirrorShown:Z

    .line 735
    :try_start_c
    sget-object v1, Lcom/harmony/ccvolume/HookEntry;->sMirrorAnimator:Ljava/lang/Object;

    const-string v2, "startBrightnessMirrorAnimation"

    .line 736
    invoke-static {v0}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v0

    sget-object v3, Lcom/harmony/ccvolume/HookEntry;->sMirrorCard:Landroid/view/View;

    sget-object v4, Lcom/harmony/ccvolume/HookEntry;->sMirrorRoot:Landroid/view/View;

    sget-object v5, Lcom/harmony/ccvolume/HookEntry;->sMirrorPanel:Landroid/view/View;

    filled-new-array {v0, v3, v4, v5}, [Ljava/lang/Object;

    move-result-object v0

    .line 735
    invoke-static {v1, v2, v0}, Lde/robv/android/xposed/XposedHelpers;->callMethod(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;
    :try_end_21
    .catchall {:try_start_c .. :try_end_21} :catchall_22

    goto :goto_35

    :catchall_22
    move-exception v0

    .line 738
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "hide mirror failed: "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/harmony/ccvolume/HookEntry;->log(Ljava/lang/String;)V

    :cond_35
    :goto_35
    return-void
.end method

.method private static id(Landroid/content/Context;Ljava/lang/String;)I
    .registers 4

    .line 931
    :try_start_0
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    const-string v0, "id"

    const-string v1, "com.android.systemui"

    invoke-virtual {p0, p1, v0, v1}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result p0
    :try_end_c
    .catchall {:try_start_0 .. :try_end_c} :catchall_d

    return p0

    :catchall_d
    const/4 p0, 0x0

    return p0
.end method

.method private static impliedLevel(Landroid/widget/SeekBar;I)I
    .registers 3

    .line 799
    invoke-virtual {p0}, Landroid/widget/SeekBar;->getMax()I

    move-result p0

    .line 800
    div-int/lit8 v0, p0, 0x64

    if-gtz p1, :cond_a

    const/4 p0, 0x0

    return p0

    :cond_a
    if-lt p1, p0, :cond_d

    return v0

    :cond_d
    int-to-float p1, p1

    int-to-float p0, p0

    div-float/2addr p1, p0

    add-int/lit8 v0, v0, -0x1

    int-to-float p0, v0

    mul-float/2addr p1, p0

    float-to-int p0, p1

    add-int/lit8 p0, p0, 0x1

    return p0
.end method

.method private install(Ljava/lang/Object;)V
    .registers 13

    const-string v0, "volume row installed, rowHeight="

    .line 128
    :try_start_2
    const-string v1, "mSliderContainer"

    invoke-static {p1, v1}, Lde/robv/android/xposed/XposedHelpers;->getObjectField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/widget/FrameLayout;

    .line 129
    const-string v2, "mQsBrightnessView"

    invoke-static {p1, v2}, Lde/robv/android/xposed/XposedHelpers;->getObjectField(Ljava/lang/Object;Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/view/View;

    if-eqz v1, :cond_11c

    if-nez v2, :cond_18

    goto/16 :goto_11c

    .line 134
    :cond_18
    check-cast p1, Landroid/view/View;

    invoke-virtual {p1}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object p1

    .line 135
    invoke-static {p1}, Lcom/harmony/ccvolume/HookEntry;->isRowEnabled(Landroid/content/Context;)Z

    move-result v3

    if-nez v3, :cond_2a

    .line 136
    const-string p1, "volume row disabled by user"

    invoke-static {p1}, Lcom/harmony/ccvolume/HookEntry;->log(Ljava/lang/String;)V

    return-void

    .line 139
    :cond_2a
    invoke-static {p1}, Lcom/harmony/ccvolume/HookEntry;->moduleContext(Landroid/content/Context;)Landroid/content/Context;

    move-result-object v3

    if-nez v3, :cond_31

    return-void

    .line 143
    :cond_31
    invoke-virtual {v3}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v4

    .line 144
    sput-object v4, Lcom/harmony/ccvolume/HookEntry;->sModuleRes:Landroid/content/res/Resources;

    .line 145
    const-string v5, "brightness_height"

    const/16 v6, 0x20

    invoke-static {p1, v5, v6}, Lcom/harmony/ccvolume/HookEntry;->dimenPx(Landroid/content/Context;Ljava/lang/String;I)I

    move-result v5

    const/4 v6, 0x0

    .line 147
    invoke-static {v2, p1, v6}, Lcom/harmony/ccvolume/HookEntry;->styleBrightness(Landroid/view/View;Landroid/content/Context;Landroid/content/res/Resources;)V

    .line 148
    const-string v7, "brightness_slider"

    invoke-static {p1, v7}, Lcom/harmony/ccvolume/HookEntry;->id(Landroid/content/Context;Ljava/lang/String;)I

    move-result v7

    invoke-virtual {v2, v7}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v7

    sput-object v7, Lcom/harmony/ccvolume/HookEntry;->sBrightnessToggle:Landroid/view/View;

    .line 149
    sput-object v2, Lcom/harmony/ccvolume/HookEntry;->sBrightnessRow:Landroid/view/View;

    .line 151
    invoke-virtual {p1}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v7

    const-string v8, "hw_status_bar_toggle_slider"

    const-string v9, "layout"

    const-string v10, "com.android.systemui"

    invoke-virtual {v7, v8, v9, v10}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result v7

    if-nez v7, :cond_67

    .line 154
    const-string p1, "volume layout not found"

    invoke-static {p1}, Lcom/harmony/ccvolume/HookEntry;->log(Ljava/lang/String;)V

    return-void

    .line 157
    :cond_67
    invoke-static {p1}, Lcom/harmony/ccvolume/HookEntry;->themeCtx(Landroid/content/Context;)Landroid/content/Context;

    move-result-object v8

    invoke-static {v8}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;

    move-result-object v8

    const/4 v9, 0x0

    invoke-virtual {v8, v7, v6, v9}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;Z)Landroid/view/View;

    move-result-object v6

    .line 158
    instance-of v7, v6, Landroid/view/ViewGroup;

    if-nez v7, :cond_7e

    .line 159
    const-string p1, "volume row root unexpected"

    invoke-static {p1}, Lcom/harmony/ccvolume/HookEntry;->log(Ljava/lang/String;)V

    return-void

    .line 162
    :cond_7e
    move-object v7, v6

    check-cast v7, Landroid/view/ViewGroup;

    .line 164
    const-string v8, "label"

    invoke-static {v2, v7, p1, v8}, Lcom/harmony/ccvolume/HookEntry;->syncVisibility(Landroid/view/View;Landroid/view/View;Landroid/content/Context;Ljava/lang/String;)V

    .line 165
    const-string v8, "toggle"

    invoke-static {v2, v7, p1, v8}, Lcom/harmony/ccvolume/HookEntry;->syncVisibility(Landroid/view/View;Landroid/view/View;Landroid/content/Context;Ljava/lang/String;)V

    .line 167
    invoke-static {v2, v7, p1}, Lcom/harmony/ccvolume/HookEntry;->alignLeftSlot(Landroid/view/View;Landroid/view/ViewGroup;Landroid/content/Context;)V

    .line 169
    invoke-static {v7, p1}, Lcom/harmony/ccvolume/HookEntry;->hideRightIcon(Landroid/view/View;Landroid/content/Context;)I

    move-result v8

    invoke-static {v7, p1, v8}, Lcom/harmony/ccvolume/HookEntry;->applyEndMargin(Landroid/view/View;Landroid/content/Context;I)V

    .line 171
    const-string v8, "brightness_indicator"

    invoke-static {p1, v8}, Lcom/harmony/ccvolume/HookEntry;->id(Landroid/content/Context;Ljava/lang/String;)I

    move-result v8

    invoke-virtual {v7, v8}, Landroid/view/ViewGroup;->findViewById(I)Landroid/view/View;

    move-result-object v8

    check-cast v8, Landroid/widget/ImageView;

    sput-object v8, Lcom/harmony/ccvolume/HookEntry;->sIcon:Landroid/widget/ImageView;

    .line 172
    const-string v8, "slider"

    invoke-static {p1, v8}, Lcom/harmony/ccvolume/HookEntry;->id(Landroid/content/Context;Ljava/lang/String;)I

    move-result v8

    invoke-virtual {v7, v8}, Landroid/view/ViewGroup;->findViewById(I)Landroid/view/View;

    move-result-object v8

    check-cast v8, Landroid/widget/SeekBar;

    sput-object v8, Lcom/harmony/ccvolume/HookEntry;->sSeek:Landroid/widget/SeekBar;

    .line 173
    const-string v8, "audio"

    invoke-virtual {p1, v8}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v8

    check-cast v8, Landroid/media/AudioManager;

    sput-object v8, Lcom/harmony/ccvolume/HookEntry;->sAudio:Landroid/media/AudioManager;

    .line 174
    sget-object v9, Lcom/harmony/ccvolume/HookEntry;->sSeek:Landroid/widget/SeekBar;

    if-eqz v9, :cond_116

    if-nez v8, :cond_c2

    goto :goto_116

    .line 179
    :cond_c2
    invoke-static {v2, v7, p1}, Lcom/harmony/ccvolume/HookEntry;->copySliderLook(Landroid/view/View;Landroid/view/ViewGroup;Landroid/content/Context;)V

    .line 180
    sget-object v7, Lcom/harmony/ccvolume/HookEntry;->sSeek:Landroid/widget/SeekBar;

    sget-object v8, Lcom/harmony/ccvolume/HookEntry;->sIcon:Landroid/widget/ImageView;

    invoke-static {p1, v7, v8}, Lcom/harmony/ccvolume/HookEntry;->bindVolume(Landroid/content/Context;Landroid/widget/SeekBar;Landroid/widget/ImageView;)V

    .line 181
    invoke-static {p1, v3, v4}, Lcom/harmony/ccvolume/HookEntry;->setupVolumeMirror(Landroid/content/Context;Landroid/content/Context;Landroid/content/res/Resources;)V

    .line 183
    new-instance v3, Landroid/widget/FrameLayout$LayoutParams;

    const/16 v4, 0x30

    const/4 v7, -0x1

    invoke-direct {v3, v7, v5, v4}, Landroid/widget/FrameLayout$LayoutParams;-><init>(III)V

    .line 185
    invoke-virtual {v2, v3}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 187
    new-instance v2, Landroid/widget/FrameLayout$LayoutParams;

    const/16 v3, 0x50

    invoke-direct {v2, v7, v5, v3}, Landroid/widget/FrameLayout$LayoutParams;-><init>(III)V

    .line 189
    invoke-virtual {v1, v6, v2}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 191
    invoke-virtual {v1}, Landroid/widget/FrameLayout;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v2

    if-eqz v2, :cond_f1

    mul-int/lit8 v3, v5, 0x2

    .line 193
    iput v3, v2, Landroid/view/ViewGroup$LayoutParams;->height:I

    .line 194
    invoke-virtual {v1, v2}, Landroid/widget/FrameLayout;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 197
    :cond_f1
    sput-object v6, Lcom/harmony/ccvolume/HookEntry;->sRow:Landroid/view/View;

    .line 198
    new-instance v1, Lcom/harmony/ccvolume/HookEntry$4;

    invoke-direct {v1, p0}, Lcom/harmony/ccvolume/HookEntry$4;-><init>(Lcom/harmony/ccvolume/HookEntry;)V

    invoke-virtual {v6, v1}, Landroid/view/View;->addOnAttachStateChangeListener(Landroid/view/View$OnAttachStateChangeListener;)V

    .line 216
    new-instance v1, Lcom/harmony/ccvolume/HookEntry$5;

    invoke-direct {v1, p0, p1}, Lcom/harmony/ccvolume/HookEntry$5;-><init>(Lcom/harmony/ccvolume/HookEntry;Landroid/content/Context;)V

    const-wide/16 v2, 0x4b0

    invoke-virtual {v6, v1, v2, v3}, Landroid/view/View;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 225
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1, v5}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p1}, Lcom/harmony/ccvolume/HookEntry;->log(Ljava/lang/String;)V

    goto :goto_135

    .line 175
    :cond_116
    :goto_116
    const-string p1, "volume slider/audio null"

    invoke-static {p1}, Lcom/harmony/ccvolume/HookEntry;->log(Ljava/lang/String;)V

    return-void

    .line 131
    :cond_11c
    :goto_11c
    const-string p1, "container/brightness null"

    invoke-static {p1}, Lcom/harmony/ccvolume/HookEntry;->log(Ljava/lang/String;)V
    :try_end_121
    .catchall {:try_start_2 .. :try_end_121} :catchall_122

    return-void

    :catchall_122
    move-exception p1

    .line 227
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "install failed: "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p1}, Lcom/harmony/ccvolume/HookEntry;->log(Ljava/lang/String;)V

    :goto_135
    return-void
.end method

.method private static isRowEnabled(Landroid/content/Context;)Z
    .registers 3

    const-string v0, "hook_ccvolume"

    const/4 v1, 0x1

    invoke-static {v0, v1}, Lcom/huawei/onekey/optimizer/hook/HookFlags;->enabled(Ljava/lang/String;Z)Z

    move-result v0

    return v0
.end method

.method private static log(Ljava/lang/String;)V
    .registers 3

    .line 950
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "CCVolume: "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lde/robv/android/xposed/XposedBridge;->log(Ljava/lang/String;)V

    return-void
.end method

.method private static moduleContext(Landroid/content/Context;)Landroid/content/Context;
    .registers 3

    .line 922
    :try_start_0
    const-string v0, "com.harmony.ccvolume"

    const/4 v1, 0x2

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->createPackageContext(Ljava/lang/String;I)Landroid/content/Context;

    move-result-object p0
    :try_end_7
    .catchall {:try_start_0 .. :try_end_7} :catchall_8

    return-object p0

    :catchall_8
    move-exception p0

    .line 924
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "createPackageContext failed: "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/harmony/ccvolume/HookEntry;->log(Ljava/lang/String;)V

    const/4 p0, 0x0

    return-object p0
.end method

.method private static moduleRes(Landroid/content/Context;Landroid/content/Context;)Landroid/content/res/Resources;
    .registers 2

    .line 450
    :try_start_0
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/res/Resources;->getConfiguration()Landroid/content/res/Configuration;

    move-result-object p0

    .line 449
    invoke-virtual {p1, p0}, Landroid/content/Context;->createConfigurationContext(Landroid/content/res/Configuration;)Landroid/content/Context;

    move-result-object p0

    if-eqz p0, :cond_13

    .line 451
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    goto :goto_17

    :cond_13
    invoke-virtual {p1}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0
    :try_end_17
    .catchall {:try_start_0 .. :try_end_17} :catchall_18

    :goto_17
    return-object p0

    .line 453
    :catchall_18
    invoke-virtual {p1}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    return-object p0
.end method

.method private static postVolume(I)V
    .registers 4

    .line 772
    sget-object v0, Lcom/harmony/ccvolume/HookEntry;->sVolHandler:Landroid/os/Handler;

    if-nez v0, :cond_35

    .line 774
    :try_start_4
    new-instance v0, Landroid/os/HandlerThread;

    const-string v1, "ccvolume"

    invoke-direct {v0, v1}, Landroid/os/HandlerThread;-><init>(Ljava/lang/String;)V

    .line 775
    invoke-virtual {v0}, Landroid/os/HandlerThread;->start()V

    .line 776
    new-instance v1, Landroid/os/Handler;

    invoke-virtual {v0}, Landroid/os/HandlerThread;->getLooper()Landroid/os/Looper;

    move-result-object v0

    invoke-direct {v1, v0}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    sput-object v1, Lcom/harmony/ccvolume/HookEntry;->sVolHandler:Landroid/os/Handler;
    :try_end_19
    .catchall {:try_start_4 .. :try_end_19} :catchall_1a

    goto :goto_35

    :catchall_1a
    move-exception v0

    .line 778
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "volume thread failed: "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/harmony/ccvolume/HookEntry;->log(Ljava/lang/String;)V

    .line 780
    :try_start_2d
    sget-object v0, Lcom/harmony/ccvolume/HookEntry;->sAudio:Landroid/media/AudioManager;

    const/4 v1, 0x3

    const/4 v2, 0x0

    invoke-virtual {v0, v1, p0, v2}, Landroid/media/AudioManager;->setStreamVolume(III)V
    :try_end_34
    .catchall {:try_start_2d .. :try_end_34} :catchall_34

    :catchall_34
    return-void

    .line 786
    :cond_35
    :goto_35
    sget-object v0, Lcom/harmony/ccvolume/HookEntry;->sVolHandler:Landroid/os/Handler;

    new-instance v1, Lcom/harmony/ccvolume/HookEntry$9;

    invoke-direct {v1, p0}, Lcom/harmony/ccvolume/HookEntry$9;-><init>(I)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method private static registerVolumeReceiver(Landroid/content/Context;)V
    .registers 4

    .line 844
    sget-object v0, Lcom/harmony/ccvolume/HookEntry;->sReceiver:Landroid/content/BroadcastReceiver;

    if-eqz v0, :cond_5

    return-void

    .line 847
    :cond_5
    new-instance v0, Lcom/harmony/ccvolume/HookEntry$10;

    invoke-direct {v0}, Lcom/harmony/ccvolume/HookEntry$10;-><init>()V

    sput-object v0, Lcom/harmony/ccvolume/HookEntry;->sReceiver:Landroid/content/BroadcastReceiver;

    .line 875
    :try_start_c
    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object v0

    if-eqz v0, :cond_16

    invoke-virtual {p0}, Landroid/content/Context;->getApplicationContext()Landroid/content/Context;

    move-result-object p0

    .line 876
    :cond_16
    sget-object v0, Lcom/harmony/ccvolume/HookEntry;->sReceiver:Landroid/content/BroadcastReceiver;

    new-instance v1, Landroid/content/IntentFilter;

    const-string v2, "android.media.VOLUME_CHANGED_ACTION"

    invoke-direct {v1, v2}, Landroid/content/IntentFilter;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;)Landroid/content/Intent;

    .line 877
    sput-object p0, Lcom/harmony/ccvolume/HookEntry;->sRegCtx:Landroid/content/Context;
    :try_end_24
    .catchall {:try_start_c .. :try_end_24} :catchall_25

    goto :goto_28

    :catchall_25
    const/4 p0, 0x0

    .line 879
    sput-object p0, Lcom/harmony/ccvolume/HookEntry;->sReceiver:Landroid/content/BroadcastReceiver;

    :goto_28
    return-void
.end method

.method private static restyleMirror(Landroid/content/Context;Landroid/content/Context;)V
    .registers 5

    .line 459
    :try_start_0
    sget-object v0, Lcom/harmony/ccvolume/HookEntry;->sMirrorCard:Landroid/view/View;

    if-nez v0, :cond_5

    return-void

    :cond_5
    if-eqz p1, :cond_1d

    .line 462
    sget-object v0, Lcom/harmony/ccvolume/HookEntry;->sMirrorWrap:Landroid/view/ViewGroup;

    if-eqz v0, :cond_1d

    .line 463
    invoke-static {p0, p1}, Lcom/harmony/ccvolume/HookEntry;->moduleRes(Landroid/content/Context;Landroid/content/Context;)Landroid/content/res/Resources;

    move-result-object p1

    if-eqz p1, :cond_1d

    .line 465
    sget-object v0, Lcom/harmony/ccvolume/HookEntry;->sMirrorWrap:Landroid/view/ViewGroup;

    invoke-static {p0}, Lcom/huawei/onekey/optimizer/hook/ccvolume/CcVolumeRes;->mirrorBg(Landroid/content/Context;)I

    move-result v1

    const/4 v2, 0x0

    invoke-virtual {p1, v1, v2}, Landroid/content/res/Resources;->getDrawable(ILandroid/content/res/Resources$Theme;)Landroid/graphics/drawable/Drawable;

    move-result-object p1

    invoke-virtual {v0, p1}, Landroid/view/ViewGroup;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 468
    :cond_1d
    sget-object p1, Lcom/harmony/ccvolume/HookEntry;->sBrightnessToggle:Landroid/view/View;

    if-eqz p1, :cond_22

    goto :goto_24

    :cond_22
    sget-object p1, Lcom/harmony/ccvolume/HookEntry;->sBrightnessMirror:Landroid/view/View;

    :goto_24
    if-eqz p1, :cond_34

    .line 469
    sget-object v0, Lcom/harmony/ccvolume/HookEntry;->sMirrorRow:Landroid/view/ViewGroup;

    if-eqz v0, :cond_34

    .line 470
    invoke-static {p1, v0, p0}, Lcom/harmony/ccvolume/HookEntry;->copySliderLook(Landroid/view/View;Landroid/view/ViewGroup;Landroid/content/Context;)V

    .line 471
    sget-object p1, Lcom/harmony/ccvolume/HookEntry;->sMirrorSeek:Landroid/widget/SeekBar;

    if-eqz p1, :cond_34

    .line 472
    invoke-virtual {p1}, Landroid/widget/SeekBar;->invalidate()V

    .line 475
    :cond_34
    sget-object p1, Lcom/harmony/ccvolume/HookEntry;->sMirrorIcon:Landroid/widget/ImageView;

    invoke-static {p0, p1}, Lcom/harmony/ccvolume/HookEntry;->tintIcon(Landroid/content/Context;Landroid/widget/ImageView;)V

    .line 476
    const-string p0, "mirror restyled"

    invoke-static {p0}, Lcom/harmony/ccvolume/HookEntry;->log(Ljava/lang/String;)V
    :try_end_3e
    .catchall {:try_start_0 .. :try_end_3e} :catchall_3f

    goto :goto_52

    :catchall_3f
    move-exception p0

    .line 478
    new-instance p1, Ljava/lang/StringBuilder;

    const-string v0, "restyleMirror failed: "

    invoke-direct {p1, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/harmony/ccvolume/HookEntry;->log(Ljava/lang/String;)V

    :goto_52
    return-void
.end method

.method private static setupVolumeMirror(Landroid/content/Context;Landroid/content/Context;Landroid/content/res/Resources;)V
    .registers 15

    .line 546
    const-string p1, "com.android.systemui"

    .line 0
    const-string v0, "mirror: set background failed: "

    .line 546
    :try_start_4
    invoke-virtual {p0}, Landroid/content/Context;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v1

    .line 547
    const-string v2, "com.android.systemui.plugins.Dependency"

    invoke-static {v2, v1}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v2

    .line 548
    const-string v3, "com.android.systemui.statusbar.phone.StatusBar"

    invoke-static {v3, v1}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v3

    .line 549
    const-string v4, "get"

    filled-new-array {v3}, [Ljava/lang/Object;

    move-result-object v3

    invoke-static {v2, v4, v3}, Lde/robv/android/xposed/XposedHelpers;->callStaticMethod(Ljava/lang/Class;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    if-nez v2, :cond_26

    .line 551
    const-string p0, "mirror: no status bar"

    invoke-static {p0}, Lcom/harmony/ccvolume/HookEntry;->log(Ljava/lang/String;)V

    return-void

    .line 554
    :cond_26
    const-string v3, "getMirrorController"

    const/4 v4, 0x0

    new-array v5, v4, [Ljava/lang/Object;

    invoke-static {v2, v3, v5}, Lde/robv/android/xposed/XposedHelpers;->callMethod(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    if-nez v2, :cond_37

    .line 556
    const-string p0, "mirror: no controller"

    invoke-static {p0}, Lcom/harmony/ccvolume/HookEntry;->log(Ljava/lang/String;)V

    return-void

    .line 559
    :cond_37
    const-string v3, "getMirror"

    new-array v5, v4, [Ljava/lang/Object;

    invoke-static {v2, v3, v5}, Lde/robv/android/xposed/XposedHelpers;->callMethod(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v2

    check-cast v2, Landroid/view/View;

    if-eqz v2, :cond_1c4

    .line 560
    invoke-virtual {v2}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v3

    instance-of v3, v3, Landroid/view/ViewGroup;

    if-nez v3, :cond_4d

    goto/16 :goto_1c4

    .line 564
    :cond_4d
    invoke-virtual {v2}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v3

    check-cast v3, Landroid/view/ViewGroup;

    .line 565
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v5

    const-string v6, "control_center_content"

    const-string v7, "id"

    invoke-virtual {v5, v6, v7, p1}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result v5

    const/4 v6, 0x0

    if-eqz v5, :cond_67

    .line 566
    invoke-virtual {v3, v5}, Landroid/view/ViewGroup;->findViewById(I)Landroid/view/View;

    move-result-object v5

    goto :goto_68

    :cond_67
    move-object v5, v6

    :goto_68
    if-nez v5, :cond_70

    .line 568
    const-string p0, "mirror: no panel view"

    invoke-static {p0}, Lcom/harmony/ccvolume/HookEntry;->log(Ljava/lang/String;)V

    return-void

    .line 572
    :cond_70
    const-string v7, "brightness_mirror_view"

    invoke-static {p0, v7}, Lcom/harmony/ccvolume/HookEntry;->id(Landroid/content/Context;Ljava/lang/String;)I

    move-result v7

    invoke-virtual {v2, v7}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v7

    if-eqz v7, :cond_7d

    goto :goto_7e

    :cond_7d
    move-object v7, v2

    .line 573
    :goto_7e
    sput-object v7, Lcom/harmony/ccvolume/HookEntry;->sBrightnessMirror:Landroid/view/View;

    .line 575
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object v7

    const-string v8, "hw_status_bar_toggle_slider"

    const-string v9, "layout"

    invoke-virtual {v7, v8, v9, p1}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result p1

    if-nez p1, :cond_94

    .line 578
    const-string p0, "mirror: layout not found"

    invoke-static {p0}, Lcom/harmony/ccvolume/HookEntry;->log(Ljava/lang/String;)V

    return-void

    .line 581
    :cond_94
    invoke-static {p0}, Lcom/harmony/ccvolume/HookEntry;->themeCtx(Landroid/content/Context;)Landroid/content/Context;

    move-result-object v7

    invoke-static {v7}, Landroid/view/LayoutInflater;->from(Landroid/content/Context;)Landroid/view/LayoutInflater;

    move-result-object v7

    invoke-virtual {v7, p1, v6, v4}, Landroid/view/LayoutInflater;->inflate(ILandroid/view/ViewGroup;Z)Landroid/view/View;

    move-result-object p1

    .line 582
    instance-of v7, p1, Landroid/view/ViewGroup;

    if-nez v7, :cond_aa

    .line 583
    const-string p0, "mirror: row root unexpected"

    invoke-static {p0}, Lcom/harmony/ccvolume/HookEntry;->log(Ljava/lang/String;)V

    return-void

    .line 586
    :cond_aa
    move-object v7, p1

    check-cast v7, Landroid/view/ViewGroup;

    .line 587
    const-string v8, "toggle"

    invoke-static {v7, p0, v8}, Lcom/harmony/ccvolume/HookEntry;->gone(Landroid/view/ViewGroup;Landroid/content/Context;Ljava/lang/String;)V

    .line 588
    const-string v8, "label"

    invoke-static {v7, p0, v8}, Lcom/harmony/ccvolume/HookEntry;->gone(Landroid/view/ViewGroup;Landroid/content/Context;Ljava/lang/String;)V

    .line 590
    const-string v8, "brightness_slider"

    invoke-static {p0, v8}, Lcom/harmony/ccvolume/HookEntry;->id(Landroid/content/Context;Ljava/lang/String;)I

    move-result v8

    invoke-virtual {v2, v8}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v8

    if-nez v8, :cond_c4

    move-object v8, v2

    .line 595
    :cond_c4
    invoke-static {v8, p0, p2}, Lcom/harmony/ccvolume/HookEntry;->styleToggleSlider(Landroid/view/View;Landroid/content/Context;Landroid/content/res/Resources;)V

    .line 596
    invoke-static {v8, v7, p0}, Lcom/harmony/ccvolume/HookEntry;->alignLeftSlot(Landroid/view/View;Landroid/view/ViewGroup;Landroid/content/Context;)V

    .line 598
    invoke-static {v8, v7, p0}, Lcom/harmony/ccvolume/HookEntry;->copySliderLook(Landroid/view/View;Landroid/view/ViewGroup;Landroid/content/Context;)V

    .line 600
    invoke-static {v7, p0}, Lcom/harmony/ccvolume/HookEntry;->hideRightIcon(Landroid/view/View;Landroid/content/Context;)I

    move-result v8

    invoke-static {v7, p0, v8}, Lcom/harmony/ccvolume/HookEntry;->applyEndMargin(Landroid/view/View;Landroid/content/Context;I)V

    .line 601
    const-string v8, "mirror row aligned"

    invoke-static {v8}, Lcom/harmony/ccvolume/HookEntry;->log(Ljava/lang/String;)V

    .line 602
    const-string v8, "slider"

    invoke-static {p0, v8}, Lcom/harmony/ccvolume/HookEntry;->id(Landroid/content/Context;Ljava/lang/String;)I

    move-result v8

    invoke-virtual {v7, v8}, Landroid/view/ViewGroup;->findViewById(I)Landroid/view/View;

    move-result-object v8

    check-cast v8, Landroid/widget/SeekBar;
    :try_end_e5
    .catchall {:try_start_4 .. :try_end_e5} :catchall_1ca

    const/4 v9, 0x1

    if-eqz v8, :cond_111

    .line 606
    :try_start_e8
    sget-object v10, Lcom/harmony/ccvolume/HookEntry;->sAudio:Landroid/media/AudioManager;

    const/4 v11, 0x3

    invoke-virtual {v10, v11}, Landroid/media/AudioManager;->getStreamMaxVolume(I)I

    move-result v10

    invoke-static {v10, v9}, Ljava/lang/Math;->max(II)I

    move-result v10

    mul-int/lit8 v10, v10, 0x64

    .line 607
    invoke-virtual {v8, v10}, Landroid/widget/SeekBar;->setMax(I)V

    .line 608
    sget-object v10, Lcom/harmony/ccvolume/HookEntry;->sAudio:Landroid/media/AudioManager;

    invoke-virtual {v10, v11}, Landroid/media/AudioManager;->getStreamVolume(I)I

    move-result v10

    mul-int/lit8 v10, v10, 0x64

    invoke-virtual {v8, v10}, Landroid/widget/SeekBar;->setProgress(I)V
    :try_end_103
    .catchall {:try_start_e8 .. :try_end_103} :catchall_103

    .line 612
    :catchall_103
    :try_start_103
    invoke-virtual {v8, v4}, Landroid/widget/SeekBar;->setFocusable(Z)V

    .line 613
    invoke-virtual {v8, v4}, Landroid/widget/SeekBar;->setClickable(Z)V

    .line 614
    new-instance v10, Lcom/harmony/ccvolume/HookEntry$7;

    invoke-direct {v10}, Lcom/harmony/ccvolume/HookEntry$7;-><init>()V

    invoke-virtual {v8, v10}, Landroid/widget/SeekBar;->setOnTouchListener(Landroid/view/View$OnTouchListener;)V

    .line 621
    :cond_111
    const-string v10, "brightness_indicator"

    invoke-static {p0, v10}, Lcom/harmony/ccvolume/HookEntry;->id(Landroid/content/Context;Ljava/lang/String;)I

    move-result v10

    invoke-virtual {v7, v10}, Landroid/view/ViewGroup;->findViewById(I)Landroid/view/View;

    move-result-object v10

    check-cast v10, Landroid/widget/ImageView;

    .line 623
    new-instance v11, Landroid/widget/LinearLayout;

    invoke-direct {v11, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    .line 624
    invoke-virtual {v11, v9}, Landroid/widget/LinearLayout;->setOrientation(I)V
    :try_end_125
    .catchall {:try_start_103 .. :try_end_125} :catchall_1ca

    .line 627
    :try_start_125
    invoke-static {p0}, Lcom/huawei/onekey/optimizer/hook/ccvolume/CcVolumeRes;->mirrorBg(Landroid/content/Context;)I

    move-result v9

    invoke-virtual {p2, v9, v6}, Landroid/content/res/Resources;->getDrawable(ILandroid/content/res/Resources$Theme;)Landroid/graphics/drawable/Drawable;

    move-result-object p2

    invoke-virtual {v11, p2}, Landroid/widget/LinearLayout;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 628
    invoke-virtual {p0}, Landroid/content/Context;->getResources()Landroid/content/res/Resources;

    move-result-object p2

    invoke-virtual {p2}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object p2

    iget p2, p2, Landroid/util/DisplayMetrics;->density:F

    const/high16 v6, 0x40800000  # 4.0f

    mul-float/2addr p2, v6

    invoke-virtual {v11, p2}, Landroid/widget/LinearLayout;->setElevation(F)V
    :try_end_13e
    .catchall {:try_start_125 .. :try_end_13e} :catchall_13f

    goto :goto_150

    :catchall_13f
    move-exception p2

    .line 630
    :try_start_140
    new-instance v6, Ljava/lang/StringBuilder;

    invoke-direct {v6, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v6, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object p2

    invoke-virtual {p2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p2

    invoke-static {p2}, Lcom/harmony/ccvolume/HookEntry;->log(Ljava/lang/String;)V

    .line 632
    :goto_150
    invoke-virtual {v11, v4, v4, v4, v4}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    const/16 p2, 0x10

    .line 633
    invoke-virtual {v11, p2}, Landroid/widget/LinearLayout;->setGravity(I)V

    .line 634
    new-instance p2, Landroid/widget/LinearLayout$LayoutParams;

    const-string v0, "brightness_height"

    const/16 v6, 0x20

    .line 635
    invoke-static {p0, v0, v6}, Lcom/harmony/ccvolume/HookEntry;->dimenPx(Landroid/content/Context;Ljava/lang/String;I)I

    move-result v0

    const/4 v6, -0x1

    invoke-direct {p2, v6, v0}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    .line 634
    invoke-virtual {v11, p1, p2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 637
    new-instance p1, Landroid/widget/FrameLayout;

    invoke-direct {p1, p0}, Landroid/widget/FrameLayout;-><init>(Landroid/content/Context;)V

    .line 638
    new-instance p2, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {p2, v6, v6}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {p1, v11, p2}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 640
    new-instance p2, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v0, -0x2

    invoke-direct {p2, v0, v0}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    .line 642
    invoke-virtual {v2}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    instance-of v0, v0, Landroid/widget/FrameLayout$LayoutParams;

    if-eqz v0, :cond_18e

    .line 643
    invoke-virtual {v2}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v0

    check-cast v0, Landroid/widget/FrameLayout$LayoutParams;

    iget v0, v0, Landroid/widget/FrameLayout$LayoutParams;->gravity:I

    iput v0, p2, Landroid/widget/FrameLayout$LayoutParams;->gravity:I

    :cond_18e
    const/4 v0, 0x4

    .line 645
    invoke-virtual {p1, v0}, Landroid/widget/FrameLayout;->setVisibility(I)V

    .line 646
    invoke-virtual {v3, p1, p2}, Landroid/view/ViewGroup;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 648
    sput-object p1, Lcom/harmony/ccvolume/HookEntry;->sMirrorCard:Landroid/view/View;

    .line 649
    sput-object v11, Lcom/harmony/ccvolume/HookEntry;->sMirrorWrap:Landroid/view/ViewGroup;

    .line 650
    sput-object v7, Lcom/harmony/ccvolume/HookEntry;->sMirrorRow:Landroid/view/ViewGroup;

    .line 651
    sput-object v8, Lcom/harmony/ccvolume/HookEntry;->sMirrorSeek:Landroid/widget/SeekBar;

    .line 652
    sput-object v10, Lcom/harmony/ccvolume/HookEntry;->sMirrorIcon:Landroid/widget/ImageView;

    .line 653
    invoke-static {p0, v10}, Lcom/harmony/ccvolume/HookEntry;->tintIcon(Landroid/content/Context;Landroid/widget/ImageView;)V

    .line 654
    sput-object v3, Lcom/harmony/ccvolume/HookEntry;->sMirrorRoot:Landroid/view/View;

    .line 655
    sput-object v5, Lcom/harmony/ccvolume/HookEntry;->sMirrorPanel:Landroid/view/View;

    .line 656
    sput-boolean v4, Lcom/harmony/ccvolume/HookEntry;->sMirrorShown:Z

    .line 657
    const-string p0, "com.android.systemui.statusbar.policy.BrightnessMirrorAnimator"

    invoke-static {p0, v1}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object p0

    new-array p2, v4, [Ljava/lang/Object;

    invoke-static {p0, p2}, Lde/robv/android/xposed/XposedHelpers;->newInstance(Ljava/lang/Class;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    sput-object p0, Lcom/harmony/ccvolume/HookEntry;->sMirrorAnimator:Ljava/lang/Object;

    .line 660
    new-instance p0, Lcom/harmony/ccvolume/HookEntry$8;

    invoke-direct {p0}, Lcom/harmony/ccvolume/HookEntry$8;-><init>()V

    invoke-virtual {p1, p0}, Landroid/widget/FrameLayout;->post(Ljava/lang/Runnable;)Z

    .line 666
    const-string p0, "volume mirror ready"

    invoke-static {p0}, Lcom/harmony/ccvolume/HookEntry;->log(Ljava/lang/String;)V

    goto :goto_1dd

    .line 561
    :cond_1c4
    :goto_1c4
    const-string p0, "mirror: no mirror view"

    invoke-static {p0}, Lcom/harmony/ccvolume/HookEntry;->log(Ljava/lang/String;)V
    :try_end_1c9
    .catchall {:try_start_140 .. :try_end_1c9} :catchall_1ca

    return-void

    :catchall_1ca
    move-exception p0

    .line 668
    new-instance p1, Ljava/lang/StringBuilder;

    const-string p2, "setupVolumeMirror failed: "

    invoke-direct {p1, p2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/harmony/ccvolume/HookEntry;->log(Ljava/lang/String;)V

    :goto_1dd
    return-void
.end method

.method private static showVolumeMirror()V
    .registers 6

    .line 708
    invoke-static {}, Lcom/harmony/ccvolume/HookEntry;->syncMirrorWidth()V

    .line 709
    sget-object v0, Lcom/harmony/ccvolume/HookEntry;->sMirrorCard:Landroid/view/View;

    if-eqz v0, :cond_78

    sget-boolean v0, Lcom/harmony/ccvolume/HookEntry;->sMirrorShown:Z

    if-nez v0, :cond_78

    sget-object v0, Lcom/harmony/ccvolume/HookEntry;->sSeek:Landroid/widget/SeekBar;

    if-nez v0, :cond_10

    goto :goto_78

    .line 712
    :cond_10
    invoke-static {}, Lcom/harmony/ccvolume/HookEntry;->syncMirrorWidth()V

    .line 713
    sget-object v0, Lcom/harmony/ccvolume/HookEntry;->sMirrorSeek:Landroid/widget/SeekBar;

    if-eqz v0, :cond_42

    .line 714
    sget-object v1, Lcom/harmony/ccvolume/HookEntry;->sSeek:Landroid/widget/SeekBar;

    invoke-virtual {v1}, Landroid/widget/SeekBar;->getMax()I

    move-result v1

    invoke-virtual {v0, v1}, Landroid/widget/SeekBar;->setMax(I)V

    .line 715
    sget-object v0, Lcom/harmony/ccvolume/HookEntry;->sMirrorSeek:Landroid/widget/SeekBar;

    sget-object v1, Lcom/harmony/ccvolume/HookEntry;->sSeek:Landroid/widget/SeekBar;

    invoke-virtual {v1}, Landroid/widget/SeekBar;->getProgress()I

    move-result v1

    invoke-virtual {v0, v1}, Landroid/widget/SeekBar;->setProgress(I)V

    .line 716
    sget-object v0, Lcom/harmony/ccvolume/HookEntry;->sMirrorIcon:Landroid/widget/ImageView;

    sget-object v1, Lcom/harmony/ccvolume/HookEntry;->sSeek:Landroid/widget/SeekBar;

    invoke-virtual {v1}, Landroid/widget/SeekBar;->getProgress()I

    move-result v2

    invoke-static {v1, v2}, Lcom/harmony/ccvolume/HookEntry;->impliedLevel(Landroid/widget/SeekBar;I)I

    move-result v1

    sget-object v2, Lcom/harmony/ccvolume/HookEntry;->sSeek:Landroid/widget/SeekBar;

    invoke-virtual {v2}, Landroid/widget/SeekBar;->getMax()I

    move-result v2

    div-int/lit8 v2, v2, 0x64

    invoke-static {v0, v1, v2}, Lcom/harmony/ccvolume/HookEntry;->updateIcon(Landroid/widget/ImageView;II)V

    .line 718
    :cond_42
    sget-object v0, Lcom/harmony/ccvolume/HookEntry;->sRow:Landroid/view/View;

    invoke-static {v0}, Lcom/harmony/ccvolume/HookEntry;->centerMirrorOn(Landroid/view/View;)V

    const/4 v0, 0x1

    .line 719
    sput-boolean v0, Lcom/harmony/ccvolume/HookEntry;->sMirrorShown:Z

    .line 721
    :try_start_4a
    sget-object v1, Lcom/harmony/ccvolume/HookEntry;->sMirrorAnimator:Ljava/lang/Object;

    const-string v2, "startBrightnessMirrorAnimation"

    .line 722
    invoke-static {v0}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    move-result-object v0

    sget-object v3, Lcom/harmony/ccvolume/HookEntry;->sMirrorCard:Landroid/view/View;

    sget-object v4, Lcom/harmony/ccvolume/HookEntry;->sMirrorRoot:Landroid/view/View;

    sget-object v5, Lcom/harmony/ccvolume/HookEntry;->sMirrorPanel:Landroid/view/View;

    filled-new-array {v0, v3, v4, v5}, [Ljava/lang/Object;

    move-result-object v0

    .line 721
    invoke-static {v1, v2, v0}, Lde/robv/android/xposed/XposedHelpers;->callMethod(Ljava/lang/Object;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    .line 723
    const-string v0, "mirror shown"

    invoke-static {v0}, Lcom/harmony/ccvolume/HookEntry;->log(Ljava/lang/String;)V
    :try_end_64
    .catchall {:try_start_4a .. :try_end_64} :catchall_65

    goto :goto_78

    :catchall_65
    move-exception v0

    .line 725
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "show mirror failed: "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/harmony/ccvolume/HookEntry;->log(Ljava/lang/String;)V

    :cond_78
    :goto_78
    return-void
.end method

.method private static styleBrightness(Landroid/view/View;Landroid/content/Context;Landroid/content/res/Resources;)V
    .registers 4

    .line 233
    :try_start_0
    const-string v0, "brightness_slider"

    invoke-static {p1, v0}, Lcom/harmony/ccvolume/HookEntry;->id(Landroid/content/Context;Ljava/lang/String;)I

    move-result v0

    invoke-virtual {p0, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p0

    if-nez p0, :cond_d

    return-void

    .line 237
    :cond_d
    invoke-static {p0, p1, p2}, Lcom/harmony/ccvolume/HookEntry;->styleToggleSlider(Landroid/view/View;Landroid/content/Context;Landroid/content/res/Resources;)V
    :try_end_10
    .catchall {:try_start_0 .. :try_end_10} :catchall_11

    goto :goto_24

    :catchall_11
    move-exception p0

    .line 239
    new-instance p1, Ljava/lang/StringBuilder;

    const-string p2, "styleBrightness failed: "

    invoke-direct {p1, p2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/harmony/ccvolume/HookEntry;->log(Ljava/lang/String;)V

    :goto_24
    return-void
.end method

.method private static styleToggleSlider(Landroid/view/View;Landroid/content/Context;Landroid/content/res/Resources;)V
    .registers 3

    .line 245
    :try_start_0
    invoke-static {p0, p1}, Lcom/harmony/ccvolume/HookEntry;->hideRightIcon(Landroid/view/View;Landroid/content/Context;)I

    move-result p2

    .line 246
    invoke-static {p0, p1, p2}, Lcom/harmony/ccvolume/HookEntry;->applyEndMargin(Landroid/view/View;Landroid/content/Context;I)V
    :try_end_7
    .catchall {:try_start_0 .. :try_end_7} :catchall_8

    goto :goto_1b

    :catchall_8
    move-exception p0

    .line 248
    new-instance p1, Ljava/lang/StringBuilder;

    const-string p2, "styleToggleSlider failed: "

    invoke-direct {p1, p2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/harmony/ccvolume/HookEntry;->log(Ljava/lang/String;)V

    :goto_1b
    return-void
.end method

.method private static sunView(Landroid/content/Context;)Landroid/view/View;
    .registers 4

    .line 387
    sget-object v0, Lcom/harmony/ccvolume/HookEntry;->sBrightnessToggle:Landroid/view/View;

    if-nez v0, :cond_6

    const/4 p0, 0x0

    return-object p0

    .line 391
    :cond_6
    const-string v1, "brightness_bar_left"

    invoke-static {p0, v1}, Lcom/harmony/ccvolume/HookEntry;->id(Landroid/content/Context;Ljava/lang/String;)I

    move-result v1

    invoke-virtual {v0, v1}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object v1

    .line 392
    const-string v2, "brightness_indicator"

    invoke-static {p0, v2}, Lcom/harmony/ccvolume/HookEntry;->id(Landroid/content/Context;Ljava/lang/String;)I

    move-result p0

    invoke-virtual {v0, p0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p0

    if-eqz v1, :cond_23

    .line 393
    invoke-virtual {v1}, Landroid/view/View;->getVisibility()I

    move-result v0

    if-nez v0, :cond_23

    return-object v1

    :cond_23
    if-eqz p0, :cond_2c

    .line 396
    invoke-virtual {p0}, Landroid/view/View;->getVisibility()I

    move-result v0

    if-nez v0, :cond_2c

    return-object p0

    :cond_2c
    if-eqz v1, :cond_2f

    goto :goto_30

    :cond_2f
    move-object v1, p0

    :goto_30
    return-object v1
.end method

.method private static syncMirror(III)V
    .registers 4

    .line 743
    sget-object v0, Lcom/harmony/ccvolume/HookEntry;->sMirrorSeek:Landroid/widget/SeekBar;

    if-nez v0, :cond_5

    return-void

    .line 746
    :cond_5
    invoke-virtual {v0}, Landroid/widget/SeekBar;->getProgress()I

    move-result v0

    if-eq v0, p0, :cond_10

    .line 747
    sget-object v0, Lcom/harmony/ccvolume/HookEntry;->sMirrorSeek:Landroid/widget/SeekBar;

    invoke-virtual {v0, p0}, Landroid/widget/SeekBar;->setProgress(I)V

    .line 749
    :cond_10
    sget-object p0, Lcom/harmony/ccvolume/HookEntry;->sMirrorIcon:Landroid/widget/ImageView;

    invoke-static {p0, p1, p2}, Lcom/harmony/ccvolume/HookEntry;->updateIcon(Landroid/widget/ImageView;II)V

    return-void
.end method

.method private static syncMirrorWidth()V
    .registers 7

    .line 673
    sget-object v0, Lcom/harmony/ccvolume/HookEntry;->sMirrorCard:Landroid/view/View;

    if-eqz v0, :cond_75

    sget-object v0, Lcom/harmony/ccvolume/HookEntry;->sBrightnessMirror:Landroid/view/View;

    if-nez v0, :cond_a

    goto/16 :goto_75

    .line 676
    :cond_a
    invoke-virtual {v0}, Landroid/view/View;->getWidth()I

    move-result v0

    .line 677
    sget-object v1, Lcom/harmony/ccvolume/HookEntry;->sBrightnessMirror:Landroid/view/View;

    invoke-virtual {v1}, Landroid/view/View;->getHeight()I

    move-result v1

    if-gtz v0, :cond_17

    return-void

    .line 681
    :cond_17
    sget-object v2, Lcom/harmony/ccvolume/HookEntry;->sMirrorCard:Landroid/view/View;

    invoke-virtual {v2}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v2

    .line 683
    iget v3, v2, Landroid/view/ViewGroup$LayoutParams;->width:I

    const/4 v4, 0x1

    if-eq v3, v0, :cond_26

    .line 684
    iput v0, v2, Landroid/view/ViewGroup$LayoutParams;->width:I

    move v0, v4

    goto :goto_27

    :cond_26
    const/4 v0, 0x0

    :goto_27
    if-lez v1, :cond_30

    .line 687
    iget v3, v2, Landroid/view/ViewGroup$LayoutParams;->height:I

    if-eq v3, v1, :cond_30

    .line 688
    iput v1, v2, Landroid/view/ViewGroup$LayoutParams;->height:I

    move v0, v4

    .line 691
    :cond_30
    instance-of v1, v2, Landroid/view/ViewGroup$MarginLayoutParams;

    if-eqz v1, :cond_6d

    sget-object v1, Lcom/harmony/ccvolume/HookEntry;->sBrightnessMirror:Landroid/view/View;

    .line 692
    invoke-virtual {v1}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v1

    instance-of v1, v1, Landroid/view/ViewGroup$MarginLayoutParams;

    if-eqz v1, :cond_6d

    .line 693
    sget-object v1, Lcom/harmony/ccvolume/HookEntry;->sBrightnessMirror:Landroid/view/View;

    .line 694
    invoke-virtual {v1}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object v1

    check-cast v1, Landroid/view/ViewGroup$MarginLayoutParams;

    .line 695
    move-object v3, v2

    check-cast v3, Landroid/view/ViewGroup$MarginLayoutParams;

    .line 696
    iget v5, v3, Landroid/view/ViewGroup$MarginLayoutParams;->leftMargin:I

    iget v6, v1, Landroid/view/ViewGroup$MarginLayoutParams;->leftMargin:I

    if-ne v5, v6, :cond_61

    iget v5, v3, Landroid/view/ViewGroup$MarginLayoutParams;->topMargin:I

    iget v6, v1, Landroid/view/ViewGroup$MarginLayoutParams;->topMargin:I

    if-ne v5, v6, :cond_61

    iget v5, v3, Landroid/view/ViewGroup$MarginLayoutParams;->rightMargin:I

    iget v6, v1, Landroid/view/ViewGroup$MarginLayoutParams;->rightMargin:I

    if-ne v5, v6, :cond_61

    iget v5, v3, Landroid/view/ViewGroup$MarginLayoutParams;->bottomMargin:I

    iget v6, v1, Landroid/view/ViewGroup$MarginLayoutParams;->bottomMargin:I

    if-eq v5, v6, :cond_6d

    .line 698
    :cond_61
    iget v0, v1, Landroid/view/ViewGroup$MarginLayoutParams;->leftMargin:I

    iget v5, v1, Landroid/view/ViewGroup$MarginLayoutParams;->topMargin:I

    iget v6, v1, Landroid/view/ViewGroup$MarginLayoutParams;->rightMargin:I

    iget v1, v1, Landroid/view/ViewGroup$MarginLayoutParams;->bottomMargin:I

    invoke-virtual {v3, v0, v5, v6, v1}, Landroid/view/ViewGroup$MarginLayoutParams;->setMargins(IIII)V

    goto :goto_6e

    :cond_6d
    move v4, v0

    :goto_6e
    if-eqz v4, :cond_75

    .line 703
    sget-object v0, Lcom/harmony/ccvolume/HookEntry;->sMirrorCard:Landroid/view/View;

    invoke-virtual {v0, v2}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    :cond_75
    :goto_75
    return-void
.end method

.method private static syncVisibility(Landroid/view/View;Landroid/view/View;Landroid/content/Context;Ljava/lang/String;)V
    .registers 5

    .line 363
    :try_start_0
    invoke-static {p2, p3}, Lcom/harmony/ccvolume/HookEntry;->id(Landroid/content/Context;Ljava/lang/String;)I

    move-result v0

    invoke-virtual {p0, v0}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p0

    .line 364
    invoke-static {p2, p3}, Lcom/harmony/ccvolume/HookEntry;->id(Landroid/content/Context;Ljava/lang/String;)I

    move-result p2

    invoke-virtual {p1, p2}, Landroid/view/View;->findViewById(I)Landroid/view/View;

    move-result-object p1

    if-eqz p1, :cond_1e

    if-eqz p0, :cond_19

    .line 366
    invoke-virtual {p0}, Landroid/view/View;->getVisibility()I

    move-result p0

    goto :goto_1b

    :cond_19
    const/16 p0, 0x8

    :goto_1b
    invoke-virtual {p1, p0}, Landroid/view/View;->setVisibility(I)V
    :try_end_1e
    .catchall {:try_start_0 .. :try_end_1e} :catchall_1e

    :catchall_1e
    :cond_1e
    return-void
.end method

.method private static themeCtx(Landroid/content/Context;)Landroid/content/Context;
    .registers 4

    .line 374
    :try_start_0
    const-string v0, "com.huawei.systemui.emui.HwThemeUtils"

    .line 375
    invoke-virtual {p0}, Landroid/content/Context;->getClassLoader()Ljava/lang/ClassLoader;

    move-result-object v1

    .line 374
    invoke-static {v0, v1}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v0

    .line 376
    const-string v1, "getHwThemeLightContext"

    filled-new-array {p0}, [Ljava/lang/Object;

    move-result-object v2

    invoke-static {v0, v1, v2}, Lde/robv/android/xposed/XposedHelpers;->callStaticMethod(Ljava/lang/Class;Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    .line 377
    instance-of v1, v0, Landroid/content/Context;

    if-eqz v1, :cond_2e

    .line 378
    check-cast v0, Landroid/content/Context;
    :try_end_1a
    .catchall {:try_start_0 .. :try_end_1a} :catchall_1b

    return-object v0

    :catchall_1b
    move-exception v0

    .line 381
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "themeCtx failed: "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/harmony/ccvolume/HookEntry;->log(Ljava/lang/String;)V

    :cond_2e
    return-object p0
.end method

.method private static tintIcon(Landroid/content/Context;Landroid/widget/ImageView;)V
    .registers 4

    if-nez p1, :cond_3

    return-void

    .line 441
    :cond_3
    :try_start_3
    new-instance v0, Landroid/graphics/PorterDuffColorFilter;

    .line 442
    invoke-static {p0}, Lcom/harmony/ccvolume/HookEntry;->brightnessIconColor(Landroid/content/Context;)I

    move-result p0

    sget-object v1, Landroid/graphics/PorterDuff$Mode;->SRC_IN:Landroid/graphics/PorterDuff$Mode;

    invoke-direct {v0, p0, v1}, Landroid/graphics/PorterDuffColorFilter;-><init>(ILandroid/graphics/PorterDuff$Mode;)V

    .line 441
    invoke-virtual {p1, v0}, Landroid/widget/ImageView;->setColorFilter(Landroid/graphics/ColorFilter;)V
    :try_end_11
    .catchall {:try_start_3 .. :try_end_11} :catchall_11

    :catchall_11
    return-void
.end method

.method private static unregisterVolumeReceiver()V
    .registers 2

    .line 884
    sget-object v0, Lcom/harmony/ccvolume/HookEntry;->sReceiver:Landroid/content/BroadcastReceiver;

    if-nez v0, :cond_5

    return-void

    .line 888
    :cond_5
    :try_start_5
    sget-object v1, Lcom/harmony/ccvolume/HookEntry;->sRegCtx:Landroid/content/Context;

    if-eqz v1, :cond_c

    .line 889
    invoke-virtual {v1, v0}, Landroid/content/Context;->unregisterReceiver(Landroid/content/BroadcastReceiver;)V
    :try_end_c
    .catchall {:try_start_5 .. :try_end_c} :catchall_c

    :catchall_c
    :cond_c
    const/4 v0, 0x0

    .line 893
    sput-object v0, Lcom/harmony/ccvolume/HookEntry;->sReceiver:Landroid/content/BroadcastReceiver;

    .line 894
    sput-object v0, Lcom/harmony/ccvolume/HookEntry;->sRegCtx:Landroid/content/Context;

    return-void
.end method

.method private static updateIcon(Landroid/widget/ImageView;II)V
    .registers 5

    if-nez p0, :cond_3

    return-void

    :cond_3
    int-to-float v0, p1

    const/high16 v1, 0x42c80000  # 100.0f

    mul-float/2addr v0, v1

    const/4 v1, 0x1

    .line 815
    invoke-static {p2, v1}, Ljava/lang/Math;->max(II)I

    move-result p2

    int-to-float p2, p2

    div-float/2addr v0, p2

    float-to-int p2, v0

    if-gtz p1, :cond_14

    .line 817
    invoke-virtual {p0}, Landroid/widget/ImageView;->getContext()Landroid/content/Context;

    move-result-object p1

    invoke-static {p1}, Lcom/huawei/onekey/optimizer/hook/ccvolume/CcVolumeRes;->icMute(Landroid/content/Context;)I

    move-result p1

    goto :goto_24

    :cond_14
    const/16 p1, 0x42

    if-lt p2, p1, :cond_1b

    .line 819
    invoke-virtual {p0}, Landroid/widget/ImageView;->getContext()Landroid/content/Context;

    move-result-object p1

    invoke-static {p1}, Lcom/huawei/onekey/optimizer/hook/ccvolume/CcVolumeRes;->icHigh(Landroid/content/Context;)I

    move-result p1

    goto :goto_24

    :cond_1b
    const/16 p1, 0x21

    if-lt p2, p1, :cond_22

    .line 821
    invoke-virtual {p0}, Landroid/widget/ImageView;->getContext()Landroid/content/Context;

    move-result-object p1

    invoke-static {p1}, Lcom/huawei/onekey/optimizer/hook/ccvolume/CcVolumeRes;->icMedium(Landroid/content/Context;)I

    move-result p1

    goto :goto_24

    .line 823
    :cond_22
    invoke-virtual {p0}, Landroid/widget/ImageView;->getContext()Landroid/content/Context;

    move-result-object p1

    invoke-static {p1}, Lcom/huawei/onekey/optimizer/hook/ccvolume/CcVolumeRes;->icLow(Landroid/content/Context;)I

    move-result p1

    .line 825
    :goto_24
    invoke-virtual {p0}, Landroid/widget/ImageView;->getTag()Ljava/lang/Object;

    move-result-object p2

    .line 826
    instance-of v0, p2, Ljava/lang/Integer;

    if-eqz v0, :cond_3c

    check-cast p2, Ljava/lang/Integer;

    invoke-virtual {p2}, Ljava/lang/Integer;->intValue()I

    move-result p2

    if-ne p2, p1, :cond_3c

    .line 828
    invoke-virtual {p0}, Landroid/widget/ImageView;->getContext()Landroid/content/Context;

    move-result-object p1

    invoke-static {p1, p0}, Lcom/harmony/ccvolume/HookEntry;->tintIcon(Landroid/content/Context;Landroid/widget/ImageView;)V

    return-void

    .line 831
    :cond_3c
    invoke-static {p1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p2

    invoke-virtual {p0, p2}, Landroid/widget/ImageView;->setTag(Ljava/lang/Object;)V

    .line 834
    :try_start_43
    sget-object p2, Lcom/harmony/ccvolume/HookEntry;->sModuleRes:Landroid/content/res/Resources;

    if-eqz p2, :cond_63

    const/4 v0, 0x0

    .line 835
    invoke-virtual {p2, p1, v0}, Landroid/content/res/Resources;->getDrawable(ILandroid/content/res/Resources$Theme;)Landroid/graphics/drawable/Drawable;

    move-result-object p1

    invoke-virtual {p0, p1}, Landroid/widget/ImageView;->setImageDrawable(Landroid/graphics/drawable/Drawable;)V
    :try_end_4f
    .catchall {:try_start_43 .. :try_end_4f} :catchall_50

    goto :goto_63

    :catchall_50
    move-exception p1

    .line 838
    new-instance p2, Ljava/lang/StringBuilder;

    const-string v0, "icon load failed: "

    invoke-direct {p2, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p2, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p1}, Lcom/harmony/ccvolume/HookEntry;->log(Ljava/lang/String;)V

    .line 840
    :cond_63
    :goto_63
    invoke-virtual {p0}, Landroid/widget/ImageView;->getContext()Landroid/content/Context;

    move-result-object p1

    invoke-static {p1, p0}, Lcom/harmony/ccvolume/HookEntry;->tintIcon(Landroid/content/Context;Landroid/widget/ImageView;)V

    return-void
.end method


# virtual methods
.method public handleLoadPackage(Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;)V
    .registers 6

    .line 74
    const-string v0, "com.android.systemui"

    iget-object v1, p1, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;->packageName:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_b

    return-void

    .line 78
    :cond_b
    :try_start_b
    const-string v0, "com.huawei.controlcenter.qs.ControlCenterQs"

    iget-object v1, p1, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;->classLoader:Ljava/lang/ClassLoader;

    invoke-static {v0, v1}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v0

    .line 79
    const-string v1, "initQsSlider"

    new-instance v2, Lcom/harmony/ccvolume/HookEntry$1;

    invoke-direct {v2, p0}, Lcom/harmony/ccvolume/HookEntry$1;-><init>(Lcom/harmony/ccvolume/HookEntry;)V

    filled-new-array {v2}, [Ljava/lang/Object;

    move-result-object v2

    invoke-static {v0, v1, v2}, Lde/robv/android/xposed/XposedHelpers;->findAndHookMethod(Ljava/lang/Class;Ljava/lang/String;[Ljava/lang/Object;)Lde/robv/android/xposed/XC_MethodHook$Unhook;

    .line 85
    const-string v1, "setViewTranslationY"

    sget-object v2, Ljava/lang/Float;->TYPE:Ljava/lang/Class;

    new-instance v3, Lcom/harmony/ccvolume/HookEntry$2;

    invoke-direct {v3, p0}, Lcom/harmony/ccvolume/HookEntry$2;-><init>(Lcom/harmony/ccvolume/HookEntry;)V

    filled-new-array {v2, v3}, [Ljava/lang/Object;

    move-result-object v2

    invoke-static {v0, v1, v2}, Lde/robv/android/xposed/XposedHelpers;->findAndHookMethod(Ljava/lang/Class;Ljava/lang/String;[Ljava/lang/Object;)Lde/robv/android/xposed/XC_MethodHook$Unhook;

    .line 94
    const-string v0, "com.android.systemui.settings.ToggleSlider"

    iget-object p1, p1, Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;->classLoader:Ljava/lang/ClassLoader;

    invoke-static {v0, p1}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object p1

    .line 96
    const-string v0, "onPanelUiModeChanged"

    new-instance v1, Lcom/harmony/ccvolume/HookEntry$3;

    invoke-direct {v1, p0}, Lcom/harmony/ccvolume/HookEntry$3;-><init>(Lcom/harmony/ccvolume/HookEntry;)V

    filled-new-array {v1}, [Ljava/lang/Object;

    move-result-object v1

    invoke-static {p1, v0, v1}, Lde/robv/android/xposed/XposedHelpers;->findAndHookMethod(Ljava/lang/Class;Ljava/lang/String;[Ljava/lang/Object;)Lde/robv/android/xposed/XC_MethodHook$Unhook;

    .line 120
    const-string p1, "hooks installed"

    invoke-static {p1}, Lcom/harmony/ccvolume/HookEntry;->log(Ljava/lang/String;)V
    :try_end_4c
    .catchall {:try_start_b .. :try_end_4c} :catchall_4d

    goto :goto_60

    :catchall_4d
    move-exception p1

    .line 122
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "install failed: "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {p1}, Lcom/harmony/ccvolume/HookEntry;->log(Ljava/lang/String;)V

    :goto_60
    return-void
.end method
