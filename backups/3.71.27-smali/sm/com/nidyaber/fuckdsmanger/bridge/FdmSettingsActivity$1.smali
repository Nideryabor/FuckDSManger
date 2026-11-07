.class Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity$1;
.super Ljava/lang/Object;
.source "FdmSettingsActivity.java"

# interfaces
.implements Landroid/view/View$OnClickListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;->onCreate(Landroid/os/Bundle;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;


# direct methods
.method constructor <init>(Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;)V
    .registers 2

    .line 73
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity$1;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .registers 5

    .line 76
    iget-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity$1;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;

    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/bridge/FdmPush;->push(Landroid/content/Context;)I

    move-result p1

    .line 77
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity$1;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;

    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "\u5df2\u63a8\u9001 "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v2, " \u9879"

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;->toast(Ljava/lang/String;)V
    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;->access$000(Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;Ljava/lang/String;)V

    .line 78
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity$1;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "\u5df2\u624b\u52a8\u63a8\u9001 "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;->refresh(Ljava/lang/String;)V
    invoke-static {p0, p1}, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;->access$100(Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;Ljava/lang/String;)V

    return-void
.end method
