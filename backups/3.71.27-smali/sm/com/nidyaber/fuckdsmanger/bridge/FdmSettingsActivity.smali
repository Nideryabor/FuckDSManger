.class public final Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;
.super Landroid/app/Activity;
.source "FdmSettingsActivity.java"


# static fields
.field private static final SWITCHES:[[Ljava/lang/String;


# instance fields
.field private col:Landroid/widget/LinearLayout;

.field private status:Landroid/widget/TextView;


# direct methods
.method static constructor <clinit>()V
    .registers 9

    .line 35
    const-string v0, "fuckds_bubble_on"

    const-string v1, "\u6c14\u6ce1\u7f8e\u5316\uff08AI \u6c14\u6ce1\uff09"

    const-string v2, "true"

    filled-new-array {v0, v1, v2}, [Ljava/lang/String;

    move-result-object v3

    const-string v0, "fuckds_ububble_on"

    const-string v1, "\u6c14\u6ce1\u7f8e\u5316\uff08\u6211\u7684\u6c14\u6ce1\uff09"

    filled-new-array {v0, v1, v2}, [Ljava/lang/String;

    move-result-object v4

    const-string v0, "fuckds_bg_on"

    const-string v1, "\u4fee\u6539\u80cc\u666f"

    filled-new-array {v0, v1, v2}, [Ljava/lang/String;

    move-result-object v5

    const-string v0, "fuckds_suggest_on"

    const-string v1, "\u56de\u590d\u5efa\u8bae"

    filled-new-array {v0, v1, v2}, [Ljava/lang/String;

    move-result-object v6

    const-string v0, "fuckds_device_on"

    const-string v1, "\u8bbe\u5907\u8eab\u4efd\u4f2a\u88c5"

    filled-new-array {v0, v1, v2}, [Ljava/lang/String;

    move-result-object v7

    const-string v0, "fuckds_model_switch"

    const-string v1, "\u6a21\u578b\u5207\u6362"

    filled-new-array {v0, v1, v2}, [Ljava/lang/String;

    move-result-object v8

    filled-new-array/range {v3 .. v8}, [[Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;->SWITCHES:[[Ljava/lang/String;

    return-void
.end method

.method public constructor <init>()V
    .registers 1

    .line 32
    invoke-direct {p0}, Landroid/app/Activity;-><init>()V

    return-void
.end method

.method static synthetic access$000(Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;Ljava/lang/String;)V
    .registers 2

    .line 32
    invoke-direct {p0, p1}, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;->toast(Ljava/lang/String;)V

    return-void
.end method

.method static synthetic access$100(Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;Ljava/lang/String;)V
    .registers 2

    .line 32
    invoke-direct {p0, p1}, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;->refresh(Ljava/lang/String;)V

    return-void
.end method

.method private dp(I)I
    .registers 2

    int-to-float p1, p1

    .line 181
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;->getResources()Landroid/content/res/Resources;

    move-result-object p0

    invoke-virtual {p0}, Landroid/content/res/Resources;->getDisplayMetrics()Landroid/util/DisplayMetrics;

    move-result-object p0

    iget p0, p0, Landroid/util/DisplayMetrics;->density:F

    mul-float/2addr p1, p0

    const/high16 p0, 0x3f000000    # 0.5f

    add-float/2addr p1, p0

    float-to-int p0, p1

    return p0
.end method

.method private note(Ljava/lang/String;)Landroid/widget/TextView;
    .registers 4

    .line 148
    new-instance v0, Landroid/widget/TextView;

    invoke-direct {v0, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 149
    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const p1, -0x616162

    .line 150
    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setTextColor(I)V

    const/high16 p1, 0x41500000    # 13.0f

    const/4 v1, 0x2

    .line 151
    invoke-virtual {v0, v1, p1}, Landroid/widget/TextView;->setTextSize(IF)V

    .line 152
    invoke-direct {p0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;->dp(I)I

    move-result p1

    invoke-direct {p0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;->dp(I)I

    move-result p0

    const/4 v1, 0x0

    invoke-virtual {v0, v1, p1, v1, p0}, Landroid/widget/TextView;->setPadding(IIII)V

    return-object v0
.end method

.method private refresh(Ljava/lang/String;)V
    .registers 8

    .line 157
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmPush;->sp(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object v0

    .line 158
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    if-eqz p1, :cond_13

    .line 159
    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const/16 p1, 0xa

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(C)Ljava/lang/StringBuilder;

    .line 160
    :cond_13
    const-string p1, "rev = "

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, "rev"

    const/4 v2, 0x1

    invoke-interface {v0, p1, v2}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result p1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, "\n\u5bbf\u4e3b\u5df2\u5e94\u7528 rev = "

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 161
    const-string p1, "applied_rev"

    const/4 v2, -0x1

    invoke-interface {v0, p1, v2}, Landroid/content/SharedPreferences;->getInt(Ljava/lang/String;I)I

    move-result p1

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p1, "\n\u6700\u8fd1\u56de\u6267 = "

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 162
    const-string p1, "applied_at"

    const-wide/16 v2, 0x0

    invoke-interface {v0, p1, v2, v3}, Landroid/content/SharedPreferences;->getLong(Ljava/lang/String;J)J

    move-result-wide v4

    cmp-long p1, v4, v2

    if-nez p1, :cond_45

    .line 163
    const-string p1, "\uff08\u8fd8\u6ca1\u6536\u5230\uff09"

    goto :goto_4e

    :cond_45
    new-instance p1, Ljava/util/Date;

    invoke-direct {p1, v4, v5}, Ljava/util/Date;-><init>(J)V

    invoke-virtual {p1}, Ljava/util/Date;->toString()Ljava/lang/String;

    move-result-object p1

    :goto_4e
    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 164
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;->status:Landroid/widget/TextView;

    if-eqz p0, :cond_5c

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p1

    invoke-virtual {p0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    :cond_5c
    return-void
.end method

.method private row(Ljava/lang/String;Ljava/lang/String;Z)Landroid/view/View;
    .registers 9

    .line 109
    new-instance v0, Landroid/widget/LinearLayout;

    invoke-direct {v0, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v1, 0x0

    .line 110
    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->setOrientation(I)V

    const/16 v2, 0x10

    .line 111
    invoke-virtual {v0, v2}, Landroid/widget/LinearLayout;->setGravity(I)V

    const/4 v2, 0x6

    .line 112
    invoke-direct {p0, v2}, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;->dp(I)I

    move-result v3

    invoke-direct {p0, v2}, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;->dp(I)I

    move-result v2

    invoke-virtual {v0, v1, v3, v1, v2}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    .line 114
    new-instance v2, Landroid/widget/TextView;

    invoke-direct {v2, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 115
    invoke-virtual {v2, p2}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const p2, -0x1f1f20

    .line 116
    invoke-virtual {v2, p2}, Landroid/widget/TextView;->setTextColor(I)V

    const/4 p2, 0x2

    const/high16 v3, 0x41800000    # 16.0f

    .line 117
    invoke-virtual {v2, p2, v3}, Landroid/widget/TextView;->setTextSize(IF)V

    .line 118
    new-instance p2, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v3, -0x2

    const/high16 v4, 0x3f800000    # 1.0f

    invoke-direct {p2, v1, v3, v4}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v2, p2}, Landroid/widget/TextView;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 119
    invoke-virtual {v0, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 121
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmPush;->sp(Landroid/content/Context;)Landroid/content/SharedPreferences;

    move-result-object p2

    .line 122
    invoke-interface {p2, p1, p3}, Landroid/content/SharedPreferences;->getBoolean(Ljava/lang/String;Z)Z

    move-result p3

    .line 123
    new-instance v1, Landroid/widget/Switch;

    invoke-direct {v1, p0}, Landroid/widget/Switch;-><init>(Landroid/content/Context;)V

    .line 124
    invoke-virtual {v1, p3}, Landroid/widget/Switch;->setChecked(Z)V

    .line 125
    new-instance p3, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity$2;

    invoke-direct {p3, p0, p2, p1}, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity$2;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;Landroid/content/SharedPreferences;Ljava/lang/String;)V

    invoke-virtual {v1, p3}, Landroid/widget/Switch;->setOnCheckedChangeListener(Landroid/widget/CompoundButton$OnCheckedChangeListener;)V

    .line 134
    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    return-object v0
.end method

.method private title(Ljava/lang/String;)Landroid/widget/TextView;
    .registers 4

    .line 139
    new-instance v0, Landroid/widget/TextView;

    invoke-direct {v0, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 140
    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/4 p1, -0x1

    .line 141
    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setTextColor(I)V

    const/4 p1, 0x2

    const/high16 v1, 0x41b00000    # 22.0f

    .line 142
    invoke-virtual {v0, p1, v1}, Landroid/widget/TextView;->setTextSize(IF)V

    const/16 p1, 0x8

    .line 143
    invoke-direct {p0, p1}, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;->dp(I)I

    move-result p0

    const/4 p1, 0x0

    invoke-virtual {v0, p1, p1, p1, p0}, Landroid/widget/TextView;->setPadding(IIII)V

    return-object v0
.end method

.method private toast(Ljava/lang/String;)V
    .registers 3

    const/4 v0, 0x0

    .line 168
    invoke-static {p0, p1, v0}, Landroid/widget/Toast;->makeText(Landroid/content/Context;Ljava/lang/CharSequence;I)Landroid/widget/Toast;

    move-result-object p0

    invoke-virtual {p0}, Landroid/widget/Toast;->show()V

    return-void
.end method

.method private versionName()Ljava/lang/String;
    .registers 5

    .line 173
    :try_start_0
    new-instance v0, Ljava/lang/StringBuilder;

    invoke-direct {v0}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v1

    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;->getPackageName()Ljava/lang/String;

    move-result-object v2

    const/4 v3, 0x0

    invoke-virtual {v1, v2, v3}, Landroid/content/pm/PackageManager;->getPackageInfo(Ljava/lang/String;I)Landroid/content/pm/PackageInfo;

    move-result-object v1

    iget-object v1, v1, Landroid/content/pm/PackageInfo;->versionName:Ljava/lang/String;

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " ("

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 174
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;->getPackageManager()Landroid/content/pm/PackageManager;

    move-result-object v1

    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;->getPackageName()Ljava/lang/String;

    move-result-object p0

    invoke-virtual {v1, p0, v3}, Landroid/content/pm/PackageManager;->getPackageInfo(Ljava/lang/String;I)Landroid/content/pm/PackageInfo;

    move-result-object p0

    iget p0, p0, Landroid/content/pm/PackageInfo;->versionCode:I

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, ")"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0
    :try_end_36
    .catchall {:try_start_0 .. :try_end_36} :catchall_37

    return-object p0

    .line 176
    :catchall_37
    const-string p0, "?"

    return-object p0
.end method


# virtual methods
.method protected onCreate(Landroid/os/Bundle;)V
    .registers 14

    .line 49
    invoke-super {p0, p1}, Landroid/app/Activity;->onCreate(Landroid/os/Bundle;)V

    .line 51
    new-instance p1, Landroid/widget/ScrollView;

    invoke-direct {p1, p0}, Landroid/widget/ScrollView;-><init>(Landroid/content/Context;)V

    const v0, -0xededee

    .line 52
    invoke-virtual {p1, v0}, Landroid/widget/ScrollView;->setBackgroundColor(I)V

    .line 53
    new-instance v0, Landroid/widget/LinearLayout;

    invoke-direct {v0, p0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    iput-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;->col:Landroid/widget/LinearLayout;

    const/4 v1, 0x1

    .line 54
    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->setOrientation(I)V

    const/16 v0, 0x10

    .line 55
    invoke-direct {p0, v0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;->dp(I)I

    move-result v0

    .line 56
    iget-object v2, p0, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;->col:Landroid/widget/LinearLayout;

    invoke-virtual {v2, v0, v0, v0, v0}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    .line 57
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;->col:Landroid/widget/LinearLayout;

    new-instance v2, Landroid/view/ViewGroup$LayoutParams;

    const/4 v3, -0x1

    const/4 v4, -0x2

    invoke-direct {v2, v3, v4}, Landroid/view/ViewGroup$LayoutParams;-><init>(II)V

    invoke-virtual {p1, v0, v2}, Landroid/widget/ScrollView;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 60
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;->col:Landroid/widget/LinearLayout;

    const-string v2, "FDM \u6865\u8bbe\u7f6e"

    invoke-direct {p0, v2}, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;->title(Ljava/lang/String;)Landroid/widget/TextView;

    move-result-object v2

    invoke-virtual {v0, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 62
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;->col:Landroid/widget/LinearLayout;

    new-instance v2, Ljava/lang/StringBuilder;

    const-string v5, "\u672c\u5305 = "

    invoke-direct {v2, v5}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;->getPackageName()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-direct {p0, v2}, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;->note(Ljava/lang/String;)Landroid/widget/TextView;

    move-result-object v2

    invoke-virtual {v0, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 63
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;->col:Landroid/widget/LinearLayout;

    new-instance v2, Ljava/lang/StringBuilder;

    const-string v5, "\u7248\u672c = "

    invoke-direct {v2, v5}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;->versionName()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v2, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v2

    invoke-direct {p0, v2}, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;->note(Ljava/lang/String;)Landroid/widget/TextView;

    move-result-object v2

    invoke-virtual {v0, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 64
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;->col:Landroid/widget/LinearLayout;

    const-string v2, "\u6539\u5b8c\u7acb\u523b\u63a8\u7ed9\u5bbf\u4e3b\u3002\u5bbf\u4e3b\u90a3\u8fb9\u91cd\u542f\u4e00\u6b21\u540e\u5b8c\u5168\u751f\u6548\u3002"

    invoke-direct {p0, v2}, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;->note(Ljava/lang/String;)Landroid/widget/TextView;

    move-result-object v2

    invoke-virtual {v0, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 65
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;->col:Landroid/widget/LinearLayout;

    const-string v2, "\u914d\u7f6e\u8d70\u5e7f\u64ad\u901a\u9053 \u2014\u2014 \u4e0d\u9700\u8981\u5305\u53ef\u89c1\u6027\u3001\u4e0d\u9700\u8981 root\u3002"

    invoke-direct {p0, v2}, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;->note(Ljava/lang/String;)Landroid/widget/TextView;

    move-result-object v2

    invoke-virtual {v0, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 67
    sget-object v0, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;->SWITCHES:[[Ljava/lang/String;

    array-length v2, v0

    const/4 v5, 0x0

    move v6, v5

    :goto_8c
    if-ge v6, v2, :cond_a9

    aget-object v7, v0, v6

    .line 68
    iget-object v8, p0, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;->col:Landroid/widget/LinearLayout;

    aget-object v9, v7, v5

    aget-object v10, v7, v1

    const/4 v11, 0x2

    aget-object v7, v7, v11

    const-string v11, "true"

    invoke-virtual {v11, v7}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result v7

    invoke-direct {p0, v9, v10, v7}, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;->row(Ljava/lang/String;Ljava/lang/String;Z)Landroid/view/View;

    move-result-object v7

    invoke-virtual {v8, v7}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    add-int/lit8 v6, v6, 0x1

    goto :goto_8c

    .line 71
    :cond_a9
    new-instance v0, Landroid/widget/Button;

    invoke-direct {v0, p0}, Landroid/widget/Button;-><init>(Landroid/content/Context;)V

    .line 72
    const-string v1, "\u518d\u63a8\u4e00\u6b21"

    invoke-virtual {v0, v1}, Landroid/widget/Button;->setText(Ljava/lang/CharSequence;)V

    .line 73
    new-instance v1, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity$1;

    invoke-direct {v1, p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity$1;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;)V

    invoke-virtual {v0, v1}, Landroid/widget/Button;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 81
    new-instance v1, Landroid/widget/LinearLayout$LayoutParams;

    invoke-direct {v1, v3, v4}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    const/16 v2, 0xc

    .line 83
    invoke-direct {p0, v2}, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;->dp(I)I

    move-result v2

    iput v2, v1, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    .line 84
    iget-object v2, p0, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;->col:Landroid/widget/LinearLayout;

    invoke-virtual {v2, v0, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 86
    const-string v0, ""

    invoke-direct {p0, v0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;->note(Ljava/lang/String;)Landroid/widget/TextView;

    move-result-object v0

    iput-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;->status:Landroid/widget/TextView;

    .line 87
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;->col:Landroid/widget/LinearLayout;

    invoke-virtual {v1, v0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 89
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;->col:Landroid/widget/LinearLayout;

    const-string v1, "\u2014 \u72b6\u6001\u6765\u81ea\u5bbf\u4e3b\u56de\u6267 \u2014"

    invoke-direct {p0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;->note(Ljava/lang/String;)Landroid/widget/TextView;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 90
    invoke-virtual {p0, p1}, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;->setContentView(Landroid/view/View;)V

    const/4 p1, 0x0

    .line 91
    invoke-direct {p0, p1}, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;->refresh(Ljava/lang/String;)V

    return-void
.end method

.method protected onResume()V
    .registers 5

    .line 96
    const-string v0, "FDM-DIAG"

    .line 0
    const-string v1, "\u8bbe\u7f6e\u9875 onResume \u21d2 \u5df2\u63a8\u9001 "

    .line 96
    invoke-super {p0}, Landroid/app/Activity;->onResume()V

    .line 100
    :try_start_7
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmPush;->push(Landroid/content/Context;)I

    move-result v2

    .line 101
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " \u9879"

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v0, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;)I
    :try_end_1f
    .catchall {:try_start_7 .. :try_end_1f} :catchall_20

    goto :goto_26

    :catchall_20
    move-exception v1

    .line 103
    const-string v2, "\u8bbe\u7f6e\u9875 onResume \u63a8\u9001\u5931\u8d25"

    invoke-static {v0, v2, v1}, Landroid/util/Log;->e(Ljava/lang/String;Ljava/lang/String;Ljava/lang/Throwable;)I

    .line 105
    :goto_26
    const-string v0, "\uff08\u56de\u5230\u524d\u53f0\uff0c\u5df2\u63a8\u4e00\u6b21\uff09"

    invoke-direct {p0, v0}, Lcom/nidyaber/fuckdsmanger/bridge/FdmSettingsActivity;->refresh(Ljava/lang/String;)V

    return-void
.end method
