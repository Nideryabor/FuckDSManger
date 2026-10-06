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
    .registers 6

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
    const/16 v1, 0x11

    if-ne v0, v1, :cond_8e

    :try_start_85
    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmPromptDialog;->open()V
    :try_end_88
    .catchall {:try_start_85 .. :try_end_88} :catchall_89

    goto :goto_8d

    :catchall_89
    move-exception v2

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logE(Ljava/lang/Throwable;)V

    :goto_8d
    return-void

    :cond_8e
    const/16 v1, 0x12

    if-ne v0, v1, :cond_96

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmPromptDialog;->save()V

    return-void

    :cond_96
    const/16 v1, 0x13

    if-ne v0, v1, :cond_9e

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmPromptDialog;->reset()V

    return-void

    :cond_9e
    const/16 v1, 0x14

    if-ne v0, v1, :cond_a6

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmPromptDialog;->close()V

    return-void

    :cond_a6
    const/16 v1, 0x15

    if-ne v0, v1, :cond_ae

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmPromptDialog;->addNew()V

    return-void

    :cond_ae
    const/16 v1, 0x16

    if-ne v0, v1, :cond_b6

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmHelloDialog;->open()V

    return-void

    :cond_b6
    const/16 v1, 0x17

    if-ne v0, v1, :cond_be

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmHelloDialog;->save()V

    return-void

    :cond_be
    const/16 v1, 0x18

    if-ne v0, v1, :cond_c6

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmHelloDialog;->reset()V

    return-void

    :cond_c6
    const/16 v1, 0x19

    if-ne v0, v1, :cond_ce

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmHelloDialog;->close()V

    return-void

    :cond_ce
    const/16 v1, 0x1a

    if-ne v0, v1, :cond_d6

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmHelloDialog;->addNew()V

    return-void

    :cond_d6
    const/16 v1, 0x1b

    if-ne v0, v1, :cond_de

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->open()V

    return-void

    :cond_de
    const/16 v1, 0x1c

    if-ne v0, v1, :cond_e6

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->setModeImg()V

    return-void

    :cond_e6
    const/16 v1, 0x1d

    if-ne v0, v1, :cond_ee

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->setModeGrad()V

    return-void

    :cond_ee
    const/16 v1, 0x1e

    if-ne v0, v1, :cond_f6

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->pickBg()V

    return-void

    :cond_f6
    const/16 v1, 0x1f

    if-ne v0, v1, :cond_fe

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->gradPrev()V

    return-void

    :cond_fe
    const/16 v1, 0x20

    if-ne v0, v1, :cond_106

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->gradNext()V

    return-void

    :cond_106
    const/16 v1, 0x21

    if-ne v0, v1, :cond_10e

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->alphaDown()V

    return-void

    :cond_10e
    const/16 v1, 0x22

    if-ne v0, v1, :cond_116

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->alphaUp()V

    return-void

    :cond_116
    const/16 v1, 0x23

    if-ne v0, v1, :cond_11e

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->close()V

    return-void

    :cond_11e
    const/16 v1, 0x24

    if-ne v0, v1, :cond_126

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->setPosOverlay()V

    return-void

    :cond_126
    const/16 v1, 0x25

    if-ne v0, v1, :cond_12e

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->setPosBehind()V

    return-void

    :cond_12e
    const/16 v1, 0x26

    if-ne v0, v1, :cond_136

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->setPosMix()V

    return-void

    :cond_136
    const/16 v1, 0x27

    if-ne v0, v1, :cond_13e

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->dirAuto()V

    return-void

    :cond_13e
    const/16 v1, 0x28

    if-ne v0, v1, :cond_146

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->dirLight()V

    return-void

    :cond_146
    const/16 v1, 0x29

    if-ne v0, v1, :cond_14e

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->dirDark()V

    return-void

    :cond_14e
    const/16 v1, 0x2a

    if-ne v0, v1, :cond_156

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->setModeCam()V

    return-void

    :cond_156
    const/16 v1, 0x2b

    if-ne v0, v1, :cond_15e

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->camBack()V

    return-void

    :cond_15e
    const/16 v1, 0x2c

    if-ne v0, v1, :cond_166

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->camFront()V

    return-void

    :cond_166
    const/16 v1, 0x2d

    if-ne v0, v1, :cond_16e

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->rotNext()V

    return-void

    :cond_16e
    const/16 v1, 0x2e

    if-ne v0, v1, :cond_176

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->cropDown()V

    return-void

    :cond_176
    const/16 v1, 0x2f

    if-ne v0, v1, :cond_17e

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBgDialog;->cropUp()V

    return-void

    :cond_17e
    const/16 v1, 0x30

    if-ne v0, v1, :cond_186

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBeautyDialog;->saveName()V

    return-void

    :cond_186
    const/16 v1, 0x31

    if-ne v0, v1, :cond_18e

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBeautyDialog;->resetName()V

    return-void

    :cond_18e
    const/16 v1, 0x32

    if-ne v0, v1, :cond_196

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBeautyDialog;->pickUserImage()V

    return-void

    :cond_196
    const/16 v1, 0x33

    if-ne v0, v1, :cond_19e

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestDialog;->open()V

    return-void

    :cond_19e
    const/16 v1, 0x34

    if-ne v0, v1, :cond_1a6

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestDialog;->save()V

    return-void

    :cond_1a6
    const/16 v1, 0x35

    if-ne v0, v1, :cond_1ae

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestDialog;->reset()V

    return-void

    :cond_1ae
    const/16 v1, 0x36

    if-ne v0, v1, :cond_1b6

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestDialog;->close()V

    return-void

    :cond_1b6
    const/16 v1, 0x37

    if-ne v0, v1, :cond_1be

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestDialog;->toggle()V

    return-void

    :cond_1be
    const/16 v1, 0x38

    if-ne v0, v1, :cond_1c6

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmSuggestDialog;->toggleAi()V

    return-void

    :cond_1c6
    const/16 v1, 0x39

    if-ne v0, v1, :cond_1ce

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->open()V

    return-void

    :cond_1ce
    const/16 v1, 0x3a

    if-ne v0, v1, :cond_1d6

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->hangup()V

    return-void

    :cond_1d6
    const/16 v1, 0x3b

    if-ne v0, v1, :cond_1de

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->toggleSpeaker()V

    return-void

    :cond_1de
    const/16 v1, 0x3c

    if-ne v0, v1, :cond_1e6

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->toggleInterrupt()V

    return-void

    :cond_1e6
    const/16 v1, 0x3d

    if-ne v0, v1, :cond_1ee

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBubbleDialog;->openAi()V

    return-void

    :cond_1ee
    const/16 v1, 0x3e

    if-ne v0, v1, :cond_1f6

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBubbleDialog;->close()V

    return-void

    :cond_1f6
    const/16 v1, 0x3f

    if-ne v0, v1, :cond_1fe

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmDumpDialog;->open()V

    return-void

    :cond_1fe
    const/16 v1, 0x40

    if-ne v0, v1, :cond_206

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmDumpDialog;->close()V

    return-void

    :cond_206
    const/16 v1, 0x41

    if-ne v0, v1, :cond_20e

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmDumpDialog;->copy()V

    return-void

    :cond_20e
    const/16 v1, 0x42

    if-ne v0, v1, :cond_218

    sget-object v2, Lcom/varuns2002/disable_flag_secure/gm/GmEntry;->sAct:Landroid/app/Activity;

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmProbe;->toggle(Landroid/content/Context;)V

    return-void

    :cond_218
    const/16 v1, 0x43

    if-ne v0, v1, :cond_220

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmDumpDialog;->clear()V

    return-void

    :cond_220
    const/16 v1, 0x44

    if-ne v0, v1, :cond_228

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmBubbleDialog;->openUser()V

    return-void

    :cond_228
    return-void
.end method
