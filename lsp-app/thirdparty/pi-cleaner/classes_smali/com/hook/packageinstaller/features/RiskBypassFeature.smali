.class public final Lcom/hook/packageinstaller/features/RiskBypassFeature;
.super Ljava/lang/Object;
.source "RiskBypassFeature.java"

# interfaces
.implements Lcom/hook/packageinstaller/features/Feature;


# static fields
.field private static final TAG:Ljava/lang/String; = "PI-Cleaner/Risk"


# direct methods
.method public constructor <init>()V
    .registers 1

    .line 20
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static hookConfirmation(Lcom/hook/packageinstaller/core/HookContext;Lcom/hook/packageinstaller/profiles/ProfileClasses;)V
    .registers 8

    .line 77
    iget-object v0, p1, Lcom/hook/packageinstaller/profiles/ProfileClasses;->piaRiskMethod:Ljava/lang/String;

    if-eqz v0, :cond_6e

    iget-object v0, p1, Lcom/hook/packageinstaller/profiles/ProfileClasses;->piaSetViewMethod:Ljava/lang/String;

    if-nez v0, :cond_9

    goto :goto_6e

    .line 80
    :cond_9
    iget-object v0, p0, Lcom/hook/packageinstaller/core/HookContext;->classLoader:Ljava/lang/ClassLoader;

    iget-object v1, p1, Lcom/hook/packageinstaller/profiles/ProfileClasses;->installationControlResult:Ljava/lang/String;

    invoke-static {v0, v1}, Lcom/hook/packageinstaller/core/SafeXposed;->findClass(Ljava/lang/ClassLoader;Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v0

    if-nez v0, :cond_14

    return-void

    .line 85
    :cond_14
    iget-object v1, p0, Lcom/hook/packageinstaller/core/HookContext;->classLoader:Ljava/lang/ClassLoader;

    iget-object v2, p1, Lcom/hook/packageinstaller/profiles/ProfileClasses;->packageInstallerActivity:Ljava/lang/String;

    iget-object v3, p1, Lcom/hook/packageinstaller/profiles/ProfileClasses;->piaSetViewMethod:Ljava/lang/String;

    const/4 v4, 0x2

    new-array v4, v4, [Ljava/lang/Class;

    const/4 v5, 0x0

    aput-object v0, v4, v5

    const/4 v0, 0x1

    sget-object v5, Ljava/lang/Boolean;->TYPE:Ljava/lang/Class;

    aput-object v5, v4, v0

    invoke-static {v1, v2, v3, v4}, Lcom/hook/packageinstaller/core/SafeXposed;->methodExists(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;)Z

    move-result v0

    if-nez v0, :cond_48

    .line 88
    new-instance p0, Ljava/lang/StringBuilder;

    const-string v0, "PIA setView method missing: "

    invoke-direct {p0, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object p1, p1, Lcom/hook/packageinstaller/profiles/ProfileClasses;->piaSetViewMethod:Ljava/lang/String;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    const-string p1, "(InstallationControlResult, boolean)"

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "PI-Cleaner/Risk"

    invoke-static {p1, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    .line 93
    :cond_48
    new-instance v0, Lcom/hook/packageinstaller/features/RiskBypassFeature$2;

    invoke-direct {v0, p0, p1}, Lcom/hook/packageinstaller/features/RiskBypassFeature$2;-><init>(Lcom/hook/packageinstaller/core/HookContext;Lcom/hook/packageinstaller/profiles/ProfileClasses;)V

    .line 111
    iget-boolean v1, p1, Lcom/hook/packageinstaller/profiles/ProfileClasses;->piaRiskHasBooleanArg:Z

    if-eqz v1, :cond_61

    .line 112
    iget-object p0, p0, Lcom/hook/packageinstaller/core/HookContext;->classLoader:Ljava/lang/ClassLoader;

    iget-object v1, p1, Lcom/hook/packageinstaller/profiles/ProfileClasses;->packageInstallerActivity:Ljava/lang/String;

    iget-object p1, p1, Lcom/hook/packageinstaller/profiles/ProfileClasses;->piaRiskMethod:Ljava/lang/String;

    sget-object v2, Ljava/lang/Boolean;->TYPE:Ljava/lang/Class;

    filled-new-array {v2, v0}, [Ljava/lang/Object;

    move-result-object v0

    invoke-static {p0, v1, p1, v0}, Lcom/hook/packageinstaller/core/SafeXposed;->hookMethod(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Object;)Z

    goto :goto_6e

    .line 115
    :cond_61
    iget-object p0, p0, Lcom/hook/packageinstaller/core/HookContext;->classLoader:Ljava/lang/ClassLoader;

    iget-object v1, p1, Lcom/hook/packageinstaller/profiles/ProfileClasses;->packageInstallerActivity:Ljava/lang/String;

    iget-object p1, p1, Lcom/hook/packageinstaller/profiles/ProfileClasses;->piaRiskMethod:Ljava/lang/String;

    filled-new-array {v0}, [Ljava/lang/Object;

    move-result-object v0

    invoke-static {p0, v1, p1, v0}, Lcom/hook/packageinstaller/core/SafeXposed;->hookMethod(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Object;)Z

    :cond_6e
    :goto_6e
    return-void
.end method

.method private static hookStaging(Lcom/hook/packageinstaller/core/HookContext;Lcom/hook/packageinstaller/profiles/ProfileClasses;)V
    .registers 10

    .line 36
    iget-object v0, p1, Lcom/hook/packageinstaller/profiles/ProfileClasses;->stagingRiskClass:Ljava/lang/String;

    if-eqz v0, :cond_92

    iget-object v0, p1, Lcom/hook/packageinstaller/profiles/ProfileClasses;->stagingRiskMethod:Ljava/lang/String;

    if-eqz v0, :cond_92

    iget-object v0, p1, Lcom/hook/packageinstaller/profiles/ProfileClasses;->stagingContinueMethod:Ljava/lang/String;

    if-nez v0, :cond_e

    goto/16 :goto_92

    .line 41
    :cond_e
    iget-object v0, p0, Lcom/hook/packageinstaller/core/HookContext;->classLoader:Ljava/lang/ClassLoader;

    iget-object v1, p1, Lcom/hook/packageinstaller/profiles/ProfileClasses;->installationControlResult:Ljava/lang/String;

    invoke-static {v0, v1}, Lcom/hook/packageinstaller/core/SafeXposed;->findClass(Ljava/lang/ClassLoader;Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v0

    .line 43
    const-string v1, "PI-Cleaner/Risk"

    if-nez v0, :cond_20

    .line 44
    const-string p0, "InstallationControlResult class missing"

    invoke-static {v1, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    .line 47
    :cond_20
    iget-object v2, p0, Lcom/hook/packageinstaller/core/HookContext;->classLoader:Ljava/lang/ClassLoader;

    iget-object v3, p1, Lcom/hook/packageinstaller/profiles/ProfileClasses;->stagingRiskClass:Ljava/lang/String;

    iget-object v4, p1, Lcom/hook/packageinstaller/profiles/ProfileClasses;->stagingRiskMethod:Ljava/lang/String;

    const/4 v5, 0x0

    new-array v6, v5, [Ljava/lang/Class;

    invoke-static {v2, v3, v4, v6}, Lcom/hook/packageinstaller/core/SafeXposed;->methodExists(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;)Z

    move-result v2

    const-string v3, "#"

    if-nez v2, :cond_50

    .line 49
    new-instance p0, Ljava/lang/StringBuilder;

    const-string v0, "Staging risk method missing: "

    invoke-direct {p0, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v0, p1, Lcom/hook/packageinstaller/profiles/ProfileClasses;->stagingRiskClass:Ljava/lang/String;

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    iget-object p1, p1, Lcom/hook/packageinstaller/profiles/ProfileClasses;->stagingRiskMethod:Ljava/lang/String;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v1, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    .line 53
    :cond_50
    iget-object v2, p0, Lcom/hook/packageinstaller/core/HookContext;->classLoader:Ljava/lang/ClassLoader;

    iget-object v4, p1, Lcom/hook/packageinstaller/profiles/ProfileClasses;->stagingRiskClass:Ljava/lang/String;

    iget-object v6, p1, Lcom/hook/packageinstaller/profiles/ProfileClasses;->stagingContinueMethod:Ljava/lang/String;

    const/4 v7, 0x1

    new-array v7, v7, [Ljava/lang/Class;

    aput-object v0, v7, v5

    invoke-static {v2, v4, v6, v7}, Lcom/hook/packageinstaller/core/SafeXposed;->methodExists(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Class;)Z

    move-result v0

    if-nez v0, :cond_80

    .line 55
    new-instance p0, Ljava/lang/StringBuilder;

    const-string v0, "Staging continue method missing: "

    invoke-direct {p0, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v0, p1, Lcom/hook/packageinstaller/profiles/ProfileClasses;->stagingRiskClass:Ljava/lang/String;

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    iget-object p1, p1, Lcom/hook/packageinstaller/profiles/ProfileClasses;->stagingContinueMethod:Ljava/lang/String;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v1, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    return-void

    .line 60
    :cond_80
    iget-object v0, p0, Lcom/hook/packageinstaller/core/HookContext;->classLoader:Ljava/lang/ClassLoader;

    iget-object v1, p1, Lcom/hook/packageinstaller/profiles/ProfileClasses;->stagingRiskClass:Ljava/lang/String;

    iget-object v2, p1, Lcom/hook/packageinstaller/profiles/ProfileClasses;->stagingRiskMethod:Ljava/lang/String;

    new-instance v3, Lcom/hook/packageinstaller/features/RiskBypassFeature$1;

    invoke-direct {v3, p0, p1}, Lcom/hook/packageinstaller/features/RiskBypassFeature$1;-><init>(Lcom/hook/packageinstaller/core/HookContext;Lcom/hook/packageinstaller/profiles/ProfileClasses;)V

    filled-new-array {v3}, [Ljava/lang/Object;

    move-result-object p0

    invoke-static {v0, v1, v2, p0}, Lcom/hook/packageinstaller/core/SafeXposed;->hookMethod(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Object;)Z

    :cond_92
    :goto_92
    return-void
.end method


# virtual methods
.method public id()Ljava/lang/String;
    .registers 1

    .line 25
    const-string p0, "risk_bypass"

    return-object p0
.end method

.method public install(Lcom/hook/packageinstaller/core/HookContext;)V
    .registers 2

    .line 30
    invoke-virtual {p1}, Lcom/hook/packageinstaller/core/HookContext;->classes()Lcom/hook/packageinstaller/profiles/ProfileClasses;

    move-result-object p0

    .line 31
    invoke-static {p1, p0}, Lcom/hook/packageinstaller/features/RiskBypassFeature;->hookStaging(Lcom/hook/packageinstaller/core/HookContext;Lcom/hook/packageinstaller/profiles/ProfileClasses;)V

    .line 32
    invoke-static {p1, p0}, Lcom/hook/packageinstaller/features/RiskBypassFeature;->hookConfirmation(Lcom/hook/packageinstaller/core/HookContext;Lcom/hook/packageinstaller/profiles/ProfileClasses;)V

    return-void
.end method
