.class Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop$1;
.super Ljava/lang/Object;
.source "GmGlassBackdrop.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->requestInternal(Z)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$d:Landroid/view/View;


# direct methods
.method constructor <init>(Landroid/view/View;)V
    .registers 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 163
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop$1;->val$d:Landroid/view/View;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 3

    const/4 v0, 0x1

    .line 167
    :try_start_1
    # getter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sRunLogged:Z
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->access$000()Z

    move-result v1

    if-nez v1, :cond_f

    .line 168
    # setter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sRunLogged:Z
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->access$002(Z)Z

    .line 169
    const-string v1, "\u3010GmGlass\u3011\u6293\u56fe\u4efb\u52a1\u5f00\u59cb\u6267\u884c"

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 171
    :cond_f
    # getter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sAct:Landroid/app/Activity;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->access$100()Landroid/app/Activity;

    move-result-object v1

    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop$1;->val$d:Landroid/view/View;

    # invokes: Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->capture(Landroid/app/Activity;Landroid/view/View;)V
    invoke-static {v1, p0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->access$200(Landroid/app/Activity;Landroid/view/View;)V
    :try_end_18
    .catchall {:try_start_1 .. :try_end_18} :catchall_19

    return-void

    :catchall_19
    move-exception p0

    .line 173
    # getter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sErrLogged:Z
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->access$300()Z

    move-result v1

    if-nez v1, :cond_34

    .line 174
    # setter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sErrLogged:Z
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->access$302(Z)Z

    .line 175
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "\u3010GmGlass\u3011\u5e95\u56fe\u622a\u53d6\u5931\u8d25\uff08\u5c06\u9000\u5316\u4e3a\u4e0d\u6298\u5c04\uff09\uff1a"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    :cond_34
    const/4 p0, 0x0

    .line 177
    # setter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sBusy:Z
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->access$402(Z)Z

    .line 178
    # setter for: Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->sCapturing:Z
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassBackdrop;->access$502(Z)Z

    return-void
.end method
