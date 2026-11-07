.class Lcom/nidyaber/fuckdsmanger/bridge/GmFileCardProbe$1;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmFileCardProbe.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmFileCardProbe;->hook(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$n:[I

.field final synthetic val$tag:Ljava/lang/String;


# direct methods
.method constructor <init>([ILjava/lang/String;)V
    .registers 3

    .line 64
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmFileCardProbe$1;->val$n:[I

    iput-object p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmFileCardProbe$1;->val$tag:Ljava/lang/String;

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 6

    .line 68
    :try_start_0
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmFileCardProbe$1;->val$n:[I

    const/4 v1, 0x0

    aget v2, v0, v1

    const/16 v3, 0xf

    if-lt v2, v3, :cond_a

    goto :goto_39

    :cond_a
    add-int/lit8 v2, v2, 0x1

    .line 69
    aput v2, v0, v1

    .line 70
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmFileCardProbe$1;->val$tag:Ljava/lang/String;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, " #"

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmFileCardProbe$1;->val$n:[I

    aget p0, p0, v1

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, " "

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    iget-object p0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmFileCardProbe;->dump([Ljava/lang/Object;)Ljava/lang/String;
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmFileCardProbe;->access$000([Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_39
    .catchall {:try_start_0 .. :try_end_39} :catchall_39

    :catchall_39
    :goto_39
    return-void
.end method
