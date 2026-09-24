// ===== GmCallDialog (NL 2.13.0) =====
.class public final Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;
.super Ljava/lang/Object;
.source "GmCallDialog.java"

# interfaces
.implements Landroid/view/View$OnLongClickListener;


# static fields
.field static sAct:Landroid/app/Activity;

.field static sAo1:Ljava/lang/Object;

.field static sDlg:Landroid/app/Dialog;

.field static sInt:Landroid/widget/Button;

.field static sSpk:Landroid/widget/Button;

.field static sSpkOn:Z

.field static sStat:Landroid/widget/TextView;

.field static sText:Landroid/widget/TextView;


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static apply(ILjava/lang/String;)V
    .registers 3

    if-eqz p0, :stat

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->sText:Landroid/widget/TextView;

    if-eqz v0, :ret

    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    return-void

    :stat
    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->sStat:Landroid/widget/TextView;

    if-eqz v0, :ret

    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    :ret
    return-void
.end method

.method public static close()V
    .registers 2

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->sDlg:Landroid/app/Dialog;

    if-eqz v0, :a

    invoke-virtual {v0}, Landroid/app/Dialog;->dismiss()V

    :a
    const/4 v1, 0x0

    sput-object v1, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->sDlg:Landroid/app/Dialog;

    sput-object v1, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->sStat:Landroid/widget/TextView;

    sput-object v1, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->sText:Landroid/widget/TextView;

    sput-object v1, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->sSpk:Landroid/widget/Button;

    sput-object v1, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->sInt:Landroid/widget/Button;

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->stopAudio()V

    const-string v1, "[通话] 已挂断"

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    return-void
.end method

.method public static hangup()V
    .registers 0

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->close()V

    return-void
.end method

.method public static line(Ljava/lang/String;)V
    .registers 4

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->sAct:Landroid/app/Activity;

    if-eqz v0, :ret

    new-instance v1, Lcom/varuns2002/disable_flag_secure/gm/GmCallRun;

    const/4 v2, 0x1

    invoke-direct {v1, v2, p0}, Lcom/varuns2002/disable_flag_secure/gm/GmCallRun;-><init>(ILjava/lang/String;)V

    invoke-virtual {v0, v1}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    :ret
    return-void
.end method

.method public onLongClick(Landroid/view/View;)Z
    .registers 2

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->testSend()V

    const/4 v0, 0x1

    return v0
.end method

.method public static open()V
    .registers 12

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmEntry;->sAct:Landroid/app/Activity;

    sput-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->sAct:Landroid/app/Activity;

    if-nez v0, :cond_5

    return-void

    :cond_5
    sget-object v1, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->sDlg:Landroid/app/Dialog;

    if-eqz v1, :cond_12

    invoke-virtual {v1}, Landroid/app/Dialog;->isShowing()Z

    move-result v2

    if-eqz v2, :cond_12

    return-void

    :cond_12
    new-instance v1, Landroid/app/Dialog;

    invoke-direct {v1, v0}, Landroid/app/Dialog;-><init>(Landroid/content/Context;)V

    sput-object v1, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->sDlg:Landroid/app/Dialog;

    const/4 v2, 0x1

    invoke-virtual {v1, v2}, Landroid/app/Dialog;->requestWindowFeature(I)Z

    new-instance v1, Landroid/widget/LinearLayout;

    invoke-direct {v1, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v2, 0x1

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->setOrientation(I)V

    const/16 v2, 0x11

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->setGravity(I)V

    const v2, -0x1000000

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->setBackgroundColor(I)V

    const/16 v2, 0x18

    invoke-static {v0, v2}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v2

    invoke-virtual {v1, v2, v2, v2, v2}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    new-instance v2, Landroid/widget/TextView;

    invoke-direct {v2, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v3, "音频通话"

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    sget-object v3, Landroid/graphics/Typeface;->DEFAULT_BOLD:Landroid/graphics/Typeface;

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V

    const/high16 v3, 0x41a00000  # 20.0f

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextSize(F)V

    const/4 v3, -0x1

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextColor(I)V

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    new-instance v2, Landroid/widget/TextView;

    invoke-direct {v2, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v3, "状态：待命（长按本行可发测试消息）"

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/high16 v3, 0x41900000  # 18.0f

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextSize(F)V

    const/4 v3, -0x1

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextColor(I)V

    const/16 v3, 0x10

    invoke-static {v0, v3}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v4

    const/4 v5, 0x0

    invoke-virtual {v2, v4, v4, v4, v5}, Landroid/widget/TextView;->setPadding(IIII)V

    new-instance v3, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;

    invoke-direct {v3}, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;-><init>()V

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setOnLongClickListener(Landroid/view/View$OnLongClickListener;)V

    sput-object v2, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->sStat:Landroid/widget/TextView;

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    new-instance v2, Landroid/widget/TextView;

    invoke-direct {v2, v0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v3, "（这里显示通话中识别到的文字）"

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/high16 v3, 0x41400000  # 12.0f

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextSize(F)V

    const v3, -0x4f4f50

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextColor(I)V

    const/16 v3, 0x30

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setGravity(I)V

    const/4 v3, 0x6

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setMinLines(I)V

    new-instance v3, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v4, -0x1

    const/4 v5, -0x2

    invoke-direct {v3, v4, v5}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    sput-object v2, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->sText:Landroid/widget/TextView;

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    new-instance v2, Landroid/widget/LinearLayout;

    invoke-direct {v2, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v3, 0x0

    invoke-virtual {v2, v3}, Landroid/widget/LinearLayout;->setOrientation(I)V

    const/16 v3, 0x10

    invoke-static {v0, v3}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v4

    invoke-virtual {v2, v4, v4, v4, v4}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    new-instance v3, Landroid/widget/Button;

    invoke-direct {v3, v0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    const-string v4, "挂断"

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    const/4 v4, 0x0

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setAllCaps(Z)V

    new-instance v4, Lcom/varuns2002/disable_flag_secure/gm/GmClick;

    const/16 v5, 0x3a

    invoke-direct {v4, v5}, Lcom/varuns2002/disable_flag_secure/gm/GmClick;-><init>(I)V

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v5, 0x0

    const/4 v6, -0x2

    const/high16 v7, 0x3f800000  # 1.0f

    invoke-direct {v4, v5, v6, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v2, v3, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    new-instance v3, Landroid/widget/Button;

    invoke-direct {v3, v0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    const-string v4, "免提：关"

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    const/4 v4, 0x0

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setAllCaps(Z)V

    new-instance v4, Lcom/varuns2002/disable_flag_secure/gm/GmClick;

    const/16 v5, 0x3b

    invoke-direct {v4, v5}, Lcom/varuns2002/disable_flag_secure/gm/GmClick;-><init>(I)V

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v5, 0x0

    const/4 v6, -0x2

    const/high16 v7, 0x3f800000  # 1.0f

    invoke-direct {v4, v5, v6, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v2, v3, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    sput-object v3, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->sSpk:Landroid/widget/Button;

    new-instance v3, Landroid/widget/Button;

    invoke-direct {v3, v0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    const-string v4, "允许AI被打断"

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    const/4 v4, 0x0

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setAllCaps(Z)V

    new-instance v4, Lcom/varuns2002/disable_flag_secure/gm/GmClick;

    const/16 v5, 0x3c

    invoke-direct {v4, v5}, Lcom/varuns2002/disable_flag_secure/gm/GmClick;-><init>(I)V

    invoke-virtual {v3, v4}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v5, 0x0

    const/4 v6, -0x2

    const/high16 v7, 0x3f800000  # 1.0f

    invoke-direct {v4, v5, v6, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v2, v3, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    sput-object v3, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->sInt:Landroid/widget/Button;

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    sget-object v2, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->sDlg:Landroid/app/Dialog;

    invoke-virtual {v2, v1}, Landroid/app/Dialog;->setContentView(Landroid/view/View;)V

    invoke-virtual {v2}, Landroid/app/Dialog;->getWindow()Landroid/view/Window;

    move-result-object v3

    if-eqz v3, :cond_1ce

    const/4 v4, 0x0

    invoke-virtual {v3, v4}, Landroid/view/Window;->setBackgroundDrawable(Landroid/graphics/drawable/Drawable;)V

    const/4 v4, -0x1

    const/4 v5, -0x1

    invoke-virtual {v3, v4, v5}, Landroid/view/Window;->setLayout(II)V

    :cond_1ce
    invoke-virtual {v2}, Landroid/app/Dialog;->show()V

    const-string v3, "[通话] 通话页已打开"

    invoke-static {v3}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    return-void
.end method

.method public static send(Ljava/lang/String;)V
    .registers 6

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->sAct:Landroid/app/Activity;

    if-eqz v0, :ret

    sget-object v1, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->sAo1:Ljava/lang/Object;

    if-nez v1, :go

    const-string v2, "还没捕获到发送入口：先在会话里手动发一条消息"

    invoke-static {v0, v2}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    return-void

    :go
    :try_start_0
    new-instance v2, Lyp1;

    invoke-direct {v2}, Lyp1;-><init>()V

    invoke-virtual {v2, p0}, Lyp1;->c(Ljava/lang/String;)V

    check-cast v1, Lao1;

    invoke-virtual {v1, v2}, Lao1;->I(Lyp1;)V

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3}, Ljava/lang/StringBuilder;-><init>()V

    const-string v4, "已发送  "

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v3

    invoke-static {v3}, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->line(Ljava/lang/String;)V

    const-string v3, "已发送"

    invoke-static {v0, v3}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    return-void

    :catchall_0
    move-exception v2

    invoke-static {v2}, Landroid/util/Log;->getStackTraceString(Ljava/lang/Throwable;)Ljava/lang/String;

    move-result-object v2

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    const-string v2, "发送异常（已写日志）"

    invoke-static {v0, v2}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    :ret
    return-void
.end method

.method public static stat(Ljava/lang/String;)V
    .registers 4

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->sAct:Landroid/app/Activity;

    if-eqz v0, :ret

    new-instance v1, Lcom/varuns2002/disable_flag_secure/gm/GmCallRun;

    const/4 v2, 0x0

    invoke-direct {v1, v2, p0}, Lcom/varuns2002/disable_flag_secure/gm/GmCallRun;-><init>(ILjava/lang/String;)V

    invoke-virtual {v0, v1}, Landroid/app/Activity;->runOnUiThread(Ljava/lang/Runnable;)V

    :ret
    return-void
.end method

.method static stopAudio()V
    .registers 5

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->sAct:Landroid/app/Activity;

    if-eqz v0, :ret

    const-string v1, "audio"

    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/media/AudioManager;

    :try_start_0
    const/4 v2, 0x0

    invoke-virtual {v1, v2}, Landroid/media/AudioManager;->setSpeakerphoneOn(Z)V

    const/4 v2, 0x0

    invoke-virtual {v1, v2}, Landroid/media/AudioManager;->setMode(I)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    goto :ret

    :catchall_0
    move-exception v2

    :ret
    return-void
.end method

.method public static testSend()V
    .registers 1

    const-string v0, "【通话测试】模块通过宿主发送链路发出的消息"

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->send(Ljava/lang/String;)V

    return-void
.end method

.method public static toggleInterrupt()V
    .registers 2

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->sAct:Landroid/app/Activity;

    if-eqz v0, :ret

    const-string v1, "「允许 AI 被打断」开发中（灰度：打断并发 尚未接入）"

    invoke-static {v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    :ret
    return-void
.end method

.method public static toggleSpeaker()V
    .registers 6

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->sAct:Landroid/app/Activity;

    if-eqz v0, :ret

    sget-boolean v1, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->sSpkOn:Z

    xor-int/lit8 v1, v1, 0x1

    sput-boolean v1, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->sSpkOn:Z

    const-string v1, "audio"

    invoke-virtual {v0, v1}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Landroid/media/AudioManager;

    :try_start_0
    const/4 v2, 0x3

    invoke-virtual {v1, v2}, Landroid/media/AudioManager;->setMode(I)V

    sget-boolean v2, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->sSpkOn:Z

    invoke-virtual {v1, v2}, Landroid/media/AudioManager;->setSpeakerphoneOn(Z)V
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    goto :ok

    :catchall_0
    move-exception v2

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logE(Ljava/lang/Throwable;)V

    :ok
    sget-object v2, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->sSpk:Landroid/widget/Button;

    if-eqz v2, :ret

    sget-boolean v3, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->sSpkOn:Z

    if-eqz v3, :on

    const-string v4, "免提：关"

    goto :set

    :on
    const-string v4, "免提：开"

    :set
    invoke-virtual {v2, v4}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    invoke-static {v0, v4}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    :ret
    return-void
.end method


// ===== GmCallRun (NL 2.13.0) =====
.class public final Lcom/varuns2002/disable_flag_secure/gm/GmCallRun;
.super Ljava/lang/Object;
.source "GmCallRun.java"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field private a:I

.field private b:Ljava/lang/String;


# direct methods
.method public constructor <init>(ILjava/lang/String;)V
    .registers 3

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput p1, p0, Lcom/varuns2002/disable_flag_secure/gm/GmCallRun;->a:I

    iput-object p2, p0, Lcom/varuns2002/disable_flag_secure/gm/GmCallRun;->b:Ljava/lang/String;

    return-void
.end method


# virtual methods
.method public run()V
    .registers 3

    iget v0, p0, Lcom/varuns2002/disable_flag_secure/gm/GmCallRun;->a:I

    iget-object v1, p0, Lcom/varuns2002/disable_flag_secure/gm/GmCallRun;->b:Ljava/lang/String;

    invoke-static {v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->apply(ILjava/lang/String;)V

    return-void
.end method
