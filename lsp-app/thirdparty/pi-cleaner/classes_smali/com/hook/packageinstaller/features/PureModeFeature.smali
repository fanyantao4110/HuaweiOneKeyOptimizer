.class public final Lcom/hook/packageinstaller/features/PureModeFeature;
.super Ljava/lang/Object;
.source "PureModeFeature.java"

# interfaces
.implements Lcom/hook/packageinstaller/features/Feature;


# static fields
.field private static final TAG:Ljava/lang/String; = "PI-Cleaner/PureMode"


# direct methods
.method public constructor <init>()V
    .registers 1

    .line 16
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public id()Ljava/lang/String;
    .registers 1

    .line 21
    const-string p0, "pure_mode_bypass"

    return-object p0
.end method

.method public install(Lcom/hook/packageinstaller/core/HookContext;)V
    .registers 6

    .line 26
    invoke-virtual {p1}, Lcom/hook/packageinstaller/core/HookContext;->classes()Lcom/hook/packageinstaller/profiles/ProfileClasses;

    move-result-object v0

    .line 27
    iget-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->pureClass:Ljava/lang/String;

    if-eqz v1, :cond_44

    iget-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->pureStatusMethod:Ljava/lang/String;

    if-nez v1, :cond_d

    goto :goto_44

    .line 30
    :cond_d
    iget-object p1, p1, Lcom/hook/packageinstaller/core/HookContext;->classLoader:Ljava/lang/ClassLoader;

    iget-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->pureClass:Ljava/lang/String;

    iget-object v2, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->pureStatusMethod:Ljava/lang/String;

    new-instance v3, Lcom/hook/packageinstaller/features/PureModeFeature$1;

    invoke-direct {v3, p0}, Lcom/hook/packageinstaller/features/PureModeFeature$1;-><init>(Lcom/hook/packageinstaller/features/PureModeFeature;)V

    filled-new-array {v3}, [Ljava/lang/Object;

    move-result-object p0

    invoke-static {p1, v1, v2, p0}, Lcom/hook/packageinstaller/core/SafeXposed;->hookMethod(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Object;)Z

    move-result p0

    if-nez p0, :cond_44

    .line 38
    new-instance p0, Ljava/lang/StringBuilder;

    const-string p1, "Pure-mode status not hooked: "

    invoke-direct {p0, p1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object p1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->pureClass:Ljava/lang/String;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    const-string p1, "#"

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    iget-object p1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->pureStatusMethod:Ljava/lang/String;

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "PI-Cleaner/PureMode"

    invoke-static {p1, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    :cond_44
    :goto_44
    return-void
.end method
