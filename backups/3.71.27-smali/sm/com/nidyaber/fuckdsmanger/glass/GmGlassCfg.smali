.class public final Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg;
.super Ljava/lang/Object;
.source "GmGlassCfg.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;
    }
.end annotation


# static fields
.field public static final D_BLUR:I = 0xe

.field public static final D_CLEAN:Z = false

.field public static final D_CLEAN_TOL:I = 0xc

.field public static final D_COLOR:I = -0x1

.field public static final D_DISP:I = 0xc

.field public static final D_DROP:Z = true

.field public static final D_EDGE:I = 0x14

.field public static final D_ENGINE:I = 0x0

.field public static final D_FADE:I = 0x32

.field public static final D_FIT:Z = true

.field public static final D_FORM:I = 0x0

.field public static final D_IMPL:I = 0x0

.field public static final D_ON:Z = false

.field public static final D_RADIUS:I = 0x16

.field public static final D_SCOPE:I = 0x1

.field public static final D_SRC:I = 0x0

.field public static final D_TINT:I = 0x2d

.field public static final FORM_EDGE:I = 0x2

.field public static final FORM_FULL:I = 0x0

.field public static final FORM_HOLLOW:I = 0x1

.field public static final K_BLUR:Ljava/lang/String; = "fuckds_glass_blur"

.field public static final K_CLEAN:Ljava/lang/String; = "fuckds_glass_clean"

.field public static final K_CLEAN_TOL:Ljava/lang/String; = "fuckds_glass_clean_tol"

.field public static final K_COLOR:Ljava/lang/String; = "fuckds_glass_color"

.field public static final K_DISP:Ljava/lang/String; = "fuckds_glass_disp"

.field public static final K_DROP:Ljava/lang/String; = "fuckds_glass_drop"

.field public static final K_EDGE:Ljava/lang/String; = "fuckds_glass_edge"

.field public static final K_ENGINE:Ljava/lang/String; = "fuckds_glass_engine"

.field public static final K_FADE:Ljava/lang/String; = "fuckds_glass_fade"

.field public static final K_FIT:Ljava/lang/String; = "fuckds_glass_fit"

.field public static final K_FORM:Ljava/lang/String; = "fuckds_glass_form"

.field public static final K_IMPL:Ljava/lang/String; = "fuckds_glass_impl"

.field public static final K_ON:Ljava/lang/String; = "fuckds_glass_on"

.field public static final K_RADIUS:Ljava/lang/String; = "fuckds_glass_radius"

.field public static final K_SCOPE:Ljava/lang/String; = "fuckds_glass_scope"

.field public static final K_SRC:Ljava/lang/String; = "fuckds_glass_src"

.field public static final K_TINT:Ljava/lang/String; = "fuckds_glass_tint"

.field public static final SCOPE_ALL:I = 0x0

.field public static final SCOPE_BUTTONS_ONLY:I = 0x1

.field private static volatile sCur:Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;


# direct methods
.method static constructor <clinit>()V
    .registers 18

    .line 247
    new-instance v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;

    const/16 v16, 0x14

    const/16 v17, 0x32

    const/4 v1, 0x0

    const/16 v2, 0x2d

    const/16 v3, 0x16

    const/16 v4, 0xe

    const/4 v5, 0x1

    const/4 v6, 0x1

    const/4 v7, -0x1

    const/16 v8, 0xc

    const/4 v9, 0x0

    const/4 v10, 0x0

    const/16 v11, 0xc

    const/4 v12, 0x0

    const/4 v13, 0x0

    const/4 v14, 0x1

    const/4 v15, 0x0

    invoke-direct/range {v0 .. v17}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;-><init>(ZIIIZIIIIZIIIZIII)V

    sput-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg;->sCur:Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;

    return-void
.end method

.method private constructor <init>()V
    .registers 1

    .line 21
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static bool(Landroid/content/Context;Ljava/lang/String;Z)Z
    .registers 4

    .line 337
    const-string v0, "b"

    invoke-static {p0, p1, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->read2(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    if-nez p0, :cond_9

    goto :goto_36

    .line 339
    :cond_9
    invoke-virtual {p0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p0

    .line 340
    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result p1

    if-eqz p1, :cond_14

    goto :goto_36

    .line 341
    :cond_14
    const-string p1, "true"

    invoke-virtual {p1, p0}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result p1

    if-nez p1, :cond_39

    const-string p1, "1"

    invoke-virtual {p1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p1

    if-eqz p1, :cond_25

    goto :goto_39

    .line 342
    :cond_25
    const-string p1, "false"

    invoke-virtual {p1, p0}, Ljava/lang/String;->equalsIgnoreCase(Ljava/lang/String;)Z

    move-result p1

    if-nez p1, :cond_37

    const-string p1, "0"

    invoke-virtual {p1, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_36

    goto :goto_37

    :cond_36
    :goto_36
    return p2

    :cond_37
    :goto_37
    const/4 p0, 0x0

    return p0

    :cond_39
    :goto_39
    const/4 p0, 0x1

    return p0
.end method

.method private static clamp(III)I
    .registers 3

    if-ge p0, p1, :cond_3

    return p1

    :cond_3
    if-le p0, p2, :cond_6

    return p2

    :cond_6
    return p0
.end method

.method public static get()Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;
    .registers 1

    .line 252
    sget-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg;->sCur:Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;

    return-object v0
.end method

.method private static intOf(Landroid/content/Context;Ljava/lang/String;I)I
    .registers 4

    .line 347
    const-string v0, "i"

    invoke-static {p0, p1, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->read2(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    if-nez p0, :cond_9

    goto :goto_13

    .line 349
    :cond_9
    invoke-virtual {p0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p0

    .line 350
    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result p1

    if-eqz p1, :cond_14

    :goto_13
    return p2

    .line 352
    :cond_14
    :try_start_14
    invoke-static {p0}, Ljava/lang/Integer;->parseInt(Ljava/lang/String;)I

    move-result p0
    :try_end_18
    .catchall {:try_start_14 .. :try_end_18} :catchall_19

    return p0

    :catchall_19
    return p2
.end method

.method private static longOf(Landroid/content/Context;Ljava/lang/String;J)J
    .registers 5

    .line 302
    const-string v0, "i"

    invoke-static {p0, p1, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->read2(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object p0

    if-nez p0, :cond_9

    goto :goto_13

    .line 304
    :cond_9
    invoke-virtual {p0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p0

    .line 305
    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result p1

    if-eqz p1, :cond_14

    :goto_13
    return-wide p2

    .line 307
    :cond_14
    :try_start_14
    invoke-static {p0}, Ljava/lang/Long;->parseLong(Ljava/lang/String;)J

    move-result-wide p0
    :try_end_18
    .catchall {:try_start_14 .. :try_end_18} :catchall_19

    return-wide p0

    :catchall_19
    return-wide p2
.end method

.method public static needCpuBlur()Z
    .registers 1

    .line 244
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg;->wantGpu()Z

    move-result v0

    xor-int/lit8 v0, v0, 0x1

    return v0
.end method

.method public static on()Z
    .registers 1

    .line 256
    sget-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg;->sCur:Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;

    iget-boolean v0, v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->on:Z

    return v0
.end method

.method public static reload(Landroid/content/Context;)Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;
    .registers 39

    move-object/from16 v0, p0

    const/4 v1, 0x0

    const/16 v2, 0x2d

    const/16 v3, 0x16

    const/16 v4, 0xe

    const/4 v5, 0x1

    const/4 v6, -0x1

    const/16 v7, 0xc

    .line 275
    :try_start_d
    const-string v10, "fuckds_glass_on"

    invoke-static {v0, v10, v1}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg;->bool(Landroid/content/Context;Ljava/lang/String;Z)Z

    move-result v10
    :try_end_13
    .catchall {:try_start_d .. :try_end_13} :catchall_13d

    .line 276
    :try_start_13
    const-string v11, "fuckds_glass_tint"

    invoke-static {v0, v11, v2}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg;->intOf(Landroid/content/Context;Ljava/lang/String;I)I

    move-result v11

    const/16 v12, 0x64

    invoke-static {v11, v1, v12}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg;->clamp(III)I

    move-result v2
    :try_end_1f
    .catchall {:try_start_13 .. :try_end_1f} :catchall_12c

    .line 277
    :try_start_1f
    const-string v11, "fuckds_glass_radius"

    invoke-static {v0, v11, v3}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg;->intOf(Landroid/content/Context;Ljava/lang/String;I)I

    move-result v11

    const/16 v13, 0x40

    invoke-static {v11, v1, v13}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg;->clamp(III)I

    move-result v3

    .line 278
    const-string v11, "fuckds_glass_blur"

    invoke-static {v0, v11, v4}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg;->intOf(Landroid/content/Context;Ljava/lang/String;I)I

    move-result v11

    const/16 v13, 0x28

    invoke-static {v11, v1, v13}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg;->clamp(III)I

    move-result v4

    .line 279
    const-string v11, "fuckds_glass_drop"

    invoke-static {v0, v11, v5}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg;->bool(Landroid/content/Context;Ljava/lang/String;Z)Z

    move-result v11
    :try_end_3d
    .catchall {:try_start_1f .. :try_end_3d} :catchall_128

    .line 280
    :try_start_3d
    const-string v13, "fuckds_glass_scope"

    invoke-static {v0, v13, v5}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg;->intOf(Landroid/content/Context;Ljava/lang/String;I)I

    move-result v13

    invoke-static {v13, v1, v5}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg;->clamp(III)I

    move-result v13
    :try_end_47
    .catchall {:try_start_3d .. :try_end_47} :catchall_11a

    .line 281
    :try_start_47
    const-string v14, "fuckds_glass_color"
    :try_end_49
    .catchall {:try_start_47 .. :try_end_49} :catchall_10e

    move/from16 v16, v13

    const-wide v12, 0xffffffffL

    :try_start_50
    invoke-static {v0, v14, v12, v13}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg;->longOf(Landroid/content/Context;Ljava/lang/String;J)J

    move-result-wide v12

    long-to-int v6, v12

    .line 282
    const-string v12, "fuckds_glass_disp"

    invoke-static {v0, v12, v7}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg;->intOf(Landroid/content/Context;Ljava/lang/String;I)I

    move-result v12

    const/16 v13, 0x3c

    invoke-static {v12, v1, v13}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg;->clamp(III)I

    move-result v12
    :try_end_61
    .catchall {:try_start_50 .. :try_end_61} :catchall_10b

    .line 283
    :try_start_61
    const-string v14, "fuckds_glass_engine"

    invoke-static {v0, v14, v1}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg;->intOf(Landroid/content/Context;Ljava/lang/String;I)I

    move-result v14

    const/4 v15, 0x2

    invoke-static {v14, v1, v15}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg;->clamp(III)I

    move-result v14
    :try_end_6c
    .catchall {:try_start_61 .. :try_end_6c} :catchall_fa

    .line 284
    :try_start_6c
    const-string v9, "fuckds_glass_clean"

    invoke-static {v0, v9, v1}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg;->bool(Landroid/content/Context;Ljava/lang/String;Z)Z

    move-result v9
    :try_end_72
    .catchall {:try_start_6c .. :try_end_72} :catchall_ed

    .line 285
    :try_start_72
    const-string v8, "fuckds_glass_clean_tol"

    invoke-static {v0, v8, v7}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg;->intOf(Landroid/content/Context;Ljava/lang/String;I)I

    move-result v8

    invoke-static {v8, v1, v13}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg;->clamp(III)I

    move-result v7

    .line 286
    const-string v8, "fuckds_glass_src"

    invoke-static {v0, v8, v1}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg;->intOf(Landroid/content/Context;Ljava/lang/String;I)I

    move-result v8

    invoke-static {v8, v1, v15}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg;->clamp(III)I

    move-result v8
    :try_end_86
    .catchall {:try_start_72 .. :try_end_86} :catchall_e7

    .line 287
    :try_start_86
    const-string v13, "fuckds_glass_impl"

    invoke-static {v0, v13, v1}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg;->intOf(Landroid/content/Context;Ljava/lang/String;I)I

    move-result v13

    invoke-static {v13, v1, v15}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg;->clamp(III)I

    move-result v13
    :try_end_90
    .catchall {:try_start_86 .. :try_end_90} :catchall_e2

    .line 288
    :try_start_90
    const-string v15, "fuckds_glass_fit"

    invoke-static {v0, v15, v5}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg;->bool(Landroid/content/Context;Ljava/lang/String;Z)Z

    move-result v5

    .line 289
    const-string v15, "fuckds_glass_form"

    invoke-static {v0, v15, v1}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg;->intOf(Landroid/content/Context;Ljava/lang/String;I)I

    move-result v15
    :try_end_9c
    .catchall {:try_start_90 .. :try_end_9c} :catchall_dc

    move/from16 v19, v2

    const/4 v2, 0x2

    :try_start_9f
    invoke-static {v15, v1, v2}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg;->clamp(III)I

    move-result v2
    :try_end_a3
    .catchall {:try_start_9f .. :try_end_a3} :catchall_de

    .line 290
    :try_start_a3
    const-string v15, "fuckds_glass_edge"

    const/16 v1, 0x14

    invoke-static {v0, v15, v1}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg;->intOf(Landroid/content/Context;Ljava/lang/String;I)I

    move-result v15
    :try_end_ab
    .catchall {:try_start_a3 .. :try_end_ab} :catchall_df

    move/from16 v18, v2

    const/16 v1, 0x3c

    const/4 v2, 0x0

    :try_start_b0
    invoke-static {v15, v2, v1}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg;->clamp(III)I

    move-result v1
    :try_end_b4
    .catchall {:try_start_b0 .. :try_end_b4} :catchall_f5

    .line 291
    :try_start_b4
    const-string v15, "fuckds_glass_fade"

    const/16 v2, 0x32

    invoke-static {v0, v15, v2}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg;->intOf(Landroid/content/Context;Ljava/lang/String;I)I

    move-result v0

    const/4 v2, 0x0

    const/16 v15, 0x64

    invoke-static {v0, v2, v15}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg;->clamp(III)I

    move-result v0
    :try_end_c3
    .catchall {:try_start_b4 .. :try_end_c3} :catchall_d5

    move/from16 v37, v0

    move/from16 v36, v1

    move/from16 v34, v5

    move/from16 v31, v7

    move/from16 v21, v10

    move/from16 v25, v11

    move/from16 v28, v12

    move/from16 v29, v14

    goto/16 :goto_15c

    :catchall_d5
    move/from16 v17, v1

    move v0, v5

    move v1, v10

    move v5, v11

    move v2, v14

    goto :goto_107

    :catchall_dc
    move/from16 v19, v2

    :catchall_de
    move v2, v1

    :catchall_df
    move/from16 v18, v2

    goto :goto_f5

    :catchall_e2
    move/from16 v19, v2

    move v2, v1

    move v13, v2

    goto :goto_f3

    :catchall_e7
    move/from16 v19, v2

    move v2, v1

    move v8, v2

    move v13, v8

    goto :goto_f3

    :catchall_ed
    move/from16 v19, v2

    move v2, v1

    move v8, v2

    move v9, v8

    move v13, v9

    :goto_f3
    move/from16 v18, v13

    :catchall_f5
    :goto_f5
    move v0, v5

    move v1, v10

    move v5, v11

    move v2, v14

    goto :goto_105

    :catchall_fa
    move/from16 v19, v2

    move v2, v1

    move v8, v2

    move v9, v8

    move v13, v9

    move/from16 v18, v13

    move v0, v5

    move v1, v10

    move v5, v11

    :goto_105
    const/16 v17, 0x14

    :goto_107
    move v10, v7

    move v7, v12

    goto/16 :goto_14c

    :catchall_10b
    move/from16 v19, v2

    goto :goto_112

    :catchall_10e
    move/from16 v19, v2

    move/from16 v16, v13

    :goto_112
    move v2, v1

    move v8, v2

    move v9, v8

    move v13, v9

    move/from16 v18, v13

    move v0, v5

    goto :goto_125

    :catchall_11a
    move/from16 v19, v2

    move v2, v1

    move v8, v2

    move v9, v8

    move v13, v9

    move/from16 v18, v13

    move v0, v5

    move/from16 v16, v0

    :goto_125
    move v1, v10

    move v5, v11

    goto :goto_139

    :catchall_128
    move/from16 v19, v2

    move v2, v1

    goto :goto_130

    :catchall_12c
    move v0, v2

    move v2, v1

    move/from16 v19, v0

    :goto_130
    move v8, v2

    move v9, v8

    move v13, v9

    move/from16 v18, v13

    move v0, v5

    move/from16 v16, v0

    move v1, v10

    :goto_139
    const/16 v17, 0x14

    move v10, v7

    goto :goto_14c

    :catchall_13d
    move v0, v2

    move v2, v1

    move/from16 v19, v0

    move v8, v1

    move v9, v8

    move v13, v9

    move/from16 v18, v13

    move v0, v5

    move/from16 v16, v0

    move v10, v7

    const/16 v17, 0x14

    :goto_14c
    move/from16 v34, v0

    move/from16 v21, v1

    move/from16 v29, v2

    move/from16 v25, v5

    move/from16 v28, v7

    move/from16 v31, v10

    move/from16 v36, v17

    const/16 v37, 0x32

    :goto_15c
    move/from16 v23, v3

    move/from16 v24, v4

    move/from16 v27, v6

    move/from16 v32, v8

    move/from16 v30, v9

    move/from16 v33, v13

    move/from16 v26, v16

    move/from16 v35, v18

    move/from16 v22, v19

    .line 295
    new-instance v20, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;

    invoke-direct/range {v20 .. v37}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;-><init>(ZIIIZIIIIZIIIZIII)V

    sput-object v20, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg;->sCur:Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;

    .line 297
    sget-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg;->sCur:Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;

    return-object v0
.end method

.method public static wantGpu()Z
    .registers 2

    .line 236
    sget-object v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg;->sCur:Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;

    iget v0, v0, Lcom/nidyaber/fuckdsmanger/glass/GmGlassCfg$S;->impl:I

    const/4 v1, 0x2

    if-ne v0, v1, :cond_9

    const/4 v0, 0x0

    return v0

    :cond_9
    const/4 v1, 0x1

    if-ne v0, v1, :cond_11

    .line 238
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassGpu;->available()Z

    move-result v0

    return v0

    .line 239
    :cond_11
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/glass/GmGlassGpu;->available()Z

    move-result v0

    return v0
.end method
