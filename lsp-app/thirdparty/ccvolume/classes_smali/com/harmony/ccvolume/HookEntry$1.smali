.class Lcom/harmony/ccvolume/HookEntry$1;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "HookEntry.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/harmony/ccvolume/HookEntry;->handleLoadPackage(Lde/robv/android/xposed/callbacks/XC_LoadPackage$LoadPackageParam;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/harmony/ccvolume/HookEntry;


# direct methods
.method constructor <init>(Lcom/harmony/ccvolume/HookEntry;)V
    .registers 2

    .line 79
    iput-object p1, p0, Lcom/harmony/ccvolume/HookEntry$1;->this$0:Lcom/harmony/ccvolume/HookEntry;

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected afterHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 3

    .line 82
    iget-object v0, p0, Lcom/harmony/ccvolume/HookEntry$1;->this$0:Lcom/harmony/ccvolume/HookEntry;

    iget-object p1, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;

    invoke-static {v0, p1}, Lcom/harmony/ccvolume/HookEntry;->access$000(Lcom/harmony/ccvolume/HookEntry;Ljava/lang/Object;)V

    return-void
.end method
