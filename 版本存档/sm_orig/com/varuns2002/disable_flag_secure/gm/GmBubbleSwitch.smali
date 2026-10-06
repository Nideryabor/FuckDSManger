.class public final Lcom/varuns2002/disable_flag_secure/gm/GmBubbleSwitch;
.super Ljava/lang/Object;
.source "GmBubbleSwitch.java"

# interfaces
.implements Landroid/widget/CompoundButton$OnCheckedChangeListener;


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public onCheckedChanged(Landroid/widget/CompoundButton;Z)V
    .registers 4

    :try_start_0
    invoke-virtual {p1}, Landroid/view/View;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-static {v0, p2}, Lcom/varuns2002/disable_flag_secure/gm/GmBubble;->applyOn(Landroid/content/Context;Z)V
    :try_end_7
    .catchall {:try_start_0 .. :try_end_7} :catchall_8

    return-void

    :catchall_8
    move-exception v0

    const-string p0, "[\u6c14\u6ce1] \u5f00\u5173\u5207\u6362\u5931\u8d25"

    invoke-static {p0, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method
