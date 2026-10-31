.class Lcom/hook/packageinstaller/features/OrientationLockFeature$1;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "OrientationLockFeature.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/hook/packageinstaller/features/OrientationLockFeature;->install(Lcom/hook/packageinstaller/core/HookContext;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/hook/packageinstaller/features/OrientationLockFeature;

.field final synthetic val$context:Lcom/hook/packageinstaller/core/HookContext;


# direct methods
.method constructor <init>(Lcom/hook/packageinstaller/features/OrientationLockFeature;Lcom/hook/packageinstaller/core/HookContext;)V
    .registers 3

    .line 35
    iput-object p1, p0, Lcom/hook/packageinstaller/features/OrientationLockFeature$1;->this$0:Lcom/hook/packageinstaller/features/OrientationLockFeature;

    iput-object p2, p0, Lcom/hook/packageinstaller/features/OrientationLockFeature$1;->val$context:Lcom/hook/packageinstaller/core/HookContext;

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 5

    .line 38
    iget-object p0, p0, Lcom/hook/packageinstaller/features/OrientationLockFeature$1;->val$context:Lcom/hook/packageinstaller/core/HookContext;

    iget-object p0, p0, Lcom/hook/packageinstaller/core/HookContext;->config:Lcom/hook/packageinstaller/config/FeatureConfig;

    iget-boolean p0, p0, Lcom/hook/packageinstaller/config/FeatureConfig;->orientationLockFix:Z

    if-nez p0, :cond_9

    return-void

    .line 41
    :cond_9
    iget-object p0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    const/4 v0, 0x0

    aget-object p0, p0, v0

    check-cast p0, Ljava/lang/Integer;

    invoke-virtual {p0}, Ljava/lang/Integer;->intValue()I

    move-result p0

    const/4 v1, 0x4

    const/16 v2, 0xa

    if-eq p0, v1, :cond_1c

    if-eq p0, v2, :cond_1c

    return-void

    .line 46
    :cond_1c
    iget-object v1, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;

    check-cast v1, Landroid/app/Activity;

    .line 47
    invoke-static {v1}, Lcom/hook/packageinstaller/features/OrientationLockFeature;->-$$Nest$smisRotationLocked(Landroid/content/Context;)Z

    move-result v1

    if-nez v1, :cond_27

    return-void

    :cond_27
    if-ne p0, v2, :cond_34

    .line 51
    iget-object v1, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    const/16 v2, 0xd

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    aput-object v2, v1, v0

    goto :goto_3d

    .line 53
    :cond_34
    iget-object v1, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    const/4 v2, 0x2

    invoke-static {v2}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v2

    aput-object v2, v1, v0

    .line 55
    :goto_3d
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "Rotation locked: requested="

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    move-result-object p0

    const-string v1, " -> "

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    iget-object p1, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    aget-object p1, p1, v0

    invoke-virtual {p0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    const-string p1, "PI-Cleaner/Orientation"

    invoke-static {p1, p0}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I

    return-void
.end method
