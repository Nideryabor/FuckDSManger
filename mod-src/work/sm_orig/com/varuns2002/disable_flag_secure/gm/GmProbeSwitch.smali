.class public final Lcom/varuns2002/disable_flag_secure/gm/GmProbeSwitch;
.super Ljava/lang/Object;
.source "GmProbeSwitch.java"

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
    .registers 5

    invoke-virtual {p1}, Landroid/widget/CompoundButton;->getContext()Landroid/content/Context;

    move-result-object v0

    if-nez v0, :cond_7

    return-void

    :cond_7
    if-eqz p2, :cond_12

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmProbe;->show(Landroid/content/Context;)V

    const-string v1, "\u5143\u7d20\u6355\u83b7\u5668\u5df2\u5f00\u542f\uff1a\u62d6\u5230\u76ee\u6807\u5143\u7d20\u4e0a\uff0c\u5355\u51fb\u5199\u65e5\u5fd7 / \u957f\u6309\u590d\u5236"

    invoke-static {v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    return-void

    :cond_12
    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmProbe;->hide()V

    const-string v1, "\u5143\u7d20\u6355\u83b7\u5668\u5df2\u5173\u95ed"

    invoke-static {v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    return-void
.end method
