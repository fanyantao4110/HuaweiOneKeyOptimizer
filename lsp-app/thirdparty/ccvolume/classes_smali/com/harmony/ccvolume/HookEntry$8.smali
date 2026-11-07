.class Lcom/harmony/ccvolume/HookEntry$8;
.super Ljava/lang/Object;
.source "HookEntry.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/harmony/ccvolume/HookEntry;->setupVolumeMirror(Landroid/content/Context;Landroid/content/Context;Landroid/content/res/Resources;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# direct methods
.method constructor <init>()V
    .registers 1

    .line 660
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 1

    .line 663
    invoke-static {}, Lcom/harmony/ccvolume/HookEntry;->access$2500()V

    return-void
.end method
