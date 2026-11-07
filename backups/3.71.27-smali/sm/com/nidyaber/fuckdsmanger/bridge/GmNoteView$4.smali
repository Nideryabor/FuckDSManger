.class Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$4;
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

    .line 123
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$4;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 1

    .line 124
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$4;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->doDel()V
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->access$200(Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;)V

    return-void
.end method
