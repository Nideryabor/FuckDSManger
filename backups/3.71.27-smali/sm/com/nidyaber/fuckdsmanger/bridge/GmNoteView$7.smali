.class Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$7;
.super Ljava/lang/Object;
.source "GmNoteView.java"

# interfaces
.implements Landroid/view/View$OnClickListener;


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

    .line 155
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$7;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .registers 2

    .line 157
    iget-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$7;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;

    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->editing:Z
    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->access$400(Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;)Z

    move-result p1

    if-nez p1, :cond_d

    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$7;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->beginEdit()V
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->access$500(Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;)V

    :cond_d
    return-void
.end method
