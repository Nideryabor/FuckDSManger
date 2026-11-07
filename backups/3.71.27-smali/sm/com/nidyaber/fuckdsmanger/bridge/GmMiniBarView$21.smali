.class Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$21;
.super Ljava/lang/Object;
.source "GmMiniBarView.java"

# interfaces
.implements Landroid/view/View$OnTouchListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->installGestures()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;


# direct methods
.method constructor <init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V
    .registers 2

    .line 1212
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$21;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onTouch(Landroid/view/View;Landroid/view/MotionEvent;)Z
    .registers 4

    .line 1216
    :try_start_0
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$21;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->gdCard:Landroid/view/GestureDetector;
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$2700(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)Landroid/view/GestureDetector;

    move-result-object v0

    invoke-virtual {v0, p2}, Landroid/view/GestureDetector;->onTouchEvent(Landroid/view/MotionEvent;)Z
    :try_end_9
    .catchall {:try_start_0 .. :try_end_9} :catchall_9

    .line 1219
    :catchall_9
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$21;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;

    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->cardDrag:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Drag;
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->access$2800(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Drag;

    move-result-object p0

    invoke-virtual {p0, p1, p2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Drag;->onTouch(Landroid/view/View;Landroid/view/MotionEvent;)Z

    const/4 p0, 0x0

    return p0
.end method
