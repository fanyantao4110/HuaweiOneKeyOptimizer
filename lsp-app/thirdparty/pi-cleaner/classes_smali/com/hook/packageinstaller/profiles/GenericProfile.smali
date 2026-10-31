.class public final Lcom/hook/packageinstaller/profiles/GenericProfile;
.super Ljava/lang/Object;
.source "GenericProfile.java"

# interfaces
.implements Lcom/hook/packageinstaller/profiles/InstallerProfile;


# instance fields
.field private final classes:Lcom/hook/packageinstaller/profiles/ProfileClasses;


# direct methods
.method public constructor <init>()V
    .registers 2

    .line 5
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 6
    new-instance v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;

    invoke-direct {v0}, Lcom/hook/packageinstaller/profiles/ProfileClasses;-><init>()V

    iput-object v0, p0, Lcom/hook/packageinstaller/profiles/GenericProfile;->classes:Lcom/hook/packageinstaller/profiles/ProfileClasses;

    return-void
.end method


# virtual methods
.method public classes()Lcom/hook/packageinstaller/profiles/ProfileClasses;
    .registers 1

    .line 40
    iget-object p0, p0, Lcom/hook/packageinstaller/profiles/GenericProfile;->classes:Lcom/hook/packageinstaller/profiles/ProfileClasses;

    return-object p0
.end method

.method public fingerprintMatches(Ljava/lang/ClassLoader;)Z
    .registers 2

    const/4 p0, 0x1

    return p0
.end method

.method public id()Ljava/lang/String;
    .registers 1

    .line 10
    const-string p0, "PI_GENERIC"

    return-object p0
.end method

.method public label()Ljava/lang/String;
    .registers 1

    .line 15
    const-string p0, "未知安装器版本"

    return-object p0
.end method

.method public matches(Lcom/hook/packageinstaller/core/InstallerVersion;Ljava/lang/ClassLoader;)Z
    .registers 3

    const/4 p0, 0x1

    return p0
.end method

.method public specificity()I
    .registers 1

    const/4 p0, 0x0

    return p0
.end method

.method public versionHintMatches(Lcom/hook/packageinstaller/core/InstallerVersion;)Z
    .registers 2

    const/4 p0, 0x1

    return p0
.end method
