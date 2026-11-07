.class final Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;
.super Landroid/widget/FrameLayout;
.source "GmMiniBarView.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Drag;,
        Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$LyricAdapter;,
        Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Resize;
    }
.end annotation


# static fields
.field private static final ANIM_MS:J = 0x12cL

.field private static final BODY_GAP:I = 0x8

.field private static final BTN_GAP:I = 0x6

.field private static final BTN_H:I = 0x1e

.field private static final BTN_W:[I

.field private static final CARD_R:I = 0x10

.field private static final CORNER_SYM:[I

.field private static final COVER_R:I = 0xa

.field private static final COVER_SIDE:I = 0x54

.field private static final C_ACC:I = -0xf57b01

.field private static final C_ACC_HI:I = -0xb05701

.field private static final C_BTN:I = 0x1fffffff

.field private static final C_BTN_HI:I = 0x400a84ff

.field private static final C_CARD_BOT:I = -0x5f3f1ec

.field private static final C_CARD_TOP:I = -0xde9e5dc

.field private static final C_PANEL:I = 0x1fffffff

.field private static final C_SOLID:I = -0xdefede8

.field private static final C_SUB:I = -0x610a0806

.field private static final C_TXT:I = -0xa0806

.field static final DEF_H:I = 0xd2

.field static final DEF_W:I = 0x14a

.field private static final LRC_HALF:I = 0xa

.field private static final LRC_ROW_H:I = 0x1c

.field static final MAX_H:I = 0x230

.field static final MAX_W:I = 0x230

.field static final MIN_H:I = 0x96

.field static final MIN_W:I = 0xf0

.field private static final PAD:I = 0xa

.field private static final SEEK_GAP:I = 0x6

.field private static final SEEK_H:I = 0x16

.field private static final TOPBAR_H:I = 0x1c


# instance fields
.field private final act:Landroid/app/Activity;

.field private final cardDrag:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Drag;

.field private coverWanted:J

.field private curDur:I

.field private curLine:I

.field private focusMode:Z

.field private gdCard:Landroid/view/GestureDetector;

.field private gdLyric:Landroid/view/GestureDetector;

.field private lastLoopOne:Z

.field private lastPlayGlyph:Ljava/lang/String;

.field private lastShuffle:Z

.field private lastTitle:Ljava/lang/String;

.field private lastTouchLog:J

.field private layoutAnim:Landroid/animation/ValueAnimator;

.field private layoutT:F

.field private lrcAskId:J

.field private lrcFollow:Z

.field private lrcId:J

.field private lrcJustBuilt:Z

.field private final lrcMs:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Ljava/lang/Long;",
            ">;"
        }
    .end annotation
.end field

.field private lrcSrcLen:I

.field private final lrcText:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Ljava/lang/String;",
            ">;"
        }
    .end annotation
.end field

.field private lrcUnlock:Ljava/lang/Runnable;

.field private pagePlay:Landroid/widget/FrameLayout;

.field private pageSearch:Landroid/widget/FrameLayout;

.field private pureImage:Z

.field private results:Ljava/util/List;
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "Ljava/util/List<",
            "Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;",
            ">;"
        }
    .end annotation
.end field

.field private searchPageOpen:Z

.field private searching:Z

.field private seekTouching:Z

.field private showQueue:Z

.field private final tick:Ljava/lang/Runnable;

.field private final ui:Landroid/os/Handler;

.field private vBgTint:Landroid/view/View;

.field private vBtnBack:Landroid/widget/TextView;

.field private vBtnClose:Landroid/widget/TextView;

.field private vBtnLoop:Landroid/widget/TextView;

.field private vBtnNext:Landroid/widget/TextView;

.field private vBtnPage:Landroid/widget/TextView;

.field private vBtnPlay:Landroid/widget/TextView;

.field private vBtnPrev:Landroid/widget/TextView;

.field private vBtnRow:Landroid/widget/LinearLayout;

.field private vBtnShuffle:Landroid/widget/TextView;

.field private vCover:Landroid/widget/ImageView;

.field private vCoverRoundMask:Landroid/view/View;

.field private vDur:Landroid/widget/TextView;

.field private vHairline:Landroid/view/View;

.field private vKw:Landroid/widget/EditText;

.field private vListBox:Landroid/widget/LinearLayout;

.field private vListScroll:Landroid/widget/ScrollView;

.field private vListSwitch:Landroid/widget/TextView;

.field private vListTitle:Landroid/widget/TextView;

.field private vLrcAdapter:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$LyricAdapter;

.field private vLyric:Landroid/widget/ListView;

.field private vPos:Landroid/widget/TextView;

.field private vScrim:Landroid/view/View;

.field private vSeek:Landroid/widget/SeekBar;

.field private vSeekRow:Landroid/widget/LinearLayout;

.field private vTitle:Landroid/widget/TextView;

.field private vTopBar:Landroid/widget/LinearLayout;


# direct methods
.method static constructor <clinit>()V
    .registers 4

    const/16 v0, 0x32

    const/16 v1, 0x1e

    const/16 v2, 0x2a

    .line 148
    filled-new-array {v2, v0, v2, v1, v1}, [I

    move-result-object v0

    sput-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->BTN_W:[I

    const/16 v0, 0x25e3

    const/16 v1, 0x25e2

    const/16 v2, 0x25e4

    const/16 v3, 0x25e5

    .line 161
    filled-new-array {v2, v3, v0, v1}, [I

    move-result-object v0

    sput-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->CORNER_SYM:[I

    return-void
.end method

.method constructor <init>(Landroid/app/Activity;)V
    .registers 7

    .line 237
    invoke-direct {p0, p1}, Landroid/widget/FrameLayout;-><init>(Landroid/content/Context;)V

    .line 164
    new-instance v0, Landroid/os/Handler;

    invoke-static {}, Landroid/os/Looper;->getMainLooper()Landroid/os/Looper;

    move-result-object v1

    invoke-direct {v0, v1}, Landroid/os/Handler;-><init>(Landroid/os/Looper;)V

    iput-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->ui:Landroid/os/Handler;

    const/4 v0, 0x0

    .line 199
    iput-boolean v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->showQueue:Z

    .line 200
    new-instance v1, Ljava/util/ArrayList;

    invoke-direct {v1}, Ljava/util/ArrayList;-><init>()V

    iput-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->results:Ljava/util/List;

    .line 201
    iput-boolean v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->searching:Z

    .line 203
    iput-boolean v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->searchPageOpen:Z

    const-wide/16 v1, -0x1

    .line 206
    iput-wide v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcId:J

    const/4 v3, -0x2

    .line 207
    iput v3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcSrcLen:I

    .line 208
    iput-wide v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcAskId:J

    .line 209
    new-instance v3, Ljava/util/ArrayList;

    invoke-direct {v3}, Ljava/util/ArrayList;-><init>()V

    iput-object v3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcText:Ljava/util/List;

    .line 210
    new-instance v3, Ljava/util/ArrayList;

    invoke-direct {v3}, Ljava/util/ArrayList;-><init>()V

    iput-object v3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcMs:Ljava/util/List;

    const/4 v3, -0x1

    .line 211
    iput v3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->curLine:I

    const/4 v3, 0x1

    .line 212
    iput-boolean v3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcFollow:Z

    .line 213
    iput-boolean v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcJustBuilt:Z

    const/4 v3, 0x0

    .line 214
    iput-object v3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcUnlock:Ljava/lang/Runnable;

    .line 217
    iput-boolean v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->focusMode:Z

    .line 218
    iput-boolean v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->pureImage:Z

    const/4 v4, 0x0

    .line 220
    iput v4, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->layoutT:F

    .line 225
    new-instance v4, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Drag;

    invoke-direct {v4, p0, v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Drag;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$1;)V

    iput-object v4, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->cardDrag:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Drag;

    .line 228
    iput-wide v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->coverWanted:J

    .line 229
    iput v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->curDur:I

    .line 230
    iput-boolean v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->seekTouching:Z

    const-wide/16 v1, 0x0

    .line 231
    iput-wide v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lastTouchLog:J

    .line 232
    iput-boolean v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lastLoopOne:Z

    iput-boolean v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lastShuffle:Z

    .line 233
    const-string v0, ""

    iput-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lastPlayGlyph:Ljava/lang/String;

    .line 234
    iput-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lastTitle:Ljava/lang/String;

    .line 1605
    new-instance v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$35;

    invoke-direct {v0, p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$35;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V

    iput-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->tick:Ljava/lang/Runnable;

    .line 238
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->act:Landroid/app/Activity;

    .line 239
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->build()V

    return-void
.end method

.method static synthetic access$100(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;F)I
    .registers 2

    .line 97
    invoke-direct {p0, p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result p0

    return p0
.end method

.method static synthetic access$1000()Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;
    .registers 1

    .line 97
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->pl()Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    move-result-object v0

    return-object v0
.end method

.method static synthetic access$1100(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)Ljava/util/List;
    .registers 1

    .line 97
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcText:Ljava/util/List;

    return-object p0
.end method

.method static synthetic access$1200(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)I
    .registers 1

    .line 97
    iget p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->curLine:I

    return p0
.end method

.method static synthetic access$1202(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;I)I
    .registers 2

    .line 97
    iput p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->curLine:I

    return p1
.end method

.method static synthetic access$1302(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;Ljava/lang/Runnable;)Ljava/lang/Runnable;
    .registers 2

    .line 97
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcUnlock:Ljava/lang/Runnable;

    return-object p1
.end method

.method static synthetic access$1402(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;Z)Z
    .registers 2

    .line 97
    iput-boolean p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcFollow:Z

    return p1
.end method

.method static synthetic access$1500(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;Z)V
    .registers 2

    .line 97
    invoke-direct {p0, p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lyricScrollToCurrent(Z)V

    return-void
.end method

.method static synthetic access$1600(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$LyricAdapter;
    .registers 1

    .line 97
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vLrcAdapter:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$LyricAdapter;

    return-object p0
.end method

.method static synthetic access$1700(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;F)V
    .registers 2

    .line 97
    invoke-direct {p0, p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->applyPlayLayout(F)V

    return-void
.end method

.method static synthetic access$1800(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)Z
    .registers 1

    .line 97
    iget-boolean p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->pureImage:Z

    return p0
.end method

.method static synthetic access$1900(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V
    .registers 1

    .line 97
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->exitPure()V

    return-void
.end method

.method static synthetic access$200(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;Z)V
    .registers 2

    .line 97
    invoke-direct {p0, p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->showSearchPage(Z)V

    return-void
.end method

.method static synthetic access$2000(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;Z)V
    .registers 2

    .line 97
    invoke-direct {p0, p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->setFocusMode(Z)V

    return-void
.end method

.method static synthetic access$2100(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)Z
    .registers 1

    .line 97
    iget-boolean p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->focusMode:Z

    return p0
.end method

.method static synthetic access$2200(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V
    .registers 1

    .line 97
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->togglePureImage()V

    return-void
.end method

.method static synthetic access$2300(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)Landroid/widget/ListView;
    .registers 1

    .line 97
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vLyric:Landroid/widget/ListView;

    return-object p0
.end method

.method static synthetic access$2400(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)Ljava/util/List;
    .registers 1

    .line 97
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcMs:Ljava/util/List;

    return-object p0
.end method

.method static synthetic access$2500(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)Landroid/view/GestureDetector;
    .registers 1

    .line 97
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->gdLyric:Landroid/view/GestureDetector;

    return-object p0
.end method

.method static synthetic access$2600(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V
    .registers 1

    .line 97
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->scheduleFollowResume()V

    return-void
.end method

.method static synthetic access$2700(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)Landroid/view/GestureDetector;
    .registers 1

    .line 97
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->gdCard:Landroid/view/GestureDetector;

    return-object p0
.end method

.method static synthetic access$2800(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Drag;
    .registers 1

    .line 97
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->cardDrag:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Drag;

    return-object p0
.end method

.method static synthetic access$2900(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V
    .registers 1

    .line 97
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->doSearch()V

    return-void
.end method

.method static synthetic access$300(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V
    .registers 1

    .line 97
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->exitFocus()V

    return-void
.end method

.method static synthetic access$3000(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)Z
    .registers 1

    .line 97
    iget-boolean p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->showQueue:Z

    return p0
.end method

.method static synthetic access$3002(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;Z)Z
    .registers 2

    .line 97
    iput-boolean p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->showQueue:Z

    return p1
.end method

.method static synthetic access$3100(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V
    .registers 1

    .line 97
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->refreshList()V

    return-void
.end method

.method static synthetic access$3202(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;Z)Z
    .registers 2

    .line 97
    iput-boolean p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->searching:Z

    return p1
.end method

.method static synthetic access$3302(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;Ljava/util/List;)Ljava/util/List;
    .registers 2

    .line 97
    iput-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->results:Ljava/util/List;

    return-object p1
.end method

.method static synthetic access$3400(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)J
    .registers 3

    .line 97
    iget-wide v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->coverWanted:J

    return-wide v0
.end method

.method static synthetic access$3500(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)Landroid/widget/ImageView;
    .registers 1

    .line 97
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vCover:Landroid/widget/ImageView;

    return-object p0
.end method

.method static synthetic access$3600(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)Landroid/os/Handler;
    .registers 1

    .line 97
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->ui:Landroid/os/Handler;

    return-object p0
.end method

.method static synthetic access$3700(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V
    .registers 1

    .line 97
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->clamp()V

    return-void
.end method

.method static synthetic access$400(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)F
    .registers 1

    .line 97
    iget p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->layoutT:F

    return p0
.end method

.method static synthetic access$402(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;F)F
    .registers 2

    .line 97
    iput p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->layoutT:F

    return p1
.end method

.method static synthetic access$600(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)I
    .registers 1

    .line 97
    iget p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->curDur:I

    return p0
.end method

.method static synthetic access$700(I)Ljava/lang/String;
    .registers 1

    .line 97
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->fmt(I)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method static synthetic access$800(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)Landroid/widget/TextView;
    .registers 1

    .line 97
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vPos:Landroid/widget/TextView;

    return-object p0
.end method

.method static synthetic access$902(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;Z)Z
    .registers 2

    .line 97
    iput-boolean p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->seekTouching:Z

    return p1
.end method

.method private animateLayout(F)V
    .registers 8

    .line 1030
    :try_start_0
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->layoutAnim:Landroid/animation/ValueAnimator;

    if-eqz v0, :cond_a

    .line 1031
    invoke-virtual {v0}, Landroid/animation/ValueAnimator;->cancel()V

    const/4 v0, 0x0

    .line 1032
    iput-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->layoutAnim:Landroid/animation/ValueAnimator;

    .line 1034
    :cond_a
    iget v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->layoutT:F

    sub-float v1, v0, p1

    .line 1035
    invoke-static {v1}, Ljava/lang/Math;->abs(F)F

    move-result v1

    const v2, 0x3a83126f    # 0.001f

    cmpg-float v1, v1, v2

    if-gez v1, :cond_1f

    .line 1036
    iput p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->layoutT:F

    .line 1037
    invoke-direct {p0, p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->applyPlayLayout(F)V

    return-void

    :cond_1f
    const/4 v1, 0x2

    .line 1040
    new-array v1, v1, [F

    const/4 v2, 0x0

    aput v0, v1, v2

    const/4 v0, 0x1

    aput p1, v1, v0

    .line 1041
    invoke-static {v1}, Landroid/animation/ValueAnimator;->ofFloat([F)Landroid/animation/ValueAnimator;

    move-result-object v0

    const-wide/16 v1, 0x12c

    .line 1042
    invoke-virtual {v0, v1, v2}, Landroid/animation/ValueAnimator;->setDuration(J)Landroid/animation/ValueAnimator;
    :try_end_31
    .catchall {:try_start_0 .. :try_end_31} :catchall_5c

    .line 1044
    :try_start_31
    new-instance v1, Landroid/view/animation/PathInterpolator;

    const v2, 0x3e4ccccd    # 0.2f

    const/high16 v3, 0x3f800000    # 1.0f

    const v4, 0x3ecccccd    # 0.4f

    const/4 v5, 0x0

    invoke-direct {v1, v4, v5, v2, v3}, Landroid/view/animation/PathInterpolator;-><init>(FFFF)V

    invoke-virtual {v0, v1}, Landroid/animation/ValueAnimator;->setInterpolator(Landroid/animation/TimeInterpolator;)V
    :try_end_42
    .catchall {:try_start_31 .. :try_end_42} :catchall_43

    goto :goto_4e

    .line 1046
    :catchall_43
    :try_start_43
    new-instance v1, Landroid/view/animation/DecelerateInterpolator;

    const v2, 0x3fcccccd    # 1.6f

    invoke-direct {v1, v2}, Landroid/view/animation/DecelerateInterpolator;-><init>(F)V

    invoke-virtual {v0, v1}, Landroid/animation/ValueAnimator;->setInterpolator(Landroid/animation/TimeInterpolator;)V

    .line 1048
    :goto_4e
    new-instance v1, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$16;

    invoke-direct {v1, p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$16;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V

    invoke-virtual {v0, v1}, Landroid/animation/ValueAnimator;->addUpdateListener(Landroid/animation/ValueAnimator$AnimatorUpdateListener;)V

    .line 1055
    iput-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->layoutAnim:Landroid/animation/ValueAnimator;

    .line 1056
    invoke-virtual {v0}, Landroid/animation/ValueAnimator;->start()V
    :try_end_5b
    .catchall {:try_start_43 .. :try_end_5b} :catchall_5c

    goto :goto_61

    .line 1058
    :catchall_5c
    iput p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->layoutT:F

    .line 1059
    invoke-direct {p0, p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->applyPlayLayout(F)V

    :goto_61
    return-void
.end method

.method private applyPlayLayout()V
    .registers 2

    .line 681
    iget v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->layoutT:F

    invoke-direct {p0, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->applyPlayLayout(F)V

    return-void
.end method

.method private applyPlayLayout(F)V
    .registers 24

    move-object/from16 v0, p0

    .line 686
    :try_start_2
    invoke-virtual {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->getWidth()I

    move-result v1

    invoke-virtual {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->getHeight()I

    move-result v2

    if-lez v1, :cond_167

    if-gtz v2, :cond_10

    goto/16 :goto_167

    :cond_10
    const/4 v6, 0x0

    cmpg-float v3, p1, v6

    if-gez v3, :cond_17

    move v3, v6

    goto :goto_19

    :cond_17
    move/from16 v3, p1

    :goto_19
    const/high16 v7, 0x3f800000    # 1.0f

    cmpl-float v4, v3, v7

    if-lez v4, :cond_21

    move v8, v7

    goto :goto_22

    :cond_21
    move v8, v3

    :goto_22
    const/high16 v3, 0x41200000    # 10.0f

    .line 691
    invoke-direct {v0, v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v4

    const/high16 v5, 0x41e00000    # 28.0f

    .line 692
    invoke-direct {v0, v5}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v5

    add-int/2addr v5, v4

    const/high16 v9, 0x41000000    # 8.0f

    .line 693
    invoke-direct {v0, v9}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v9

    add-int/2addr v5, v9

    const/high16 v9, 0x41f00000    # 30.0f

    .line 694
    invoke-direct {v0, v9}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v9

    const/high16 v10, 0x41b00000    # 22.0f

    .line 695
    invoke-direct {v0, v10}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v10

    const/high16 v11, 0x40c00000    # 6.0f

    .line 696
    invoke-direct {v0, v11}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v11

    sub-int v12, v2, v4

    sub-int v13, v12, v9

    sub-int v14, v13, v11

    sub-int/2addr v14, v10

    sub-int v11, v14, v11

    sub-int/2addr v11, v5

    const/high16 v15, 0x42200000    # 40.0f

    move/from16 p1, v7

    .line 703
    invoke-direct {v0, v15}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v7

    if-ge v11, v7, :cond_60

    invoke-direct {v0, v15}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v11

    :cond_60
    const/high16 v7, 0x42a80000    # 84.0f

    .line 705
    invoke-direct {v0, v7}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v7

    if-le v7, v11, :cond_72

    const/high16 v7, 0x42100000    # 36.0f

    .line 706
    invoke-direct {v0, v7}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v7

    invoke-static {v7, v11}, Ljava/lang/Math;->max(II)I

    move-result v7

    :cond_72
    int-to-float v15, v4

    .line 709
    invoke-static {v15, v6, v8}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lerp(FFF)F

    move-result v16

    int-to-float v3, v5

    .line 710
    invoke-static {v3, v6, v8}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lerp(FFF)F

    move-result v18

    add-int v6, v4, v7

    move/from16 v19, v4

    int-to-float v4, v6

    move/from16 v20, v6

    int-to-float v6, v1

    .line 711
    invoke-static {v4, v6, v8}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lerp(FFF)F

    move-result v4

    add-int/2addr v7, v5

    int-to-float v7, v7

    int-to-float v2, v2

    .line 712
    invoke-static {v7, v2, v8}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lerp(FFF)F

    move-result v7

    move/from16 v21, v1

    const/high16 v1, 0x41200000    # 10.0f

    .line 715
    invoke-direct {v0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v1

    add-int v1, v20, v1

    int-to-float v1, v1

    invoke-static {v1, v15, v8}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lerp(FFF)F

    move-result v17

    .line 716
    invoke-static {v3, v3, v8}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lerp(FFF)F

    move-result v20

    sub-int v1, v21, v19

    int-to-float v1, v1

    .line 717
    invoke-static {v1, v1, v8}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lerp(FFF)F

    move-result v19

    add-int/2addr v5, v11

    int-to-float v3, v5

    int-to-float v5, v12

    .line 718
    invoke-static {v3, v5, v8}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lerp(FFF)F

    move-result v11

    move v3, v1

    .line 720
    iget-object v1, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vCover:Landroid/widget/ImageView;

    move v12, v3

    move v5, v7

    move/from16 v3, v18

    move v7, v2

    move/from16 v2, v16

    invoke-direct/range {v0 .. v5}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->setBounds(Landroid/view/View;FFFF)V

    .line 721
    iget-object v1, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vLyric:Landroid/widget/ListView;

    move v5, v11

    move/from16 v2, v17

    move/from16 v4, v19

    move/from16 v3, v20

    invoke-direct/range {v0 .. v5}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->setBounds(Landroid/view/View;FFFF)V

    .line 722
    iget-object v1, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vScrim:Landroid/view/View;

    const/4 v2, 0x0

    const/4 v3, 0x0

    move v4, v6

    move v5, v7

    invoke-direct/range {v0 .. v5}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->setBounds(Landroid/view/View;FFFF)V

    .line 723
    iget-object v1, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vSeekRow:Landroid/widget/LinearLayout;

    int-to-float v3, v14

    add-int/2addr v14, v10

    int-to-float v5, v14

    move v4, v12

    move v2, v15

    invoke-direct/range {v0 .. v5}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->setBounds(Landroid/view/View;FFFF)V

    .line 724
    iget-object v1, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vBtnRow:Landroid/widget/LinearLayout;

    int-to-float v3, v13

    add-int/2addr v13, v9

    int-to-float v5, v13

    invoke-direct/range {v0 .. v5}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->setBounds(Landroid/view/View;FFFF)V

    sub-float v7, p1, v8

    .line 728
    iget-object v1, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vSeekRow:Landroid/widget/LinearLayout;

    invoke-virtual {v1, v7}, Landroid/widget/LinearLayout;->setAlpha(F)V

    .line 729
    iget-object v1, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vBtnRow:Landroid/widget/LinearLayout;

    invoke-virtual {v1, v7}, Landroid/widget/LinearLayout;->setAlpha(F)V

    .line 735
    iget-object v1, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vScrim:Landroid/view/View;

    iget-boolean v2, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->pureImage:Z

    if-eqz v2, :cond_f8

    const/4 v6, 0x0

    goto :goto_f9

    :cond_f8
    move v6, v8

    :goto_f9
    invoke-virtual {v1, v6}, Landroid/view/View;->setAlpha(F)V

    .line 736
    iget-object v1, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vBtnPage:Landroid/widget/TextView;

    invoke-virtual {v1, v7}, Landroid/widget/TextView;->setAlpha(F)V

    .line 737
    iget-object v1, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vBtnClose:Landroid/widget/TextView;

    invoke-virtual {v1, v7}, Landroid/widget/TextView;->setAlpha(F)V

    .line 738
    iget-object v1, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vBtnBack:Landroid/widget/TextView;

    invoke-virtual {v1, v8}, Landroid/widget/TextView;->setAlpha(F)V

    const v1, 0x3f7ae148    # 0.98f

    cmpl-float v1, v8, v1

    const/4 v2, 0x0

    if-lez v1, :cond_115

    const/4 v1, 0x1

    goto :goto_116

    :cond_115
    move v1, v2

    .line 745
    :goto_116
    iget-object v3, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vSeekRow:Landroid/widget/LinearLayout;

    const/16 v4, 0x8

    if-eqz v1, :cond_11e

    move v5, v4

    goto :goto_11f

    :cond_11e
    move v5, v2

    :goto_11f
    invoke-virtual {v3, v5}, Landroid/widget/LinearLayout;->setVisibility(I)V

    .line 746
    iget-object v3, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vBtnRow:Landroid/widget/LinearLayout;

    if-eqz v1, :cond_128

    move v5, v4

    goto :goto_129

    :cond_128
    move v5, v2

    :goto_129
    invoke-virtual {v3, v5}, Landroid/widget/LinearLayout;->setVisibility(I)V

    .line 747
    iget-object v3, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vBtnPage:Landroid/widget/TextView;

    if-eqz v1, :cond_132

    move v5, v4

    goto :goto_133

    :cond_132
    move v5, v2

    :goto_133
    invoke-virtual {v3, v5}, Landroid/widget/TextView;->setVisibility(I)V

    .line 748
    iget-object v3, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vBtnClose:Landroid/widget/TextView;

    if-eqz v1, :cond_13c

    move v1, v4

    goto :goto_13d

    :cond_13c
    move v1, v2

    :goto_13d
    invoke-virtual {v3, v1}, Landroid/widget/TextView;->setVisibility(I)V

    .line 749
    iget-object v1, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vBtnBack:Landroid/widget/TextView;

    const v3, 0x3ca3d70a    # 0.02f

    cmpl-float v3, v8, v3

    if-lez v3, :cond_14a

    goto :goto_14b

    :cond_14a
    move v2, v4

    :goto_14b
    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setVisibility(I)V
    :try_end_14e
    .catchall {:try_start_2 .. :try_end_14e} :catchall_161

    .line 753
    :try_start_14e
    iget-object v1, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vCover:Landroid/widget/ImageView;

    invoke-virtual {v1}, Landroid/widget/ImageView;->invalidateOutline()V
    :try_end_153
    .catchall {:try_start_14e .. :try_end_153} :catchall_153

    .line 758
    :catchall_153
    :try_start_153
    iget-object v0, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vTitle:Landroid/widget/TextView;

    const v1, -0xa0806

    const/4 v2, -0x1

    invoke-static {v1, v2, v8}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->blend(IIF)I

    move-result v1

    invoke-virtual {v0, v1}, Landroid/widget/TextView;->setTextColor(I)V
    :try_end_160
    .catchall {:try_start_153 .. :try_end_160} :catchall_161

    goto :goto_167

    :catchall_161
    move-exception v0

    .line 760
    const-string v1, "\u3010GmMiniBar\u3011\u6446\u7248\u9762\u5931\u8d25"

    invoke-static {v1, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    :cond_167
    :goto_167
    return-void
.end method

.method private static blend(IIF)I
    .registers 7

    .line 787
    invoke-static {p0}, Landroid/graphics/Color;->alpha(I)I

    move-result v0

    int-to-float v0, v0

    invoke-static {p1}, Landroid/graphics/Color;->alpha(I)I

    move-result v1

    int-to-float v1, v1

    invoke-static {v0, v1, p2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lerp(FFF)F

    move-result v0

    float-to-int v0, v0

    .line 788
    invoke-static {p0}, Landroid/graphics/Color;->red(I)I

    move-result v1

    int-to-float v1, v1

    invoke-static {p1}, Landroid/graphics/Color;->red(I)I

    move-result v2

    int-to-float v2, v2

    invoke-static {v1, v2, p2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lerp(FFF)F

    move-result v1

    float-to-int v1, v1

    .line 789
    invoke-static {p0}, Landroid/graphics/Color;->green(I)I

    move-result v2

    int-to-float v2, v2

    invoke-static {p1}, Landroid/graphics/Color;->green(I)I

    move-result v3

    int-to-float v3, v3

    invoke-static {v2, v3, p2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lerp(FFF)F

    move-result v2

    float-to-int v2, v2

    .line 790
    invoke-static {p0}, Landroid/graphics/Color;->blue(I)I

    move-result p0

    int-to-float p0, p0

    invoke-static {p1}, Landroid/graphics/Color;->blue(I)I

    move-result p1

    int-to-float p1, p1

    invoke-static {p0, p1, p2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lerp(FFF)F

    move-result p0

    float-to-int p0, p0

    .line 791
    invoke-static {v0, v1, v2, p0}, Landroid/graphics/Color;->argb(IIII)I

    move-result p0

    return p0
.end method

.method private boxBtn(Ljava/lang/String;FLjava/lang/String;Ljava/lang/Runnable;)Landroid/widget/TextView;
    .registers 6

    const v0, -0xa0806

    .line 270
    invoke-direct {p0, p1, p2, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->tv(Ljava/lang/String;FI)Landroid/widget/TextView;

    move-result-object p1

    const/16 p2, 0x11

    .line 271
    invoke-virtual {p1, p2}, Landroid/widget/TextView;->setGravity(I)V

    const/4 p2, 0x1

    .line 272
    invoke-virtual {p1, p2}, Landroid/widget/TextView;->setSingleLine(Z)V

    const p2, 0x1fffffff

    const/16 v0, 0x9

    .line 273
    invoke-direct {p0, p2, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->round(II)Landroid/graphics/drawable/GradientDrawable;

    move-result-object p2

    invoke-virtual {p1, p2}, Landroid/widget/TextView;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 274
    new-instance p2, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$1;

    invoke-direct {p2, p0, p3, p4}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$1;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;Ljava/lang/String;Ljava/lang/Runnable;)V

    invoke-virtual {p1, p2}, Landroid/widget/TextView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    return-object p1
.end method

.method private build()V
    .registers 11

    .line 316
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->getContext()Landroid/content/Context;

    move-result-object v0

    const/4 v1, 0x0

    .line 319
    invoke-virtual {p0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->setBackgroundColor(I)V

    const/4 v2, 0x1

    .line 320
    invoke-virtual {p0, v2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->setClipToOutline(Z)V

    .line 322
    :try_start_c
    new-instance v3, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$2;

    invoke-direct {v3, p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$2;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V

    invoke-virtual {p0, v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->setOutlineProvider(Landroid/view/ViewOutlineProvider;)V
    :try_end_14
    .catchall {:try_start_c .. :try_end_14} :catchall_14

    .line 332
    :catchall_14
    invoke-virtual {p0, v2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->setClickable(Z)V

    .line 333
    invoke-virtual {p0, v2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->setFocusable(Z)V

    .line 335
    :try_start_1a
    invoke-virtual {p0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->setFilterTouchesWhenObscured(Z)V
    :try_end_1d
    .catchall {:try_start_1a .. :try_end_1d} :catchall_1d

    .line 353
    :catchall_1d
    new-instance v3, Landroid/view/View;

    invoke-direct {v3, v0}, Landroid/view/View;-><init>(Landroid/content/Context;)V

    iput-object v3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vBgTint:Landroid/view/View;

    .line 354
    new-instance v4, Landroid/graphics/drawable/GradientDrawable;

    sget-object v5, Landroid/graphics/drawable/GradientDrawable$Orientation;->TOP_BOTTOM:Landroid/graphics/drawable/GradientDrawable$Orientation;

    const v6, -0x5f3f1ec

    const v7, -0xde9e5dc

    filled-new-array {v7, v7, v6}, [I

    move-result-object v6

    invoke-direct {v4, v5, v6}, Landroid/graphics/drawable/GradientDrawable;-><init>(Landroid/graphics/drawable/GradientDrawable$Orientation;[I)V

    invoke-virtual {v3, v4}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 356
    iget-object v3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vBgTint:Landroid/view/View;

    new-instance v4, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v5, -0x1

    invoke-direct {v4, v5, v5}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {p0, v3, v4}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 360
    new-instance v3, Landroid/view/View;

    invoke-direct {v3, v0}, Landroid/view/View;-><init>(Landroid/content/Context;)V

    .line 361
    new-instance v4, Landroid/graphics/drawable/GradientDrawable;

    sget-object v6, Landroid/graphics/drawable/GradientDrawable$Orientation;->TOP_BOTTOM:Landroid/graphics/drawable/GradientDrawable$Orientation;

    const v7, 0x26ffffff

    const v8, 0xfffffff

    const v9, 0xffffff

    filled-new-array {v7, v8, v9}, [I

    move-result-object v7

    invoke-direct {v4, v6, v7}, Landroid/graphics/drawable/GradientDrawable;-><init>(Landroid/graphics/drawable/GradientDrawable$Orientation;[I)V

    invoke-virtual {v3, v4}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 363
    new-instance v4, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {v4, v5, v1}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    const/high16 v6, 0x42800000    # 64.0f

    .line 365
    invoke-direct {p0, v6}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v6

    iput v6, v4, Landroid/widget/FrameLayout$LayoutParams;->height:I

    .line 366
    invoke-virtual {p0, v3, v4}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 369
    new-instance v3, Landroid/view/View;

    invoke-direct {v3, v0}, Landroid/view/View;-><init>(Landroid/content/Context;)V

    .line 370
    new-instance v4, Landroid/graphics/drawable/GradientDrawable;

    sget-object v6, Landroid/graphics/drawable/GradientDrawable$Orientation;->BOTTOM_TOP:Landroid/graphics/drawable/GradientDrawable$Orientation;

    const v7, 0x14ffffff

    filled-new-array {v7, v9}, [I

    move-result-object v7

    invoke-direct {v4, v6, v7}, Landroid/graphics/drawable/GradientDrawable;-><init>(Landroid/graphics/drawable/GradientDrawable$Orientation;[I)V

    invoke-virtual {v3, v4}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 372
    new-instance v4, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {v4, v5, v1}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    const/high16 v6, 0x42200000    # 40.0f

    .line 374
    invoke-direct {p0, v6}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v6

    iput v6, v4, Landroid/widget/FrameLayout$LayoutParams;->height:I

    .line 375
    iput v1, v4, Landroid/widget/FrameLayout$LayoutParams;->topMargin:I

    .line 376
    invoke-virtual {p0, v3, v4}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    const/16 v3, 0x50

    .line 378
    iput v3, v4, Landroid/widget/FrameLayout$LayoutParams;->gravity:I

    .line 381
    new-instance v3, Landroid/widget/FrameLayout;

    invoke-direct {v3, v0}, Landroid/widget/FrameLayout;-><init>(Landroid/content/Context;)V

    iput-object v3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->pagePlay:Landroid/widget/FrameLayout;

    .line 382
    invoke-virtual {v3, v1}, Landroid/widget/FrameLayout;->setClipChildren(Z)V

    .line 383
    iget-object v3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->pagePlay:Landroid/widget/FrameLayout;

    new-instance v4, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {v4, v5, v5}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {p0, v3, v4}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 385
    iget-object v3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->pagePlay:Landroid/widget/FrameLayout;

    invoke-direct {p0, v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->buildPlayPage(Landroid/widget/FrameLayout;)V

    .line 388
    new-instance v3, Landroid/widget/FrameLayout;

    invoke-direct {v3, v0}, Landroid/widget/FrameLayout;-><init>(Landroid/content/Context;)V

    iput-object v3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->pageSearch:Landroid/widget/FrameLayout;

    .line 389
    invoke-direct {p0, v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->buildSearchPage(Landroid/widget/FrameLayout;)V

    .line 390
    iget-object v3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->pageSearch:Landroid/widget/FrameLayout;

    const/16 v4, 0x8

    invoke-virtual {v3, v4}, Landroid/widget/FrameLayout;->setVisibility(I)V

    .line 391
    iget-object v3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->pageSearch:Landroid/widget/FrameLayout;

    new-instance v4, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {v4, v5, v5}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {p0, v3, v4}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 395
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->buildTopBar()V

    .line 398
    new-instance v3, Landroid/view/View;

    invoke-direct {v3, v0}, Landroid/view/View;-><init>(Landroid/content/Context;)V

    iput-object v3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vHairline:Landroid/view/View;

    .line 399
    new-instance v0, Landroid/graphics/drawable/GradientDrawable;

    invoke-direct {v0}, Landroid/graphics/drawable/GradientDrawable;-><init>()V

    .line 400
    invoke-virtual {v0, v1}, Landroid/graphics/drawable/GradientDrawable;->setShape(I)V

    .line 401
    invoke-virtual {v0, v1}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V

    const/high16 v3, 0x41800000    # 16.0f

    .line 402
    invoke-direct {p0, v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v3

    int-to-float v3, v3

    invoke-virtual {v0, v3}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V

    const/high16 v3, 0x3f800000    # 1.0f

    .line 403
    invoke-direct {p0, v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v3

    const v4, 0x3dffffff    # 0.12499999f

    invoke-virtual {v0, v3, v4}, Landroid/graphics/drawable/GradientDrawable;->setStroke(II)V

    .line 404
    iget-object v3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vHairline:Landroid/view/View;

    invoke-virtual {v3, v0}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 405
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vHairline:Landroid/view/View;

    invoke-virtual {v0, v1}, Landroid/view/View;->setClickable(Z)V

    .line 406
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vHairline:Landroid/view/View;

    new-instance v3, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {v3, v5, v5}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {p0, v0, v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    :goto_10e
    const/4 v0, 0x4

    if-ge v1, v0, :cond_16c

    .line 411
    sget-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->CORNER_SYM:[I

    aget v0, v0, v1

    int-to-char v0, v0

    invoke-static {v0}, Ljava/lang/String;->valueOf(C)Ljava/lang/String;

    move-result-object v0

    const/high16 v3, 0x41100000    # 9.0f

    const v4, 0x66ffffff

    invoke-direct {p0, v0, v3, v4}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->tv(Ljava/lang/String;FI)Landroid/widget/TextView;

    move-result-object v0

    const/16 v3, 0x11

    .line 412
    invoke-virtual {v0, v3}, Landroid/widget/TextView;->setGravity(I)V

    add-int/lit16 v3, v1, 0x3e8

    .line 413
    invoke-static {v3}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v3

    invoke-virtual {v0, v3}, Landroid/widget/TextView;->setTag(Ljava/lang/Object;)V

    .line 414
    new-instance v3, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Resize;

    invoke-direct {v3, p0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$Resize;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;I)V

    invoke-virtual {v0, v3}, Landroid/widget/TextView;->setOnTouchListener(Landroid/view/View$OnTouchListener;)V

    .line 415
    new-instance v3, Landroid/widget/FrameLayout$LayoutParams;

    const/high16 v4, 0x41d00000    # 26.0f

    invoke-direct {p0, v4}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v5

    invoke-direct {p0, v4}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v4

    invoke-direct {v3, v5, v4}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    if-eqz v1, :cond_161

    if-eq v1, v2, :cond_15b

    const/4 v4, 0x2

    if-eq v1, v4, :cond_155

    const v4, 0x800055

    .line 420
    iput v4, v3, Landroid/widget/FrameLayout$LayoutParams;->gravity:I

    goto :goto_166

    :cond_155
    const v4, 0x800053

    .line 419
    iput v4, v3, Landroid/widget/FrameLayout$LayoutParams;->gravity:I

    goto :goto_166

    :cond_15b
    const v4, 0x800035

    .line 418
    iput v4, v3, Landroid/widget/FrameLayout$LayoutParams;->gravity:I

    goto :goto_166

    :cond_161
    const v4, 0x800033

    .line 417
    iput v4, v3, Landroid/widget/FrameLayout$LayoutParams;->gravity:I

    .line 422
    :goto_166
    invoke-virtual {p0, v0, v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    add-int/lit8 v1, v1, 0x1

    goto :goto_10e

    .line 425
    :cond_16c
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->installGestures()V

    return-void
.end method

.method private buildPlayPage(Landroid/widget/FrameLayout;)V
    .registers 19

    move-object/from16 v0, p0

    move-object/from16 v1, p1

    .line 491
    invoke-virtual {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->getContext()Landroid/content/Context;

    move-result-object v2

    .line 494
    new-instance v3, Landroid/widget/ImageView;

    invoke-direct {v3, v2}, Landroid/widget/ImageView;-><init>(Landroid/content/Context;)V

    iput-object v3, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vCover:Landroid/widget/ImageView;

    .line 495
    sget-object v4, Landroid/widget/ImageView$ScaleType;->CENTER_CROP:Landroid/widget/ImageView$ScaleType;

    invoke-virtual {v3, v4}, Landroid/widget/ImageView;->setScaleType(Landroid/widget/ImageView$ScaleType;)V

    .line 496
    iget-object v3, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vCover:Landroid/widget/ImageView;

    const v4, 0x14ffffff

    invoke-virtual {v3, v4}, Landroid/widget/ImageView;->setBackgroundColor(I)V

    .line 497
    iget-object v3, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vCover:Landroid/widget/ImageView;

    const/4 v4, 0x1

    invoke-virtual {v3, v4}, Landroid/widget/ImageView;->setClipToOutline(Z)V

    .line 499
    :try_start_22
    iget-object v3, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vCover:Landroid/widget/ImageView;

    new-instance v5, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$6;

    invoke-direct {v5, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$6;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V

    invoke-virtual {v3, v5}, Landroid/widget/ImageView;->setOutlineProvider(Landroid/view/ViewOutlineProvider;)V
    :try_end_2c
    .catchall {:try_start_22 .. :try_end_2c} :catchall_2c

    .line 508
    :catchall_2c
    iget-object v3, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vCover:Landroid/widget/ImageView;

    new-instance v5, Landroid/widget/FrameLayout$LayoutParams;

    const/high16 v6, 0x42a80000    # 84.0f

    invoke-direct {v0, v6}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v7

    invoke-direct {v0, v6}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v6

    invoke-direct {v5, v7, v6}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v1, v3, v5}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 511
    new-instance v3, Landroid/view/View;

    invoke-direct {v3, v2}, Landroid/view/View;-><init>(Landroid/content/Context;)V

    iput-object v3, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vScrim:Landroid/view/View;

    .line 512
    invoke-direct {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->scrimDrawable()Landroid/graphics/drawable/Drawable;

    move-result-object v5

    invoke-virtual {v3, v5}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 513
    iget-object v3, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vScrim:Landroid/view/View;

    const/4 v5, 0x0

    invoke-virtual {v3, v5}, Landroid/view/View;->setAlpha(F)V

    .line 514
    iget-object v3, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vScrim:Landroid/view/View;

    new-instance v6, Landroid/widget/FrameLayout$LayoutParams;

    const/4 v7, -0x1

    invoke-direct {v6, v7, v7}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v1, v3, v6}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 518
    new-instance v3, Landroid/widget/ListView;

    invoke-direct {v3, v2}, Landroid/widget/ListView;-><init>(Landroid/content/Context;)V

    iput-object v3, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vLyric:Landroid/widget/ListView;

    const/4 v6, 0x0

    .line 519
    invoke-virtual {v3, v6}, Landroid/widget/ListView;->setDivider(Landroid/graphics/drawable/Drawable;)V

    .line 520
    iget-object v3, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vLyric:Landroid/widget/ListView;

    const/4 v8, 0x0

    invoke-virtual {v3, v8}, Landroid/widget/ListView;->setDividerHeight(I)V

    .line 522
    :try_start_70
    iget-object v3, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vLyric:Landroid/widget/ListView;

    new-instance v9, Landroid/graphics/drawable/ColorDrawable;

    invoke-direct {v9, v8}, Landroid/graphics/drawable/ColorDrawable;-><init>(I)V

    invoke-virtual {v3, v9}, Landroid/widget/ListView;->setSelector(Landroid/graphics/drawable/Drawable;)V
    :try_end_7a
    .catchall {:try_start_70 .. :try_end_7a} :catchall_7a

    .line 525
    :catchall_7a
    iget-object v3, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vLyric:Landroid/widget/ListView;

    invoke-virtual {v3, v8}, Landroid/widget/ListView;->setVerticalScrollBarEnabled(Z)V

    .line 526
    iget-object v3, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vLyric:Landroid/widget/ListView;

    invoke-virtual {v3, v8}, Landroid/widget/ListView;->setCacheColorHint(I)V

    .line 527
    iget-object v3, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vLyric:Landroid/widget/ListView;

    invoke-virtual {v3, v8}, Landroid/widget/ListView;->setBackgroundColor(I)V

    .line 528
    iget-object v3, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vLyric:Landroid/widget/ListView;

    const/4 v9, 0x2

    invoke-virtual {v3, v9}, Landroid/widget/ListView;->setOverScrollMode(I)V

    .line 529
    iget-object v3, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vLyric:Landroid/widget/ListView;

    invoke-virtual {v3, v8}, Landroid/widget/ListView;->setItemsCanFocus(Z)V

    .line 530
    iget-object v3, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vLyric:Landroid/widget/ListView;

    invoke-virtual {v3, v8}, Landroid/widget/ListView;->setClipToPadding(Z)V

    .line 531
    iget-object v3, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vLyric:Landroid/widget/ListView;

    const/high16 v10, 0x40000000    # 2.0f

    invoke-direct {v0, v10}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v11

    invoke-direct {v0, v10}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v10

    invoke-virtual {v3, v11, v8, v10, v8}, Landroid/widget/ListView;->setPadding(IIII)V

    .line 532
    new-instance v3, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$LyricAdapter;

    invoke-direct {v3, v0, v6}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$LyricAdapter;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$1;)V

    iput-object v3, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vLrcAdapter:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$LyricAdapter;

    .line 533
    iget-object v6, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vLyric:Landroid/widget/ListView;

    invoke-virtual {v6, v3}, Landroid/widget/ListView;->setAdapter(Landroid/widget/ListAdapter;)V

    .line 534
    iget-object v3, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vLyric:Landroid/widget/ListView;

    new-instance v6, Landroid/widget/FrameLayout$LayoutParams;

    const/high16 v10, 0x42c80000    # 100.0f

    invoke-direct {v0, v10}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v10

    const/high16 v11, 0x42200000    # 40.0f

    invoke-direct {v0, v11}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v12

    invoke-direct {v6, v10, v12}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v1, v3, v6}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 537
    new-instance v3, Landroid/widget/LinearLayout;

    invoke-direct {v3, v2}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    iput-object v3, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vSeekRow:Landroid/widget/LinearLayout;

    .line 538
    invoke-virtual {v3, v8}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 539
    iget-object v3, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vSeekRow:Landroid/widget/LinearLayout;

    const/16 v6, 0x10

    invoke-virtual {v3, v6}, Landroid/widget/LinearLayout;->setGravity(I)V

    .line 541
    const-string v3, "0:00"

    const/high16 v10, 0x41200000    # 10.0f

    const v12, -0x610a0806

    invoke-direct {v0, v3, v10, v12}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->tv(Ljava/lang/String;FI)Landroid/widget/TextView;

    move-result-object v13

    iput-object v13, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vPos:Landroid/widget/TextView;

    const/16 v14, 0x11

    .line 542
    invoke-virtual {v13, v14}, Landroid/widget/TextView;->setGravity(I)V

    .line 543
    iget-object v13, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vPos:Landroid/widget/TextView;

    invoke-virtual {v13, v4}, Landroid/widget/TextView;->setSingleLine(Z)V

    const/high16 v13, -0x67000000

    const/high16 v15, 0x40400000    # 3.0f

    move/from16 v16, v9

    const/high16 v9, 0x3f800000    # 1.0f

    .line 545
    :try_start_fa
    iget-object v6, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vPos:Landroid/widget/TextView;

    invoke-virtual {v6, v15, v5, v9, v13}, Landroid/widget/TextView;->setShadowLayer(FFFI)V
    :try_end_ff
    .catchall {:try_start_fa .. :try_end_ff} :catchall_ff

    .line 548
    :catchall_ff
    iget-object v6, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vSeekRow:Landroid/widget/LinearLayout;

    iget-object v5, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vPos:Landroid/widget/TextView;

    new-instance v13, Landroid/widget/LinearLayout$LayoutParams;

    invoke-direct {v0, v11}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v15

    invoke-direct {v13, v15, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v6, v5, v13}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 551
    new-instance v5, Landroid/widget/SeekBar;

    invoke-direct {v5, v2}, Landroid/widget/SeekBar;-><init>(Landroid/content/Context;)V

    iput-object v5, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vSeek:Landroid/widget/SeekBar;

    const/16 v6, 0x3e8

    .line 552
    invoke-virtual {v5, v6}, Landroid/widget/SeekBar;->setMax(I)V

    .line 553
    iget-object v5, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vSeek:Landroid/widget/SeekBar;

    const/high16 v6, 0x40c00000    # 6.0f

    invoke-direct {v0, v6}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v13

    invoke-direct {v0, v6}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v15

    invoke-virtual {v5, v13, v8, v15, v8}, Landroid/widget/SeekBar;->setPadding(IIII)V

    .line 554
    iget-object v5, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vSeek:Landroid/widget/SeekBar;

    invoke-virtual {v5, v8}, Landroid/widget/SeekBar;->setMinimumHeight(I)V

    .line 556
    :try_start_12f
    iget-object v5, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vSeek:Landroid/widget/SeekBar;

    invoke-direct {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->thumbDrawable()Landroid/graphics/drawable/Drawable;

    move-result-object v13

    invoke-virtual {v5, v13}, Landroid/widget/SeekBar;->setThumb(Landroid/graphics/drawable/Drawable;)V

    .line 557
    iget-object v5, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vSeek:Landroid/widget/SeekBar;

    invoke-virtual {v5, v8}, Landroid/widget/SeekBar;->setThumbOffset(I)V

    .line 558
    iget-object v5, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vSeek:Landroid/widget/SeekBar;

    invoke-virtual {v5, v8}, Landroid/widget/SeekBar;->setSplitTrack(Z)V

    .line 559
    iget-object v5, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vSeek:Landroid/widget/SeekBar;

    const v13, -0xf57b01

    invoke-static {v13}, Landroid/content/res/ColorStateList;->valueOf(I)Landroid/content/res/ColorStateList;

    move-result-object v13

    invoke-virtual {v5, v13}, Landroid/widget/SeekBar;->setProgressTintList(Landroid/content/res/ColorStateList;)V

    .line 560
    iget-object v5, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vSeek:Landroid/widget/SeekBar;

    const v13, 0x38ffffff

    .line 561
    invoke-static {v13}, Landroid/content/res/ColorStateList;->valueOf(I)Landroid/content/res/ColorStateList;

    move-result-object v13

    .line 560
    invoke-virtual {v5, v13}, Landroid/widget/SeekBar;->setProgressBackgroundTintList(Landroid/content/res/ColorStateList;)V
    :try_end_15a
    .catchall {:try_start_12f .. :try_end_15a} :catchall_15a

    .line 564
    :catchall_15a
    iget-object v5, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vSeek:Landroid/widget/SeekBar;

    new-instance v13, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$7;

    invoke-direct {v13, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$7;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V

    invoke-virtual {v5, v13}, Landroid/widget/SeekBar;->setOnSeekBarChangeListener(Landroid/widget/SeekBar$OnSeekBarChangeListener;)V

    .line 583
    iget-object v5, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vSeekRow:Landroid/widget/LinearLayout;

    iget-object v13, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vSeek:Landroid/widget/SeekBar;

    new-instance v15, Landroid/widget/LinearLayout$LayoutParams;

    invoke-direct {v15, v8, v7, v9}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v5, v13, v15}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 586
    invoke-direct {v0, v3, v10, v12}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->tv(Ljava/lang/String;FI)Landroid/widget/TextView;

    move-result-object v3

    iput-object v3, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vDur:Landroid/widget/TextView;

    .line 587
    invoke-virtual {v3, v14}, Landroid/widget/TextView;->setGravity(I)V

    .line 588
    iget-object v3, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vDur:Landroid/widget/TextView;

    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setSingleLine(Z)V

    .line 590
    :try_start_17e
    iget-object v3, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vDur:Landroid/widget/TextView;

    const/high16 v5, -0x67000000

    const/high16 v10, 0x40400000    # 3.0f

    const/4 v12, 0x0

    invoke-virtual {v3, v10, v12, v9, v5}, Landroid/widget/TextView;->setShadowLayer(FFFI)V
    :try_end_188
    .catchall {:try_start_17e .. :try_end_188} :catchall_188

    .line 593
    :catchall_188
    iget-object v3, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vSeekRow:Landroid/widget/LinearLayout;

    iget-object v5, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vDur:Landroid/widget/TextView;

    new-instance v9, Landroid/widget/LinearLayout$LayoutParams;

    invoke-direct {v0, v11}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v10

    invoke-direct {v9, v10, v7}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v3, v5, v9}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 596
    iget-object v3, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vSeekRow:Landroid/widget/LinearLayout;

    new-instance v5, Landroid/widget/FrameLayout$LayoutParams;

    const/high16 v9, 0x41b00000    # 22.0f

    .line 597
    invoke-direct {v0, v9}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v9

    invoke-direct {v5, v7, v9}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    .line 596
    invoke-virtual {v1, v3, v5}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 600
    new-instance v3, Landroid/widget/LinearLayout;

    invoke-direct {v3, v2}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    iput-object v3, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vBtnRow:Landroid/widget/LinearLayout;

    .line 601
    invoke-virtual {v3, v8}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 602
    iget-object v3, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vBtnRow:Landroid/widget/LinearLayout;

    invoke-virtual {v3, v14}, Landroid/widget/LinearLayout;->setGravity(I)V

    .line 604
    new-instance v3, Landroid/widget/LinearLayout;

    invoke-direct {v3, v2}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    .line 605
    invoke-virtual {v3, v8}, Landroid/widget/LinearLayout;->setOrientation(I)V

    const/16 v2, 0x10

    .line 606
    invoke-virtual {v3, v2}, Landroid/widget/LinearLayout;->setGravity(I)V

    .line 608
    new-instance v2, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$8;

    invoke-direct {v2, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$8;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V

    const-string v5, "\u25c0\u25c0"

    const/high16 v9, 0x41300000    # 11.0f

    const-string v10, "\u4e0a\u4e00\u9996"

    invoke-direct {v0, v5, v9, v10, v2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->boxBtn(Ljava/lang/String;FLjava/lang/String;Ljava/lang/Runnable;)Landroid/widget/TextView;

    move-result-object v2

    iput-object v2, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vBtnPrev:Landroid/widget/TextView;

    .line 615
    new-instance v2, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$9;

    invoke-direct {v2, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$9;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V

    const-string v5, "\u25b6"

    const/high16 v10, 0x41600000    # 14.0f

    const-string v11, "\u64ad\u653e/\u6682\u505c"

    invoke-direct {v0, v5, v10, v11, v2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->boxBtn(Ljava/lang/String;FLjava/lang/String;Ljava/lang/Runnable;)Landroid/widget/TextView;

    move-result-object v2

    iput-object v2, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vBtnPlay:Landroid/widget/TextView;

    const v5, 0x33ffffff

    const/16 v10, 0x9

    .line 622
    invoke-direct {v0, v5, v10}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->round(II)Landroid/graphics/drawable/GradientDrawable;

    move-result-object v5

    invoke-virtual {v2, v5}, Landroid/widget/TextView;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 623
    new-instance v2, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$10;

    invoke-direct {v2, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$10;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V

    const-string v5, "\u25b6\u25b6"

    const-string v10, "\u4e0b\u4e00\u9996"

    invoke-direct {v0, v5, v9, v10, v2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->boxBtn(Ljava/lang/String;FLjava/lang/String;Ljava/lang/Runnable;)Landroid/widget/TextView;

    move-result-object v2

    iput-object v2, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vBtnNext:Landroid/widget/TextView;

    .line 630
    new-instance v2, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$11;

    invoke-direct {v2, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$11;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V

    const-string v5, "\u21bb"

    const/high16 v9, 0x41400000    # 12.0f

    const-string v10, "\u5faa\u73af"

    invoke-direct {v0, v5, v9, v10, v2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->boxBtn(Ljava/lang/String;FLjava/lang/String;Ljava/lang/Runnable;)Landroid/widget/TextView;

    move-result-object v2

    iput-object v2, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vBtnLoop:Landroid/widget/TextView;

    .line 639
    new-instance v2, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$12;

    invoke-direct {v2, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$12;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V

    const-string v5, "\u21c4"

    const/high16 v9, 0x41500000    # 13.0f

    const-string v10, "\u968f\u673a"

    invoke-direct {v0, v5, v9, v10, v2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->boxBtn(Ljava/lang/String;FLjava/lang/String;Ljava/lang/Runnable;)Landroid/widget/TextView;

    move-result-object v2

    iput-object v2, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vBtnShuffle:Landroid/widget/TextView;

    const/4 v5, 0x5

    .line 649
    new-array v9, v5, [Landroid/widget/TextView;

    iget-object v10, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vBtnPrev:Landroid/widget/TextView;

    aput-object v10, v9, v8

    iget-object v10, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vBtnPlay:Landroid/widget/TextView;

    aput-object v10, v9, v4

    iget-object v4, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vBtnNext:Landroid/widget/TextView;

    aput-object v4, v9, v16

    const/4 v4, 0x3

    iget-object v10, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vBtnLoop:Landroid/widget/TextView;

    aput-object v10, v9, v4

    const/4 v4, 0x4

    aput-object v2, v9, v4

    :goto_23a
    const/high16 v2, 0x41f00000    # 30.0f

    if-ge v8, v5, :cond_260

    .line 651
    new-instance v4, Landroid/widget/LinearLayout$LayoutParams;

    sget-object v10, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->BTN_W:[I

    aget v10, v10, v8

    int-to-float v10, v10

    invoke-direct {v0, v10}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v10

    invoke-direct {v0, v2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v2

    invoke-direct {v4, v10, v2}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    if-lez v8, :cond_258

    .line 652
    invoke-direct {v0, v6}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v2

    iput v2, v4, Landroid/widget/LinearLayout$LayoutParams;->leftMargin:I

    .line 653
    :cond_258
    aget-object v2, v9, v8

    invoke-virtual {v3, v2, v4}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    add-int/lit8 v8, v8, 0x1

    goto :goto_23a

    .line 656
    :cond_260
    iget-object v4, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vBtnRow:Landroid/widget/LinearLayout;

    new-instance v5, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v6, -0x2

    .line 657
    invoke-direct {v0, v2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v8

    invoke-direct {v5, v6, v8}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    .line 656
    invoke-virtual {v4, v3, v5}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 658
    iget-object v3, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vBtnRow:Landroid/widget/LinearLayout;

    new-instance v4, Landroid/widget/FrameLayout$LayoutParams;

    .line 659
    invoke-direct {v0, v2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v2

    invoke-direct {v4, v7, v2}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    .line 658
    invoke-virtual {v1, v3, v4}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 661
    const-string v1, "\u2014\u2014"

    invoke-direct {v0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->setLyricHint(Ljava/lang/String;)V

    return-void
.end method

.method private buildSearchPage(Landroid/widget/FrameLayout;)V
    .registers 18

    move-object/from16 v0, p0

    .line 1228
    invoke-virtual {v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->getContext()Landroid/content/Context;

    move-result-object v1

    const/high16 v2, 0x41200000    # 10.0f

    .line 1229
    invoke-direct {v0, v2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v3

    .line 1231
    new-instance v4, Landroid/widget/LinearLayout;

    invoke-direct {v4, v1}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v5, 0x1

    .line 1232
    invoke-virtual {v4, v5}, Landroid/widget/LinearLayout;->setOrientation(I)V

    const/high16 v6, 0x41e00000    # 28.0f

    .line 1233
    invoke-direct {v0, v6}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v6

    add-int/2addr v6, v3

    const/high16 v7, 0x41000000    # 8.0f

    invoke-direct {v0, v7}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v8

    add-int/2addr v6, v8

    invoke-virtual {v4, v3, v6, v3, v3}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    .line 1235
    new-instance v3, Landroid/widget/LinearLayout;

    invoke-direct {v3, v1}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v6, 0x0

    .line 1236
    invoke-virtual {v3, v6}, Landroid/widget/LinearLayout;->setOrientation(I)V

    const/16 v8, 0x10

    .line 1237
    invoke-virtual {v3, v8}, Landroid/widget/LinearLayout;->setGravity(I)V

    .line 1239
    new-instance v9, Landroid/widget/EditText;

    invoke-direct {v9, v1}, Landroid/widget/EditText;-><init>(Landroid/content/Context;)V

    iput-object v9, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vKw:Landroid/widget/EditText;

    .line 1240
    const-string v10, "\u641c\u6b4c / \u6b4c\u624b"

    invoke-virtual {v9, v10}, Landroid/widget/EditText;->setHint(Ljava/lang/CharSequence;)V

    .line 1241
    iget-object v9, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vKw:Landroid/widget/EditText;

    const v10, -0x610a0806

    invoke-virtual {v9, v10}, Landroid/widget/EditText;->setHintTextColor(I)V

    .line 1242
    iget-object v9, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vKw:Landroid/widget/EditText;

    const v11, -0xa0806

    invoke-virtual {v9, v11}, Landroid/widget/EditText;->setTextColor(I)V

    .line 1243
    iget-object v9, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vKw:Landroid/widget/EditText;

    const/4 v11, 0x2

    const/high16 v12, 0x41300000    # 11.0f

    invoke-virtual {v9, v11, v12}, Landroid/widget/EditText;->setTextSize(IF)V

    .line 1244
    iget-object v9, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vKw:Landroid/widget/EditText;

    invoke-virtual {v9, v5}, Landroid/widget/EditText;->setSingleLine(Z)V

    .line 1245
    iget-object v9, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vKw:Landroid/widget/EditText;

    const v11, 0x1fffffff

    const/16 v13, 0xc

    invoke-direct {v0, v11, v13}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->round(II)Landroid/graphics/drawable/GradientDrawable;

    move-result-object v14

    invoke-virtual {v9, v14}, Landroid/widget/EditText;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 1246
    iget-object v9, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vKw:Landroid/widget/EditText;

    invoke-direct {v0, v7}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v14

    const/high16 v15, 0x40c00000    # 6.0f

    invoke-direct {v0, v15}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v5

    invoke-direct {v0, v7}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v7

    invoke-direct {v0, v15}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v11

    invoke-virtual {v9, v14, v5, v7, v11}, Landroid/widget/EditText;->setPadding(IIII)V

    .line 1247
    iget-object v5, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vKw:Landroid/widget/EditText;

    const/4 v7, 0x3

    invoke-virtual {v5, v7}, Landroid/widget/EditText;->setImeOptions(I)V

    .line 1248
    iget-object v5, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vKw:Landroid/widget/EditText;

    new-instance v7, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$22;

    invoke-direct {v7, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$22;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V

    invoke-virtual {v5, v7}, Landroid/widget/EditText;->setOnEditorActionListener(Landroid/widget/TextView$OnEditorActionListener;)V

    .line 1255
    iget-object v5, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vKw:Landroid/widget/EditText;

    new-instance v7, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$23;

    invoke-direct {v7, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$23;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V

    invoke-virtual {v5, v7}, Landroid/widget/EditText;->setOnTouchListener(Landroid/view/View$OnTouchListener;)V

    .line 1265
    iget-object v5, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vKw:Landroid/widget/EditText;

    new-instance v7, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v9, -0x2

    const/high16 v11, 0x3f800000    # 1.0f

    invoke-direct {v7, v6, v9, v11}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v3, v5, v7}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 1268
    new-instance v5, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$24;

    invoke-direct {v5, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$24;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V

    const-string v7, "\u641c"

    const/high16 v14, 0x41400000    # 12.0f

    const-string v15, "\u641c\u7d22"

    invoke-direct {v0, v7, v14, v15, v5}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->boxBtn(Ljava/lang/String;FLjava/lang/String;Ljava/lang/Runnable;)Landroid/widget/TextView;

    move-result-object v5

    const/16 v7, 0x22

    .line 1273
    invoke-direct {v0, v7}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lpDp(I)Landroid/widget/LinearLayout$LayoutParams;

    move-result-object v7

    .line 1268
    invoke-virtual {v3, v5, v7}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 1275
    new-instance v5, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$25;

    invoke-direct {v5, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$25;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V

    const-string v7, "\u2715"

    const-string v14, "\u56de\u64ad\u653e\u9875"

    invoke-direct {v0, v7, v12, v14, v5}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->boxBtn(Ljava/lang/String;FLjava/lang/String;Ljava/lang/Runnable;)Landroid/widget/TextView;

    move-result-object v5

    const/16 v7, 0x1e

    .line 1280
    invoke-direct {v0, v7}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lpDp(I)Landroid/widget/LinearLayout$LayoutParams;

    move-result-object v7

    .line 1275
    invoke-virtual {v3, v5, v7}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 1281
    invoke-virtual {v4, v3}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 1283
    new-instance v3, Landroid/widget/LinearLayout;

    invoke-direct {v3, v1}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    .line 1284
    invoke-virtual {v3, v6}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 1285
    invoke-virtual {v3, v8}, Landroid/widget/LinearLayout;->setGravity(I)V

    .line 1286
    const-string v5, "\u641c\u7d22\u7ed3\u679c"

    invoke-direct {v0, v5, v2, v10}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->tv(Ljava/lang/String;FI)Landroid/widget/TextView;

    move-result-object v5

    iput-object v5, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vListTitle:Landroid/widget/TextView;

    .line 1287
    new-instance v7, Landroid/widget/LinearLayout$LayoutParams;

    invoke-direct {v7, v6, v9, v11}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    invoke-virtual {v3, v5, v7}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 1292
    new-instance v5, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$26;

    invoke-direct {v5, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$26;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V

    const-string v7, "\u21c4 \u961f\u5217"

    const-string v8, "\u5207\u6362 \u641c\u7d22\u7ed3\u679c/\u961f\u5217"

    invoke-direct {v0, v7, v2, v8, v5}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->boxBtn(Ljava/lang/String;FLjava/lang/String;Ljava/lang/Runnable;)Landroid/widget/TextView;

    move-result-object v2

    iput-object v2, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vListSwitch:Landroid/widget/TextView;

    .line 1299
    invoke-virtual {v3, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 1300
    new-instance v2, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v5, -0x1

    invoke-direct {v2, v5, v9}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    const/high16 v7, 0x40800000    # 4.0f

    .line 1302
    invoke-direct {v0, v7}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v8

    iput v8, v2, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    .line 1303
    invoke-virtual {v4, v3, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 1305
    new-instance v2, Landroid/widget/FrameLayout;

    invoke-direct {v2, v1}, Landroid/widget/FrameLayout;-><init>(Landroid/content/Context;)V

    const v3, 0x1fffffff

    .line 1306
    invoke-direct {v0, v3, v13}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->round(II)Landroid/graphics/drawable/GradientDrawable;

    move-result-object v3

    invoke-virtual {v2, v3}, Landroid/widget/FrameLayout;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 1307
    new-instance v3, Landroid/widget/ScrollView;

    invoke-direct {v3, v1}, Landroid/widget/ScrollView;-><init>(Landroid/content/Context;)V

    iput-object v3, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vListScroll:Landroid/widget/ScrollView;

    .line 1308
    new-instance v3, Landroid/widget/LinearLayout;

    invoke-direct {v3, v1}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    iput-object v3, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vListBox:Landroid/widget/LinearLayout;

    const/4 v1, 0x1

    .line 1309
    invoke-virtual {v3, v1}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 1310
    iget-object v1, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vListBox:Landroid/widget/LinearLayout;

    const/high16 v3, 0x40c00000    # 6.0f

    invoke-direct {v0, v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v8

    invoke-direct {v0, v7}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v9

    invoke-direct {v0, v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v3

    invoke-direct {v0, v7}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v10

    invoke-virtual {v1, v8, v9, v3, v10}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    .line 1311
    iget-object v1, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vListScroll:Landroid/widget/ScrollView;

    iget-object v3, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vListBox:Landroid/widget/LinearLayout;

    invoke-virtual {v1, v3}, Landroid/widget/ScrollView;->addView(Landroid/view/View;)V

    .line 1312
    iget-object v1, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vListScroll:Landroid/widget/ScrollView;

    new-instance v3, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {v3, v5, v5}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v2, v1, v3}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 1314
    new-instance v1, Landroid/widget/LinearLayout$LayoutParams;

    invoke-direct {v1, v5, v6, v11}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    .line 1316
    invoke-direct {v0, v7}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v0

    iput v0, v1, Landroid/widget/LinearLayout$LayoutParams;->topMargin:I

    .line 1317
    invoke-virtual {v4, v2, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 1319
    new-instance v0, Landroid/widget/FrameLayout$LayoutParams;

    invoke-direct {v0, v5, v5}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    move-object/from16 v1, p1

    invoke-virtual {v1, v4, v0}, Landroid/widget/FrameLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    return-void
.end method

.method private buildTopBar()V
    .registers 10

    .line 431
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->getContext()Landroid/content/Context;

    move-result-object v0

    .line 432
    new-instance v1, Landroid/widget/LinearLayout;

    invoke-direct {v1, v0}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    iput-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vTopBar:Landroid/widget/LinearLayout;

    const/4 v0, 0x0

    .line 433
    invoke-virtual {v1, v0}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 434
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vTopBar:Landroid/widget/LinearLayout;

    const/16 v2, 0x10

    invoke-virtual {v1, v2}, Landroid/widget/LinearLayout;->setGravity(I)V

    .line 435
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vTopBar:Landroid/widget/LinearLayout;

    const/high16 v3, 0x41200000    # 10.0f

    invoke-direct {p0, v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v4

    invoke-direct {p0, v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v5

    invoke-virtual {v1, v4, v0, v5, v0}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    .line 437
    new-instance v1, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$3;

    invoke-direct {v1, p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$3;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V

    const-string v4, "\u266a"

    const/high16 v5, 0x41500000    # 13.0f

    const-string v6, "\u5207\u5230\u641c\u7d22\u9875"

    invoke-direct {p0, v4, v5, v6, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->boxBtn(Ljava/lang/String;FLjava/lang/String;Ljava/lang/Runnable;)Landroid/widget/TextView;

    move-result-object v1

    iput-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vBtnPage:Landroid/widget/TextView;

    const v4, -0xb05701

    .line 443
    invoke-virtual {v1, v4}, Landroid/widget/TextView;->setTextColor(I)V

    .line 444
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vTopBar:Landroid/widget/LinearLayout;

    iget-object v4, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vBtnPage:Landroid/widget/TextView;

    const/16 v6, 0x1c

    invoke-direct {p0, v6, v6}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lp(II)Landroid/widget/FrameLayout$LayoutParams;

    move-result-object v7

    invoke-virtual {v1, v4, v7}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 446
    new-instance v1, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$4;

    invoke-direct {v1, p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$4;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V

    const-string v4, "\u2039"

    const/high16 v7, 0x41a00000    # 20.0f

    const-string v8, "\u9000\u51fa\u805a\u7126"

    invoke-direct {p0, v4, v7, v8, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->boxBtn(Ljava/lang/String;FLjava/lang/String;Ljava/lang/Runnable;)Landroid/widget/TextView;

    move-result-object v1

    iput-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vBtnBack:Landroid/widget/TextView;

    const/16 v4, 0x8

    .line 452
    invoke-virtual {v1, v4}, Landroid/widget/TextView;->setVisibility(I)V

    .line 453
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vTopBar:Landroid/widget/LinearLayout;

    iget-object v4, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vBtnBack:Landroid/widget/TextView;

    invoke-direct {p0, v6, v6}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lp(II)Landroid/widget/FrameLayout$LayoutParams;

    move-result-object v7

    invoke-virtual {v1, v4, v7}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 455
    const-string v1, "\u8fd8\u6ca1\u6709\u6b4c \u2014\u2014 \u70b9 \u266a \u641c\u4e00\u9996"

    const v4, -0xa0806

    invoke-direct {p0, v1, v5, v4}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->tv(Ljava/lang/String;FI)Landroid/widget/TextView;

    move-result-object v1

    iput-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vTitle:Landroid/widget/TextView;

    const/4 v4, 0x1

    .line 456
    invoke-virtual {v1, v4}, Landroid/widget/TextView;->setSingleLine(Z)V

    .line 457
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vTitle:Landroid/widget/TextView;

    sget-object v4, Landroid/text/TextUtils$TruncateAt;->END:Landroid/text/TextUtils$TruncateAt;

    invoke-virtual {v1, v4}, Landroid/widget/TextView;->setEllipsize(Landroid/text/TextUtils$TruncateAt;)V

    .line 458
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vTitle:Landroid/widget/TextView;

    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setGravity(I)V

    .line 460
    :try_start_85
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vTitle:Landroid/widget/TextView;

    sget-object v2, Landroid/graphics/Typeface;->DEFAULT_BOLD:Landroid/graphics/Typeface;

    invoke-virtual {v1, v2}, Landroid/widget/TextView;->setTypeface(Landroid/graphics/Typeface;)V
    :try_end_8c
    .catchall {:try_start_85 .. :try_end_8c} :catchall_8c

    :catchall_8c
    const/high16 v1, 0x3f800000    # 1.0f

    .line 465
    :try_start_8e
    iget-object v2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vTitle:Landroid/widget/TextView;

    const/4 v4, 0x0

    const/high16 v5, -0x67000000

    const/high16 v7, 0x40800000    # 4.0f

    invoke-virtual {v2, v7, v4, v1, v5}, Landroid/widget/TextView;->setShadowLayer(FFFI)V
    :try_end_98
    .catchall {:try_start_8e .. :try_end_98} :catchall_98

    .line 468
    :catchall_98
    new-instance v2, Landroid/widget/LinearLayout$LayoutParams;

    const/4 v4, -0x1

    invoke-direct {v2, v0, v4, v1}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    const/high16 v0, 0x40c00000    # 6.0f

    .line 470
    invoke-direct {p0, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v1

    iput v1, v2, Landroid/widget/LinearLayout$LayoutParams;->leftMargin:I

    .line 471
    invoke-direct {p0, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v0

    iput v0, v2, Landroid/widget/LinearLayout$LayoutParams;->rightMargin:I

    .line 472
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vTopBar:Landroid/widget/LinearLayout;

    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vTitle:Landroid/widget/TextView;

    invoke-virtual {v0, v1, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 474
    new-instance v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$5;

    invoke-direct {v0, p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$5;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V

    const-string v1, "\u2715"

    const/high16 v2, 0x41300000    # 11.0f

    const-string v5, "\u672c\u6b21\u6536\u8d77"

    invoke-direct {p0, v1, v2, v5, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->boxBtn(Ljava/lang/String;FLjava/lang/String;Ljava/lang/Runnable;)Landroid/widget/TextView;

    move-result-object v0

    iput-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vBtnClose:Landroid/widget/TextView;

    .line 480
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vTopBar:Landroid/widget/LinearLayout;

    invoke-direct {p0, v6, v6}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lp(II)Landroid/widget/FrameLayout$LayoutParams;

    move-result-object v2

    invoke-virtual {v1, v0, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 482
    new-instance v0, Landroid/widget/FrameLayout$LayoutParams;

    const/high16 v1, 0x41e00000    # 28.0f

    .line 483
    invoke-direct {p0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v1

    invoke-direct {v0, v4, v1}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    .line 484
    invoke-direct {p0, v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v1

    iput v1, v0, Landroid/widget/FrameLayout$LayoutParams;->topMargin:I

    .line 485
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vTopBar:Landroid/widget/LinearLayout;

    invoke-virtual {p0, v1, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    return-void
.end method

.method private cancelFollowResume()V
    .registers 3

    .line 991
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcUnlock:Ljava/lang/Runnable;

    if-eqz v0, :cond_c

    .line 992
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->ui:Landroid/os/Handler;

    invoke-virtual {v1, v0}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    const/4 v0, 0x0

    .line 993
    iput-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcUnlock:Ljava/lang/Runnable;

    :cond_c
    return-void
.end method

.method private clamp()V
    .registers 7

    .line 1694
    :try_start_0
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->getParent()Landroid/view/ViewParent;

    move-result-object v0

    check-cast v0, Landroid/view/View;

    if-nez v0, :cond_9

    goto :goto_51

    .line 1696
    :cond_9
    invoke-virtual {v0}, Landroid/view/View;->getWidth()I

    move-result v1

    invoke-virtual {v0}, Landroid/view/View;->getHeight()I

    move-result v0

    if-lez v1, :cond_51

    if-gtz v0, :cond_16

    goto :goto_51

    .line 1698
    :cond_16
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->getX()F

    move-result v2

    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->getY()F

    move-result v3

    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->getWidth()I

    move-result v4

    int-to-float v4, v4

    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->getHeight()I

    move-result v5

    int-to-float v5, v5

    int-to-float v1, v1

    sub-float/2addr v1, v4

    const/4 v4, 0x0

    .line 1699
    invoke-static {v4, v1}, Ljava/lang/Math;->max(FF)F

    move-result v1

    int-to-float v0, v0

    sub-float/2addr v0, v5

    invoke-static {v4, v0}, Ljava/lang/Math;->max(FF)F

    move-result v0

    cmpg-float v5, v2, v4

    if-gez v5, :cond_3a

    move v2, v4

    :cond_3a
    cmpl-float v5, v2, v1

    if-lez v5, :cond_3f

    goto :goto_40

    :cond_3f
    move v1, v2

    :goto_40
    cmpg-float v2, v3, v4

    if-gez v2, :cond_45

    move v3, v4

    :cond_45
    cmpl-float v2, v3, v0

    if-lez v2, :cond_4a

    goto :goto_4b

    :cond_4a
    move v0, v3

    .line 1704
    :goto_4b
    invoke-virtual {p0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->setX(F)V

    .line 1705
    invoke-virtual {p0, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->setY(F)V
    :try_end_51
    .catchall {:try_start_0 .. :try_end_51} :catchall_51

    :catchall_51
    :cond_51
    :goto_51
    return-void
.end method

.method private doSearch()V
    .registers 5

    .line 1355
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vKw:Landroid/widget/EditText;

    invoke-virtual {v0}, Landroid/widget/EditText;->getText()Landroid/text/Editable;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/Object;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v0

    .line 1356
    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v1

    if-eqz v1, :cond_34

    iget-boolean v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->searching:Z

    if-eqz v1, :cond_19

    goto :goto_34

    .line 1357
    :cond_19
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->pl()Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    move-result-object v1

    if-nez v1, :cond_20

    goto :goto_34

    :cond_20
    const/4 v2, 0x1

    .line 1359
    iput-boolean v2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->searching:Z

    .line 1360
    iget-object v2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vListTitle:Landroid/widget/TextView;

    const-string v3, "\u641c\u7d22\u4e2d\u2026"

    invoke-virtual {v2, v3}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 1361
    new-instance v2, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$27;

    invoke-direct {v2, p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$27;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V

    const/16 p0, 0x14

    invoke-virtual {v1, v0, p0, v2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->search(Ljava/lang/String;ILcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Cb;)V

    :cond_34
    :goto_34
    return-void
.end method

.method private dp(F)I
    .registers 2

    .line 245
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->getContext()Landroid/content/Context;

    move-result-object p0

    invoke-static {p0, p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->dp(Landroid/content/Context;F)I

    move-result p0

    return p0
.end method

.method private ensureCover(J)V
    .registers 5

    .line 1581
    iget-wide v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->coverWanted:J

    cmp-long v0, v0, p1

    if-nez v0, :cond_7

    goto :goto_17

    .line 1582
    :cond_7
    iput-wide p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->coverWanted:J

    .line 1583
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vCover:Landroid/widget/ImageView;

    if-eqz v0, :cond_11

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/widget/ImageView;->setImageBitmap(Landroid/graphics/Bitmap;)V

    .line 1584
    :cond_11
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->pl()Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    move-result-object v0

    if-nez v0, :cond_18

    :goto_17
    return-void

    .line 1586
    :cond_18
    new-instance v1, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$34;

    invoke-direct {v1, p0, p1, p2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$34;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;J)V

    invoke-virtual {v0, p1, p2, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->cover(JLcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Cb;)V

    return-void
.end method

.method private exitFocus()V
    .registers 2

    .line 1064
    iget-boolean v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->pureImage:Z

    if-eqz v0, :cond_7

    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->exitPure()V

    :cond_7
    const/4 v0, 0x0

    .line 1065
    invoke-direct {p0, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->setFocusMode(Z)V

    return-void
.end method

.method private exitPure()V
    .registers 4

    .line 1089
    iget-boolean v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->pureImage:Z

    if-nez v0, :cond_5

    return-void

    :cond_5
    const/4 v0, 0x0

    .line 1090
    iput-boolean v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->pureImage:Z

    .line 1091
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vLyric:Landroid/widget/ListView;

    invoke-virtual {v1, v0}, Landroid/widget/ListView;->setVisibility(I)V

    const/4 v1, 0x2

    .line 1092
    new-array v1, v1, [Landroid/view/View;

    iget-object v2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vScrim:Landroid/view/View;

    aput-object v2, v1, v0

    const/4 v0, 0x1

    iget-object v2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vTopBar:Landroid/widget/LinearLayout;

    aput-object v2, v1, v0

    invoke-direct {p0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->fadeIn([Landroid/view/View;)V

    .line 1094
    :try_start_1c
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vLrcAdapter:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$LyricAdapter;

    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$LyricAdapter;->notifyDataSetChanged()V
    :try_end_21
    .catchall {:try_start_1c .. :try_end_21} :catchall_21

    .line 1097
    :catchall_21
    const-string p0, "\u3010GmMiniBar\u3011\u53cc\u51fb \u2192 \u6062\u590d\u6b4c\u8bcd"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    return-void
.end method

.method private varargs fadeIn([Landroid/view/View;)V
    .registers 6

    .line 1109
    array-length p0, p1

    const/4 v0, 0x0

    :goto_2
    if-ge v0, p0, :cond_28

    aget-object v1, p1, v0

    if-nez v1, :cond_9

    goto :goto_25

    .line 1111
    :cond_9
    invoke-virtual {v1}, Landroid/view/View;->animate()Landroid/view/ViewPropertyAnimator;

    move-result-object v1

    const/high16 v2, 0x3f800000    # 1.0f

    invoke-virtual {v1, v2}, Landroid/view/ViewPropertyAnimator;->alpha(F)Landroid/view/ViewPropertyAnimator;

    move-result-object v1

    const-wide/16 v2, 0xdc

    invoke-virtual {v1, v2, v3}, Landroid/view/ViewPropertyAnimator;->setDuration(J)Landroid/view/ViewPropertyAnimator;

    move-result-object v1

    new-instance v2, Landroid/view/animation/DecelerateInterpolator;

    invoke-direct {v2}, Landroid/view/animation/DecelerateInterpolator;-><init>()V

    .line 1112
    invoke-virtual {v1, v2}, Landroid/view/ViewPropertyAnimator;->setInterpolator(Landroid/animation/TimeInterpolator;)Landroid/view/ViewPropertyAnimator;

    move-result-object v1

    invoke-virtual {v1}, Landroid/view/ViewPropertyAnimator;->start()V

    :goto_25
    add-int/lit8 v0, v0, 0x1

    goto :goto_2

    :cond_28
    return-void
.end method

.method private varargs fadeOut([Landroid/view/View;)V
    .registers 6

    .line 1101
    array-length p0, p1

    const/4 v0, 0x0

    :goto_2
    if-ge v0, p0, :cond_27

    aget-object v1, p1, v0

    if-nez v1, :cond_9

    goto :goto_24

    .line 1103
    :cond_9
    invoke-virtual {v1}, Landroid/view/View;->animate()Landroid/view/ViewPropertyAnimator;

    move-result-object v1

    const/4 v2, 0x0

    invoke-virtual {v1, v2}, Landroid/view/ViewPropertyAnimator;->alpha(F)Landroid/view/ViewPropertyAnimator;

    move-result-object v1

    const-wide/16 v2, 0xdc

    invoke-virtual {v1, v2, v3}, Landroid/view/ViewPropertyAnimator;->setDuration(J)Landroid/view/ViewPropertyAnimator;

    move-result-object v1

    new-instance v2, Landroid/view/animation/DecelerateInterpolator;

    invoke-direct {v2}, Landroid/view/animation/DecelerateInterpolator;-><init>()V

    .line 1104
    invoke-virtual {v1, v2}, Landroid/view/ViewPropertyAnimator;->setInterpolator(Landroid/animation/TimeInterpolator;)Landroid/view/ViewPropertyAnimator;

    move-result-object v1

    invoke-virtual {v1}, Landroid/view/ViewPropertyAnimator;->start()V

    :goto_24
    add-int/lit8 v0, v0, 0x1

    goto :goto_2

    :cond_27
    return-void
.end method

.method private static fmt(I)Ljava/lang/String;
    .registers 2

    if-gtz p0, :cond_5

    .line 308
    const-string p0, "0:00"

    return-object p0

    .line 309
    :cond_5
    div-int/lit16 p0, p0, 0x3e8

    .line 310
    div-int/lit8 v0, p0, 0x3c

    invoke-static {v0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object v0

    rem-int/lit8 p0, p0, 0x3c

    invoke-static {p0}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    move-result-object p0

    filled-new-array {v0, p0}, [Ljava/lang/Object;

    move-result-object p0

    const-string v0, "%d:%02d"

    invoke-static {v0, p0}, Ljava/lang/String;->format(Ljava/lang/String;[Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private highlight(I)V
    .registers 10

    .line 946
    :try_start_0
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcMs:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->isEmpty()Z

    move-result v0

    if-eqz v0, :cond_9

    goto :goto_44

    :cond_9
    const/4 v0, 0x0

    const/4 v1, -0x1

    move v2, v1

    move v1, v0

    .line 948
    :goto_d
    iget-object v3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcMs:Ljava/util/List;

    invoke-interface {v3}, Ljava/util/List;->size()I

    move-result v3

    if-ge v1, v3, :cond_2c

    .line 949
    iget-object v3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcMs:Ljava/util/List;

    invoke-interface {v3, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v3

    check-cast v3, Ljava/lang/Long;

    invoke-virtual {v3}, Ljava/lang/Long;->longValue()J

    move-result-wide v3

    int-to-long v5, p1

    cmp-long v3, v3, v5

    if-gtz v3, :cond_2c

    add-int/lit8 v2, v1, 0x1

    move v7, v2

    move v2, v1

    move v1, v7

    goto :goto_d

    .line 952
    :cond_2c
    iget-boolean p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcJustBuilt:Z

    .line 953
    iput-boolean v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcJustBuilt:Z

    .line 954
    iget v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->curLine:I

    if-ne v2, v0, :cond_37

    if-nez p1, :cond_37

    goto :goto_44

    .line 955
    :cond_37
    iput v2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->curLine:I

    .line 956
    iget-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vLyric:Landroid/widget/ListView;

    if-eqz p1, :cond_40

    invoke-virtual {p1}, Landroid/widget/ListView;->invalidateViews()V

    :cond_40
    const/4 p1, 0x1

    .line 957
    invoke-direct {p0, p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lyricScrollToCurrent(Z)V
    :try_end_44
    .catchall {:try_start_0 .. :try_end_44} :catchall_44

    :catchall_44
    :goto_44
    return-void
.end method

.method private hintRow(Ljava/lang/String;)Landroid/widget/TextView;
    .registers 4

    const/high16 v0, 0x41200000    # 10.0f

    const v1, -0x610a0806

    .line 1436
    invoke-direct {p0, p1, v0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->tv(Ljava/lang/String;FI)Landroid/widget/TextView;

    move-result-object p1

    const/high16 v0, 0x40c00000    # 6.0f

    .line 1437
    invoke-direct {p0, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result p0

    const/4 v0, 0x0

    invoke-virtual {p1, v0, p0, v0, v0}, Landroid/widget/TextView;->setPadding(IIII)V

    return-object p1
.end method

.method private installGestures()V
    .registers 4

    .line 1119
    new-instance v0, Landroid/view/GestureDetector;

    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->getContext()Landroid/content/Context;

    move-result-object v1

    new-instance v2, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$17;

    invoke-direct {v2, p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$17;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V

    invoke-direct {v0, v1, v2}, Landroid/view/GestureDetector;-><init>(Landroid/content/Context;Landroid/view/GestureDetector$OnGestureListener;)V

    iput-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->gdLyric:Landroid/view/GestureDetector;

    .line 1163
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vLyric:Landroid/widget/ListView;

    new-instance v1, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$18;

    invoke-direct {v1, p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$18;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V

    invoke-virtual {v0, v1}, Landroid/widget/ListView;->setOnTouchListener(Landroid/view/View$OnTouchListener;)V

    .line 1174
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vLyric:Landroid/widget/ListView;

    new-instance v1, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$19;

    invoke-direct {v1, p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$19;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V

    invoke-virtual {v0, v1}, Landroid/widget/ListView;->setOnScrollListener(Landroid/widget/AbsListView$OnScrollListener;)V

    .line 1190
    new-instance v0, Landroid/view/GestureDetector;

    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->getContext()Landroid/content/Context;

    move-result-object v1

    new-instance v2, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$20;

    invoke-direct {v2, p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$20;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V

    invoke-direct {v0, v1, v2}, Landroid/view/GestureDetector;-><init>(Landroid/content/Context;Landroid/view/GestureDetector$OnGestureListener;)V

    iput-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->gdCard:Landroid/view/GestureDetector;

    .line 1212
    new-instance v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$21;

    invoke-direct {v0, p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$21;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V

    invoke-virtual {p0, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->setOnTouchListener(Landroid/view/View$OnTouchListener;)V

    return-void
.end method

.method private static lerp(FFF)F
    .registers 3

    sub-float/2addr p1, p0

    mul-float/2addr p1, p2

    add-float/2addr p0, p1

    return p0
.end method

.method private lp(II)Landroid/widget/FrameLayout$LayoutParams;
    .registers 4

    .line 266
    new-instance v0, Landroid/widget/FrameLayout$LayoutParams;

    int-to-float p1, p1

    invoke-direct {p0, p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result p1

    int-to-float p2, p2

    invoke-direct {p0, p2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result p0

    invoke-direct {v0, p1, p0}, Landroid/widget/FrameLayout$LayoutParams;-><init>(II)V

    return-object v0
.end method

.method private lpDp(I)Landroid/widget/LinearLayout$LayoutParams;
    .registers 4

    .line 1324
    new-instance v0, Landroid/widget/LinearLayout$LayoutParams;

    int-to-float p1, p1

    invoke-direct {p0, p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result p1

    const/high16 v1, 0x41f00000    # 30.0f

    invoke-direct {p0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v1

    invoke-direct {v0, p1, v1}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    const/high16 p1, 0x40800000    # 4.0f

    .line 1325
    invoke-direct {p0, p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result p0

    iput p0, v0, Landroid/widget/LinearLayout$LayoutParams;->leftMargin:I

    return-object v0
.end method

.method private lyricScrollToCurrent(Z)V
    .registers 5

    .line 964
    :try_start_0
    iget-boolean v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcFollow:Z

    if-nez v0, :cond_5

    goto :goto_34

    .line 965
    :cond_5
    iget v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->curLine:I

    if-ltz v0, :cond_34

    .line 966
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcText:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->size()I

    move-result v1

    if-lt v0, v1, :cond_12

    goto :goto_34

    .line 967
    :cond_12
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vLyric:Landroid/widget/ListView;

    invoke-virtual {v1}, Landroid/widget/ListView;->getHeight()I

    move-result v1

    if-gtz v1, :cond_1b

    goto :goto_34

    :cond_1b
    const/high16 v2, 0x41e00000    # 28.0f

    .line 969
    invoke-direct {p0, v2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v2

    sub-int/2addr v1, v2

    div-int/lit8 v1, v1, 0x2

    const/4 v2, 0x0

    invoke-static {v2, v1}, Ljava/lang/Math;->max(II)I

    move-result v1
    :try_end_29
    .catchall {:try_start_0 .. :try_end_29} :catchall_34

    .line 971
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vLyric:Landroid/widget/ListView;

    if-eqz p1, :cond_31

    .line 970
    :try_start_2d
    invoke-virtual {p0, v0, v1}, Landroid/widget/ListView;->smoothScrollToPositionFromTop(II)V

    return-void

    .line 971
    :cond_31
    invoke-virtual {p0, v0, v1}, Landroid/widget/ListView;->setSelectionFromTop(II)V
    :try_end_34
    .catchall {:try_start_2d .. :try_end_34} :catchall_34

    :catchall_34
    :cond_34
    :goto_34
    return-void
.end method

.method private static pl()Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;
    .registers 1

    .line 304
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->get()Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    move-result-object v0

    return-object v0
.end method

.method private rebuildLyric(Ljava/lang/String;)V
    .registers 8

    .line 916
    :try_start_0
    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->parseLrc(Ljava/lang/String;)[Ljava/lang/Object;

    move-result-object p1

    const/4 v0, 0x0

    const/4 v1, 0x0

    if-eqz p1, :cond_10

    .line 917
    array-length v2, p1

    if-lez v2, :cond_10

    aget-object v2, p1, v0

    check-cast v2, [J

    goto :goto_11

    :cond_10
    move-object v2, v1

    :goto_11
    const/4 v3, 0x1

    if-eqz p1, :cond_1c

    .line 918
    array-length v4, p1

    if-le v4, v3, :cond_1c

    aget-object p1, p1, v3

    move-object v1, p1

    check-cast v1, [Ljava/lang/String;

    .line 920
    :cond_1c
    iget-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcText:Ljava/util/List;

    invoke-interface {p1}, Ljava/util/List;->clear()V

    .line 921
    iget-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcMs:Ljava/util/List;

    invoke-interface {p1}, Ljava/util/List;->clear()V

    const/4 p1, -0x1

    .line 922
    iput p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->curLine:I

    if-eqz v2, :cond_66

    if-eqz v1, :cond_66

    .line 924
    array-length p1, v2

    if-nez p1, :cond_31

    goto :goto_66

    .line 930
    :cond_31
    :goto_31
    array-length p1, v2

    if-ge v0, p1, :cond_5a

    .line 931
    aget-object p1, v1, v0

    if-nez p1, :cond_3b

    const-string p1, ""

    goto :goto_3f

    :cond_3b
    invoke-virtual {p1}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p1

    .line 932
    :goto_3f
    iget-object v4, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcText:Ljava/util/List;

    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v5

    if-nez v5, :cond_49

    const-string p1, "\u266a"

    :cond_49
    invoke-interface {v4, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 933
    iget-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcMs:Ljava/util/List;

    aget-wide v4, v2, v0

    invoke-static {v4, v5}, Ljava/lang/Long;->valueOf(J)Ljava/lang/Long;

    move-result-object v4

    invoke-interface {p1, v4}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    add-int/lit8 v0, v0, 0x1

    goto :goto_31

    .line 935
    :cond_5a
    iput-boolean v3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcJustBuilt:Z

    .line 936
    iput-boolean v3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcFollow:Z

    .line 937
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vLrcAdapter:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$LyricAdapter;

    if-eqz p0, :cond_74

    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$LyricAdapter;->notifyDataSetChanged()V

    return-void

    .line 925
    :cond_66
    :goto_66
    iget-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcText:Ljava/util/List;

    const-string v0, "\u8fd9\u9996\u6b4c\u6ca1\u6709\u6b4c\u8bcd"

    invoke-interface {p1, v0}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 926
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vLrcAdapter:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$LyricAdapter;

    if-eqz p0, :cond_74

    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$LyricAdapter;->notifyDataSetChanged()V
    :try_end_74
    .catchall {:try_start_0 .. :try_end_74} :catchall_75

    :cond_74
    return-void

    :catchall_75
    move-exception p0

    .line 939
    const-string p1, "\u3010GmMiniBar\u3011\u94fa\u6b4c\u8bcd\u5931\u8d25"

    invoke-static {p1, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.method private refreshList()V
    .registers 13

    const-string v0, "\u641c\u7d22\u7ed3\u679c\uff08"

    const-string v1, "\u64ad\u653e\u961f\u5217\uff08"

    .line 1374
    :try_start_4
    iget-object v2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vListBox:Landroid/widget/LinearLayout;

    invoke-virtual {v2}, Landroid/widget/LinearLayout;->removeAllViews()V

    .line 1375
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->getContext()Landroid/content/Context;

    move-result-object v10

    .line 1376
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->pl()Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    move-result-object v2

    .line 1377
    iget-object v3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vListSwitch:Landroid/widget/TextView;

    if-eqz v3, :cond_21

    .line 1378
    iget-boolean v4, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->showQueue:Z

    if-eqz v4, :cond_1c

    const-string v4, "\u21c4 \u641c\u7d22\u7ed3\u679c"

    goto :goto_1e

    :cond_1c
    const-string v4, "\u21c4 \u961f\u5217"

    :goto_1e
    invoke-virtual {v3, v4}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 1380
    :cond_21
    iget-boolean v3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->showQueue:Z
    :try_end_23
    .catchall {:try_start_4 .. :try_end_23} :catchall_fb

    const-string v4, "\uff09"

    if-eqz v3, :cond_8c

    if-nez v2, :cond_2f

    .line 1382
    :try_start_29
    new-instance v0, Ljava/util/ArrayList;

    invoke-direct {v0}, Ljava/util/ArrayList;-><init>()V

    goto :goto_33

    :cond_2f
    invoke-virtual {v2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->queue()Ljava/util/List;

    move-result-object v0

    .line 1383
    :goto_33
    iget-object v2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vListTitle:Landroid/widget/TextView;

    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v1

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-virtual {v2, v1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 1384
    invoke-interface {v0}, Ljava/util/List;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_5d

    .line 1385
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vListBox:Landroid/widget/LinearLayout;

    const-string v1, "\u961f\u5217\u662f\u7a7a\u7684"

    invoke-direct {p0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->hintRow(Ljava/lang/String;)Landroid/widget/TextView;

    move-result-object p0

    invoke-virtual {v0, p0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    return-void

    :cond_5d
    const/4 v1, 0x0

    .line 1388
    :goto_5e
    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v2

    if-ge v1, v2, :cond_fa

    .line 1390
    iget-object v2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vListBox:Landroid/widget/LinearLayout;

    invoke-interface {v0, v1}, Ljava/util/List;->get(I)Ljava/lang/Object;

    move-result-object v3

    move-object v4, v3

    check-cast v4, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;

    add-int/lit8 v11, v1, 0x1

    invoke-static {v11}, Ljava/lang/String;->valueOf(I)Ljava/lang/String;

    move-result-object v5

    new-instance v6, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$28;

    invoke-direct {v6, p0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$28;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;I)V

    new-instance v7, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$29;

    invoke-direct {v7, p0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$29;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;I)V

    const-string v8, "\uff0d"

    const-string v9, "\u4ece\u961f\u5217\u79fb\u9664"

    move-object v3, p0

    invoke-direct/range {v3 .. v10}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->row(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;Ljava/lang/String;Ljava/lang/Runnable;Ljava/lang/Runnable;Ljava/lang/String;Ljava/lang/String;Landroid/content/Context;)Landroid/widget/LinearLayout;

    move-result-object p0

    invoke-virtual {v2, p0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    move-object p0, v3

    move v1, v11

    goto :goto_5e

    :cond_8c
    move-object v3, p0

    .line 1406
    iget-object p0, v3, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vListTitle:Landroid/widget/TextView;

    iget-object v1, v3, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->results:Ljava/util/List;

    invoke-interface {v1}, Ljava/util/List;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_9a

    const-string v0, "\u641c\u7d22\u7ed3\u679c"

    goto :goto_af

    .line 1407
    :cond_9a
    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    iget-object v0, v3, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->results:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->size()I

    move-result v0

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 1406
    :goto_af
    invoke-virtual {p0, v0}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 1408
    iget-object p0, v3, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->results:Ljava/util/List;

    invoke-interface {p0}, Ljava/util/List;->isEmpty()Z

    move-result p0

    if-eqz p0, :cond_cd

    .line 1409
    iget-object p0, v3, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vListBox:Landroid/widget/LinearLayout;

    iget-boolean v0, v3, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->searching:Z

    if-eqz v0, :cond_c3

    const-string v0, "\u641c\u7740\u5462\u2026"

    goto :goto_c5

    :cond_c3
    const-string v0, "\u641c\u4e00\u9996\u5427"

    :goto_c5
    invoke-direct {v3, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->hintRow(Ljava/lang/String;)Landroid/widget/TextView;

    move-result-object v0

    invoke-virtual {p0, v0}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    return-void

    .line 1412
    :cond_cd
    iget-object p0, v3, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->results:Ljava/util/List;

    invoke-interface {p0}, Ljava/util/List;->iterator()Ljava/util/Iterator;

    move-result-object p0

    :goto_d3
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_fa

    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    move-object v4, v0

    check-cast v4, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;

    .line 1413
    iget-object v0, v3, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vListBox:Landroid/widget/LinearLayout;

    const-string v5, "\u25b6"

    new-instance v6, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$30;

    invoke-direct {v6, v3, v4}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$30;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;)V

    new-instance v7, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$31;

    invoke-direct {v7, v3, v4}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$31;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;)V

    const-string v8, "\uff0b"

    const-string v9, "\u52a0\u5165\u961f\u5217"

    invoke-direct/range {v3 .. v10}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->row(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;Ljava/lang/String;Ljava/lang/Runnable;Ljava/lang/Runnable;Ljava/lang/String;Ljava/lang/String;Landroid/content/Context;)Landroid/widget/LinearLayout;

    move-result-object v1

    invoke-virtual {v0, v1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V
    :try_end_f9
    .catchall {:try_start_29 .. :try_end_f9} :catchall_fb

    goto :goto_d3

    :cond_fa
    return-void

    :catchall_fb
    move-exception v0

    move-object p0, v0

    .line 1431
    const-string v0, "\u3010GmMiniBar\u3011\u5237\u65b0\u5217\u8868\u5931\u8d25"

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.method private round(II)Landroid/graphics/drawable/GradientDrawable;
    .registers 5

    .line 249
    new-instance v0, Landroid/graphics/drawable/GradientDrawable;

    invoke-direct {v0}, Landroid/graphics/drawable/GradientDrawable;-><init>()V

    const/4 v1, 0x0

    .line 250
    invoke-virtual {v0, v1}, Landroid/graphics/drawable/GradientDrawable;->setShape(I)V

    .line 251
    invoke-virtual {v0, p1}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V

    int-to-float p1, p2

    .line 252
    invoke-direct {p0, p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result p0

    int-to-float p0, p0

    invoke-virtual {v0, p0}, Landroid/graphics/drawable/GradientDrawable;->setCornerRadius(F)V

    return-object v0
.end method

.method private row(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;Ljava/lang/String;Ljava/lang/Runnable;Ljava/lang/Runnable;Ljava/lang/String;Ljava/lang/String;Landroid/content/Context;)Landroid/widget/LinearLayout;
    .registers 21

    move-object/from16 v0, p3

    move-object/from16 v1, p4

    move-object/from16 v2, p7

    .line 1453
    new-instance v3, Landroid/widget/LinearLayout;

    invoke-direct {v3, v2}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v4, 0x0

    .line 1454
    invoke-virtual {v3, v4}, Landroid/widget/LinearLayout;->setOrientation(I)V

    const/16 v5, 0x10

    .line 1455
    invoke-virtual {v3, v5}, Landroid/widget/LinearLayout;->setGravity(I)V

    const/high16 v5, 0x40400000    # 3.0f

    .line 1456
    invoke-direct {p0, v5}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v5

    .line 1457
    invoke-virtual {v3, v5, v5, v5, v5}, Landroid/widget/LinearLayout;->setPadding(IIII)V

    const v5, 0x14ffffff

    const/16 v6, 0x8

    .line 1458
    invoke-direct {p0, v5, v6}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->round(II)Landroid/graphics/drawable/GradientDrawable;

    move-result-object v5

    invoke-virtual {v3, v5}, Landroid/widget/LinearLayout;->setBackground(Landroid/graphics/drawable/Drawable;)V

    const/high16 v5, 0x41200000    # 10.0f

    const v6, -0xb05701

    .line 1460
    invoke-direct {p0, p2, v5, v6}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->tv(Ljava/lang/String;FI)Landroid/widget/TextView;

    move-result-object v5

    const/16 v7, 0x11

    .line 1461
    invoke-virtual {v5, v7}, Landroid/widget/TextView;->setGravity(I)V

    .line 1462
    new-instance v8, Landroid/widget/LinearLayout$LayoutParams;

    const/high16 v9, 0x41900000    # 18.0f

    invoke-direct {p0, v9}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v9

    const/4 v10, -0x2

    invoke-direct {v8, v9, v10}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v3, v5, v8}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    .line 1465
    new-instance v5, Landroid/widget/LinearLayout;

    invoke-direct {v5, v2}, Landroid/widget/LinearLayout;-><init>(Landroid/content/Context;)V

    const/4 v2, 0x1

    .line 1466
    invoke-virtual {v5, v2}, Landroid/widget/LinearLayout;->setOrientation(I)V

    .line 1467
    iget-object v8, p1, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;->name:Ljava/lang/String;

    const/high16 v9, 0x41300000    # 11.0f

    const v11, -0xa0806

    invoke-direct {p0, v8, v9, v11}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->tv(Ljava/lang/String;FI)Landroid/widget/TextView;

    move-result-object v8

    .line 1468
    invoke-virtual {v8, v2}, Landroid/widget/TextView;->setSingleLine(Z)V

    .line 1469
    sget-object v9, Landroid/text/TextUtils$TruncateAt;->END:Landroid/text/TextUtils$TruncateAt;

    invoke-virtual {v8, v9}, Landroid/widget/TextView;->setEllipsize(Landroid/text/TextUtils$TruncateAt;)V

    .line 1470
    iget-object v9, p1, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;->artist:Ljava/lang/String;

    if-nez v9, :cond_69

    const-string v9, ""

    goto :goto_6b

    :cond_69
    iget-object v9, p1, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;->artist:Ljava/lang/String;

    :goto_6b
    const/high16 v11, 0x41100000    # 9.0f

    const v12, -0x610a0806

    invoke-direct {p0, v9, v11, v12}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->tv(Ljava/lang/String;FI)Landroid/widget/TextView;

    move-result-object v9

    .line 1471
    invoke-virtual {v9, v2}, Landroid/widget/TextView;->setSingleLine(Z)V

    .line 1472
    sget-object v2, Landroid/text/TextUtils$TruncateAt;->END:Landroid/text/TextUtils$TruncateAt;

    invoke-virtual {v9, v2}, Landroid/widget/TextView;->setEllipsize(Landroid/text/TextUtils$TruncateAt;)V

    .line 1473
    invoke-virtual {v5, v8}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 1474
    invoke-virtual {v5, v9}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;)V

    .line 1475
    new-instance v2, Landroid/widget/LinearLayout$LayoutParams;

    const/high16 v8, 0x3f800000    # 1.0f

    invoke-direct {v2, v4, v10, v8}, Landroid/widget/LinearLayout$LayoutParams;-><init>(IIF)V

    const/high16 v4, 0x40800000    # 4.0f

    .line 1477
    invoke-direct {p0, v4}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v4

    iput v4, v2, Landroid/widget/LinearLayout$LayoutParams;->leftMargin:I

    .line 1478
    invoke-virtual {v3, v5, v2}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    if-eqz v1, :cond_c9

    if-nez p6, :cond_9b

    .line 1481
    const-string v2, "\u64cd\u4f5c"

    goto :goto_9d

    :cond_9b
    move-object/from16 v2, p6

    :goto_9d
    if-nez p5, :cond_a2

    .line 1482
    const-string v4, "\uff0b"

    goto :goto_a4

    :cond_a2
    move-object/from16 v4, p5

    :goto_a4
    const/high16 v5, 0x41600000    # 14.0f

    invoke-direct {p0, v4, v5, v6}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->tv(Ljava/lang/String;FI)Landroid/widget/TextView;

    move-result-object v4

    .line 1483
    invoke-virtual {v4, v7}, Landroid/widget/TextView;->setGravity(I)V

    .line 1484
    new-instance v5, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$32;

    invoke-direct {v5, p0, v2, p1, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$32;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;Ljava/lang/String;Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;Ljava/lang/Runnable;)V

    invoke-virtual {v4, v5}, Landroid/widget/TextView;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    .line 1494
    new-instance p1, Landroid/widget/LinearLayout$LayoutParams;

    const/high16 v1, 0x42080000    # 34.0f

    invoke-direct {p0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v1

    const/high16 v2, 0x41f00000    # 30.0f

    invoke-direct {p0, v2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result v2

    invoke-direct {p1, v1, v2}, Landroid/widget/LinearLayout$LayoutParams;-><init>(II)V

    invoke-virtual {v3, v4, p1}, Landroid/widget/LinearLayout;->addView(Landroid/view/View;Landroid/view/ViewGroup$LayoutParams;)V

    :cond_c9
    if-eqz v0, :cond_d3

    .line 1498
    new-instance p1, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$33;

    invoke-direct {p1, p0, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$33;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;Ljava/lang/Runnable;)V

    invoke-virtual {v3, p1}, Landroid/widget/LinearLayout;->setOnClickListener(Landroid/view/View$OnClickListener;)V

    :cond_d3
    return-object v3
.end method

.method private scheduleFollowResume()V
    .registers 4

    .line 977
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->cancelFollowResume()V

    .line 978
    new-instance v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$14;

    invoke-direct {v0, p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$14;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V

    iput-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcUnlock:Ljava/lang/Runnable;

    .line 987
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->ui:Landroid/os/Handler;

    const-wide/16 v1, 0xbb8

    invoke-virtual {p0, v0, v1, v2}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    return-void
.end method

.method private scrimDrawable()Landroid/graphics/drawable/Drawable;
    .registers 5

    .line 299
    new-instance p0, Landroid/graphics/drawable/GradientDrawable;

    sget-object v0, Landroid/graphics/drawable/GradientDrawable$Orientation;->TOP_BOTTOM:Landroid/graphics/drawable/GradientDrawable$Orientation;

    const/high16 v1, 0x47000000    # 32768.0f

    const/high16 v2, -0x48000000

    const/high16 v3, -0x62000000

    filled-new-array {v3, v1, v2}, [I

    move-result-object v1

    invoke-direct {p0, v0, v1}, Landroid/graphics/drawable/GradientDrawable;-><init>(Landroid/graphics/drawable/GradientDrawable$Orientation;[I)V

    return-object p0
.end method

.method private setBounds(Landroid/view/View;FFFF)V
    .registers 7

    sub-float/2addr p4, p2

    .line 767
    :try_start_1
    invoke-static {p4}, Ljava/lang/Math;->round(F)I

    move-result p0

    const/4 p4, 0x1

    invoke-static {p4, p0}, Ljava/lang/Math;->max(II)I

    move-result p0

    sub-float/2addr p5, p3

    .line 768
    invoke-static {p5}, Ljava/lang/Math;->round(F)I

    move-result p5

    invoke-static {p4, p5}, Ljava/lang/Math;->max(II)I

    move-result p4

    .line 769
    invoke-virtual {p1}, Landroid/view/View;->getLayoutParams()Landroid/view/ViewGroup$LayoutParams;

    move-result-object p5

    if-eqz p5, :cond_28

    .line 770
    iget v0, p5, Landroid/view/ViewGroup$LayoutParams;->width:I

    if-ne v0, p0, :cond_21

    iget v0, p5, Landroid/view/ViewGroup$LayoutParams;->height:I

    if-eq v0, p4, :cond_28

    .line 771
    :cond_21
    iput p0, p5, Landroid/view/ViewGroup$LayoutParams;->width:I

    .line 772
    iput p4, p5, Landroid/view/ViewGroup$LayoutParams;->height:I

    .line 773
    invoke-virtual {p1, p5}, Landroid/view/View;->setLayoutParams(Landroid/view/ViewGroup$LayoutParams;)V

    .line 775
    :cond_28
    invoke-virtual {p1, p2}, Landroid/view/View;->setX(F)V

    .line 776
    invoke-virtual {p1, p3}, Landroid/view/View;->setY(F)V
    :try_end_2e
    .catchall {:try_start_1 .. :try_end_2e} :catchall_2e

    :catchall_2e
    return-void
.end method

.method private setFocusMode(Z)V
    .registers 6

    .line 1000
    iget-boolean v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->focusMode:Z

    if-ne v0, p1, :cond_5

    return-void

    .line 1001
    :cond_5
    iput-boolean p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->focusMode:Z

    if-eqz p1, :cond_c

    const/4 v0, 0x0

    .line 1002
    iput-boolean v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->pureImage:Z

    :cond_c
    const/4 v0, 0x1

    .line 1004
    iput-boolean v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcFollow:Z

    .line 1005
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->cancelFollowResume()V

    if-eqz p1, :cond_17

    const/high16 v0, 0x3f800000    # 1.0f

    goto :goto_18

    :cond_17
    const/4 v0, 0x0

    .line 1007
    :goto_18
    invoke-direct {p0, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->animateLayout(F)V

    .line 1013
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->ui:Landroid/os/Handler;

    new-instance v1, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$15;

    invoke-direct {v1, p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$15;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V

    const-wide/16 v2, 0x140

    invoke-virtual {v0, v1, v2, v3}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    if-eqz p1, :cond_2c

    .line 1024
    const-string p0, "\u805a\u7126\uff08\u5168\u6b4c\u8bcd\uff09"

    goto :goto_2e

    :cond_2c
    const-string p0, "\u5e38\u6001"

    :goto_2e
    const-string p1, "\u3010GmMiniBar\u3011\u5e03\u5c40 \u2192 "

    invoke-virtual {p1, p0}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    return-void
.end method

.method private setLyricHint(Ljava/lang/String;)V
    .registers 3

    .line 852
    :try_start_0
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcText:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->clear()V

    .line 853
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcMs:Ljava/util/List;

    invoke-interface {v0}, Ljava/util/List;->clear()V

    const/4 v0, -0x1

    .line 854
    iput v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->curLine:I

    .line 855
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcText:Ljava/util/List;

    invoke-interface {v0, p1}, Ljava/util/List;->add(Ljava/lang/Object;)Z

    .line 856
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vLrcAdapter:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$LyricAdapter;

    if-eqz p0, :cond_19

    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$LyricAdapter;->notifyDataSetChanged()V
    :try_end_19
    .catchall {:try_start_0 .. :try_end_19} :catchall_19

    :catchall_19
    :cond_19
    return-void
.end method

.method private showSearchPage(Z)V
    .registers 5

    .line 1331
    :try_start_0
    iput-boolean p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->searchPageOpen:Z
    :try_end_2
    .catchall {:try_start_0 .. :try_end_2} :catchall_55

    .line 1332
    const-string v0, "input_method"

    const/16 v1, 0x8

    const/4 v2, 0x0

    if-eqz p1, :cond_35

    .line 1334
    :try_start_9
    iget-boolean p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->focusMode:Z

    if-eqz p1, :cond_10

    invoke-direct {p0, v2}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->setFocusMode(Z)V

    .line 1335
    :cond_10
    iget-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->pagePlay:Landroid/widget/FrameLayout;

    invoke-virtual {p1, v1}, Landroid/widget/FrameLayout;->setVisibility(I)V

    .line 1336
    iget-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->pageSearch:Landroid/widget/FrameLayout;

    invoke-virtual {p1, v2}, Landroid/widget/FrameLayout;->setVisibility(I)V

    .line 1337
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->refreshList()V

    .line 1338
    iget-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vKw:Landroid/widget/EditText;

    invoke-virtual {p1}, Landroid/widget/EditText;->requestFocus()Z

    .line 1340
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->getContext()Landroid/content/Context;

    move-result-object p1

    invoke-virtual {p1, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Landroid/view/inputmethod/InputMethodManager;

    if-eqz p1, :cond_54

    .line 1341
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vKw:Landroid/widget/EditText;

    const/4 v0, 0x1

    invoke-virtual {p1, p0, v0}, Landroid/view/inputmethod/InputMethodManager;->showSoftInput(Landroid/view/View;I)Z

    return-void

    .line 1343
    :cond_35
    iget-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->pageSearch:Landroid/widget/FrameLayout;

    invoke-virtual {p1, v1}, Landroid/widget/FrameLayout;->setVisibility(I)V

    .line 1344
    iget-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->pagePlay:Landroid/widget/FrameLayout;

    invoke-virtual {p1, v2}, Landroid/widget/FrameLayout;->setVisibility(I)V

    .line 1346
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->getContext()Landroid/content/Context;

    move-result-object p1

    invoke-virtual {p1, v0}, Landroid/content/Context;->getSystemService(Ljava/lang/String;)Ljava/lang/Object;

    move-result-object p1

    check-cast p1, Landroid/view/inputmethod/InputMethodManager;

    if-eqz p1, :cond_54

    .line 1347
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vKw:Landroid/widget/EditText;

    invoke-virtual {p0}, Landroid/widget/EditText;->getWindowToken()Landroid/os/IBinder;

    move-result-object p0

    invoke-virtual {p1, p0, v2}, Landroid/view/inputmethod/InputMethodManager;->hideSoftInputFromWindow(Landroid/os/IBinder;I)Z
    :try_end_54
    .catchall {:try_start_9 .. :try_end_54} :catchall_55

    :cond_54
    return-void

    :catchall_55
    move-exception p0

    .line 1350
    const-string p1, "\u3010GmMiniBar\u3011\u5207\u9875\u5931\u8d25"

    invoke-static {p1, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.method private syncLyric(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;)V
    .registers 10

    .line 869
    :try_start_0
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->pl()Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;

    move-result-object v0

    const-wide/16 v1, -0x1

    if-eqz p1, :cond_11

    .line 870
    iget-object v3, p1, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->track:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;

    if-eqz v3, :cond_11

    iget-object p1, p1, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->track:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;

    iget-wide v3, p1, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;->id:J

    goto :goto_12

    :cond_11
    move-wide v3, v1

    :goto_12
    const-wide/16 v5, 0x0

    cmp-long p1, v3, v5

    const/4 v5, -0x2

    if-gez p1, :cond_34

    .line 873
    iget-wide v3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcId:J

    cmp-long p1, v3, v1

    if-nez p1, :cond_28

    iget-object p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcText:Ljava/util/List;

    invoke-interface {p1}, Ljava/util/List;->size()I

    move-result p1

    const/4 v0, 0x1

    if-eq p1, v0, :cond_6d

    .line 874
    :cond_28
    iput-wide v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcId:J

    .line 875
    iput v5, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcSrcLen:I

    .line 876
    iput-wide v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcAskId:J

    .line 877
    const-string p1, "\u2014\u2014"

    invoke-direct {p0, p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->setLyricHint(Ljava/lang/String;)V

    return-void

    :cond_34
    if-nez v0, :cond_37

    goto :goto_6d

    .line 883
    :cond_37
    invoke-virtual {v0, v3, v4}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->cachedLyric(J)Ljava/lang/String;

    move-result-object p1

    if-nez p1, :cond_3f

    const/4 v1, -0x1

    goto :goto_43

    .line 884
    :cond_3f
    invoke-virtual {p1}, Ljava/lang/String;->length()I

    move-result v1
    :try_end_43
    .catchall {:try_start_0 .. :try_end_43} :catchall_76

    .line 904
    :goto_43
    iget-wide v6, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcId:J

    if-gtz v1, :cond_65

    cmp-long p1, v6, v3

    if-eqz p1, :cond_54

    .line 888
    :try_start_4b
    iput-wide v3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcId:J

    .line 889
    iput v5, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcSrcLen:I

    .line 890
    const-string p1, "\u6b4c\u8bcd\u52a0\u8f7d\u4e2d\u2026"

    invoke-direct {p0, p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->setLyricHint(Ljava/lang/String;)V

    .line 892
    :cond_54
    iget-wide v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcAskId:J

    cmp-long p1, v1, v3

    if-eqz p1, :cond_6d

    .line 893
    iput-wide v3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcAskId:J

    .line 894
    new-instance p1, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$13;

    invoke-direct {p1, p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$13;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V

    invoke-virtual {v0, v3, v4, p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer;->lyric(JLcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Cb;)V

    return-void

    :cond_65
    cmp-long v0, v6, v3

    if-nez v0, :cond_6e

    .line 904
    iget v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcSrcLen:I

    if-ne v1, v0, :cond_6e

    :cond_6d
    :goto_6d
    return-void

    .line 906
    :cond_6e
    iput-wide v3, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcId:J

    .line 907
    iput v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lrcSrcLen:I

    .line 908
    invoke-direct {p0, p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->rebuildLyric(Ljava/lang/String;)V
    :try_end_75
    .catchall {:try_start_4b .. :try_end_75} :catchall_76

    return-void

    :catchall_76
    move-exception p0

    .line 910
    const-string p1, "\u3010GmMiniBar\u3011\u540c\u6b65\u6b4c\u8bcd\u5931\u8d25"

    invoke-static {p1, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method

.method private thumbDrawable()Landroid/graphics/drawable/Drawable;
    .registers 3

    .line 289
    new-instance v0, Landroid/graphics/drawable/GradientDrawable;

    invoke-direct {v0}, Landroid/graphics/drawable/GradientDrawable;-><init>()V

    const/4 v1, 0x1

    .line 290
    invoke-virtual {v0, v1}, Landroid/graphics/drawable/GradientDrawable;->setShape(I)V

    const v1, -0xd000001

    .line 291
    invoke-virtual {v0, v1}, Landroid/graphics/drawable/GradientDrawable;->setColor(I)V

    const/high16 v1, 0x41600000    # 14.0f

    .line 292
    invoke-direct {p0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->dp(F)I

    move-result p0

    .line 293
    invoke-virtual {v0, p0, p0}, Landroid/graphics/drawable/GradientDrawable;->setSize(II)V

    return-object v0
.end method

.method private togglePureImage()V
    .registers 6

    .line 1070
    iget-boolean v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->focusMode:Z

    if-nez v0, :cond_5

    goto :goto_4c

    .line 1071
    :cond_5
    iget-boolean v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->pureImage:Z

    const/4 v1, 0x1

    xor-int/2addr v0, v1

    iput-boolean v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->pureImage:Z

    .line 1072
    iget-boolean v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->pureImage:Z

    if-eqz v0, :cond_12

    const-string v0, "\u53cc\u51fb \u2192 \u7eaf\u56fe\uff08\u9690\u85cf\u6b4c\u8bcd+\u6697\u819c\uff09"

    goto :goto_14

    :cond_12
    const-string v0, "\u53cc\u51fb \u2192 \u6062\u590d\u6b4c\u8bcd"

    :goto_14
    const-string v2, "\u3010GmMiniBar\u3011"

    invoke-virtual {v2, v0}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 1073
    iget-boolean v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->pureImage:Z

    .line 1079
    iget-object v2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vLyric:Landroid/widget/ListView;

    const/4 v3, 0x2

    const/4 v4, 0x0

    if-eqz v0, :cond_37

    const/4 v0, 0x4

    .line 1076
    invoke-virtual {v2, v0}, Landroid/widget/ListView;->setVisibility(I)V

    .line 1077
    new-array v0, v3, [Landroid/view/View;

    iget-object v2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vScrim:Landroid/view/View;

    aput-object v2, v0, v4

    iget-object v2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vTopBar:Landroid/widget/LinearLayout;

    aput-object v2, v0, v1

    invoke-direct {p0, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->fadeOut([Landroid/view/View;)V

    return-void

    .line 1079
    :cond_37
    invoke-virtual {v2, v4}, Landroid/widget/ListView;->setVisibility(I)V

    .line 1080
    new-array v0, v3, [Landroid/view/View;

    iget-object v2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vScrim:Landroid/view/View;

    aput-object v2, v0, v4

    iget-object v2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vTopBar:Landroid/widget/LinearLayout;

    aput-object v2, v0, v1

    invoke-direct {p0, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->fadeIn([Landroid/view/View;)V

    .line 1082
    :try_start_47
    iget-object p0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vLrcAdapter:Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$LyricAdapter;

    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$LyricAdapter;->notifyDataSetChanged()V
    :try_end_4c
    .catchall {:try_start_47 .. :try_end_4c} :catchall_4c

    :catchall_4c
    :goto_4c
    return-void
.end method

.method private tv(Ljava/lang/String;FI)Landroid/widget/TextView;
    .registers 5

    .line 257
    new-instance v0, Landroid/widget/TextView;

    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->getContext()Landroid/content/Context;

    move-result-object p0

    invoke-direct {v0, p0}, Landroid/widget/TextView;-><init>(Landroid/content/Context;)V

    .line 258
    invoke-virtual {v0, p1}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    const/4 p0, 0x2

    .line 259
    invoke-virtual {v0, p0, p2}, Landroid/widget/TextView;->setTextSize(IF)V

    .line 260
    invoke-virtual {v0, p3}, Landroid/widget/TextView;->setTextColor(I)V

    const/4 p0, 0x0

    .line 261
    invoke-virtual {v0, p0}, Landroid/widget/TextView;->setIncludeFontPadding(Z)V

    return-object v0
.end method


# virtual methods
.method applyState(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;)V
    .registers 12

    if-eqz p1, :cond_157

    .line 1515
    :try_start_2
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vTitle:Landroid/widget/TextView;

    if-nez v0, :cond_8

    goto/16 :goto_157

    .line 1517
    :cond_8
    iget-object v0, p1, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->track:Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;

    const/4 v1, 0x1

    const/4 v2, 0x0

    if-eqz v0, :cond_10

    move v3, v1

    goto :goto_11

    :cond_10
    move v3, v2

    .line 1519
    :goto_11
    iget-object v4, p1, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->error:Ljava/lang/String;

    if-eqz v4, :cond_1f

    iget-object v4, p1, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->error:Ljava/lang/String;

    invoke-virtual {v4}, Ljava/lang/String;->length()I

    move-result v4
    :try_end_1b
    .catchall {:try_start_2 .. :try_end_1b} :catchall_151

    if-lez v4, :cond_1f

    move v4, v1

    goto :goto_20

    :cond_1f
    move v4, v2

    .line 1522
    :goto_20
    const-string v5, ""

    if-eqz v4, :cond_27

    .line 1523
    :try_start_24
    iget-object v6, p1, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->error:Ljava/lang/String;

    goto :goto_5e

    :cond_27
    if-eqz v3, :cond_55

    .line 1525
    iget-object v6, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;->artist:Ljava/lang/String;

    if-nez v6, :cond_2f

    move-object v6, v5

    goto :goto_35

    :cond_2f
    iget-object v6, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;->artist:Ljava/lang/String;

    invoke-virtual {v6}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object v6

    .line 1526
    :goto_35
    invoke-virtual {v6}, Ljava/lang/String;->length()I

    move-result v7

    if-nez v7, :cond_3e

    iget-object v6, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;->name:Ljava/lang/String;

    goto :goto_5e

    :cond_3e
    new-instance v7, Ljava/lang/StringBuilder;

    invoke-direct {v7}, Ljava/lang/StringBuilder;-><init>()V

    iget-object v8, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;->name:Ljava/lang/String;

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v8, " \u00b7 "

    invoke-virtual {v7, v8}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7, v6}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v7}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v6

    goto :goto_5e

    .line 1528
    :cond_55
    iget-boolean v6, p1, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->preparing:Z

    if-eqz v6, :cond_5c

    const-string v6, "\u52a0\u8f7d\u4e2d\u2026"

    goto :goto_5e

    :cond_5c
    const-string v6, "\u8fd8\u6ca1\u6709\u6b4c \u2014\u2014 \u70b9 \u266a \u641c\u4e00\u9996"

    .line 1530
    :goto_5e
    iget-object v7, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lastTitle:Ljava/lang/String;

    invoke-virtual {v6, v7}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v7

    if-nez v7, :cond_6d

    .line 1531
    iput-object v6, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lastTitle:Ljava/lang/String;

    .line 1532
    iget-object v7, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vTitle:Landroid/widget/TextView;

    invoke-virtual {v7, v6}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 1535
    :cond_6d
    iget-boolean v6, p1, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->playing:Z
    :try_end_6f
    .catchall {:try_start_24 .. :try_end_6f} :catchall_151

    const-string v7, "\u275a\u275a"

    const-string v8, "\u25b6"

    if-eqz v6, :cond_77

    move-object v6, v7

    goto :goto_78

    :cond_77
    move-object v6, v8

    :goto_78
    if-eqz v4, :cond_7c

    :try_start_7a
    const-string v5, "!"

    :cond_7c
    invoke-virtual {v6, v5}, Ljava/lang/String;->concat(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v5

    .line 1536
    iget-object v6, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lastPlayGlyph:Ljava/lang/String;

    invoke-virtual {v5, v6}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result v6

    const v9, -0xa0806

    if-nez v6, :cond_a4

    .line 1537
    iput-object v5, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lastPlayGlyph:Ljava/lang/String;

    .line 1538
    iget-object v5, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vBtnPlay:Landroid/widget/TextView;

    iget-boolean v6, p1, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->playing:Z

    if-eqz v6, :cond_94

    goto :goto_95

    :cond_94
    move-object v7, v8

    :goto_95
    invoke-virtual {v5, v7}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 1539
    iget-object v5, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vBtnPlay:Landroid/widget/TextView;

    if-eqz v4, :cond_a0

    const v4, -0x9495

    goto :goto_a1

    :cond_a0
    move v4, v9

    :goto_a1
    invoke-virtual {v5, v4}, Landroid/widget/TextView;->setTextColor(I)V

    .line 1542
    :cond_a4
    iget v4, p1, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->loop:I

    if-ne v4, v1, :cond_aa

    move v4, v1

    goto :goto_ab

    :cond_aa
    move v4, v2

    .line 1543
    :goto_ab
    iget v5, p1, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->loop:I

    const/4 v6, 0x2

    if-ne v5, v6, :cond_b1

    goto :goto_b2

    :cond_b1
    move v1, v2

    .line 1544
    :goto_b2
    iget-boolean v5, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lastLoopOne:Z

    if-ne v4, v5, :cond_ba

    iget-boolean v5, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lastShuffle:Z

    if-eq v1, v5, :cond_102

    .line 1545
    :cond_ba
    iput-boolean v4, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lastLoopOne:Z

    .line 1546
    iput-boolean v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lastShuffle:Z

    .line 1547
    iget-object v5, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vBtnLoop:Landroid/widget/TextView;

    if-eqz v4, :cond_c5

    const-string v6, "\u21bb1"

    goto :goto_c7

    :cond_c5
    const-string v6, "\u21bb"

    :goto_c7
    invoke-virtual {v5, v6}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 1548
    iget-object v5, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vBtnLoop:Landroid/widget/TextView;

    const v6, -0xb05701

    if-eqz v4, :cond_d3

    move v7, v6

    goto :goto_d4

    :cond_d3
    move v7, v9

    :goto_d4
    invoke-virtual {v5, v7}, Landroid/widget/TextView;->setTextColor(I)V

    .line 1549
    iget-object v5, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vBtnShuffle:Landroid/widget/TextView;

    if-eqz v1, :cond_dc

    move v9, v6

    :cond_dc
    invoke-virtual {v5, v9}, Landroid/widget/TextView;->setTextColor(I)V
    :try_end_df
    .catchall {:try_start_7a .. :try_end_df} :catchall_151

    .line 1551
    :try_start_df
    iget-object v5, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vBtnLoop:Landroid/widget/TextView;

    const v6, 0x400a84ff

    const v7, 0x1fffffff

    if-eqz v4, :cond_eb

    move v4, v6

    goto :goto_ec

    :cond_eb
    move v4, v7

    :goto_ec
    const/16 v8, 0x9

    invoke-direct {p0, v4, v8}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->round(II)Landroid/graphics/drawable/GradientDrawable;

    move-result-object v4

    invoke-virtual {v5, v4}, Landroid/widget/TextView;->setBackground(Landroid/graphics/drawable/Drawable;)V

    .line 1552
    iget-object v4, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vBtnShuffle:Landroid/widget/TextView;

    if-eqz v1, :cond_fa

    goto :goto_fb

    :cond_fa
    move v6, v7

    :goto_fb
    invoke-direct {p0, v6, v8}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->round(II)Landroid/graphics/drawable/GradientDrawable;

    move-result-object v1

    invoke-virtual {v4, v1}, Landroid/widget/TextView;->setBackground(Landroid/graphics/drawable/Drawable;)V
    :try_end_102
    .catchall {:try_start_df .. :try_end_102} :catchall_102

    .line 1557
    :catchall_102
    :cond_102
    :try_start_102
    iget v1, p1, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->dur:I

    iput v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->curDur:I

    .line 1558
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vDur:Landroid/widget/TextView;

    iget v4, p1, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->dur:I

    invoke-static {v4}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->fmt(I)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v1, v4}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V

    .line 1559
    iget-boolean v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->seekTouching:Z

    if-nez v1, :cond_134

    .line 1560
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vPos:Landroid/widget/TextView;

    iget v4, p1, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->pos:I

    invoke-static {v4}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->fmt(I)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v1, v4}, Landroid/widget/TextView;->setText(Ljava/lang/CharSequence;)V
    :try_end_120
    .catchall {:try_start_102 .. :try_end_120} :catchall_151

    .line 1562
    :try_start_120
    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vSeek:Landroid/widget/SeekBar;

    iget v4, p1, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->dur:I

    if-lez v4, :cond_131

    iget v2, p1, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->pos:I

    int-to-long v4, v2

    const-wide/16 v6, 0x3e8

    mul-long/2addr v4, v6

    iget v2, p1, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->dur:I

    int-to-long v6, v2

    div-long/2addr v4, v6

    long-to-int v2, v4

    :cond_131
    invoke-virtual {v1, v2}, Landroid/widget/SeekBar;->setProgress(I)V
    :try_end_134
    .catchall {:try_start_120 .. :try_end_134} :catchall_134

    :catchall_134
    :cond_134
    if-eqz v3, :cond_13c

    .line 1567
    :try_start_136
    iget-wide v0, v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$Track;->id:J

    invoke-direct {p0, v0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->ensureCover(J)V

    goto :goto_148

    :cond_13c
    const-wide/16 v0, -0x1

    .line 1569
    iput-wide v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->coverWanted:J

    .line 1570
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->vCover:Landroid/widget/ImageView;

    if-eqz v0, :cond_148

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/widget/ImageView;->setImageBitmap(Landroid/graphics/Bitmap;)V

    .line 1573
    :cond_148
    :goto_148
    invoke-direct {p0, p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->syncLyric(Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;)V

    .line 1574
    iget p1, p1, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicPlayer$State;->pos:I

    invoke-direct {p0, p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->highlight(I)V
    :try_end_150
    .catchall {:try_start_136 .. :try_end_150} :catchall_151

    goto :goto_157

    :catchall_151
    move-exception p0

    .line 1576
    const-string p1, "\u3010GmMiniBar\u3011\u5237\u65b0\u5931\u8d25"

    invoke-static {p1, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    :cond_157
    :goto_157
    return-void
.end method

.method bootstrap()V
    .registers 2

    .line 1661
    new-instance v0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$37;

    invoke-direct {v0, p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$37;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V

    invoke-virtual {p0, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->post(Ljava/lang/Runnable;)Z

    return-void
.end method

.method public dispatchTouchEvent(Landroid/view/MotionEvent;)Z
    .registers 10

    .line 1715
    const-string v0, ","

    .line 0
    const-string v1, "\u3010GmMiniBar\u3011\ud83d\udc4b \u89e6\u6478\u5230\u8fbe\u5361\u7247 ("

    .line 1715
    :try_start_4
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getActionMasked()I

    move-result v2

    if-nez v2, :cond_8e

    .line 1716
    invoke-static {}, Ljava/lang/System;->currentTimeMillis()J

    move-result-wide v2

    .line 1717
    iget-wide v4, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lastTouchLog:J

    sub-long v4, v2, v4

    const-wide/16 v6, 0x7d0

    cmp-long v4, v4, v6

    if-lez v4, :cond_8e

    .line 1718
    iput-wide v2, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->lastTouchLog:J

    .line 1719
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    .line 1720
    invoke-virtual {p1}, Landroid/view/MotionEvent;->getX()F

    move-result v1

    float-to-int v1, v1

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p1}, Landroid/view/MotionEvent;->getY()F

    move-result v1

    float-to-int v1, v1

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, ") \u4f4d\u7f6e=("

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1721
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->getContext()Landroid/content/Context;

    move-result-object v1

    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->getX()F

    move-result v3

    invoke-static {v1, v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->px2dp(Landroid/content/Context;F)I

    move-result v1

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1722
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->getY()F

    move-result v1

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->px2dp(Landroid/content/Context;F)I

    move-result v0

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, ")dp \u5c3a\u5bf8="

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1723
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->getWidth()I

    move-result v1

    int-to-float v1, v1

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->px2dp(Landroid/content/Context;F)I

    move-result v0

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, "\u00d7"

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 1724
    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->getContext()Landroid/content/Context;

    move-result-object v0

    invoke-virtual {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->getHeight()I

    move-result v1

    int-to-float v1, v1

    invoke-static {v0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBar;->px2dp(Landroid/content/Context;F)I

    move-result v0

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, "dp"

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    .line 1719
    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_8e
    .catchall {:try_start_4 .. :try_end_8e} :catchall_8e

    .line 1729
    :catchall_8e
    :cond_8e
    invoke-super {p0, p1}, Landroid/widget/FrameLayout;->dispatchTouchEvent(Landroid/view/MotionEvent;)Z

    move-result p0

    return p0
.end method

.method protected onAttachedToWindow()V
    .registers 5

    .line 1619
    invoke-super {p0}, Landroid/widget/FrameLayout;->onAttachedToWindow()V

    .line 1621
    :try_start_3
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->ui:Landroid/os/Handler;

    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->tick:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 1622
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->ui:Landroid/os/Handler;

    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->tick:Ljava/lang/Runnable;

    const-wide/16 v2, 0x1f4

    invoke-virtual {v0, v1, v2, v3}, Landroid/os/Handler;->postDelayed(Ljava/lang/Runnable;J)Z

    .line 1623
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->ui:Landroid/os/Handler;

    new-instance v1, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$36;

    invoke-direct {v1, p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView$36;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;)V

    invoke-virtual {v0, v1}, Landroid/os/Handler;->post(Ljava/lang/Runnable;)Z
    :try_end_1d
    .catchall {:try_start_3 .. :try_end_1d} :catchall_1d

    :catchall_1d
    return-void
.end method

.method protected onDetachedFromWindow()V
    .registers 3

    .line 1637
    :try_start_0
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->ui:Landroid/os/Handler;

    iget-object v1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->tick:Ljava/lang/Runnable;

    invoke-virtual {v0, v1}, Landroid/os/Handler;->removeCallbacks(Ljava/lang/Runnable;)V

    .line 1638
    invoke-direct {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->cancelFollowResume()V

    .line 1639
    iget-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->layoutAnim:Landroid/animation/ValueAnimator;

    if-eqz v0, :cond_14

    .line 1640
    invoke-virtual {v0}, Landroid/animation/ValueAnimator;->cancel()V

    const/4 v0, 0x0

    .line 1641
    iput-object v0, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->layoutAnim:Landroid/animation/ValueAnimator;
    :try_end_14
    .catchall {:try_start_0 .. :try_end_14} :catchall_14

    .line 1645
    :catchall_14
    :cond_14
    invoke-super {p0}, Landroid/widget/FrameLayout;->onDetachedFromWindow()V

    return-void
.end method

.method protected onSizeChanged(IIII)V
    .registers 5

    .line 1650
    invoke-super {p0, p1, p2, p3, p4}, Landroid/widget/FrameLayout;->onSizeChanged(IIII)V

    .line 1652
    :try_start_3
    iget p1, p0, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->layoutT:F

    invoke-direct {p0, p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmMiniBarView;->applyPlayLayout(F)V
    :try_end_8
    .catchall {:try_start_3 .. :try_end_8} :catchall_8

    :catchall_8
    return-void
.end method
