.class public final Lcom/hook/packageinstaller/features/FeatureRegistry;
.super Ljava/lang/Object;
.source "FeatureRegistry.java"


# static fields
.field private static final TAG:Ljava/lang/String; = "PI-Cleaner/Features"


# direct methods
.method private constructor <init>()V
    .registers 1

    .line 14
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static install(Lcom/hook/packageinstaller/core/HookContext;)V
    .registers 7

    .line 18
    iget-object v0, p0, Lcom/hook/packageinstaller/core/HookContext;->config:Lcom/hook/packageinstaller/config/FeatureConfig;

    .line 19
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    .line 21
    iget-boolean v2, v0, Lcom/hook/packageinstaller/config/FeatureConfig;->orientationLockFix:Z

    if-eqz v2, :cond_13

    .line 22
    new-instance v2, Lcom/hook/packageinstaller/features/OrientationLockFeature;

    invoke-direct {v2}, Lcom/hook/packageinstaller/features/OrientationLockFeature;-><init>()V

    invoke-interface {v1, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 24
    :cond_13
    iget-boolean v2, v0, Lcom/hook/packageinstaller/config/FeatureConfig;->authBypass:Z

    if-eqz v2, :cond_1f

    .line 25
    new-instance v2, Lcom/hook/packageinstaller/features/AuthBypassFeature;

    invoke-direct {v2}, Lcom/hook/packageinstaller/features/AuthBypassFeature;-><init>()V

    invoke-interface {v1, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 27
    :cond_1f
    iget-boolean v2, v0, Lcom/hook/packageinstaller/config/FeatureConfig;->riskBypass:Z

    if-eqz v2, :cond_2b

    .line 28
    new-instance v2, Lcom/hook/packageinstaller/features/RiskBypassFeature;

    invoke-direct {v2}, Lcom/hook/packageinstaller/features/RiskBypassFeature;-><init>()V

    invoke-interface {v1, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 30
    :cond_2b
    iget-boolean v2, v0, Lcom/hook/packageinstaller/config/FeatureConfig;->riskUiClean:Z

    if-eqz v2, :cond_37

    .line 31
    new-instance v2, Lcom/hook/packageinstaller/features/RiskUiCleanFeature;

    invoke-direct {v2}, Lcom/hook/packageinstaller/features/RiskUiCleanFeature;-><init>()V

    invoke-interface {v1, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 33
    :cond_37
    iget-boolean v2, v0, Lcom/hook/packageinstaller/config/FeatureConfig;->adClean:Z

    if-eqz v2, :cond_43

    .line 34
    new-instance v2, Lcom/hook/packageinstaller/features/AdFeature;

    invoke-direct {v2}, Lcom/hook/packageinstaller/features/AdFeature;-><init>()V

    invoke-interface {v1, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 36
    :cond_43
    iget-boolean v2, v0, Lcom/hook/packageinstaller/config/FeatureConfig;->unknownSourceBypass:Z

    if-eqz v2, :cond_4f

    .line 37
    new-instance v2, Lcom/hook/packageinstaller/features/UnknownSourceFeature;

    invoke-direct {v2}, Lcom/hook/packageinstaller/features/UnknownSourceFeature;-><init>()V

    invoke-interface {v1, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 39
    :cond_4f
    iget-boolean v2, v0, Lcom/hook/packageinstaller/config/FeatureConfig;->pureModeBypass:Z

    if-eqz v2, :cond_5b

    .line 40
    new-instance v2, Lcom/hook/packageinstaller/features/PureModeFeature;

    invoke-direct {v2}, Lcom/hook/packageinstaller/features/PureModeFeature;-><init>()V

    invoke-interface {v1, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 42
    :cond_5b
    iget-boolean v2, v0, Lcom/hook/packageinstaller/config/FeatureConfig;->storeClean:Z

    if-eqz v2, :cond_67

    .line 43
    new-instance v2, Lcom/hook/packageinstaller/features/StoreFeature;

    invoke-direct {v2}, Lcom/hook/packageinstaller/features/StoreFeature;-><init>()V

    invoke-interface {v1, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 45
    :cond_67
    iget-boolean v2, v0, Lcom/hook/packageinstaller/config/FeatureConfig;->anonymousSourceBypass:Z

    if-eqz v2, :cond_73

    .line 46
    new-instance v2, Lcom/hook/packageinstaller/features/AnonymousSourceFeature;

    invoke-direct {v2}, Lcom/hook/packageinstaller/features/AnonymousSourceFeature;-><init>()V

    invoke-interface {v1, v2}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 48
    :cond_73
    iget-boolean v0, v0, Lcom/hook/packageinstaller/config/FeatureConfig;->promoUiClean:Z

    if-eqz v0, :cond_7f

    .line 49
    new-instance v0, Lcom/hook/packageinstaller/features/PromoUiFeature;

    invoke-direct {v0}, Lcom/hook/packageinstaller/features/PromoUiFeature;-><init>()V

    invoke-interface {v1, v0}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 52
    :cond_7f
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v2, "Installing "

    invoke-direct {v0, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v2

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object v0

    const-string v2, " features"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    const-string v2, "PI-Cleaner/Features"

    invoke-static {v2, v0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    .line 53
    invoke-interface {v1}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object v0

    :goto_a1
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_e3

    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Lcom/hook/packageinstaller/features/Feature;

    .line 55
    :try_start_ad
    invoke-interface {v1, p0}, Lcom/hook/packageinstaller/features/Feature;->install(Lcom/hook/packageinstaller/core/HookContext;)V

    .line 56
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "Feature installed: "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-interface {v1}, Lcom/hook/packageinstaller/features/Feature;->id()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v2, v3}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_ca
    .catchall {:try_start_ad .. :try_end_ca} :catchall_cb

    goto :goto_a1

    :catchall_cb
    move-exception v3

    .line 58
    new-instance v4, Ljava/lang/StringBuilder;

    const-string v5, "Feature failed: "

    invoke-direct {v4, v5}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-interface {v1}, Lcom/hook/packageinstaller/features/Feature;->id()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v1

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v2, v1, v3}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    goto :goto_a1

    :cond_e3
    return-void
.end method
