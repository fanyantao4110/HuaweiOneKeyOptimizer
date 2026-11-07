.class public final Lcom/hook/packageinstaller/features/AnonymousSourceFeature;
.super Ljava/lang/Object;
.source "AnonymousSourceFeature.java"

# interfaces
.implements Lcom/hook/packageinstaller/features/Feature;


# static fields
.field private static final TAG:Ljava/lang/String; = "PI-Cleaner/Anonymous"


# direct methods
.method public constructor <init>()V
    .registers 1

    .line 22
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static hookDialog(Lcom/hook/packageinstaller/core/HookContext;Ljava/lang/String;)V
    .registers 4

    if-nez p1, :cond_3

    return-void

    .line 44
    :cond_3
    iget-object p0, p0, Lcom/hook/packageinstaller/core/HookContext;->classLoader:Ljava/lang/ClassLoader;

    invoke-static {p0, p1}, Lcom/hook/packageinstaller/core/SafeXposed;->findClass(Ljava/lang/ClassLoader;Ljava/lang/String;)Ljava/lang/Class;

    move-result-object p0

    if-nez p0, :cond_c

    return-void

    .line 49
    :cond_c
    :try_start_c
    const-string v0, "onStart"

    new-instance v1, Lcom/hook/packageinstaller/features/AnonymousSourceFeature$1;

    invoke-direct {v1, p1}, Lcom/hook/packageinstaller/features/AnonymousSourceFeature$1;-><init>(Ljava/lang/String;)V

    filled-new-array {v1}, [Ljava/lang/Object;

    move-result-object v1

    invoke-static {p0, v0, v1}, Lde/robv/android/xposed/XposedHelpers;->findAndHookMethod(Ljava/lang/Class;Ljava/lang/String;[Ljava/lang/Object;)Lde/robv/android/xposed/XC_MethodHook$Unhook;
    :try_end_1a
    .catchall {:try_start_c .. :try_end_1a} :catchall_1b

    goto :goto_30

    :catchall_1b
    move-exception p0

    .line 69
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "Dialog hook unavailable: "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    const-string v0, "PI-Cleaner/Anonymous"

    invoke-static {v0, p1, p0}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :goto_30
    return-void
.end method


# virtual methods
.method public id()Ljava/lang/String;
    .registers 1

    .line 27
    const-string p0, "anonymous_source_bypass"

    return-object p0
.end method

.method public install(Lcom/hook/packageinstaller/core/HookContext;)V
    .registers 4

    .line 32
    invoke-virtual {p1}, Lcom/hook/packageinstaller/core/HookContext;->classes()Lcom/hook/packageinstaller/profiles/ProfileClasses;

    move-result-object p0

    .line 33
    iget-object v0, p0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->anonymousClass:Ljava/lang/String;

    invoke-static {p1, v0}, Lcom/hook/packageinstaller/features/AnonymousSourceFeature;->hookDialog(Lcom/hook/packageinstaller/core/HookContext;Ljava/lang/String;)V

    .line 34
    iget-object v0, p0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->unknownSourceClass:Ljava/lang/String;

    if-eqz v0, :cond_1c

    iget-object v0, p0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->unknownSourceClass:Ljava/lang/String;

    iget-object v1, p0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->anonymousClass:Ljava/lang/String;

    .line 35
    invoke-virtual {v0, v1}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v0

    if-nez v0, :cond_1c

    .line 36
    iget-object p0, p0, Lcom/hook/packageinstaller/profiles/ProfileClasses;->unknownSourceClass:Ljava/lang/String;

    invoke-static {p1, p0}, Lcom/hook/packageinstaller/features/AnonymousSourceFeature;->hookDialog(Lcom/hook/packageinstaller/core/HookContext;Ljava/lang/String;)V

    :cond_1c
    return-void
.end method
