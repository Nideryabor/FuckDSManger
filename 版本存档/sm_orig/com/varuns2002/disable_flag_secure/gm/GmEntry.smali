.class public final Lcom/varuns2002/disable_flag_secure/gm/GmEntry;
.super Ljava/lang/Object;
.source "GmEntry.java"

# interfaces
.implements Ljava/lang/Runnable;


# static fields
.field static sAct:Landroid/app/Activity;

.field static sBar:Landroid/view/View;

.field static sH:Landroid/os/Handler;

.field static sInited:Z

.field static sRunner:Lcom/varuns2002/disable_flag_secure/gm/GmEntry;

.field static sTick:J

.field static sTitleId:I


# direct methods
.method static constructor <clinit>()V
    .registers 2

    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    sput-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmEntry;->sH:Landroid/os/Handler;

    new-instance v0, Lcom/varuns2002/disable_flag_secure/gm/GmEntry;

    invoke-direct {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmEntry;-><init>()V

    sput-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmEntry;->sRunner:Lcom/varuns2002/disable_flag_secure/gm/GmEntry;

    return-void
.end method

.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method public static hide()V
    .registers 3

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmEntry;->sBar:Landroid/view/View;

    if-nez v0, :cond_5

    return-void

    :cond_5
    invoke-virtual {v0}, Landroid/view/View;->getParent()Landroid/view/ViewParent;

    move-result-object v1

    check-cast v1, Landroid/view/ViewGroup;

    if-eqz v1, :cond_10

    invoke-virtual {v1, v0}, Landroid/view/ViewGroup;->removeView(Landroid/view/View;)V

    :cond_10
    const/4 v0, 0x0

    sput-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmEntry;->sBar:Landroid/view/View;

    return-void
.end method

.method public static setAct(Landroid/app/Activity;)V
    .registers 8

    sput-object p0, Lcom/varuns2002/disable_flag_secure/gm/GmEntry;->sAct:Landroid/app/Activity;

    sget-boolean v0, Lcom/varuns2002/disable_flag_secure/gm/GmEntry;->sInited:Z

    if-nez v0, :cond_34

    const/4 v0, 0x1

    sput-boolean v0, Lcom/varuns2002/disable_flag_secure/gm/GmEntry;->sInited:Z

    invoke-virtual {p0}, Landroid/app/Activity;->getResources()Landroid/content/res/Resources;

    move-result-object v0

    const-string v1, "profile_check_for_updates"

    const-string v2, "string"

    invoke-virtual {p0}, Landroid/app/Activity;->getPackageName()Ljava/lang/String;

    move-result-object v3

    invoke-virtual {v0, v1, v2, v3}, Landroid/content/res/Resources;->getIdentifier(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)I

    move-result v0

    sput v0, Lcom/varuns2002/disable_flag_secure/gm/GmEntry;->sTitleId:I

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string v2, "profile_check_for_updates resId="

    invoke-virtual {v1, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    const-string v1, "FuckDSManger v1.0.8 loaded OK"

    invoke-static {p0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->toast(Landroid/content/Context;Ljava/lang/String;)V

    :cond_34
    return-void
.end method

.method public static show(Landroid/app/Activity;)V
    .registers 9

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmEntry;->sBar:Landroid/view/View;

    if-eqz v0, :cond_5

    return-void

    :cond_5
    :try_start_5
    invoke-virtual {p0}, Landroid/app/Activity;->getWindow()Landroid/view/Window;

    move-result-object v0

    invoke-virtual {v0}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object v0

    check-cast v0, Landroid/view/ViewGroup;

    new-instance v1, Landroid/widget/LinearLayout;

    invoke-direct {v1, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v2, 0x0

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->setOrientation(I)V

    const/16 v2, 0x10

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->setGravity(I)V

    const/16 v2, 0xe

    invoke-static {p0, v2}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->dp(Landroid/content/Context;I)I

    move-result v2

    invoke-virtual {v1, v2, v2, v2, v2}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    const v2, -0x1000000

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->setBackgroundColor(I)V

    new-instance v2, Landroid/widget/TextView;

    invoke-direct {v2, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v3, "FuckDSManger"

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/4 v3, -0x1

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 v3, 0x41800000    # 16.0f

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextSize(F)V

    new-instance v3, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v4, 0x0

    const/4 v5, -0x2

    const/high16 v6, 0x3f800000    # 1.0f

    invoke-direct {v3, v4, v5, v6}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    new-instance v2, Landroid/widget/TextView;

    invoke-direct {v2, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    const-string v3, ">"

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/4 v3, -0x1

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 v3, 0x41a00000    # 20.0f

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setTextSize(F)V

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    const/4 v2, 0x1

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->setClickable(Z)V

    new-instance v2, Lcom/varuns2002/disable_flag_secure/gm/GmClick;

    const/4 v3, 0x0

    invoke-direct {v2, v3}, Lcom/varuns2002/disable_flag_secure/gm/GmClick;-><init>(I)V

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    new-instance v2, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v3, -0x1

    const/4 v4, -0x2

    invoke-direct {v2, v3, v4}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    const/16 v3, 0x30

    iput v3, v2, Landroid/widget/FrameLayout$LayoutParams;->gravity:I

    invoke-virtual {v0, v1, v2}, Landroid/view/ViewGroup;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    sput-object v1, Lcom/varuns2002/disable_flag_secure/gm/GmEntry;->sBar:Landroid/view/View;

    const-string v1, "overlay"

    const-string v7, "bar added to decorView OK"

    invoke-static {v1, v7}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V
    :try_end_88
    .catchall {:try_start_5 .. :try_end_88} :catchall_89

    goto :goto_8f

    :catchall_89
    move-exception v0

    const-string v1, "show overlay FAIL"

    invoke-static {v1, v0}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    :goto_8f
    return-void
.end method

.method public static tick()V
    .registers 4

    sget-object v0, Lcom/varuns2002/disable_flag_secure/gm/GmEntry;->sAct:Landroid/app/Activity;

    if-nez v0, :cond_c

    const-string v1, "tick_noact"

    const-string v2, "tick() but activity == null"

    invoke-static {v1, v2}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    return-void

    :cond_c
    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v1

    sput-wide v1, Lcom/varuns2002/disable_flag_secure/gm/GmEntry;->sTick:J

    return-void
.end method


# virtual methods
.method public run()V
    .registers 5

    invoke-static {}, Landroid/os/SystemClock;->uptimeMillis()J

    move-result-wide v0

    sget-wide v2, Lcom/varuns2002/disable_flag_secure/gm/GmEntry;->sTick:J

    sub-long/2addr v0, v2

    const-wide/16 v2, 0xbb8

    cmp-long p0, v0, v2

    if-lez p0, :cond_10

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmEntry;->hide()V

    :cond_10
    return-void
.end method
