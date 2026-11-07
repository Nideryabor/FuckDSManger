.class Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$9;
.super Ljava/lang/Object;
.source "GmNoteView.java"

# interfaces
.implements Landroid/view/View$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->mkBtn(Ljava/lang/String;Ljava/lang/Runnable;)Landroid/widget/TextView;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;

.field final synthetic val$r:Ljava/lang/Runnable;


# direct methods
.method constructor <init>(Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;Ljava/lang/Runnable;)V
    .registers 3
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 202
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$9;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;

    iput-object p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$9;->val$r:Ljava/lang/Runnable;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .registers 2

    .line 205
    :try_start_0
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView$9;->val$r:Ljava/lang/Runnable;

    invoke-interface {p0}, Ljava/lang/Runnable;->run()V
    :try_end_5
    .catchall {:try_start_0 .. :try_end_5} :catchall_6

    return-void

    :catchall_6
    move-exception p0

    .line 207
    const-string p1, "\u3010GmNote\u3011\u6309\u94ae\u52a8\u4f5c\u5931\u8d25"

    invoke-static {p1, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method
