.class public final Lcom/varuns2002/disable_flag_secure/gm/GmEnvHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmEnvHook.java"


# instance fields
.field private m:I


# direct methods
.method public constructor <init>(I)V
    .registers 2

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    iput p1, p0, Lcom/varuns2002/disable_flag_secure/gm/GmEnvHook;->m:I

    return-void
.end method


# virtual methods
.method protected afterHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 4

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmEnv;->isOn()Z

    move-result v0

    if-eqz v0, :cond_2d

    iget v0, p0, Lcom/varuns2002/disable_flag_secure/gm/GmEnvHook;->m:I

    packed-switch v0, :pswitch_data_2e

    goto :goto_2d

    :pswitch_c
    sget-object v0, Ljava/lang/Boolean;->FALSE:Ljava/lang/Boolean;

    goto :goto_29

    :pswitch_f
    new-instance v0, Ljava/util/HashMap;

    invoke-direct {v0}, Ljava/util/HashMap;-><init>()V

    goto :goto_29

    :pswitch_15
    new-instance v0, Ljava/util/HashSet;

    invoke-direct {v0}, Ljava/util/HashSet;-><init>()V

    goto :goto_29

    :pswitch_1b
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    goto :goto_29

    :pswitch_21
    const-string v0, ""

    goto :goto_29

    :pswitch_24
    const/4 v0, 0x0

    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    :goto_29
    invoke-virtual {p1, v0}, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->setResult(Ljava/lang/Object;)V

    return-void

    :cond_2d
    :goto_2d
    return-void

    :pswitch_data_2e
    .packed-switch 0x0
        :pswitch_c
        :pswitch_f
        :pswitch_15
        :pswitch_1b
        :pswitch_21
        :pswitch_24
    .end packed-switch
.end method
