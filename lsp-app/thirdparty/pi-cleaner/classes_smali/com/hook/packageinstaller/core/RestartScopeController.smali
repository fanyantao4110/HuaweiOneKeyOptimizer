.class public final Lcom/hook/packageinstaller/core/RestartScopeController;
.super Ljava/lang/Object;
.source "RestartScopeController.java"


# direct methods
.method private constructor <init>()V
    .registers 1

    .line 10
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static restart(Landroid/content/Context;)V
    .registers 4

    .line 14
    new-instance v0, Landroid/content/Intent;

    const-string v1, "com.hook.packageinstaller.action.RELOAD_INSTALLER"

    invoke-direct {v0, v1}, Landroid/content/Intent;-><init>(Ljava/lang/String;)V

    .line 15
    const-string v1, "com.android.packageinstaller"

    invoke-virtual {v0, v1}, Landroid/content/Intent;->setPackage(Ljava/lang/String;)Landroid/content/Intent;

    const/high16 v2, 0x10000000

    .line 16
    invoke-virtual {v0, v2}, Landroid/content/Intent;->addFlags(I)Landroid/content/Intent;

    .line 17
    invoke-virtual {p0, v0}, Landroid/content/Context;->sendBroadcast(Landroid/content/Intent;)V

    .line 23
    :try_start_14
    const-string v0, "activity"

    .line 24
    invoke-virtual {p0, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Landroid/app/ActivityManager;

    if-eqz p0, :cond_21

    .line 26
    invoke-virtual {p0, v1}, Landroid/app/ActivityManager;->killBackgroundProcesses(Ljava/lang/String;)V
    :try_end_21
    .catchall {:try_start_14 .. :try_end_21} :catchall_21

    :catchall_21
    :cond_21
    return-void
.end method
