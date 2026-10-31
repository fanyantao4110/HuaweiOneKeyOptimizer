.class public final Lcom/hook/packageinstaller/config/ConfigRepository;
.super Ljava/lang/Object;
.source "ConfigRepository.java"


# static fields
.field private static final TAG:Ljava/lang/String; = "PI-Cleaner/Config"


# direct methods
.method private constructor <init>()V
    .registers 1

    .line 13
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static load(Landroid/content/Context;)Lcom/hook/packageinstaller/config/FeatureConfig;
    .registers 7

    .line 17
    const-string v0, "ad_clean"

    const-string v1, "PI-Cleaner/Config"

    new-instance v2, Lcom/hook/packageinstaller/config/FeatureConfig;

    invoke-direct {v2}, Lcom/hook/packageinstaller/config/FeatureConfig;-><init>()V

    .line 22
    :try_start_9
    invoke-virtual {p0}, Landroid/content/Context;->getContentResolver()Landroid/content/ContentResolver;

    move-result-object p0

    const-string v3, "content://com.hook.packageinstaller.config"

    .line 23
    invoke-static {v3}, Landroid/net/Uri;->parse(Ljava/lang/String;)Landroid/net/Uri;

    move-result-object v3

    const-string v4, "get_config"

    const/4 v5, 0x0

    .line 22
    invoke-virtual {p0, v3, v4, v5, v5}, Landroid/content/ContentResolver;->call(Landroid/net/Uri;Ljava/lang/String;Ljava/lang/String;Landroid/os/Bundle;)Landroid/os/Bundle;

    move-result-object p0

    if-eqz p0, :cond_3e

    .line 27
    invoke-virtual {p0, v0}, Landroid/os/Bundle;->containsKey(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_3e

    .line 28
    invoke-virtual {v2, p0}, Lcom/hook/packageinstaller/config/FeatureConfig;->apply(Landroid/os/Bundle;)V

    .line 29
    const-string p0, "Loaded config from ContentProvider"

    invoke-static {v1, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_2a
    .catchall {:try_start_9 .. :try_end_2a} :catchall_2b

    return-object v2

    :catchall_2b
    move-exception p0

    .line 33
    new-instance v3, Ljava/lang/StringBuilder;

    const-string v4, "ContentProvider config unavailable: "

    invoke-direct {v3, v4}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v3, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v1, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 38
    :cond_3e
    :try_start_3e
    new-instance p0, Lde/robv/android/xposed/XSharedPreferences;

    const-string v3, "com.hook.packageinstaller"

    const-string v4, "config"

    invoke-direct {p0, v3, v4}, Lde/robv/android/xposed/XSharedPreferences;-><init>(Ljava/lang/String;Ljava/lang/String;)V

    .line 40
    invoke-virtual {p0}, Lde/robv/android/xposed/XSharedPreferences;->reload()V

    .line 41
    invoke-virtual {p0, v0}, Lde/robv/android/xposed/XSharedPreferences;->contains(Ljava/lang/String;)Z

    move-result v0

    if-eqz v0, :cond_6c

    .line 42
    invoke-virtual {v2, p0}, Lcom/hook/packageinstaller/config/FeatureConfig;->apply(Landroid/content/SharedPreferences;)V

    .line 43
    const-string p0, "Loaded config from XSharedPreferences"

    invoke-static {v1, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_58
    .catchall {:try_start_3e .. :try_end_58} :catchall_59

    return-object v2

    :catchall_59
    move-exception p0

    .line 47
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v3, "XSharedPreferences config unavailable: "

    invoke-direct {v0, v3}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v1, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 50
    :cond_6c
    const-string p0, "Using default config (all features enabled)"

    invoke-static {v1, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-object v2
.end method
