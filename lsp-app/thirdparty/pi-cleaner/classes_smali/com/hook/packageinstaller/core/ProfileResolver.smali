.class public final Lcom/hook/packageinstaller/core/ProfileResolver;
.super Ljava/lang/Object;
.source "ProfileResolver.java"


# static fields
.field private static final TAG:Ljava/lang/String; = "PI-Cleaner/Profile"


# direct methods
.method private constructor <init>()V
    .registers 1

    .line 19
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static profiles()Ljava/util/List;
    .registers 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()",
            "Ljava/util/List<",
            "Lcom/hook/packageinstaller/profiles/InstallerProfile;",
            ">;"
        }
    .end annotation

    .line 57
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    .line 58
    new-instance v1, Lcom/hook/packageinstaller/profiles/Harmony20Profile;

    invoke-direct {v1}, Lcom/hook/packageinstaller/profiles/Harmony20Profile;-><init>()V

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 59
    new-instance v1, Lcom/hook/packageinstaller/profiles/Harmony30Profile;

    invoke-direct {v1}, Lcom/hook/packageinstaller/profiles/Harmony30Profile;-><init>()V

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 60
    new-instance v1, Lcom/hook/packageinstaller/profiles/Harmony40Profile;

    invoke-direct {v1}, Lcom/hook/packageinstaller/profiles/Harmony40Profile;-><init>()V

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 61
    new-instance v1, Lcom/hook/packageinstaller/profiles/Harmony42Profile;

    invoke-direct {v1}, Lcom/hook/packageinstaller/profiles/Harmony42Profile;-><init>()V

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 62
    new-instance v1, Lcom/hook/packageinstaller/profiles/Harmony43Profile;

    invoke-direct {v1}, Lcom/hook/packageinstaller/profiles/Harmony43Profile;-><init>()V

    invoke-interface {v0, v1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    return-object v0
.end method

.method public static resolve(Lcom/hook/packageinstaller/core/InstallerVersion;Ljava/lang/ClassLoader;)Lcom/hook/packageinstaller/profiles/InstallerProfile;
    .registers 8

    .line 23
    invoke-static {}, Lcom/hook/packageinstaller/core/ProfileResolver;->profiles()Ljava/util/List;

    move-result-object v0

    .line 27
    invoke-interface {v0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    const/4 v1, 0x0

    move-object v2, v1

    :cond_a
    :goto_a
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v3

    if-eqz v3, :cond_44

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Lcom/hook/packageinstaller/profiles/InstallerProfile;

    .line 28
    invoke-interface {v3, p0}, Lcom/hook/packageinstaller/profiles/InstallerProfile;->versionHintMatches(Lcom/hook/packageinstaller/core/InstallerVersion;)Z

    move-result v4

    if-eqz v4, :cond_30

    invoke-interface {v3, p1}, Lcom/hook/packageinstaller/profiles/InstallerProfile;->fingerprintMatches(Ljava/lang/ClassLoader;)Z

    move-result v4

    if-eqz v4, :cond_30

    if-eqz v1, :cond_2e

    .line 29
    invoke-interface {v3}, Lcom/hook/packageinstaller/profiles/InstallerProfile;->specificity()I

    move-result v4

    invoke-interface {v1}, Lcom/hook/packageinstaller/profiles/InstallerProfile;->specificity()I

    move-result v5

    if-le v4, v5, :cond_a

    :cond_2e
    move-object v1, v3

    goto :goto_a

    .line 32
    :cond_30
    invoke-interface {v3, p1}, Lcom/hook/packageinstaller/profiles/InstallerProfile;->fingerprintMatches(Ljava/lang/ClassLoader;)Z

    move-result v4

    if-eqz v4, :cond_a

    if-eqz v2, :cond_42

    .line 34
    invoke-interface {v3}, Lcom/hook/packageinstaller/profiles/InstallerProfile;->specificity()I

    move-result v4

    invoke-interface {v2}, Lcom/hook/packageinstaller/profiles/InstallerProfile;->specificity()I

    move-result v5

    if-le v4, v5, :cond_a

    :cond_42
    move-object v2, v3

    goto :goto_a

    .line 40
    :cond_44
    const-string p0, " / "

    const-string p1, "PI-Cleaner/Profile"

    if-eqz v1, :cond_6d

    .line 41
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v2, "Matched by installer version + fingerprint: "

    invoke-direct {v0, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 42
    invoke-interface {v1}, Lcom/hook/packageinstaller/profiles/InstallerProfile;->id()Ljava/lang/String;

    move-result-object v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-interface {v1}, Lcom/hook/packageinstaller/profiles/InstallerProfile;->label()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 41
    invoke-static {p1, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-object v1

    :cond_6d
    if-eqz v2, :cond_92

    .line 47
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "Installer version hint did not match, using fingerprint fallback: "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 48
    invoke-interface {v2}, Lcom/hook/packageinstaller/profiles/InstallerProfile;->id()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-interface {v2}, Lcom/hook/packageinstaller/profiles/InstallerProfile;->label()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 47
    invoke-static {p1, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    return-object v2

    .line 52
    :cond_92
    const-string p0, "No profile fingerprint matched, using GenericProfile"

    invoke-static {p1, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    .line 53
    new-instance p0, Lcom/hook/packageinstaller/profiles/GenericProfile;

    invoke-direct {p0}, Lcom/hook/packageinstaller/profiles/GenericProfile;-><init>()V

    return-object p0
.end method
