.class Lcom/hook/packageinstaller/features/AnonymousSourceFeature$1;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "AnonymousSourceFeature.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/hook/packageinstaller/features/AnonymousSourceFeature;->hookDialog(Lcom/hook/packageinstaller/core/HookContext;Ljava/lang/String;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$className:Ljava/lang/String;


# direct methods
.method constructor <init>(Ljava/lang/String;)V
    .registers 2

    .line 49
    iput-object p1, p0, Lcom/hook/packageinstaller/features/AnonymousSourceFeature$1;->val$className:Ljava/lang/String;

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected afterHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 5

    .line 52
    const-string v0, "PI-Cleaner/Anonymous"

    .line 0
    const-string v1, "Auto-confirmed source dialog: "

    .line 52
    iget-object v2, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;

    instance-of v2, v2, Landroid/app/DialogFragment;

    if-nez v2, :cond_b

    return-void

    .line 55
    :cond_b
    iget-object p1, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;

    check-cast p1, Landroid/app/DialogFragment;

    .line 56
    invoke-virtual {p1}, Landroid/app/DialogFragment;->getDialog()Landroid/app/Dialog;

    move-result-object p1

    .line 57
    instance-of v2, p1, Landroid/app/AlertDialog;

    if-eqz v2, :cond_49

    .line 59
    :try_start_17
    check-cast p1, Landroid/app/AlertDialog;

    const/4 v2, -0x1

    invoke-virtual {p1, v2}, Landroid/app/AlertDialog;->getButton(I)Landroid/widget/Button;

    move-result-object p1

    .line 60
    invoke-virtual {p1}, Landroid/widget/Button;->performClick()Z

    .line 61
    new-instance p1, Ljava/lang/StringBuilder;

    invoke-direct {p1, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v1, p0, Lcom/hook/packageinstaller/features/AnonymousSourceFeature$1;->val$className:Ljava/lang/String;

    invoke-virtual {p1, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p1

    invoke-virtual {p1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-static {v0, p1}, Landroid/util/Log;->i(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_33
    .catchall {:try_start_17 .. :try_end_33} :catchall_34

    goto :goto_49

    :catchall_34
    move-exception p1

    .line 63
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "Auto-confirm failed: "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object p0, p0, Lcom/hook/packageinstaller/features/AnonymousSourceFeature$1;->val$className:Ljava/lang/String;

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    move-result-object p0

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v0, p0, p1}, Landroid/util/Log;->w(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    :cond_49
    :goto_49
    return-void
.end method
