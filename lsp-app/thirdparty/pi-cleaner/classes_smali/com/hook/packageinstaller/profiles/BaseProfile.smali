.class public abstract Lcom/hook/packageinstaller/profiles/BaseProfile;
.super Ljava/lang/Object;
.source "BaseProfile.java"

# interfaces
.implements Lcom/hook/packageinstaller/profiles/InstallerProfile;


# instance fields
.field private final classes:Lcom/hook/packageinstaller/profiles/ProfileClasses;

.field private final id:Ljava/lang/String;

.field private final label:Ljava/lang/String;

.field private final maxVersionCode:J

.field private final minVersionCode:J

.field private final requiredClasses:[Ljava/lang/String;

.field private final versionPrefix:Ljava/lang/String;


# direct methods
.method protected constructor <init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;JJ[Ljava/lang/String;Lcom/hook/packageinstaller/profiles/ProfileClasses;)V
    .registers 10

    .line 17
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 18
    iput-object p1, p0, Lcom/hook/packageinstaller/profiles/BaseProfile;->id:Ljava/lang/String;

    .line 19
    iput-object p2, p0, Lcom/hook/packageinstaller/profiles/BaseProfile;->label:Ljava/lang/String;

    .line 20
    iput-object p3, p0, Lcom/hook/packageinstaller/profiles/BaseProfile;->versionPrefix:Ljava/lang/String;

    .line 21
    iput-wide p4, p0, Lcom/hook/packageinstaller/profiles/BaseProfile;->minVersionCode:J

    .line 22
    iput-wide p6, p0, Lcom/hook/packageinstaller/profiles/BaseProfile;->maxVersionCode:J

    .line 23
    iput-object p8, p0, Lcom/hook/packageinstaller/profiles/BaseProfile;->requiredClasses:[Ljava/lang/String;

    .line 24
    iput-object p9, p0, Lcom/hook/packageinstaller/profiles/BaseProfile;->classes:Lcom/hook/packageinstaller/profiles/ProfileClasses;

    return-void
.end method


# virtual methods
.method public classes()Lcom/hook/packageinstaller/profiles/ProfileClasses;
    .registers 1

    .line 74
    iget-object p0, p0, Lcom/hook/packageinstaller/profiles/BaseProfile;->classes:Lcom/hook/packageinstaller/profiles/ProfileClasses;

    return-object p0
.end method

.method public fingerprintMatches(Ljava/lang/ClassLoader;)Z
    .registers 6

    .line 50
    iget-object p0, p0, Lcom/hook/packageinstaller/profiles/BaseProfile;->requiredClasses:[Ljava/lang/String;

    const/4 v0, 0x0

    if-eqz p0, :cond_1b

    array-length v1, p0

    if-nez v1, :cond_9

    goto :goto_1b

    .line 53
    :cond_9
    array-length v1, p0

    move v2, v0

    :goto_b
    if-ge v2, v1, :cond_19

    aget-object v3, p0, v2

    .line 54
    invoke-static {p1, v3}, Lcom/hook/packageinstaller/core/SafeXposed;->classExists(Ljava/lang/ClassLoader;Ljava/lang/String;)Z

    move-result v3

    if-nez v3, :cond_16

    return v0

    :cond_16
    add-int/lit8 v2, v2, 0x1

    goto :goto_b

    :cond_19
    const/4 p0, 0x1

    return p0

    :cond_1b
    :goto_1b
    return v0
.end method

.method public id()Ljava/lang/String;
    .registers 1

    .line 29
    iget-object p0, p0, Lcom/hook/packageinstaller/profiles/BaseProfile;->id:Ljava/lang/String;

    return-object p0
.end method

.method public label()Ljava/lang/String;
    .registers 1

    .line 34
    iget-object p0, p0, Lcom/hook/packageinstaller/profiles/BaseProfile;->label:Ljava/lang/String;

    return-object p0
.end method

.method public matches(Lcom/hook/packageinstaller/core/InstallerVersion;Ljava/lang/ClassLoader;)Z
    .registers 3

    .line 63
    invoke-virtual {p0, p1}, Lcom/hook/packageinstaller/profiles/BaseProfile;->versionHintMatches(Lcom/hook/packageinstaller/core/InstallerVersion;)Z

    move-result p1

    if-eqz p1, :cond_e

    invoke-virtual {p0, p2}, Lcom/hook/packageinstaller/profiles/BaseProfile;->fingerprintMatches(Ljava/lang/ClassLoader;)Z

    move-result p0

    if-eqz p0, :cond_e

    const/4 p0, 0x1

    goto :goto_f

    :cond_e
    const/4 p0, 0x0

    :goto_f
    return p0
.end method

.method public specificity()I
    .registers 3

    .line 68
    iget-object v0, p0, Lcom/hook/packageinstaller/profiles/BaseProfile;->requiredClasses:[Ljava/lang/String;

    const/4 v1, 0x0

    if-nez v0, :cond_7

    move v0, v1

    goto :goto_a

    :cond_7
    array-length v0, v0

    mul-int/lit8 v0, v0, 0xa

    .line 69
    :goto_a
    iget-object p0, p0, Lcom/hook/packageinstaller/profiles/BaseProfile;->versionPrefix:Ljava/lang/String;

    if-nez p0, :cond_f

    goto :goto_10

    :cond_f
    const/4 v1, 0x1

    :goto_10
    add-int/2addr v0, v1

    return v0
.end method

.method public versionHintMatches(Lcom/hook/packageinstaller/core/InstallerVersion;)Z
    .registers 9

    const/4 v0, 0x0

    if-nez p1, :cond_4

    return v0

    .line 42
    :cond_4
    iget-wide v1, p1, Lcom/hook/packageinstaller/core/InstallerVersion;->versionCode:J

    iget-wide v3, p0, Lcom/hook/packageinstaller/profiles/BaseProfile;->minVersionCode:J

    cmp-long v1, v1, v3

    const/4 v2, 0x1

    if-ltz v1, :cond_16

    iget-wide v3, p1, Lcom/hook/packageinstaller/core/InstallerVersion;->versionCode:J

    iget-wide v5, p0, Lcom/hook/packageinstaller/profiles/BaseProfile;->maxVersionCode:J

    cmp-long v1, v3, v5

    if-gtz v1, :cond_16

    return v2

    .line 45
    :cond_16
    iget-object v1, p1, Lcom/hook/packageinstaller/core/InstallerVersion;->versionName:Ljava/lang/String;

    if-eqz v1, :cond_25

    iget-object p1, p1, Lcom/hook/packageinstaller/core/InstallerVersion;->versionName:Ljava/lang/String;

    iget-object p0, p0, Lcom/hook/packageinstaller/profiles/BaseProfile;->versionPrefix:Ljava/lang/String;

    invoke-virtual {p1, p0}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result p0

    if-eqz p0, :cond_25

    move v0, v2

    :cond_25
    return v0
.end method
