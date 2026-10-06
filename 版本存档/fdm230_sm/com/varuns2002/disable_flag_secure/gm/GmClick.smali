.class public final Lcom/varuns2002/disable_flag_secure/gm/GmClick;
.super Ljava/lang/Object;
.source "GmClick.java"

# interfaces
.implements Landroid/view/View$OnClickListener;


# instance fields
.field private a:I


# direct methods
.method public constructor <init>(I)V
    .registers 2

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput p1, p0, Lcom/varuns2002/disable_flag_secure/gm/GmClick;->a:I

    return-void
.end method


# virtual methods
.method public onClick(Landroid/view/View;)V
    .registers 4

    iget v0, p0, Lcom/varuns2002/disable_flag_secure/gm/GmClick;->a:I

    if-nez v0, :cond_8

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmDialog;->open()V

    return-void

    :cond_8
    const/4 v1, 0x1

    if-ne v0, v1, :cond_f

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmDialog;->save()V

    return-void

    :cond_f
    const/4 v1, 0x2

    if-ne v0, v1, :cond_16

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmDialog;->resetAll()V

    return-void

    :cond_16
    const/4 v1, 0x3

    if-ne v0, v1, :cond_1d

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmDialog;->close()V

    return-void

    :cond_1d
    const/4 v1, 0x4

    if-ne v0, v1, :cond_24

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmMenuDialog;->open()V

    return-void

    :cond_24
    const/4 v1, 0x5

    if-ne v0, v1, :cond_2b

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmMenuDialog;->close()V

    return-void

    :cond_2b
    const/4 v1, 0x6

    if-ne v0, v1, :cond_32

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmChatDialog;->open()V

    return-void

    :cond_32
    const/4 v1, 0x7

    if-ne v0, v1, :cond_39

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmChatDialog;->close()V

    return-void

    :cond_39
    const/16 v1, 0x8

    if-ne v0, v1, :cond_41

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmDbDialog;->open()V

    return-void

    :cond_41
    const/16 v1, 0x9

    if-ne v0, v1, :cond_49

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmDbDialog;->close()V

    return-void

    :cond_49
    const/16 v1, 0xa

    if-ne v0, v1, :cond_51

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmDbDialog;->clear()V

    return-void

    :cond_51
    const/16 v1, 0xb

    if-ne v0, v1, :cond_59

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBeautyDialog;->open()V

    return-void

    :cond_59
    const/16 v1, 0xc

    if-ne v0, v1, :cond_61

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBeautyDialog;->close()V

    return-void

    :cond_61
    const/16 v1, 0xd

    if-ne v0, v1, :cond_69

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBeautyDialog;->pickImage()V

    return-void

    :cond_69
    const/16 v1, 0xe

    if-ne v0, v1, :cond_71

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmDsDialog;->open()V

    return-void

    :cond_71
    const/16 v1, 0xf

    if-ne v0, v1, :cond_79

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmDsDialog;->close()V

    return-void

    :cond_79
    const/16 v1, 0x10

    if-ne v0, v1, :cond_81

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmDsDialog;->clear()V

    return-void

    :cond_81
    return-void
.end method
