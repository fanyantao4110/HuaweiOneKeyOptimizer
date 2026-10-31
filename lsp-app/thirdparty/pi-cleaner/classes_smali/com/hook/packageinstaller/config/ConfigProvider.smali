.class public final Lcom/hook/packageinstaller/config/ConfigProvider;
.super Landroid/content/ContentProvider;
.source "ConfigProvider.java"


# direct methods
.method public constructor <init>()V
    .registers 1

    .line 12
    invoke-direct {p0}, Landroid/content/ContentProvider;-><init>()V

    return-void
.end method

.method private prefs()Landroid/content/SharedPreferences;
    .registers 3

    .line 63
    invoke-virtual {p0}, Lcom/hook/packageinstaller/config/ConfigProvider;->getContext()Landroid/content/Context;

    move-result-object p0

    if-eqz p0, :cond_e

    .line 67
    const-string v0, "config"

    const/4 v1, 0x0

    invoke-virtual {p0, v0, v1}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object p0

    return-object p0

    .line 65
    :cond_e
    new-instance p0, Ljava/lang/IllegalStateException;

    const-string v0, "ConfigProvider is not attached"

    invoke-direct {p0, v0}, Ljava/lang/IllegalStateException;-><init>(Ljava/lang/String;)V

    throw p0
.end method


# virtual methods
.method public call(Ljava/lang/String;Ljava/lang/String;Landroid/os/Bundle;)Landroid/os/Bundle;
    .registers 7

    .line 20
    const-string v0, "get_config"

    invoke-virtual {v0, p1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-eqz v0, :cond_25

    .line 21
    new-instance p1, Landroid/os/Bundle;

    invoke-direct {p1}, Landroid/os/Bundle;-><init>()V

    .line 22
    invoke-direct {p0}, Lcom/hook/packageinstaller/config/ConfigProvider;->prefs()Landroid/content/SharedPreferences;

    move-result-object p0

    .line 23
    sget-object p2, Lcom/hook/packageinstaller/config/ConfigKeys;->ALL:[Ljava/lang/String;

    array-length p3, p2

    const/4 v0, 0x0

    :goto_15
    if-ge v0, p3, :cond_24

    aget-object v1, p2, v0

    const/4 v2, 0x1

    .line 24
    invoke-interface {p0, v1, v2}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v2

    invoke-virtual {p1, v1, v2}, Landroid/os/Bundle;->putBoolean(Ljava/lang/String;Z)V

    add-int/lit8 v0, v0, 0x1

    goto :goto_15

    :cond_24
    return-object p1

    .line 28
    :cond_25
    invoke-super {p0, p1, p2, p3}, Landroid/content/ContentProvider;->call(Ljava/lang/String;Ljava/lang/String;Landroid/os/Bundle;)Landroid/os/Bundle;

    move-result-object p0

    return-object p0
.end method

.method public delete(Landroid/net/Uri;Ljava/lang/String;[Ljava/lang/String;)I
    .registers 4

    const/4 p0, 0x0

    return p0
.end method

.method public getType(Landroid/net/Uri;)Ljava/lang/String;
    .registers 2

    .line 44
    const-string p0, "vnd.android.cursor.dir/vnd.com.hook.packageinstaller.config"

    return-object p0
.end method

.method public insert(Landroid/net/Uri;Landroid/content/ContentValues;)Landroid/net/Uri;
    .registers 3

    const/4 p0, 0x0

    return-object p0
.end method

.method public onCreate()Z
    .registers 1

    const/4 p0, 0x1

    return p0
.end method

.method public query(Landroid/net/Uri;[Ljava/lang/String;Ljava/lang/String;[Ljava/lang/String;Ljava/lang/String;)Landroid/database/Cursor;
    .registers 8

    .line 34
    invoke-direct {p0}, Lcom/hook/packageinstaller/config/ConfigProvider;->prefs()Landroid/content/SharedPreferences;

    move-result-object p0

    .line 35
    new-instance p1, Landroid/database/MatrixCursor;

    const/4 p2, 0x2

    new-array p2, p2, [Ljava/lang/String;

    const-string p3, "key"

    const/4 p4, 0x0

    aput-object p3, p2, p4

    const-string p3, "value"

    const/4 p5, 0x1

    aput-object p3, p2, p5

    invoke-direct {p1, p2}, Landroid/database/MatrixCursor;-><init>([Ljava/lang/String;)V

    .line 36
    sget-object p2, Lcom/hook/packageinstaller/config/ConfigKeys;->ALL:[Ljava/lang/String;

    array-length p3, p2

    :goto_19
    if-ge p4, p3, :cond_2f

    aget-object v0, p2, p4

    .line 37
    invoke-interface {p0, v0, p5}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v1

    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v1

    filled-new-array {v0, v1}, [Ljava/lang/Object;

    move-result-object v0

    invoke-virtual {p1, v0}, Landroid/database/MatrixCursor;->addRow([Ljava/lang/Object;)V

    add-int/lit8 p4, p4, 0x1

    goto :goto_19

    :cond_2f
    return-object p1
.end method

.method public update(Landroid/net/Uri;Landroid/content/ContentValues;Ljava/lang/String;[Ljava/lang/String;)I
    .registers 5

    const/4 p0, 0x0

    return p0
.end method
