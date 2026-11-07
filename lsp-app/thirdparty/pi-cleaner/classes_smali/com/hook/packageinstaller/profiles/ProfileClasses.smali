.class public final Lcom/hook/packageinstaller/profiles/ProfileClasses;
.super Ljava/lang/Object;
.source "ProfileClasses.java"


# instance fields
.field public adManagerClass:Ljava/lang/String;

.field public adManagerMethod:Ljava/lang/String;

.field public anonymousClass:Ljava/lang/String;

.field public authChildCheckMethod:Ljava/lang/String;

.field public authChildClass:Ljava/lang/String;

.field public authEntryClass:Ljava/lang/String;

.field public authEntryMethod:Ljava/lang/String;

.field public installationControlResult:Ljava/lang/String;

.field public orientationClass:Ljava/lang/String;

.field public packageInstallerActivity:Ljava/lang/String;

.field public piaRiskHasBooleanArg:Z

.field public piaRiskMethod:Ljava/lang/String;

.field public piaSetViewMethod:Ljava/lang/String;

.field public pureClass:Ljava/lang/String;

.field public pureStatusMethod:Ljava/lang/String;

.field public stagingContinueMethod:Ljava/lang/String;

.field public stagingRiskClass:Ljava/lang/String;

.field public stagingRiskMethod:Ljava/lang/String;

.field public storeClass:Ljava/lang/String;

.field public unknownSourceClass:Ljava/lang/String;


# direct methods
.method public constructor <init>()V
    .registers 2

    .line 7
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    .line 8
    const-string v0, "com.android.packageinstaller.PackageInstallerActivity"

    iput-object v0, p0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->packageInstallerActivity:Ljava/lang/String;

    .line 9
    const-string v0, "com.huawei.android.packageinstaller.storeapi.response.InstallationControlResult"

    iput-object v0, p0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->installationControlResult:Ljava/lang/String;

    const/4 v0, 0x1

    .line 20
    iput-boolean v0, p0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->piaRiskHasBooleanArg:Z

    return-void
.end method


# virtual methods
.method public copy()Lcom/hook/packageinstaller/profiles/ProfileClasses;
    .registers 3

    .line 46
    new-instance v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;

    invoke-direct {v0}, Lcom/hook/packageinstaller/profiles/ProfileClasses;-><init>()V

    .line 47
    iget-object v1, p0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->packageInstallerActivity:Ljava/lang/String;

    iput-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->packageInstallerActivity:Ljava/lang/String;

    .line 48
    iget-object v1, p0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->installationControlResult:Ljava/lang/String;

    iput-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->installationControlResult:Ljava/lang/String;

    .line 49
    iget-object v1, p0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->stagingRiskClass:Ljava/lang/String;

    iput-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->stagingRiskClass:Ljava/lang/String;

    .line 50
    iget-object v1, p0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->stagingRiskMethod:Ljava/lang/String;

    iput-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->stagingRiskMethod:Ljava/lang/String;

    .line 51
    iget-object v1, p0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->stagingContinueMethod:Ljava/lang/String;

    iput-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->stagingContinueMethod:Ljava/lang/String;

    .line 52
    iget-object v1, p0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->piaRiskMethod:Ljava/lang/String;

    iput-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->piaRiskMethod:Ljava/lang/String;

    .line 53
    iget-boolean v1, p0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->piaRiskHasBooleanArg:Z

    iput-boolean v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->piaRiskHasBooleanArg:Z

    .line 54
    iget-object v1, p0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->piaSetViewMethod:Ljava/lang/String;

    iput-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->piaSetViewMethod:Ljava/lang/String;

    .line 55
    iget-object v1, p0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->authChildClass:Ljava/lang/String;

    iput-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->authChildClass:Ljava/lang/String;

    .line 56
    iget-object v1, p0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->authChildCheckMethod:Ljava/lang/String;

    iput-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->authChildCheckMethod:Ljava/lang/String;

    .line 57
    iget-object v1, p0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->authEntryClass:Ljava/lang/String;

    iput-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->authEntryClass:Ljava/lang/String;

    .line 58
    iget-object v1, p0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->authEntryMethod:Ljava/lang/String;

    iput-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->authEntryMethod:Ljava/lang/String;

    .line 59
    iget-object v1, p0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->pureClass:Ljava/lang/String;

    iput-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->pureClass:Ljava/lang/String;

    .line 60
    iget-object v1, p0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->pureStatusMethod:Ljava/lang/String;

    iput-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->pureStatusMethod:Ljava/lang/String;

    .line 61
    iget-object v1, p0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->adManagerClass:Ljava/lang/String;

    iput-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->adManagerClass:Ljava/lang/String;

    .line 62
    iget-object v1, p0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->adManagerMethod:Ljava/lang/String;

    iput-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->adManagerMethod:Ljava/lang/String;

    .line 63
    iget-object v1, p0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->storeClass:Ljava/lang/String;

    iput-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->storeClass:Ljava/lang/String;

    .line 64
    iget-object v1, p0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->anonymousClass:Ljava/lang/String;

    iput-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->anonymousClass:Ljava/lang/String;

    .line 65
    iget-object v1, p0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->unknownSourceClass:Ljava/lang/String;

    iput-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->unknownSourceClass:Ljava/lang/String;

    .line 66
    iget-object p0, p0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->orientationClass:Ljava/lang/String;

    iput-object p0, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->orientationClass:Ljava/lang/String;

    return-object v0
.end method
