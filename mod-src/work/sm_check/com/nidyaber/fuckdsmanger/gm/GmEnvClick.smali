.class public final Lcom/nidyaber/fuckdsmanger/gm/GmEnvClick;
.super Ljava/lang/Object;
.source "GmEnvClick.java"

# interfaces
.implements Landroid/view/View$OnClickListener;


# instance fields
.field private m:I


# direct methods
.method public constructor <init>(I)V
    .registers 2

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput p1, p0, Lcom/nidyaber/fuckdsmanger/gm/GmEnvClick;->m:I

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .registers 5

    iget p0, p0, Lcom/nidyaber/fuckdsmanger/gm/GmEnvClick;->m:I

    if-nez p0, :cond_8

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmEnvDialog;->open()V

    return-void

    :cond_8
    const/4 v0, 0x1

    if-ne p0, v0, :cond_f

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmEnvDialog;->close()V

    return-void

    :cond_f
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmDevice;->reset()Ljava/lang/String;

    invoke-virtual {p1}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v1

    if-eqz v1, :cond_1d

    const-string v2, "\u5df2\u751f\u6210\u65b0\u7684\u8bbe\u5907\u8eab\u4efd\uff0c\u91cd\u542f\u5bbf\u4e3b\u540e\u751f\u6548"

    invoke-static {v1, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    :cond_1d
    return-void
.end method
