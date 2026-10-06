.class public final Lcom/varuns2002/disable_flag_secure/gm/GmAlphaClick;
.super Ljava/lang/Object;
.source "GmAlphaClick.java"

# interfaces
.implements Landroid/view/View$OnClickListener;


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .registers 5

    :try_start_0
    invoke-virtual {p1}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-virtual {p1}, Landroid/view/View;->getTag()Ljava/lang/Object;

    move-result-object v0

    instance-of v2, v0, Ljava/lang/Integer;

    if-eqz v2, :cond_37

    check-cast v0, Ljava/lang/Integer;

    invoke-virtual {v0}, Ljava/lang/Integer;->intValue()I

    move-result v2

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->alpha()I

    move-result p0

    add-int/2addr v2, p0

    invoke-static {v1, v2}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->setAlpha(Landroid/content/Context;I)V

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->alpha()I

    move-result v2

    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    const-string p0, "AI \u6c14\u6ce1\u56fe\u7247\u900f\u660e\u5ea6 = "

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, "%\uff08\u5217\u8868\u5212\u4e00\u4e0b\u5373\u53ef\u770b\u5230\uff09"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v1, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V
    :try_end_37
    .catchall {:try_start_0 .. :try_end_37} :catchall_38

    :cond_37
    return-void

    :catchall_38
    move-exception v0

    return-void
.end method
