.class public final Lcom/hook/packageinstaller/features/AdFeature;
.super Ljava/lang/Object;
.source "AdFeature.java"

# interfaces
.implements Lcom/hook/packageinstaller/features/Feature;


# static fields
.field private static final TAG:Ljava/lang/String; = "PI-Cleaner/Ad"


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
    const-string p0, "ad_clean"

    return-object p0
.end method

.method public install(Lcom/hook/packageinstaller/core/HookContext;)V
    .registers 11

    .line 27
    invoke-virtual {p1}, Lcom/hook/packageinstaller/core/HookContext;->classes()Lcom/hook/packageinstaller/profiles/ProfileClasses;

    move-result-object v0

    .line 28
    iget-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->adManagerClass:Ljava/lang/String;

    if-eqz v1, :cond_56

    iget-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->adManagerMethod:Ljava/lang/String;

    if-nez v1, :cond_d

    goto :goto_56

    .line 31
    :cond_d
    iget-object p1, p1, Lcom/hook/packageinstaller/core/HookContext;->classLoader:Ljava/lang/ClassLoader;

    iget-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->adManagerClass:Ljava/lang/String;

    invoke-static {p1, v1}, Lcom/hook/packageinstaller/core/SafeXposed;->findClass(Ljava/lang/ClassLoader;Ljava/lang/String;)Ljava/lang/Class;

    move-result-object p1

    if-nez p1, :cond_18

    return-void

    .line 36
    :cond_18
    :try_start_18
    iget-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->adManagerMethod:Ljava/lang/String;

    const-class v2, Landroid/app/Activity;

    sget-object v3, Ljava/lang/Integer;->TYPE:Ljava/lang/Class;

    const-class v4, Ljava/lang/String;

    const-class v5, Ljava/lang/String;

    const-class v6, Ljava/lang/String;

    const-class v7, Ljava/lang/String;

    new-instance v8, Lcom/hook/packageinstaller/features/AdFeature$1;

    invoke-direct {v8, p0}, Lcom/hook/packageinstaller/features/AdFeature$1;-><init>(Lcom/hook/packageinstaller/features/AdFeature;)V

    filled-new-array/range {v2 .. v8}, [Ljava/lang/Object;

    move-result-object p0

    invoke-static {p1, v1, p0}, Lde/robv/android/xposed/XposedHelpers;->findAndHookMethod(Ljava/lang/Class;Ljava/lang/String;[Ljava/lang/Object;)Lde/robv/android/xposed/XC_MethodHook$Unhook;
    :try_end_32
    .catchall {:try_start_18 .. :try_end_32} :catchall_33

    goto :goto_56

    :catchall_33
    move-exception p0

    .line 46
    new-instance p1, Ljava/lang/StringBuilder;

    const-string v1, "Ad hook unavailable: "

    invoke-direct {p1, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v1, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->adManagerClass:Ljava/lang/String;

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    const-string v1, "#"

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    iget-object v0, v0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->adManagerMethod:Ljava/lang/String;

    invoke-virtual {p1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string v0, "PI-Cleaner/Ad"

    invoke-static {v0, p1, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :cond_56
    :goto_56
    return-void
.end method
