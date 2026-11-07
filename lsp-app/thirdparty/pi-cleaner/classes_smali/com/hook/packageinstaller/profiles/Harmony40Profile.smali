.class public final Lcom/hook/packageinstaller/profiles/Harmony40Profile;
.super Lcom/hook/packageinstaller/profiles/BaseProfile;
.source "Harmony40Profile.java"


# direct methods
.method public constructor <init>()V
    .registers 12

    const/4 v0, 0x3

    .line 5
    new-array v9, v0, [Ljava/lang/String;

    const/4 v0, 0x0

    const-string v1, "defpackage.cv"

    aput-object v1, v9, v0

    const/4 v0, 0x1

    const-string v1, "defpackage.dd"

    aput-object v1, v9, v0

    const/4 v0, 0x2

    const-string v1, "defpackage.ek"

    aput-object v1, v9, v0

    .line 8
    invoke-static {}, Lcom/hook/packageinstaller/profiles/Harmony40Profile;->createClasses()Lcom/hook/packageinstaller/profiles/ProfileClasses;

    move-result-object v10

    .line 5
    const-string v2, "PI_40"

    const-string v3, "HarmonyOS 4.0 安装器"

    const-string v4, "13.2."

    const-wide/32 v5, 0x4d9af180

    const-wide/32 v7, 0x4daa33bf

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
    const-string v1, "defpackage.aq"

    iput-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->stagingRiskClass:Ljava/lang/String;

    .line 14
    const-string v1, "h"

    iput-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->stagingRiskMethod:Ljava/lang/String;

    .line 15
    const-string v1, "a"

    iput-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->stagingContinueMethod:Ljava/lang/String;

    .line 16
    iput-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->piaRiskMethod:Ljava/lang/String;

    const/4 v2, 0x1

    .line 17
    iput-boolean v2, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->piaRiskHasBooleanArg:Z

    .line 18
    const-string v2, "b"

    iput-object v2, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->piaSetViewMethod:Ljava/lang/String;

    .line 19
    const-string v2, "defpackage.cr"

    iput-object v2, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->authChildClass:Ljava/lang/String;

    .line 20
    iput-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->authChildCheckMethod:Ljava/lang/String;

    .line 21
    const-string v2, "defpackage.dt"

    iput-object v2, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->authEntryClass:Ljava/lang/String;

    .line 22
    iput-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->authEntryMethod:Ljava/lang/String;

    .line 23
    const-string v2, "defpackage.cv"

    iput-object v2, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->pureClass:Ljava/lang/String;

    .line 24
    iput-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->pureStatusMethod:Ljava/lang/String;

    .line 25
    const-string v2, "defpackage.at"

    iput-object v2, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->adManagerClass:Ljava/lang/String;

    .line 26
    iput-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->adManagerMethod:Ljava/lang/String;

    .line 27
    const-string v1, "defpackage.ck"

    iput-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->storeClass:Ljava/lang/String;

    .line 28
    const-string v1, "defpackage.ek"

    iput-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->anonymousClass:Ljava/lang/String;

    .line 29
    const-string v1, "defpackage.eo"

    iput-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->unknownSourceClass:Ljava/lang/String;

    .line 30
    const-string v1, "defpackage.dd"

    iput-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->orientationClass:Ljava/lang/String;

    return-object v0
.end method
