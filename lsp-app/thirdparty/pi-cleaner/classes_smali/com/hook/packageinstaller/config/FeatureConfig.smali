.class public final Lcom/hook/packageinstaller/config/FeatureConfig;
.super Ljava/lang/Object;
.source "FeatureConfig.java"


# instance fields
.field public adClean:Z

.field public anonymousSourceBypass:Z

.field public authBypass:Z

.field public orientationLockFix:Z

.field public promoUiClean:Z

.field public pureModeBypass:Z

.field public riskBypass:Z

.field public riskUiClean:Z

.field public storeClean:Z

.field public unknownSourceBypass:Z


# direct methods
.method public constructor <init>()V
    .registers 2

    .line 6
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    const/4 v0, 0x1

    .line 7
    iput-boolean v0, p0, Lcom/hook/packageinstaller/config/FeatureConfig;->adClean:Z

    .line 8
    iput-boolean v0, p0, Lcom/hook/packageinstaller/config/FeatureConfig;->storeClean:Z

    .line 9
    iput-boolean v0, p0, Lcom/hook/packageinstaller/config/FeatureConfig;->authBypass:Z

    .line 10
    iput-boolean v0, p0, Lcom/hook/packageinstaller/config/FeatureConfig;->riskBypass:Z

    .line 11
    iput-boolean v0, p0, Lcom/hook/packageinstaller/config/FeatureConfig;->riskUiClean:Z

    .line 12
    iput-boolean v0, p0, Lcom/hook/packageinstaller/config/FeatureConfig;->pureModeBypass:Z

    .line 13
    iput-boolean v0, p0, Lcom/hook/packageinstaller/config/FeatureConfig;->unknownSourceBypass:Z

    .line 14
    iput-boolean v0, p0, Lcom/hook/packageinstaller/config/FeatureConfig;->anonymousSourceBypass:Z

    .line 15
    iput-boolean v0, p0, Lcom/hook/packageinstaller/config/FeatureConfig;->promoUiClean:Z

    .line 16
    iput-boolean v0, p0, Lcom/hook/packageinstaller/config/FeatureConfig;->orientationLockFix:Z

    return-void
.end method

.method private static get(Landroid/os/Bundle;Ljava/lang/String;Z)Z
    .registers 4

    if-eqz p0, :cond_e

    .line 51
    invoke-virtual {p0, p1}, Landroid/os/Bundle;->containsKey(Ljava/lang/String;)Z

    move-result v0

    if-nez v0, :cond_9

    goto :goto_e

    .line 54
    :cond_9
    invoke-virtual {p0, p1, p2}, Landroid/os/Bundle;->getBoolean(Ljava/lang/String;Z)Z

    move-result p0

    return p0

    :cond_e
    :goto_e
    return p2
.end method


# virtual methods
.method public apply(Landroid/content/SharedPreferences;)V
    .registers 4

    if-nez p1, :cond_3

    return-void

    .line 38
    :cond_3
    const-string v0, "ad_clean"

    iget-boolean v1, p0, Lcom/hook/packageinstaller/config/FeatureConfig;->adClean:Z

    invoke-interface {p1, v0, v1}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v0

    iput-boolean v0, p0, Lcom/hook/packageinstaller/config/FeatureConfig;->adClean:Z

    .line 39
    const-string v0, "store_clean"

    iget-boolean v1, p0, Lcom/hook/packageinstaller/config/FeatureConfig;->storeClean:Z

    invoke-interface {p1, v0, v1}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v0

    iput-boolean v0, p0, Lcom/hook/packageinstaller/config/FeatureConfig;->storeClean:Z

    .line 40
    const-string v0, "auth_bypass"

    iget-boolean v1, p0, Lcom/hook/packageinstaller/config/FeatureConfig;->authBypass:Z

    invoke-interface {p1, v0, v1}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v0

    iput-boolean v0, p0, Lcom/hook/packageinstaller/config/FeatureConfig;->authBypass:Z

    .line 41
    const-string v0, "risk_bypass"

    iget-boolean v1, p0, Lcom/hook/packageinstaller/config/FeatureConfig;->riskBypass:Z

    invoke-interface {p1, v0, v1}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v0

    iput-boolean v0, p0, Lcom/hook/packageinstaller/config/FeatureConfig;->riskBypass:Z

    .line 42
    const-string v0, "risk_ui_clean"

    iget-boolean v1, p0, Lcom/hook/packageinstaller/config/FeatureConfig;->riskUiClean:Z

    invoke-interface {p1, v0, v1}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v0

    iput-boolean v0, p0, Lcom/hook/packageinstaller/config/FeatureConfig;->riskUiClean:Z

    .line 43
    const-string v0, "pure_mode_bypass"

    iget-boolean v1, p0, Lcom/hook/packageinstaller/config/FeatureConfig;->pureModeBypass:Z

    invoke-interface {p1, v0, v1}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v0

    iput-boolean v0, p0, Lcom/hook/packageinstaller/config/FeatureConfig;->pureModeBypass:Z

    .line 44
    const-string v0, "unknown_source_bypass"

    iget-boolean v1, p0, Lcom/hook/packageinstaller/config/FeatureConfig;->unknownSourceBypass:Z

    invoke-interface {p1, v0, v1}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v0

    iput-boolean v0, p0, Lcom/hook/packageinstaller/config/FeatureConfig;->unknownSourceBypass:Z

    .line 45
    const-string v0, "anonymous_source_bypass"

    iget-boolean v1, p0, Lcom/hook/packageinstaller/config/FeatureConfig;->anonymousSourceBypass:Z

    invoke-interface {p1, v0, v1}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v0

    iput-boolean v0, p0, Lcom/hook/packageinstaller/config/FeatureConfig;->anonymousSourceBypass:Z

    .line 46
    const-string v0, "promo_ui_clean"

    iget-boolean v1, p0, Lcom/hook/packageinstaller/config/FeatureConfig;->promoUiClean:Z

    invoke-interface {p1, v0, v1}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result v0

    iput-boolean v0, p0, Lcom/hook/packageinstaller/config/FeatureConfig;->promoUiClean:Z

    .line 47
    const-string v0, "orientation_lock_fix"

    iget-boolean v1, p0, Lcom/hook/packageinstaller/config/FeatureConfig;->orientationLockFix:Z

    invoke-interface {p1, v0, v1}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result p1

    iput-boolean p1, p0, Lcom/hook/packageinstaller/config/FeatureConfig;->orientationLockFix:Z

    return-void
.end method

.method public apply(Landroid/os/Bundle;)V
    .registers 4

    if-nez p1, :cond_3

    return-void

    .line 22
    :cond_3
    const-string v0, "ad_clean"

    iget-boolean v1, p0, Lcom/hook/packageinstaller/config/FeatureConfig;->adClean:Z

    invoke-static {p1, v0, v1}, Lcom/hook/packageinstaller/config/FeatureConfig;->get(Landroid/os/Bundle;Ljava/lang/String;Z)Z

    move-result v0

    iput-boolean v0, p0, Lcom/hook/packageinstaller/config/FeatureConfig;->adClean:Z

    .line 23
    const-string v0, "store_clean"

    iget-boolean v1, p0, Lcom/hook/packageinstaller/config/FeatureConfig;->storeClean:Z

    invoke-static {p1, v0, v1}, Lcom/hook/packageinstaller/config/FeatureConfig;->get(Landroid/os/Bundle;Ljava/lang/String;Z)Z

    move-result v0

    iput-boolean v0, p0, Lcom/hook/packageinstaller/config/FeatureConfig;->storeClean:Z

    .line 24
    const-string v0, "auth_bypass"

    iget-boolean v1, p0, Lcom/hook/packageinstaller/config/FeatureConfig;->authBypass:Z

    invoke-static {p1, v0, v1}, Lcom/hook/packageinstaller/config/FeatureConfig;->get(Landroid/os/Bundle;Ljava/lang/String;Z)Z

    move-result v0

    iput-boolean v0, p0, Lcom/hook/packageinstaller/config/FeatureConfig;->authBypass:Z

    .line 25
    const-string v0, "risk_bypass"

    iget-boolean v1, p0, Lcom/hook/packageinstaller/config/FeatureConfig;->riskBypass:Z

    invoke-static {p1, v0, v1}, Lcom/hook/packageinstaller/config/FeatureConfig;->get(Landroid/os/Bundle;Ljava/lang/String;Z)Z

    move-result v0

    iput-boolean v0, p0, Lcom/hook/packageinstaller/config/FeatureConfig;->riskBypass:Z

    .line 26
    const-string v0, "risk_ui_clean"

    iget-boolean v1, p0, Lcom/hook/packageinstaller/config/FeatureConfig;->riskUiClean:Z

    invoke-static {p1, v0, v1}, Lcom/hook/packageinstaller/config/FeatureConfig;->get(Landroid/os/Bundle;Ljava/lang/String;Z)Z

    move-result v0

    iput-boolean v0, p0, Lcom/hook/packageinstaller/config/FeatureConfig;->riskUiClean:Z

    .line 27
    const-string v0, "pure_mode_bypass"

    iget-boolean v1, p0, Lcom/hook/packageinstaller/config/FeatureConfig;->pureModeBypass:Z

    invoke-static {p1, v0, v1}, Lcom/hook/packageinstaller/config/FeatureConfig;->get(Landroid/os/Bundle;Ljava/lang/String;Z)Z

    move-result v0

    iput-boolean v0, p0, Lcom/hook/packageinstaller/config/FeatureConfig;->pureModeBypass:Z

    .line 28
    const-string v0, "unknown_source_bypass"

    iget-boolean v1, p0, Lcom/hook/packageinstaller/config/FeatureConfig;->unknownSourceBypass:Z

    invoke-static {p1, v0, v1}, Lcom/hook/packageinstaller/config/FeatureConfig;->get(Landroid/os/Bundle;Ljava/lang/String;Z)Z

    move-result v0

    iput-boolean v0, p0, Lcom/hook/packageinstaller/config/FeatureConfig;->unknownSourceBypass:Z

    .line 29
    const-string v0, "anonymous_source_bypass"

    iget-boolean v1, p0, Lcom/hook/packageinstaller/config/FeatureConfig;->anonymousSourceBypass:Z

    invoke-static {p1, v0, v1}, Lcom/hook/packageinstaller/config/FeatureConfig;->get(Landroid/os/Bundle;Ljava/lang/String;Z)Z

    move-result v0

    iput-boolean v0, p0, Lcom/hook/packageinstaller/config/FeatureConfig;->anonymousSourceBypass:Z

    .line 30
    const-string v0, "promo_ui_clean"

    iget-boolean v1, p0, Lcom/hook/packageinstaller/config/FeatureConfig;->promoUiClean:Z

    invoke-static {p1, v0, v1}, Lcom/hook/packageinstaller/config/FeatureConfig;->get(Landroid/os/Bundle;Ljava/lang/String;Z)Z

    move-result v0

    iput-boolean v0, p0, Lcom/hook/packageinstaller/config/FeatureConfig;->promoUiClean:Z

    .line 31
    const-string v0, "orientation_lock_fix"

    iget-boolean v1, p0, Lcom/hook/packageinstaller/config/FeatureConfig;->orientationLockFix:Z

    invoke-static {p1, v0, v1}, Lcom/hook/packageinstaller/config/FeatureConfig;->get(Landroid/os/Bundle;Ljava/lang/String;Z)Z

    move-result p1

    iput-boolean p1, p0, Lcom/hook/packageinstaller/config/FeatureConfig;->orientationLockFix:Z

    return-void
.end method
