.class Lcom/nidyaber/fuckdsmanger/bridge/GmNote$3;
.super Ljava/lang/Object;
.source "GmNote.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmNote;->refresh()V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic val$v:Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;


# direct methods
.method constructor <init>(Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;)V
    .registers 2
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 271
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNote$3;->val$v:Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 1

    .line 275
    :try_start_0
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmNote$3;->val$v:Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;

    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmNoteView;->refreshAll()V
    :try_end_5
    .catchall {:try_start_0 .. :try_end_5} :catchall_5

    :catchall_5
    return-void
.end method
