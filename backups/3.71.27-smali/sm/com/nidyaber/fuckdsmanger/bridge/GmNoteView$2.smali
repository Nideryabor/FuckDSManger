.class Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$2;
.super Ljava/lang/Object;
.source "GmNoteView.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->buildCard()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;


# direct methods
.method constructor <init>(Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;)V
    .registers 2

    .line 110
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$2;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 2

    .line 111
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$2;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->commitEdit()V
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->access$100(Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;)V

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->curIdx()I

    move-result v0

    add-int/lit8 v0, v0, -0x1

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->setIdx(I)V

    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$2;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;

    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->refreshAll()V

    return-void
.end method
