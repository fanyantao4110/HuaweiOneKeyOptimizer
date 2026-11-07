.class public final Lcom/hook/packageinstaller/features/RiskUiCleanFeature;
.super Ljava/lang/Object;
.source "RiskUiCleanFeature.java"

# interfaces
.implements Lcom/hook/packageinstaller/features/Feature;


# static fields
.field private static final RISK_VIEWS:[Ljava/lang/String;

.field private static final TAG:Ljava/lang/String; = "PI-Cleaner/RiskUi"


# direct methods
.method static constructor <clinit>()V
    .registers 3

    const/16 v0, 0x9

    .line 23
    new-array v0, v0, [Ljava/lang/String;

    const/4 v1, 0x0

    const-string v2, "risk_check_layout"

    aput-object v2, v0, v1

    const/4 v1, 0x1

    const-string v2, "risk_img"

    aput-object v2, v0, v1

    const/4 v1, 0x2

    const-string v2, "risk_tip_title"

    aput-object v2, v0, v1

    const/4 v1, 0x3

    const-string v2, "risk_desc_tv"

    aput-object v2, v0, v1

    const/4 v1, 0x4

    const-string v2, "risk_desc_content"

    aput-object v2, v0, v1

    const/4 v1, 0x5

    const-string v2, "pure_introduction_tv"

    aput-object v2, v0, v1

    const/4 v1, 0x6

    const-string v2, "go_setting_layout"

    aput-object v2, v0, v1

    const/4 v1, 0x7

    const-string v2, "setNetWork"

    aput-object v2, v0, v1

    const/16 v1, 0x8

    const-string v2, "network_arrow"

    aput-object v2, v0, v1

    sput-object v0, Lcom/hook/packageinstaller/features/RiskUiCleanFeature;->RISK_VIEWS:[Ljava/lang/String;

    return-void
.end method

.method public constructor <init>()V
    .registers 1

    .line 20
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static hide(Landroid/app/Activity;)V
    .registers 8

    if-nez p0, :cond_3

    return-void

    .line 70
    :cond_3
    sget-object v0, Lcom/hook/packageinstaller/features/RiskUiCleanFeature;->RISK_VIEWS:[Ljava/lang/String;

    array-length v1, v0

    const/4 v2, 0x0

    :goto_7
    if-ge v2, v1, :cond_4b

    aget-object v3, v0, v2

    .line 72
    :try_start_b
    invoke-virtual {p0}, Landroid/app/Activity;->getResources()Landroid/content/res/Resources;

    move-result-object v4

    const-string v5, "id"

    .line 73
    invoke-virtual {p0}, Landroid/app/Activity;->getPackageName()Ljava/lang/String;

    move-result-object v6

    .line 72
    invoke-virtual {v4, v3, v5, v6}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result v4

    if-nez v4, :cond_1c

    goto :goto_48

    .line 77
    :cond_1c
    invoke-virtual {p0, v4}, Landroid/app/Activity;->findViewById(I)Landroid/view/View;

    move-result-object v4

    if-nez v4, :cond_23

    goto :goto_48

    :cond_23
    const/16 v5, 0x8

    .line 81
    invoke-virtual {v4, v5}, Landroid/view/View;->setVisibility(I)V

    .line 82
    instance-of v5, v4, Landroid/widget/ImageView;

    if-eqz v5, :cond_48

    .line 83
    check-cast v4, Landroid/widget/ImageView;

    const/4 v5, 0x0

    invoke-virtual {v4, v5}, Landroid/widget/ImageView;->setImageDrawable(Landroid/graphics/drawable/Drawable;)V
    :try_end_32
    .catchall {:try_start_b .. :try_end_32} :catchall_33

    goto :goto_48

    :catchall_33
    move-exception v4

    .line 86
    new-instance v5, Ljava/lang/StringBuilder;

    const-string v6, "Unable to hide risk view: "

    invoke-direct {v5, v6}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v5, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object v3

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    const-string v5, "PI-Cleaner/RiskUi"

    invoke-static {v5, v3, v4}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :cond_48
    :goto_48
    add-int/lit8 v2, v2, 0x1

    goto :goto_7

    :cond_4b
    return-void
.end method


# virtual methods
.method public id()Ljava/lang/String;
    .registers 1

    .line 37
    const-string p0, "risk_ui_clean"

    return-object p0
.end method

.method public install(Lcom/hook/packageinstaller/core/HookContext;)V
    .registers 7

    .line 42
    invoke-virtual {p1}, Lcom/hook/packageinstaller/core/HookContext;->classes()Lcom/hook/packageinstaller/profiles/ProfileClasses;

    move-result-object v0

    iget-object v0, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->packageInstallerActivity:Ljava/lang/String;

    .line 44
    iget-object v1, p1, Lcom/hook/packageinstaller/core/HookContext;->classLoader:Ljava/lang/ClassLoader;

    new-instance v2, Lcom/hook/packageinstaller/features/RiskUiCleanFeature$1;

    invoke-direct {v2, p0}, Lcom/hook/packageinstaller/features/RiskUiCleanFeature$1;-><init>(Lcom/hook/packageinstaller/features/RiskUiCleanFeature;)V

    filled-new-array {v2}, [Ljava/lang/Object;

    move-result-object v2

    const-string v3, "onResume"

    invoke-static {v1, v0, v3, v2}, Lcom/hook/packageinstaller/core/SafeXposed;->hookMethod(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Object;)Z

    .line 52
    iget-object v1, p1, Lcom/hook/packageinstaller/core/HookContext;->classLoader:Ljava/lang/ClassLoader;

    .line 53
    invoke-virtual {p1}, Lcom/hook/packageinstaller/core/HookContext;->classes()Lcom/hook/packageinstaller/profiles/ProfileClasses;

    move-result-object v2

    iget-object v2, v2, Lcom/hook/packageinstaller/profiles/ProfileClasses;->installationControlResult:Ljava/lang/String;

    .line 52
    invoke-static {v1, v2}, Lcom/hook/packageinstaller/core/SafeXposed;->findClass(Ljava/lang/ClassLoader;Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v1

    if-eqz v1, :cond_42

    .line 54
    invoke-virtual {p1}, Lcom/hook/packageinstaller/core/HookContext;->classes()Lcom/hook/packageinstaller/profiles/ProfileClasses;

    move-result-object v2

    iget-object v2, v2, Lcom/hook/packageinstaller/profiles/ProfileClasses;->piaSetViewMethod:Ljava/lang/String;

    if-eqz v2, :cond_42

    .line 55
    iget-object v2, p1, Lcom/hook/packageinstaller/core/HookContext;->classLoader:Ljava/lang/ClassLoader;

    .line 56
    invoke-virtual {p1}, Lcom/hook/packageinstaller/core/HookContext;->classes()Lcom/hook/packageinstaller/profiles/ProfileClasses;

    move-result-object p1

    iget-object p1, p1, Lcom/hook/packageinstaller/profiles/ProfileClasses;->piaSetViewMethod:Ljava/lang/String;

    sget-object v3, Ljava/lang/Boolean;->TYPE:Ljava/lang/Class;

    new-instance v4, Lcom/hook/packageinstaller/features/RiskUiCleanFeature$2;

    invoke-direct {v4, p0}, Lcom/hook/packageinstaller/features/RiskUiCleanFeature$2;-><init>(Lcom/hook/packageinstaller/features/RiskUiCleanFeature;)V

    filled-new-array {v1, v3, v4}, [Ljava/lang/Object;

    move-result-object p0

    .line 55
    invoke-static {v2, v0, p1, p0}, Lcom/hook/packageinstaller/core/SafeXposed;->hookMethod(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Object;)Z

    :cond_42
    return-void
.end method
