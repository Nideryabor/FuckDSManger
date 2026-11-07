.class Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity$2;
.super Ljava/lang/Object;
.source "FdmSettingsActivity.java"

# interfaces
.implements Landroid/widget/CompoundButton$OnCheckedChangeListener;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;->row(Ljava/lang/String;Ljava/lang/String;Z)Landroid/view/View;
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# instance fields
.field final synthetic this$0:Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;

.field final synthetic val$key:Ljava/lang/String;

.field final synthetic val$sp:Landroid/content/SharedPreferences;


# direct methods
.method constructor <init>(Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;Landroid/content/SharedPreferences;Ljava/lang/String;)V
    .registers 4
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "()V"
        }
    .end annotation

    .line 125
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity$2;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;

    iput-object p2, p0, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity$2;->val$sp:Landroid/content/SharedPreferences;

    iput-object p3, p0, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity$2;->val$key:Ljava/lang/String;

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onCheckedChanged(Landroid/widget/CompoundButton;Z)V
    .registers 7

    .line 128
    iget-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity$2;->val$sp:Landroid/content/SharedPreferences;

    invoke-interface {p1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity$2;->val$key:Ljava/lang/String;

    invoke-interface {p1, v0, p2}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object p1

    invoke-interface {p1}, Landroid/content/SharedPreferences$Editor;->apply()V

    .line 129
    iget-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity$2;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;

    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/bridge/FdmPush;->push(Landroid/content/Context;)I

    move-result p1

    .line 130
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity$2;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v2, p0, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity$2;->val$key:Ljava/lang/String;

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v2, " = "

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    const-string v3, "\uff08\u5df2\u63a8 "

    invoke-virtual {v1, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, " \u9879\uff09"

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;->toast(Ljava/lang/String;)V
    invoke-static {v0, p1}, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;->access$000(Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;Ljava/lang/String;)V

    .line 131
    iget-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity$2;->this$0:Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;

    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "\u521a\u6539\uff1a "

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity$2;->val$key:Ljava/lang/String;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Z)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    # invokes: Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;->refresh(Ljava/lang/String;)V
    invoke-static {p1, p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;->access$100(Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;Ljava/lang/String;)V

    return-void
.end method
