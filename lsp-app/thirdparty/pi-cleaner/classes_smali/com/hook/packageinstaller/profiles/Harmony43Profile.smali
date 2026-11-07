.class public final Lcom/hook/packageinstaller/profiles/Harmony43Profile;
.super Lcom/hook/packageinstaller/profiles/BaseProfile;
.source "Harmony43Profile.java"


# direct methods
.method public constructor <init>()V
    .registers 12

    const/4 v0, 0x3

    .line 5
    new-array v9, v0, [Ljava/lang/String;

    const/4 v0, 0x0

    const-string v1, "defpackage.i7"

    aput-object v1, v9, v0

    const/4 v0, 0x1

    const-string v1, "defpackage.x8"

    aput-object v1, v9, v0

    const/4 v0, 0x2

    const-string v1, "defpackage.t4"

    aput-object v1, v9, v0

    .line 8
    invoke-static {}, Lcom/hook/packageinstaller/profiles/Harmony43Profile;->createClasses()Lcom/hook/packageinstaller/profiles/ProfileClasses;

    move-result-object v10

    .line 5
    const-string v2, "PI_43"

    const-string v3, "HarmonyOS 4.3 安装器"

    const-string v4, "15.2."

    const-wide/32 v5, 0x5986b380

    const-wide/32 v7, 0x5995f5bf

    move-object v1, p0

    invoke-direct/range {v1 .. v10}, Lcom/hook/packageinstaller/profiles/BaseProfile;-><init>(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;JJ[Ljava/lang/String;Lcom/hook/packageinstaller/profiles/ProfileClasses;)V

    return-void
.end method

.method private static createClasses()Lcom/hook/packageinstaller/profiles/ProfileClasses;
    .registers 3

    .line 12
    new-instance v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;

    invoke-direct {v0}, Lcom/hook/packageinstaller/profiles/ProfileClasses;-><init>()V

    .line 13
    const-string v1, "defpackage.t4"

    iput-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->stagingRiskClass:Ljava/lang/String;

    .line 14
    const-string v1, "g1"

    iput-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->stagingRiskMethod:Ljava/lang/String;

    .line 15
    const-string v1, "i0"

    iput-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->stagingContinueMethod:Ljava/lang/String;

    .line 16
    const-string v1, "N0"

    iput-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->piaRiskMethod:Ljava/lang/String;

    const/4 v1, 0x1

    .line 17
    iput-boolean v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->piaRiskHasBooleanArg:Z

    .line 18
    const-string v1, "B0"

    iput-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->piaSetViewMethod:Ljava/lang/String;

    .line 19
    const-string v1, "defpackage.w6"

    iput-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->authChildClass:Ljava/lang/String;

    .line 20
    const-string v1, "d"

    iput-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->authChildCheckMethod:Ljava/lang/String;

    .line 21
    const-string v2, "defpackage.ra"

    iput-object v2, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->authEntryClass:Ljava/lang/String;

    .line 22
    const-string v2, "l"

    iput-object v2, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->authEntryMethod:Ljava/lang/String;

    .line 23
    const-string v2, "defpackage.i7"

    iput-object v2, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->pureClass:Ljava/lang/String;

    .line 24
    iput-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->pureStatusMethod:Ljava/lang/String;

    .line 25
    const-string v1, "defpackage.j"

    iput-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->adManagerClass:Ljava/lang/String;

    .line 26
    const-string v1, "j"

    iput-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->adManagerMethod:Ljava/lang/String;

    .line 27
    const-string v1, "defpackage.z2"

    iput-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->storeClass:Ljava/lang/String;

    .line 28
    const-string v1, "defpackage.n"

    iput-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->anonymousClass:Ljava/lang/String;

    .line 29
    const-string v1, "defpackage.f2"

    iput-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->unknownSourceClass:Ljava/lang/String;

    .line 30
    const-string v1, "defpackage.x8"

    iput-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->orientationClass:Ljava/lang/String;

    return-object v0
.end method
