.class public final Lcom/hook/packageinstaller/core/RestartScopeReceiver;
.super Landroid/content/BroadcastReceiver;
.source "RestartScopeReceiver.java"


# static fields
.field private static final TAG:Ljava/lang/String; = "PI-Cleaner/Reload"

.field private static registered:Z = false


# direct methods
.method static constructor <clinit>()V
    .registers 0

    return-void
.end method

.method public constructor <init>()V
    .registers 1

    .line 20
    invoke-direct {p0}, Landroid/content/BroadcastReceiver;-><init>()V

    return-void
.end method

.method public static register(Landroid/app/Application;)V
    .registers 6

    .line 35
    const-string v0, "PI-Cleaner/Reload"

    sget-boolean v1, Lcom/hook/packageinstaller/core/RestartScopeReceiver;->registered:Z

    if-eqz v1, :cond_7

    return-void

    .line 39
    :cond_7
    :try_start_7
    new-instance v1, Landroid/content/IntentFilter;

    const-string v2, "com.hook.packageinstaller.action.RELOAD_INSTALLER"

    invoke-direct {v1, v2}, Landroid/content/IntentFilter;-><init>(Ljava/lang/String;)V

    .line 40
    new-instance v2, Lcom/hook/packageinstaller/core/RestartScopeReceiver;

    invoke-direct {v2}, Lcom/hook/packageinstaller/core/RestartScopeReceiver;-><init>()V

    .line 41
    sget v3, Landroid/os/Build$VERSION;->SDK_INT:I

    const/16 v4, 0x21

    if-lt v3, v4, :cond_1e

    const/4 v3, 0x2

    .line 42
    invoke-virtual {p0, v2, v1, v3}, Landroid/app/Application;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;I)Landroid/content/Intent;

    goto :goto_21

    .line 44
    :cond_1e
    invoke-virtual {p0, v2, v1}, Landroid/app/Application;->registerReceiver(Landroid/content/BroadcastReceiver;Landroid/content/IntentFilter;)Landroid/content/Intent;

    :goto_21
    const/4 p0, 0x1

    .line 46
    sput-boolean p0, Lcom/hook/packageinstaller/core/RestartScopeReceiver;->registered:Z

    .line 47
    const-string p0, "Reload receiver registered"

    invoke-static {v0, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_29
    .catchall {:try_start_7 .. :try_end_29} :catchall_2a

    goto :goto_30

    :catchall_2a
    move-exception p0

    .line 49
    const-string v1, "Unable to register reload receiver"

    invoke-static {v0, v1, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :goto_30
    return-void
.end method


# virtual methods
.method public onReceive(Landroid/content/Context;Landroid/content/Intent;)V
    .registers 3

    if-eqz p2, :cond_21

    .line 26
    const-string p0, "com.hook.packageinstaller.action.RELOAD_INSTALLER"

    invoke-virtual {p2}, Landroid/content/Intent;->getAction()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_f

    goto :goto_21

    .line 29
    :cond_f
    const-string p0, "PI-Cleaner/Reload"

    const-string p1, "Reload broadcast received, terminating PackageInstaller process"

    invoke-static {p0, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 30
    invoke-static {}, Landroid/os/Process;->myPid()I

    move-result p0

    invoke-static {p0}, Landroid/os/Process;->killProcess(I)V

    const/4 p0, 0x0

    .line 31
    invoke-static {p0}, Ljava/lang/System;->exit(I)V

    :cond_21
    :goto_21
    return-void
.end method
