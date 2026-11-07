.class Lcom/huawei/onekey/optimizer/hook/mxx/MxxHook$1;
.super Lde/robv/android/xposed/XC_MethodReplacement;
.source "MxxHook.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/huawei/onekey/optimizer/hook/mxx/MxxHook;->hookConst(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/Object;)Z
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/huawei/onekey/optimizer/hook/mxx/MxxHook;

.field final synthetic val$value:Ljava/lang/Object;


# direct methods
.method constructor <init>(Lcom/huawei/onekey/optimizer/hook/mxx/MxxHook;Ljava/lang/Object;)V
    .registers 3

    .line 72
    iput-object p1, p0, Lcom/huawei/onekey/optimizer/hook/mxx/MxxHook$1;->this$0:Lcom/huawei/onekey/optimizer/hook/mxx/MxxHook;

    iput-object p2, p0, Lcom/huawei/onekey/optimizer/hook/mxx/MxxHook$1;->val$value:Ljava/lang/Object;

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodReplacement;-><init>()V

    return-void
.end method


# virtual methods
.method protected replaceHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)Ljava/lang/Object;
    .registers 2

    .line 75
    iget-object p1, p0, Lcom/huawei/onekey/optimizer/hook/mxx/MxxHook$1;->val$value:Ljava/lang/Object;

    return-object p1
.end method
