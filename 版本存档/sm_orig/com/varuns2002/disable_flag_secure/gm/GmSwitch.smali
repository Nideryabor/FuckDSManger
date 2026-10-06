.class public final Lcom/varuns2002/disable_flag_secure/gm/GmSwitch;
.super Ljava/lang/Object;
.source "GmSwitch.java"

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
    .registers 6

    invoke-virtual {p1}, Landroid/widget/CompoundButton;->getContext()Landroid/content/Context;

    move-result-object v0

    if-eqz v0, :cond_27

    const-string v1, "fuckds_gm"

    const/4 v2, 0x0

    invoke-virtual {v0, v1, v2}, Landroid/content/Context;->getSharedPreferences(Ljava/lang/String;I)Landroid/content/SharedPreferences;

    move-result-object v1

    invoke-interface {v1}, Landroid/content/SharedPreferences;->edit()Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    const-string v2, "anti_revoke"

    invoke-interface {v1, v2, p2}, Landroid/content/SharedPreferences$Editor;->putBoolean(Ljava/lang/String;Z)Landroid/content/SharedPreferences$Editor;

    move-result-object v1

    invoke-interface {v1}, Landroid/content/SharedPreferences$Editor;->apply()V

    if-eqz p2, :cond_22

    const-string v1, "\u9632\u64a4\u56de\u5df2\u5f00\u542f\uff1a\u6d88\u606f\u4f1a\u5907\u4efd\u5230\u672c\u5730\u6570\u636e\u5e93\uff0c\u4f1a\u5360\u7528\u5b58\u50a8\u7a7a\u95f4"

    invoke-static {v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    return-void

    :cond_22
    const-string v1, "\u9632\u64a4\u56de\u5df2\u5173\u95ed"

    invoke-static {v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    :cond_27
    return-void
.end method
