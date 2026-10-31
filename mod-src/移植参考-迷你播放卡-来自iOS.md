# 44 · 迷你播放卡 → 安卓反向移植处方

> ✅ **已执行（2026-10-25 · 3.71.20）** ⇒ 落地记录见 `版本/3.71.20.md`
>
> 执行时对处方本身的两处修正（**下一轮改代码时以本文的"修正"为准**）：
> 1. **歌词控件用 `ListView`，不是 `RecyclerView`** ——
>    模块是零依赖的（只有 `android.jar`），`unzip -l android.jar | grep -c recycler` = **0**。
>    `ListView` 与 `UITableView` 同源：`smoothScrollToPositionFromTop(row, (h-rowH)/2)` ≈
>    `scrollToRowAtIndexPath:atScrollPosition:Middle`；`invalidateViews()` 不传索引 ⇒
>    天然躲开 iOS 那个「空数组崩溃」。
> 2. **按钮宽度必须缩**：`44/52/44/32/32 + 8dp = 236dp` 塞不进最小卡宽
>    （240 − 10×2 = **只剩 220dp**）⇒ 改成 `42/50/42/30/30 + 6dp = 218dp`。
>    `LinearLayout` **不会**替你缩 `WRAP_CONTENT` 子项，只会两头裁。
>
> 另外：`onSingleTapConfirmed` 那条是对的，但还要加一句 ——
> **`OnTouchListener` 必须 `return false`**，否则 `ListView` 收不到事件、歌词滚不动。

> 2026-10-25 · 尼得亚伯 🐲
> 来源：iOS `src/FDMProbe5/FDMMiniBar.m`（**1,392 行**，v68 真机验通）
> 目标：`mod-src/src/com/nidyaber/fuckdsmanger/bridge/GmMiniBarView.java`（1,051 行）
>
> **这篇是"照着抄就能做"的处方，不是感想。** 按 §三 的顺序做，每步都能单独上机看效果。

---

## 〇、一句话差距

| | 安卓现在 | iOS 现在（目标） |
|---|---|---|
| 排版 | **左右两栏**：左列=封面+控件，右列=歌词 | **上下分区**：顶栏 / 封面+歌词 / 进度条 / 按钮行 |
| 歌词 | 一堆 `TextView` 塞进 `ScrollView` | `UITableView` 全歌词，可滚、自动居中当前句 |
| 形态 | 只有一种 | **三态**：常态 / 聚焦（全歌词）/ 纯图（只封面） |
| 缩放 | ✅ 四角 `Resize` **已经对了** | ✅ 四角 + 捏合 |
| 进度条 | 在左列控件区顶部 | **吸附在按钮行上沿**（卡片拉高 ⇒ 高度全给歌词） |

**结论：四角缩放不用动，其余基本重排。**

---

## 一、目标布局（三态 · 精确坐标）

单位 pt（安卓用 dp，1dp ≈ 1pt；7P 是 414 宽）。

### 常量（iOS 实际用的值，抄这个）

```java
static final int   PAD        = 10;   // 卡片内边距
static final int   TOPBAR_H   = 28;   // 顶栏按钮边长
static final int   COVER_SIDE = 84;   // 常态封面边长
static final int   BTN_H      = 30;   // 按钮行高度
static final int   SLIDER_H   = 22;   // 进度条高度
static final int   ROW_H_FOCUS = 30;  // 聚焦态歌词行高
static final int   ROW_H_NORMAL = 22; // 常态歌词行高
static final float CORNER_R    = 16f; // 卡片圆角
static final int   MIN_W = 240, MAX_W = 560;
static final int   MIN_H = 150, MAX_H = 560;

// 按钮行（居中）—— 顺序：◀◀ ❚❚ ▶▶ ↻ ⇄
static final int W_PREV = 44, W_PLAY = 52, W_NEXT = 44, W_REP = 32, W_SHUF = 32;
static final int BTN_GAP = 8;
// 总宽 = 44+52+44+32+32 + 8*4 = 236
```

### ① 常态

```
y=10          ┌ [♪] ─── 曲名 · 歌手 ─── [✕] ┐   TOPBAR_H = 28
y=46(46=10+28+8)│ ┌────┐ 歌词行1（窄条）      │
              │ │封面│ 歌词行2               │
              │ │ 84 │ 歌词行3               │
              │ └────┘ ……                   │
y=?           │ 0:11 ━━━●──────── 3:26     │   ← slY = btnY - 6 - SLIDER_H
              │    ◀◀  ❚❚  ▶▶  ↻  ⇄        │   ← btnY = h - PAD - BTN_H
y=h-10-30     └────────────────────────────┘
```

**★ 核心：从下往上算**（这是主人特别强调的那条）

```java
int btnY = h - PAD - BTN_H;                 // 按钮贴底
int slY  = btnY - 6 - SLIDER_H;             // 进度条吸附在按钮上方
int lyricTop = bodyY;                       // 歌词从顶栏下开始
int lyricH   = slY - 6 - lyricTop;          // ★ 剩下的全给歌词
```

⇒ 卡片拉高时 `lyricH` 自动变大，**歌词行数变多**，中间不会留白。

> ⚠️ iOS v65 之前写死 `sliderY = 88`（= 封面底 + 4），拉高就中间一大片空 —— 主人截图指出的就是这个。

### ② 聚焦（点歌词进）

```
┌ [‹] ─── 曲名 · 歌手 ─────────────┐
│ ┌──────────────────────────────┐ │
│ │  封面 ImageView MATCH_PARENT  │ │  ← 铺满整卡（含顶栏下面全部）
│ │  ┌────────────────────────┐  │ │
│ │  │ 渐变暗膜（0.62/0.28/0.72）│ │ │  ← 保证白字可读
│ │  └────────────────────────┘  │ │
│ │   歌词1（普通 14sp alpha .58）│ │
│ │ ┃ 歌词2（当前 16sp 白 加粗） │ │  ← 自动滚到中间
│ │   歌词3                      │ │
│ │   ……可滚动，全歌词……         │ │
│ └──────────────────────────────┘ │
└──────────────────────────────────┘
  进度条 + 按钮行 全部 GONE
```

### ③ 纯图（聚焦时双击）

- 封面铺满整卡（**保持**）
- 歌词、暗膜、标题、返回键 全部 `alpha=0`
- 只剩封面
- 单击 → 回常态；双击 → 恢复歌词

---

## 二、安卓现在的结构（要改的地方）

`GmMiniBarView.buildPlayPage()` 现在是：

```
content (HORIZONTAL)
├── left (VERTICAL)
│   ├── pCover   weight 1.15   ← 封面
│   └── pCtl                   ← rowSeek + rowBtn
└── right (…)                  ← 歌词
```

**要改成：**

```
content (VERTICAL)
├── topBar      (HORIZONTAL, h=28)   [♪/‹] … [✕]
├── body        (FrameLayout, weight=1)
│   ├── cover        (ImageView)
│   ├── scrim        (View，渐变，仅聚焦)
│   └── lyricScroll  (ScrollView 或 RecyclerView)
├── seekRow     (HORIZONTAL, h=22)
└── btnRow      (HORIZONTAL, h=30, gravity=center)
```

---

## 三、施工顺序（每步都能单独上机看）

### 步骤 1 · 排版：改成上下分区（必做，30 分钟）

```java
// buildPlayPage() 里
content.setOrientation(LinearLayout.VERTICAL);

// ① 顶栏
LinearLayout topBar = new LinearLayout(c);
topBar.setOrientation(LinearLayout.HORIZONTAL);
topBar.setGravity(Gravity.CENTER_VERTICAL);
topBar.addView(vBtnNote, new LinearLayout.LayoutParams(dp(28), dp(28)));  // ♪
// …中间放标题（weight=1）…
topBar.addView(vBtnClose, new LinearLayout.LayoutParams(dp(28), dp(28))); // ✕
content.addView(topBar, new LinearLayout.LayoutParams(MATCH_PARENT, dp(28)));

// ② 中部 FrameLayout（封面当底，歌词浮上）
FrameLayout body = new FrameLayout(c);
body.addView(vCover, new FrameLayout.LayoutParams(MATCH_PARENT, MATCH_PARENT));
body.addView(vScrim, new FrameLayout.LayoutParams(MATCH_PARENT, MATCH_PARENT));
body.addView(vLyric, new FrameLayout.LayoutParams(MATCH_PARENT, MATCH_PARENT));
content.addView(body, new LinearLayout.LayoutParams(MATCH_PARENT, 0, 1f));  // ★ weight=1

// ③ 进度条行
content.addView(rowSeek, new LinearLayout.LayoutParams(MATCH_PARENT, dp(22)));

// ④ 按钮行（★ 居中）
LinearLayout rowBtn = new LinearLayout(c);
rowBtn.setOrientation(LinearLayout.HORIZONTAL);
rowBtn.setGravity(Gravity.CENTER);        // ★ 不是默认的 LEFT
// 五个按钮：固定宽度 + 间距，总宽 236dp，靠 gravity=CENTER 居中
rowBtn.addView(btnPrev, new LinearLayout.LayoutParams(dp(44), dp(30)));
// … gap(dp(8)) …
content.addView(rowBtn, new LinearLayout.LayoutParams(MATCH_PARENT, dp(30)));
```

> **为什么这样就自动"进度条吸附按钮上沿"**：
> 因为 `body` 用了 `weight=1`，它会吃掉所有剩余高度 ⇒
> 卡片拉高 → body 变高 → 歌词区变大。**不需要手算 y 坐标**。
> 这比 iOS 的手算更省事，安卓这边 LinearLayout 天然有这个能力。

### 步骤 2 · 封面两态（15 分钟）

```java
// 常态：小方块，靠左上（在 body 里用 margin 定位）
FrameLayout.LayoutParams lp = (FrameLayout.LayoutParams) vCover.getLayoutParams();
lp.width  = dp(COVER_SIDE);          // 84
lp.height = dp(COVER_SIDE);
lp.leftMargin = dp(PAD);
lp.topMargin  = 0;
lp.gravity = Gravity.TOP | Gravity.LEFT;
vCover.setLayoutParams(lp);
vCover.setScaleType(ImageView.ScaleType.CENTER_CROP);

// 聚焦：铺满 body
lp.width  = MATCH_PARENT;
lp.height = MATCH_PARENT;
lp.leftMargin = 0; lp.topMargin = 0;
vCover.setLayoutParams(lp);
```

**动画**（关键 —— 安卓必须显式做，iOS 是白送的）：

```java
// 方式 A：属性动画（推荐，不用 Transition）
if (on) {
    vCover.animate().x(0).y(0)
          .scaleX((float) body.getWidth() / dp(COVER_SIDE))
          .scaleY((float) body.getHeight() / dp(COVER_SIDE))
          .setDuration(280).setInterpolator(new DecelerateInterpolator()).start();
} else { /* 反向 */ }

// 方式 B：TransitionManager（如果布局参数都变了）
TransitionManager.beginDelayedTransition((ViewGroup) getRootView(),
        new ChangeBounds().setDuration(280));
```

> ⚠️ 方式 B 在 `DecorView` 下偶尔不生效（宿主是 Compose，父层有自己的一套）。
> **建议用方式 A**，或者干脆用 `ValueAnimator` 手动算宽高。

### 步骤 3 · 歌词换成正经列表（1 小时，最重要的改动）

现在是 `List<TextView> lrcViews` + 手动塞进 `ScrollView`。改成：

```java
// 用 RecyclerView（安卓自带，不需要额外依赖）
private RecyclerView vLyric;
private LyricAdapter lrcAdapter;

vLyric = new RecyclerView(c);
vLyric.setLayoutManager(new LinearLayoutManager(c, LinearLayoutManager.VERTICAL, false));
lrcAdapter = new LyricAdapter();
vLyric.setAdapter(lrcAdapter);
vLyric.setOverScrollMode(View.OVER_SCROLL_NEVER);
// ★ 上下留半屏 padding，首行/末行也能滚到中间
vLyric.setPadding(0, body.getHeight() / 2, 0, body.getHeight() / 2);
```

Adapter 关键点：

```java
class LyricAdapter extends RecyclerView.Adapter<VH> {
    final List<Lrc> lines = new ArrayList<>();   // {ms, text}
    int cur = -1;                                // 当前唱到第几行

    @Override public void onBindViewHolder(VH h, int pos) {
        Lrc l = lines.get(pos);
        h.t.setText(l.text.isEmpty() ? "♪" : l.text);   // 空行给占位
        boolean isCur = (pos == cur);
        if (isCur) {
            h.t.setTextSize(focus ? 16f : 13.5f);
            h.t.setTypeface(null, Typeface.BOLD);
            h.t.setTextColor(0xFFFFFFFF);
            h.t.setShadowLayer(3f, 0, 0, 0x8C000000);   // ★ 封面上白字必须给阴影
        } else {
            h.t.setTextSize(focus ? 14f : 12f);
            h.t.setTextColor(focus ? 0x94FFFFFF : 0x6BFFFFFF);
            h.t.setShadowLayer(2f, 0, 0, 0x59000000);
        }
        h.itemView.setOnLongClickListener(v -> { seekTo(lines.get(pos).ms); return true; });
    }
}
```

**自动跟随 + 手动锁定**（主人要的"临时锁定"）：

```java
boolean follow = true;
Handler unlockHandler = new Handler(Looper.getMainLooper());
Runnable unlock = () -> { follow = true; scrollToCurrent(true); };

vLyric.addOnScrollListener(new RecyclerView.OnScrollListener() {
    @Override public void onScrollStateChanged(RecyclerView rv, int st) {
        if (st == RecyclerView.SCROLL_STATE_DRAGGING) {
            follow = false;                       // ★ 用户一滑就锁定
            unlockHandler.removeCallbacks(unlock);
            unlockHandler.postDelayed(unlock, 3000);   // ★ 3 秒后恢复
        }
    }
});

void scrollToCurrent(boolean anim) {
    if (!follow || cur < 0) return;
    SmoothOrLinear lm = ...;
    if (anim) vLyric.smoothScrollToPosition(cur);
    else      vLyric.scrollToPosition(cur);
}
```

> ⚠️ `smoothScrollToPosition` 是"滚到可见"，不是"滚到中间"。
> 想要严格居中，用 `LinearLayoutManager.scrollToPositionWithOffset(cur, -height/2)`
> 或者 `smoothScrollBy(0, dy)` 自己算。

### 步骤 4 · 三态切换（30 分钟）

```java
boolean focusMode = false, pureImage = false;

void setFocusMode(boolean on) {
    focusMode = on;
    int vis = on ? View.GONE : View.VISIBLE;

    vSeekRow.setVisibility(vis);
    vBtnRow.setVisibility(vis);
    vBtnNote.setVisibility(vis);
    vBtnClose.setVisibility(vis);

    vBtnBack.setVisibility(on ? View.VISIBLE : View.GONE);
    vScrim.setVisibility(on ? View.VISIBLE : View.GONE);
    lrcAdapter.setFocus(on);       // 通知 adapter 换字号
    lrcAdapter.notifyDataSetChanged();

    if (on) { pureImage = false; follow = true; }
    animateLayoutChange();         // ★ 见步骤 2 的动画
    refreshLayout();
}

void togglePureImage() {
    if (!focusMode) return;
    pureImage = !pureImage;
    float a = pureImage ? 0f : 1f;
    vScrim.animate().alpha(pureImage ? 0f : 1f).setDuration(220).start();
    vLyric.animate().alpha(a).setDuration(220).start();
    vTitle.animate().alpha(a).setDuration(220).start();
    vBtnBack.animate().alpha(a).setDuration(220).start();
}
```

### 步骤 5 · 手势（40 分钟，安卓的坑最多）

**单击 / 双击 / 长按 只能挂一个，用 `GestureDetector` 统一处理**：

```java
GestureDetector gd = new GestureDetector(c, new GestureDetector.SimpleOnGestureListener() {
    @Override public boolean onSingleTapConfirmed(MotionEvent e) {
        // ★ 必须是 onSingleTapConfirmed，不是 onSingleTapUp
        //   （onSingleTapUp 在双击的第一下就会触发，会误切）
        if (pureImage) { pureImage = false; setFocusMode(false); }
        else           { setFocusMode(!focusMode); }
        return true;
    }
    @Override public boolean onDoubleTap(MotionEvent e) {
        togglePureImage();
        return true;
    }
    @Override public void onLongPress(MotionEvent e) {
        if (!focusMode) return;
        int pos = findLyricRowAt(e);
        if (pos >= 0) seekTo(lrcAdapter.lines.get(pos).ms);
    }
});

vLyric.setOnTouchListener((v, ev) -> gd.onTouchEvent(ev));
```

> ⚠️⚠️ **`onSingleTapConfirmed` vs `onSingleTapUp`** 是安卓最容易踩的坑：
> `onSingleTapUp` 在双击的第一下就触发 ⇒ 双击永远生效不了。
> iOS 这边对应的坑是 `requireGestureRecognizerToFail:`。

**滚歌词时不要拖卡**：

```java
// 卡片自己的拖动是 Drag（OnTouchListener）
// 因为 vLyric 是独立子 View，事件先到它 ⇒ 天然不冲突。
// 但 Rx 之外要注意：如果 Drag 挂在根容器上，需要

vLyric.setOnTouchListener((v, ev) -> {
    v.getParent().requestDisallowInterceptTouchEvent(true);   // ★ 抢走事件
    gd.onTouchEvent(ev);
    return true;
});
```

**别的控件也要 `requestDisallowInterceptTouchEvent(true)`**（`SeekBar`/按钮/输入框），
否则卡片的 `Drag` 会把它们的拖动吞掉。

---

## 四、iOS 踩过的坑 → 安卓对应风险

| iOS 的坑 | 安卓会不会踩 | 说明 |
|---|---|---|
| `reloadRowsAtIndexPaths` 收空数组 → 崩 | ✅ **会** | `notifyItemChanged(-1)` 直接 `IndexOutOfBoundsException`。**index 越界必须判** |
| 缓存只比 songId，歌词后到不重建 | ✅ **会** | 缓存键要含**源歌词行数**（或版本号），不能只比曲 id |
| 手势 tag 用 0 → 全被拒（整卡拖不动） | ⚠️ 不会 | 安卓没用 tag 判手势，但**注意 `View.NO_ID = -1`**：用 `getId()` 判控件时别和默认值撞 |
| `_cover` 是 `_playPage` 子视图 ⇒ 铺不到顶栏 | ⚠️ 变种 | 安卓 `body` 是独立 FrameLayout，封面铺满 body 就够（顶栏本来就在 body 外）——**反而更好做** |
| `CAGradientLayer` 不跟 frame 变 | ✅ **会** | 安卓 `GradientDrawable` + `setBounds()`，或者直接用 `alpha` 渐变的 `View` 背景 |
| 返回键被 `_playPage` 盖住 | ⚠️ 不会 | 安卓用 `LinearLayout` 顺序排，天然不重叠 |
| 四角缩放用"累加增量"有死区 | ✅ 已规避 | 安卓 `Resize` 已经是"起点+总位移"，**保持别改** |
| 动画必须显式做（iOS 免费） | ✅ **会** | 见步骤 2 |

---

## 五、照抄清单（复制粘贴级）

### 5.1 居中按钮行

```java
LinearLayout rowBtn = new LinearLayout(c);
rowBtn.setOrientation(LinearLayout.HORIZONTAL);
rowBtn.setGravity(Gravity.CENTER);          // ★ 关键，不是 LEFT

int[] ws = {44, 52, 44, 32, 32};
View[] bs = {vBtnPrev, vBtnPlay, vBtnNext, vBtnLoop, vBtnShuffle};
for (int i = 0; i < bs.length; i++) {
    LinearLayout.LayoutParams lp = new LinearLayout.LayoutParams(dp(ws[i]), dp(30));
    if (i > 0) lp.leftMargin = dp(8);
    rowBtn.addView(bs[i], lp);
}
```

### 5.2 小圆点（14dp）

```java
GradientDrawable thumb = new GradientDrawable();
thumb.setShape(GradientDrawable.OVAL);
thumb.setColor(0xF0FFFFFF);
thumb.setSize(dp(14), dp(14));                   // ★ 直径
vSeek.setThumb(thumb);
vSeek.setThumbOffset(0);                          // ★ 不然会被前一个 thumb 宽度挤偏
vSeek.setSplitTrack(false);                       // ★ 不然圆点后面有条白线
```

### 5.3 渐变暗膜

```java
View vScrim = new View(c);
vScrim.setBackground(new GradientDrawable(
    GradientDrawable.Orientation.TOP_BOTTOM,
    new int[]{ 0x9E000000, 0x47000000, 0xB8000000 }));   // 0.62 / 0.28 / 0.72
vScrim.setVisibility(View.GONE);
```

### 5.4 从下往上算布局（`body` 用 weight=1 就自动了）

```java
// 唯一要手算的是 body 之外的部分：
content.addView(topBar,  new LinearLayout.LayoutParams(MATCH_PARENT, dp(28)));
content.addView(body,    new LinearLayout.LayoutParams(MATCH_PARENT, 0, 1f));  // ★
content.addView(seekRow, new LinearLayout.LayoutParams(MATCH_PARENT, dp(22)));
content.addView(btnRow,  new LinearLayout.LayoutParams(MATCH_PARENT, dp(30)));
// outer padding = dp(10)
```

---

## 六、上机验收清单

- [ ] 常态：封面左上小方块、歌词在右、进度条在按钮上方
- [ ] **拉高卡片 → 歌词行数变多，中间无留白**（主人最在意这条）
- [ ] 常态整卡任意处可拖（按钮 / 进度条 / 四角除外）
- [ ] 四角拖动改大小，对角固定，夹 240×150 ~ 560×560
- [ ] 点歌词 → 聚焦：封面铺满、进度条和按钮消失、返回键出现
- [ ] 聚焦态滑歌词 → **歌词滚、卡不动**；松手 3 秒后回到当前句
- [ ] 聚焦态长按某句 → 跳到那句
- [ ] 聚焦态双击 → 只剩封面；再双击 → 回来；单击 → 回常态
- [ ] 纯图态还能拖卡、还能拖角
- [ ] 换歌 → 歌词自动重建（不是残留上一首）
- [ ] 前奏（还没唱）时**不崩**（index = -1 的越界）

---

## 七、给下次的三句话

> **1. 安卓的 `weight=1` 就是 iOS 的"从下往上算"。**
> iOS 那边我手算了 `btnY → slY → lyricH`；安卓只要给 `body` 一个 `weight=1`，
> 布局系统自己就把剩余高度全给歌词了 —— **别抄 iOS 的手算代码**。

> **2. `onSingleTapConfirmed` 不是 `onSingleTapUp`。**
> 后者在双击的第一下就触发，双击永远失效。iOS 对应的是 `requireGestureRecognizerToFail:`。

> **3. 安卓四角 `Resize` 已经是对的，不要重写。**
> 对角固定 + 夹紧 + `requestDisallowInterceptTouchEvent` 全齐了。
> 唯一要补的是"松手存尺寸"里的**版本标记**（iOS 吃过老存档的亏）。

🐲
