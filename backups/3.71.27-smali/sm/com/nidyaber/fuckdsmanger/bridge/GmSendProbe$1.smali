.class Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe$1;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmSendProbe.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe;->install(Ljava/lang/ClassLoader;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$mn:Ljava/lang/String;

.field final synthetic val$pts:[Ljava/lang/Class;


# direct methods
.method constructor <init>(Ljava/lang/String;[Ljava/lang/Class;)V
    .registers 3

    .line 118
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe$1;->val$mn:Ljava/lang/String;

    iput-object p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe$1;->val$pts:[Ljava/lang/Class;

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 3

    .line 122
    :try_start_0
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe$1;->val$mn:Ljava/lang/String;

    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe$1;->val$pts:[Ljava/lang/Class;

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe;->onHit(Ljava/lang/String;[Ljava/lang/Class;Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    invoke-static {v0, p0, p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmSendProbe;->access$000(Ljava/lang/String;[Ljava/lang/Class;Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    :try_end_7
    .catchall {:try_start_0 .. :try_end_7} :catchall_7

    :catchall_7
    return-void
.end method
