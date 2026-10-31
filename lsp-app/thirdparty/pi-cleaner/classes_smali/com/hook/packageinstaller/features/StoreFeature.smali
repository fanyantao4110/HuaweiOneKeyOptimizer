.class public final Lcom/hook/packageinstaller/features/StoreFeature;
.super Ljava/lang/Object;
.source "StoreFeature.java"

# interfaces
.implements Lcom/hook/packageinstaller/features/Feature;


# static fields
.field private static final TAG:Ljava/lang/String; = "PI-Cleaner/Store"


# direct methods
.method public constructor <init>()V
    .registers 1

    .line 17
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public id()Ljava/lang/String;
    .registers 1

    .line 22
    const-string p0, "store_clean"

    return-object p0
.end method

.method public install(Lcom/hook/packageinstaller/core/HookContext;)V
    .registers 8

    .line 27
    invoke-virtual {p1}, Lcom/hook/packageinstaller/core/HookContext;->classes()Lcom/hook/packageinstaller/profiles/ProfileClasses;

    move-result-object v0

    iget-object v0, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->packageInstallerActivity:Ljava/lang/String;

    .line 28
    iget-object v1, p1, Lcom/hook/packageinstaller/core/HookContext;->classLoader:Ljava/lang/ClassLoader;

    new-instance v2, Lcom/hook/packageinstaller/features/StoreFeature$1;

    invoke-direct {v2, p0}, Lcom/hook/packageinstaller/features/StoreFeature$1;-><init>(Lcom/hook/packageinstaller/features/StoreFeature;)V

    filled-new-array {v2}, [Ljava/lang/Object;

    move-result-object v2

    const-string v3, "onResume"

    invoke-static {v1, v0, v3, v2}, Lcom/hook/packageinstaller/core/SafeXposed;->hookMethod(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Object;)Z

    move-result v1

    .line 36
    iget-object v2, p1, Lcom/hook/packageinstaller/core/HookContext;->classLoader:Ljava/lang/ClassLoader;

    .line 37
    invoke-virtual {p1}, Lcom/hook/packageinstaller/core/HookContext;->classes()Lcom/hook/packageinstaller/profiles/ProfileClasses;

    move-result-object v3

    iget-object v3, v3, Lcom/hook/packageinstaller/profiles/ProfileClasses;->installationControlResult:Ljava/lang/String;

    .line 36
    invoke-static {v2, v3}, Lcom/hook/packageinstaller/core/SafeXposed;->findClass(Ljava/lang/ClassLoader;Ljava/lang/String;)Ljava/lang/Class;

    move-result-object v2

    if-eqz v2, :cond_43

    .line 38
    invoke-virtual {p1}, Lcom/hook/packageinstaller/core/HookContext;->classes()Lcom/hook/packageinstaller/profiles/ProfileClasses;

    move-result-object v3

    iget-object v3, v3, Lcom/hook/packageinstaller/profiles/ProfileClasses;->piaSetViewMethod:Ljava/lang/String;

    if-eqz v3, :cond_43

    .line 39
    iget-object v3, p1, Lcom/hook/packageinstaller/core/HookContext;->classLoader:Ljava/lang/ClassLoader;

    .line 40
    invoke-virtual {p1}, Lcom/hook/packageinstaller/core/HookContext;->classes()Lcom/hook/packageinstaller/profiles/ProfileClasses;

    move-result-object p1

    iget-object p1, p1, Lcom/hook/packageinstaller/profiles/ProfileClasses;->piaSetViewMethod:Ljava/lang/String;

    sget-object v4, Ljava/lang/Boolean;->TYPE:Ljava/lang/Class;

    new-instance v5, Lcom/hook/packageinstaller/features/StoreFeature$2;

    invoke-direct {v5, p0}, Lcom/hook/packageinstaller/features/StoreFeature$2;-><init>(Lcom/hook/packageinstaller/features/StoreFeature;)V

    filled-new-array {v2, v4, v5}, [Ljava/lang/Object;

    move-result-object p0

    .line 39
    invoke-static {v3, v0, p1, p0}, Lcom/hook/packageinstaller/core/SafeXposed;->hookMethod(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;[Ljava/lang/Object;)Z

    :cond_43
    if-nez v1, :cond_4c

    .line 50
    const-string p0, "PI-Cleaner/Store"

    const-string p1, "Store UI hook unavailable"

    invoke-static {p0, p1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;)I

    :cond_4c
    return-void
.end method
