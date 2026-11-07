.class Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar$3;
.super Ljava/lang/Object;
.source "GmMiniBar.java"

# interfaces
.implements Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Listener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->attach(Landroid/app/Activity;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$nv:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;


# direct methods
.method constructor <init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V
    .registers 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 232
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar$3;->val$nv:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onState(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;)V
    .registers 4

    .line 235
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar$3;->val$nv:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->sView:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->access$400()Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    move-result-object v1

    if-eq v0, v1, :cond_9

    return-void

    .line 236
    :cond_9
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar$3;->val$nv:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    invoke-virtual {p0, p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->applyState(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;)V

    return-void
.end method
