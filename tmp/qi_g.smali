{"ok":true,"data":{"workspaceId":"smjygppz","editSessionId":"","locator":"dex_method:Lqi;->g(Ljava/lang/Object;)Ljava/lang/Object;","name":"Lqi; g(Ljava/lang/Object;)Ljava/lang/Object;","textSourceKind":"class_smali","targetVersion":"sha256:ffa38844f882dcfa472ff229fe9758921807a7778e01cf1d810a8802a184fbfe","limit":2000,"truncated":true,"truncatedReason":"window","textWindow":{"text":".method public final g(Ljava/lang/Object;)Ljava/lang/Object;
    .registers 25

    .line 1
    move-object/from16 v0, p0

    .line 3
    iget v1, v0, Lqi;->a:I

    .line 5
    const/16 v2, 0x8

    .line 7
    const/16 v3, 0xf

    .line 9
    const-string v4, "chat_session_id"

    .line 11
    const/4 v5, 0x3

    .line 12
    const/4 v6, 0x1

    .line 13
    const/4 v8, 0x0

    .line 14
    packed-switch v1, :pswitch_data_704

    .line 17
    iget-object v1, v0, Lqi;->c:Ljava/lang/Object;

    .line 19
    check-cast v1, Leu6;

    .line 21
    iget-object v2, v0, Lqi;->d:Ljava/lang/Object;

    .line 23
    check-cast v2, Ljl7;

    .line 25
    iget-object v3, v0, Lqi;->b:Ljava/lang/Object;

    .line 27
    check-cast v3, Lc2a;

    .line 29
    iget-object v0, v0, Lqi;->e:Ljava/lang/Object;

    .line 31
    check-cast v0, Lhl7;

    .line 33
    move-object/from16 v4, p1

    .line 35
    check-cast v4, Ljava/lang/Long;

    .line 37
    invoke-virtual {v4}, Ljava/lang/Long;->longValue()J

    .line 40
    move-result-wide v4

    .line 41
    invoke-virtual {v1}, Leu6;->k()I

    .line 44
    move-result v6

    .line 45
    int-to-float v6, v6

    .line 46
    invoke-virtual {v1}, Leu6;->l()F

    .line 49
    move-result v1

    .line 50
    add-float/2addr v1, v6

    .line 51
    iget-wide v6, v2, Ljl7;->a:J

    .line 53
    const-wide/16 v8, 0x0

    .line 55
    cmp-long v8, v6, v8

    .line 57
    if-lez v8, :cond_59

    .line 59
    sub-long v6, v4, v6

    .line 61
    long-to-float v6, v6

    .line 62
    const v7, 0x4e6e6b28  # 1.0E9f

    .line 65
    div-float/2addr v6, v7

    .line 66
    const v7, 0x3b888889

    .line 69
    cmpl-float v7, v6, v7

    .line 71
    if-lez v7, :cond_59

    .line 73
    iget-object v3, v3, Lc2a;->c:Luk3;

    .line 75
    iget v7, v0, Lhl7;->a:F

    .line 77
    sub-float v7, v1, v7

    .line 79
    div-float/2addr v7, v6

    .line 80
    const/high16 v6, -0x3f000000  # -8.0f

    .line 82
    const/high16 v8, 0x41000000  # 8.0f

    .line 84
    invoke-static {v7, v6, v8}, Lge5;->p(FFF)F

    .line 87
    move-result v6

    .line 88
    iput v6, v3, Luk3;->a:F

    .line 90
    :cond_59
    iput v1, v0, Lhl7;->a:F

    .line 92
    iput-wide v4, v2, Ljl7;->a:J

    .line 94
    sget-object v0, Llp9;->a:Llp9;

    .line 96
    return-object v0

    .line 97
    :pswitch_60  #0x13
    iget-object v1, v0, Lqi;->c:Ljava/lang/Object;

    .line 99
    check-cast v1, Lo44;

    .line 101
    iget-object v2, v0, Lqi;->d:Ljava/lang/Object;

    .line 103
    check-cast v2, Liv5;

    .line 105
    iget-object v3, v0, Lqi;->b:Ljava/lang/Object;

    .line 107
    check-cast v3, Lg31;

    .line 109
    iget-object v0, v0, Lqi;->e:Ljava/lang/Object;

    .line 111
    check-cast v0, Lvq;

    .line 113
    move-object/from16 v4, p1

    .line 115
    check-cast v4, Lyl6;

    .line 117
    invoke-interface {v1, v8}, Lo44;->a(I)V

    .line 120
    if-eqz v4, :cond_93

    .line 122
    iget-wide v4, v4, Lyl6;->a:J

    .line 124
    invoke-static {v4, v5}, Lzl9;->B0(J)J

    .line 127
    move-result-wide v4

    .line 128
    invoke-virtual {v2, v4, v5}, Liv5;->d(J)Z

    .line 131
    move-result v1

    .line 132
    if-eqz v1, :cond_93

    .line 134
    invoke-virtual {v0}, Lvq;->x()I

    .line 137
    move-result v0

    .line 138
    sget-object v1, Lpj1;->Companion:Loj1;

    .line 140
    invoke-virtual {v1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    .line 143
    const-string v1, "USER"

    .line 145
    invoke-virtual {v3, v0, v1}, Lg31;->g(ILjava/lang/String;)V

    .line 148
    :cond_93
    sget-object v0, Llp9;->a:Llp9;

    .line 150
    return-object v0

    .line 151
    :pswitch_96  #0x12
    iget-object v1, v0, Lqi;->c:Ljava/lang/Object;

    .line 153
    move-object v9, v1

    .line 154
    check-cast v9, Lsq9;

    .line 156
    iget-object v1, v0, Lqi;->d:Ljava/lang/Object;

    .line 158
    move-object v10, v1

    .line 159
    check-cast v10, Lh12;

    .line 161
    iget-object v1, v0, Lqi;->b:Ljava/lang/Object;

    .line 163
    move-object v11, v1

    .line 164
    check-cast v11, Lsq9;

    .line 166
    iget-object v0, v0, Lqi;->e:Ljava/lang/Object;

    .line 168
    move-object v8, v0

    .line 169
    check-cast v8, Lsh;

    .line 171
    move-object/from16 v0, p1

    .line 173
    check-cast v0, Lm9;

    .line 175
    iget-boolean v1, v9, Lsq9;->d:Z

    .line 177
    if-nez v1, :cond_bc

    .line 179
    new-instance v1, Ltq9;

    .line 181
    invoke-direct {v1, v10, v11}, Ltq9;-><init>(Lh12;Lsq9;)V

    .line 184
    sget-object v2, Lob2;->j:Lt62;

    .line 186
    invoke-static {v0, v0, v1, v2}, Los8;->G(Lm9;Lm9;Lhv3;Lwv3;)V

    .line 189
    :cond_bc
    new-instance v7, Ld4;

    .line 191
    const/16 v12, 0xd

    .line 193
    invoke-direct/range {v7 .. v12}, Ld4;-><init>(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;I)V

    .line 196
    new-instance v1, Luq9;

    .line 198
    const/4 v2, 0x2

    .line 199
    invoke-direct {v1, v9, v2}, Luq9;-><init>(Lsq9;I)V

    .line 202
    new-instance v2, Lt62;

    .line 204
    const v3, -0x5def2447

    .line 207
    invoke-direct {v2, v1, v6, v3}, Lt62;-><init>(Ljava/lang/Object;ZI)V

    .line 210
    invoke-static {v0, v0, v7, v2}, Los8;->F(Lm9;Lm9;Lhv3;Lwv3;)V

    .line 213
    sget-object v0, Llp9;->a:Llp9;

    .line 215
    return-object v0

    .line 216
    :pswitch_d7  #0x11
    iget-object v1, v0, Lqi;->c:Ljava/lang/Object;

    .line 218
    check-cast v1, Lhv3;

    .line 220
    iget-object v2, v0, Lqi;->d:Ljava/lang/Object;

    .line 222
    check-cast v2, Lhv3;

    .line 224
    iget-object v3, v0, Lqi;->b:Ljava/lang/Object;

    .line 226
    check-cast v3, Le89;

    .line 228
    iget-object v0, v0, Lqi;->e:Ljava/lang/Object;

    .line 230
    check-cast v0, Lea9;

    .line 232
    move-object/from16 v4, p1

    .line 234
    check-cast v4, Lj69;

    .line 236
    invoke-interface {v1}, Lhv3;->v()Ljava/lang/Object;

    .line 239
    if-eqz v2, :cond_fa

    .line 241
    invoke-interface {v2}, Lhv3;->v()Ljava/lang/Object;

    .line 244
    move-result-object v1

    .line 245
    check-cast v1, Ljava/lang/Boolean;

    .line 247
    invoke-virtual {v1}, Ljava/lang/Boolean;->booleanValue()Z

    .line 250
    move-result v6

    .line 251
    :cond_fa
    if-eqz v6, :cond_ff

    .line 253
    invoke-interface {v4}, Lj69;->close()V

    .line 256
    :cond_ff
    invoke-virtual {v3, v0}, Le89;->y(Lea9;)V

    .line 259
    sget-object v0, Llp9;->a:Llp9;

    .line 261
    return-object v0

    .line 262
    :pswitch_105  #0x10
    iget-object v1, v0, Lqi;->c:Ljava/lang/Object;

    .line 264
    check-cast v1, Landroid/content/Context;

    .line 266
    iget-object v2, v0, Lqi;->d:Ljava/lang/Object;

    .line 268
    check-cast v2, Lex2;

    .line 270
    iget-object v3, v0, Lqi;->b:Ljava/lang/Object;

    .line 272
    check-cast v3, Lh64;

    .line 274
    iget-object v0, v0, Lqi;->e:Ljava/lang/Object;

    .line 276
    check-cast v0, Ltu;

    .line 278
    move-object/from16 v4, p1

    .line 280
    check-cast v4, Lur2;

    .line 282
    iget-object v5, v4, Lur2;->b:Loo9;

    .line 284
    const-string v6, "chat.deepseek.com"

    .line 286
    iput-object v6, v5, Loo9;->a:Ljava/lang/String;

    .line 288
    iget-object v0, v0, Ltu;->b:Lqo9;

    .line 290
    iput-object v0, v5, Loo9;->d:Lqo9;

    .line 292
    invoke-virtual {v5, v8}, Loo9;->d(I)V

    .line 295
    sget-object v0, Llp9;->a:Llp9;

    .line 297
    const-string v5, "x-client-platform"

    .line 299
    const-string v6, "android"

    .line 301
    invoke-static {v4, v5, v6}, Lpd5;->r(Lib4;Ljava/lang/String;Ljava/lang/Object;)V

    .line 304
    const-string v5, "x-client-version"

    .line 306
    const-string v6, "2.5.2"

    .line 308
    invoke-static {v4, v5, v6}, Lpd5;->r(Lib4;Ljava/lang/String;Ljava/lang/Object;)V

    .line 311
    const v5, 0x7f0f014a

    .line 314
    invoke-static {v1, v5}, Li52;->s0(Landroid/content/Context;I)Ljava/lang/String;

    .line 317
    move-result-object v1

    .line 318
    const-string v5, "x-client-locale"

    .line 320
    invoke-static {v4, v5, v1}, Lpd5;->r(Lib4;Ljava/lang/String;Ljava/lang/Object;)V

    .line 323
    const-string v1, "x-client-bundle-id"

    .line 325
    const-string v5, "com.deepseek.chat"

    .line 327
    invoke-static {v4, v1, v5}, Lpd5;->r(Lib4;Ljava/lang/String;Ljava/lang/Object;)V

    .line 330
    sget-object v1, Ldw;->a:Lnqa;

    .line 332
    invoke-virtual {v1}, Lnqa;->g()Ljava/lang/String;

    .line 335
    move-result-object v1

    .line 336
    const-string v5, "x-rangers-id"

    .line 338
    invoke-static {v4, v5, v1}, Lpd5;->r(Lib4;Ljava/lang/String;Ljava/lang/Object;)V

    .line 341
    sget-object v1, Lik5;->b:Ljava/lang/Integer;

    .line 343
    if-eqz v1, :cond_15d

    .line 345
    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    .line 348
    move-result v1

    .line 349
    goto :goto_18b

    .line 350
    :cond_15d
    sget-object v1, Lxb9;->Companion:Lwb9;

    .line 352
    invoke-virtual {v1}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    .line 355
    invoke-static {}, Lwb9;->a()Lxb9;

    .line 358
    move-result-object v1

    .line 359
    sget-object v5, Lsn4;->a:Lr12;

    .line 361
    invoke-interface {v5}, Lr12;->k()Lqn4;

    .line 364
    move-result-object v5

    .line 365
    iget-object v1, v1, Lxb9;->a:Lj$/time/ZoneId;

    .line 367
    invoke-virtual {v1}, Lj$/time/ZoneId;->getRules()Lj$/time/zone/ZoneRules;

    .line 370
    move-result-object v1

    .line 371
    iget-wide v6, v5, Lqn4;->a:J

    .line 373
    iget v5, v5, Lqn4;->b:I

    .line 375
    int-to-long v8, v5

    .line 376
    invoke-static {v6, v7, v8, v9}, Lj$/time/Instant;->ofEpochSecond(JJ)Lj$/time/Instant;

    .line 379
    move-result-object v5

    .line 380
    invoke-virtual {v1, v5}, Lj$/time/zone/ZoneRules;->getOffset(Lj$/time/Instant;)Lj$/time/ZoneOffset;

    .line 383
    move-result-object v1

    .line 384
    new-instance v5, Lcv9;

    .line 386
    invoke-virtual {v1}, Lj$/time/ZoneOffset;->getTotalSeconds()I

    .line 389
    move-result v1

    .line 390
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 393
    move-result-object v5

    .line 394
    sput-object v5, Lik5;->b:Ljava/lang/Integer;

    .line 396
    :goto_18b
    invoke-static {v1}, Ljava/lang/Integer;->valueOf(I)Ljava/lang/Integer;

    .line 399
    move-result-object v1

    .line 400
    const-string v5, "x-client-timezone-offset"

    .line 402
    invoke-static {v4, v5, v1}, Lpd5;->r(Lib4;Ljava/lang/String;Ljava/lang/Object;)V

    .line 405
    const-string v1, "x-device-model"

    .line 407
    sget-object v5, Landroid/os/Build;->MODEL:Ljava/lang/String;

    .line 409
    invoke-static {v4, v1, v5}, Lpd5;->r(Lib4;Ljava/lang/String;Ljava/lang/Object;)V

    .line 412
    invoke-virtual {v2}, Lex2;->b()Ljava/lang/String;

    .line 415
    move-result-object v1

    .line 416
    invoke-static {v1}, Llx8;->i0(Ljava/lang/CharSequence;)Z

    .line 419
    move-result v2

    .line 420
    if-nez v2, :cond_1aa

    .line 422
    const-string v2, "x-device-id"

    .line 424
    invoke-static {v4, v2, v1}, Lpd5;->r(Lib4;Ljava/lang/String;Ljava/lang/Object;)V

    .line 427
    :cond_1aa
    iget-object v1, v3, Lh64;->a:Ljava/lang/String;

    .line 429
    if-eqz v1, :cond_1b3

    .line 431
    const-string v2, "x-hif-dliq"

    .line 433
    invoke-static {v4, v2, v1}, Lpd5;->r(Lib4;Ljava/lang/String;Ljava/lang/Object;)V

    .line 436
    :cond_1b3
    iget-object v1, v3, Lh64;->b:Ljava/lang/String;

    .line 438
    if-eqz v1, :cond_1bc

    .line 440
    const-string v2, "x-hif-leim"

    .line 442
    invoke-static {v4, v2, v1}, Lpd5;->r(Lib4;Ljava/lang/String;Ljava/lang/Object;)V

    .line 445
    :cond_1bc
    return-object v0

    .line 446
    :pswitch_1bd  #0xf
    iget-object v1, v0, Lqi;->c:Ljava/lang/Object;

    .line 448
    check-cast v1, Lds1;

    .line 450
    iget-object v2, v0, Lqi;->d:Ljava/lang/Object;

    .line 452
    check-cast v2, Lg31;

    .line 454
    iget-object v3, v0, Lqi;->b:Ljava/lang/Object;

    .line 456
    check-cast v3, Lwv3;

    .line 458
    iget-object v0, v0, Lqi;->e:Ljava/lang/Object;

    .line 460
    check-cast v0, Ldb6;

    .line 462
    move-object/from16 v5, p1

    .line 464
    check-cast v5, Lxe4;

    .line 466
    invoke-interface {v1}, Lds1;->d()Landroid/graphics/Bitmap;

    .line 469
    move-result-object v9

    .line 470
    invoke-interface {v0}, Lns8;->getValue()Ljava/lang/Object;

    .line 473
    move-result-object v0

    .line 474
    move-object v10, v0

    .line 475
    check-cast v10, Lkj2;

    .line 477
    if-eqz v5, :cond_1ea

    .line 479
    :try_start_1de
    invoke-static {v5}, Lrn4;->h(Lxe4;)Landroid/graphics/Bitmap;

    .line 482
    move-result-object v0
    :try_end_1e2
    .catchall {:try_start_1de .. :try_end_1e2} :catchall_1e3

    .line 483
    goto :goto_1eb

    .line 484
    :catchall_1e3
    move-exception v0

    .line 485
    new-instance v5, Ltr7;

    .line 487
    invoke-direct {v5, v0}, Ltr7;-><init>(Ljava/lang/Throwable;)V

    .line 490
    goto :goto_1ec

    .line 491
    :cond_1ea
    const/4 v0, 0x0

    .line 492
    :goto_1eb
    move-object v5, v0

    .line 493
    :goto_1ec
    nop

    .line 494
    instance-of v0, v5, Ltr7;

    .line 496
    if-eqz v0, :cond_1f2

    .line 498
    const/4 v5, 0x0

    .line 499
    :cond_1f2
    check-cast v5, Landroid/graphics/Bitmap;

    .line 501
    if-eqz v10, :cond_293

    .line 503
    invoke-virtual {v10}, Lkj2;->m()F

    .line 506
    move-result v0

    .line 507
    float-to-int v0, v0

    .line 508
    const-string v10, "image_source_scene"

    .line 510
    const-string v11, "time_elapsed"

    .line 512
    const-string v12, "rotate_degrees"

    .line 514
    const-string v13, "raw_image_height"

    .line 516
    const-string v14, "raw_image_width"

    .line 518
    if-eqz v5, :cond_258

    .line 520
    invoke-virtual {v9}, Landroid/graphics/Bitmap;->getWidth()I

    .line 523
    move-result v15

    .line 524
    invoke-virtual {v9}, Landroid/graphics/Bitmap;->getHeight()I

    .line 527
    move-result v6

    .line 528
    invoke-virtual {v5}, Landroid/graphics/Bitmap;->getWidth()I

    .line 531
    move-result v8

    .line 532
    invoke-virtual {v5}, Landroid/graphics/Bitmap;->getHeight()I

    .line 535
    move-result v7

    .line 536
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    .line 539
    move-result-wide v17

    .line 540
    invoke-interface {v1}, Lds1;->c()J

    .line 543
    move-result-wide v19

    .line 544
    move-object/from16 v21, v1

    .line 546
    move-object/from16 v22, v2

    .line 548
    sub-long v1, v17, v19

    .line 550
    invoke-interface/range {v21 .. v21}, Lds1;->a()Ljava/lang/String;

    .line 553
    move-result-object v17

    .line 554
    move-object/from16 p0, v5

    .line 556
    invoke-virtual/range {v22 .. v22}, Lg31;->b()Ljava/lang/String;

    .line 559
    move-result-object v5

    .line 560
    long-to-int v1, v1

    .line 561
    invoke-static {v4, v15, v5, v14}, Los8;->z(Ljava/lang/String;ILjava/lang/String;Ljava/lang/String;)Lorg/json/JSONObject;

    .line 564
    move-result-object v2

    .line 565
    invoke-virtual {v2, v13, v6}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    .line 568
    const-string v4, "image_width"

    .line 570
    invoke-virtual {v2, v4, v8}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    .line 573
    const-string v4, "image_height"

    .line 575
    invoke-virtual {v2, v4, v7}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    .line 578
    invoke-virtual {v2, v12, v0}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    .line 581
    invoke-virtual {v2, v11, v1}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    .line 584
    if-nez v17, :cond_24b

    .line 586
    const/4 v7, 0x0

    .line 587
    goto :goto_24d

    .line 588
    :cond_24b
    move-object/from16 v7, v17

    .line 590
    :goto_24d
    invoke-virtual {v2, v10, v7}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 593
    sget-object v0, Ldw;->a:Lnqa;

    .line 595
    const-string v1, "image_edit_commit"

    .line 597
    invoke-virtual {v0, v1, v2}, Lnqa;->p(Ljava/lang/String;Lorg/json/JSONObject;)V

    .line 600
    goto :goto_295

    .line 601
    :cond_258
    move-object/from16 v21, v1

    .line 603
    move-object/from16 v22, v2

    .line 605
    move-object/from16 p0, v5

    .line 607
    invoke-virtual {v9}, Landroid/graphics/Bitmap;->getWidth()I

    .line 610
    move-result v1

    .line 611
    invoke-virtual {v9}, Landroid/graphics/Bitmap;->getHeight()I

    .line 614
    move-result v2

    .line 615
    invoke-static {}, Landroid/os/SystemClock;->elapsedRealtime()J

    .line 618
    move-result-wide v5

    .line 619
    invoke-interface/range {v21 .. v21}, Lds1;->c()J

    .line 622
    move-result-wide v7

    .line 623
    sub-long/2addr v5, v7

    .line 624
    invoke-interface/range {v21 .. v21}, Lds1;->a()Ljava/lang/String;

    .line 627
    move-result-object v7

    .line 628
    invoke-virtual/range {v22 .. v22}, Lg31;->b()Ljava/lang/String;

    .line 631
    move-result-object v8

    .line 632
    long-to-int v5, v5

    .line 633
    invoke-static {v4, v1, v8, v14}, Los8;->z(Ljava/lang/String;ILjava/lang/String;Ljava/lang/String;)Lorg/json/JSONObject;

    .line 636
    move-result-object v1

    .line 637
    invoke-virtual {v1, v13, v2}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    .line 640
    invoke-virtual {v1, v12, v0}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    .line 643
    invoke-virtual {v1, v11, v5}, Lorg/json/JSONObject;->put(Ljava/lang/String;I)Lorg/json/JSONObject;

    .line 646
    if-nez v7, :cond_288

    .line 648
    const/4 v7, 0x0

    .line 649
    :cond_288
    invoke-virtual {v1, v10, v7}, Lorg/json/JSONObject;->put(Ljava/lang/String;Ljava/lang/Object;)Lorg/json/JSONObject;

    .line 652
    sget-object v0, Ldw;->a:Lnqa;

    .line 654
    const-string v2, "image_edit_error"

    .line 656
    invoke-virtual {v0, v2, v1}, Lnqa;->p(Ljava/lang/String;Lorg/json/JSONObject;)V

    .line 659
    goto :goto_295

    .line 660
    :cond_293
    move-object/from16 p0, v5

    .line 662
    :goto_295
    if-nez p0, :cond_299

    .line 664
    const/4 v6, 0x1

    .line 665
    goto :goto_29a

    .line 666
    :cond_299
    const/4 v6, 0x0

    .line 667
    :goto_29a
    invoke-static {v6}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    .line 670
    move-result-object v0

    .line 671
    if-nez p0, :cond_2a1

    .line 673
    goto :goto_2a3

    .line 674
    :cond_2a1
    move-object/from16 v9, p0

    .line 676
    :goto_2a3
    invoke-interface {v3, v0, v9}, Lwv3;->q(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 679
    sget-object v0, Llp9;->a:Llp9;

    .line 681
    return-object v0

    .line 682
    :pswitch_2a9  #0xe
    iget-object v1, v0, Lqi;->c:Ljava/lang/Object;

    .line 684
    check-cast v1, Lil7;

    .line 686
    iget-object v2, v0, Lqi;->d:Ljava/lang/Object;

    .line 688
    check-cast v2, Lro0;

    .line 690
    iget-object v3, v0, Lqi;->b:Ljava/lang/Object;

    .line 692
    check-cast v3, Lzb4;

    .line 694
    iget-object v0, v0, Lqi;->e:Ljava/lang/Object;

    .line 696
    move-object v4, v0

    .line 697
    check-cast v4, Lag2;

    .line 699
    move-object/from16 v0, p1

    .line 701
    check-cast v0, Ljava/nio/ByteBuffer;

    .line 703
    :try_start_2be
    invoke-interface {v2, v0}, Ljava/nio/channels/ReadableByteChannel;->read(Ljava/nio/ByteBuffer;)I

    .line 706
    move-result v0
    :try_end_2c2
    .catchall {:try_start_2be .. :try_end_2c2} :catchall_2c7

    .line 707
    iput v0, v1, Lil7;->a:I

    .line 709
    sget-object v0, Llp9;->a:Llp9;

    .line 711
    return-object v0

    .line 712
    :catchall_2c7
    move-exception v0

    .line 713
    move-object v1, v0

    .line 714
    :try_start_2c9
    invoke-static {v4}, Lru0;->G(Lag2;)Lht4;

    .line 717
    move-result-object v0

    .line 718
    invoke-interface {v0}, Lht4;->v()Ljava/util/concurrent/CancellationException;

    .line 721
    move-result-object v0
    :try_end_2d1
    .catchall {:try_start_2c9 .. :try_end_2d1} :catchall_2d2

    .line 722
    goto :goto_2d9

    .line 723
    :catchall_2d2
    move-exception v0

    .line 724
    new-instance v2, Ltr7;

    .line 726
    invoke-direct {v2, v0}, Ltr7;-><init>(Ljava/lang/Throwable;)V

    .line 729
    move-object v0, v2

    .line 730
    :goto_2d9
    nop

    .line 731
    instance-of v2, v0, Ltr7;

    .line 733
    if-eqz v2, :cond_2e0

    .line 735
    const/4 v7, 0x0

    .line 736
    goto :goto_2e1

    .line 737
    :cond_2e0
    move-object v7, v0

    .line 738
    :goto_2e1
    check-cast v7, Ljava/util/concurrent/CancellationException;

    .line 740
    if-eqz v7, :cond_2e6

    .line 742
    move-object v1, v7

    .line 743
    :cond_2e6
    instance-of v0, v1, Ljava/net/SocketTimeoutException;

    .line 745
    if-eqz v0, :cond_2f0

    .line 747
    check-cast v1, Ljava/io/IOException;

    .line 749
    invoke-static {v3, v1}, Lxc4;->a(Lzb4;Ljava/io/IOException;)Ljava/net/SocketTimeoutException;

    .line 752
    move-result-object v1

    .line 753
    :cond_2f0
    throw v1

    .line 754
    :pswitch_2f1  #0xd
    iget-object v1, v0, Lqi;->c:Ljava/lang/Object;

    .line 756
    check-cast v1, Lhl7;

    .line 758
    iget-object v2, v0, Lqi;->d:Ljava/lang/Object;

    .line 760
    check-cast v2, Lo86;

    .line 762
    iget-object v3, v0, Lqi;->b:Ljava/lang/Object;

    .line 764
    check-cast v3, Ly18;

    .line 766
    iget-object v0, v0, Lqi;->e:Ljava/lang/Object;

    .line 768
    check-cast v0, Le7;

    .line 770
    move-object/from16 v4, p1

    .line 772
    check-cast v4, Lrl;

    .line 774
    sget-object v5, Llp9;->a:Llp9;

    .line 776
    iget-object v6, v4, Lrl;->e:Lnv6;

    .line 778
    invoke-virtual {v6}, Lnv6;->getValue()Ljava/lang/Object;

    .line 781
    move-result-object v6

    .line 782
    check-cast v6, Ljava/lang/Number;

    .line 784
    invoke-virtual {v6}, Ljava/lang/Number;->floatValue()F

    .line 787
    move-result v6

    .line 788
    iget v7, v1, Lhl7;->a:F

    .line 790
    sub-float/2addr v6, v7

    .line 791
    invoke-static {v6}, Li95;->j(F)Z

    .line 794
    move-result v7

    .line 795
    if-nez v7, :cond_331

    .line 797
    invoke-virtual {v2, v3, v6}, Lo86;->i(Ly18;F)F

    .line 800
    move-result v2

    .line 801
    sub-float v2, v6, v2

    .line 803
    invoke-static {v2}, Li95;->j(F)Z

    .line 806
    move-result v2

    .line 807
    if-nez v2, :cond_32c

    .line 809
    invoke-virtual {v4}, Lrl;->a()V

    .line 812
    goto :goto_346

    .line 813
    :cond_32c
    iget v2, v1, Lhl7;->a:F

    .line 815
    add-float/2addr v2, v6

    .line 816
    iput v2, v1, Lhl7;->a:F

    .line 818
    :cond_331
    iget v1, v1, Lhl7;->a:F

    .line 820
    invoke-static {v1}, Ljava/lang/Float;->valueOf(F)Ljava/lang/Float;

    .line 823
    move-result-object v1

    .line 824
    invoke-virtual {v0, v1}, Le7;->g(Ljava/lang/Object;)Ljava/lang/Object;

    .line 827
    move-result-object v0

    .line 828
    check-cast v0, Ljava/lang/Boolean;

    .line 830
    invoke-virtual {v0}, Ljava/lang/Boolean;->booleanValue()Z

    .line 833
    move-result v0

    .line 834
    if-eqz v0, :cond_346

    .line 836
    invoke-virtual {v4}, Lrl;->a()V

    .line 839
    :cond_346
    :goto_346
    return-object v5

    .line 840
    :pswitch_347  #0xc
    iget-object v1, v0, Lqi;->c:Ljava/lang/Object;

    .line 842
    check-cast v1, Lkl7;

    .line 844
    iget-object v2, v0, Lqi;->d:Ljava/lang/Object;

    .line 846
    check-cast v2, Ldb6;

    .line 848
    iget-object v3, v0, Lqi;->b:Ljava/lang/Object;

    .line 850
    check-cast v3, Lig2;

    .line 852
    iget-object v0, v0, Lqi;->e:Ljava/lang/Object;

    .line 854
    check-cast v0, Lca6;

    .line 856
    move-object/from16 v4, p1

    .line 858
    check-cast v4, Lyl6;

    .line 860
    invoke-interface {v2}, Lns8;->getValue()Ljava/lang/Object;

    .line 863
    move-result-object v2

    .line 864
    check-cast v2, Lsv3;

    .line 866
    invoke-interface {v2, v4}, Lsv3;->g(Ljava/lang/Object;)Ljava/lang/Object;

    .line 869
    iget-object v1, v1, Lkl7;->a:Ljava/lang/Object;

    .line 871
    check-cast v1, Lk87;

    .line 873
    if-eqz v1, :cond_374

    .line 875
    new-instance v2, Lf0;

    .line 877
    const/4 v4, 0x0

    .line 878
    invoke-direct {v2, v0, v1, v4, v5}, Lf0;-><init>(Lca6;Lk87;Lhf2;I)V

    .line 881
    const/4 v1, 0x0

    .line 882
    invoke-static {v3, v4, v1, v2, v5}, Lv9a;->P(Lig2;Lag2;ILwv3;I)Lwr8;

    .line 885
    :cond_374
    sget-object v0, Llp9;->a:Llp9;

    .line 887
    return-object v0

    .line 888
    :pswitch_377  #0xb
    iget-object v1, v0, Lqi;->c:Ljava/lang/Object;

    .line 890
    check-cast v1, Lig2;

    .line 892
    iget-object v2, v0, Lqi;->d:Ljava/lang/Object;

    .line 894
    move-object v7, v2

    .line 895
    check-cast v7, Lps8;

    .line 897
    iget-object v2, v0, Lqi;->b:Ljava/lang/Object;

    .line 899
    move-object v8, v2

    .line 900
    check-cast v8, Ljp8;

    .line 902
    iget-object v0, v0, Lqi;->e:Ljava/lang/Object;

    .line 904
    move-object v9, v0

    .line 905
    check-cast v9, Lyv5;

    .line 907
    move-object/from16 v0, p1

    .line 909
    check-cast v0, Ljz2;

    .line 911
    new-instance v6, Lzi4;

    .line 913
    const/4 v11, 0x7

    .line 914
    const/4 v10, 0x0

    .line 915
    invoke-direct/range {v6 .. v11}, Lzi4;-><init>(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;Lhf2;I)V

    .line 918
    const/4 v2, 0x0

    .line 919
    invoke-static {v1, v10, v2, v6, v5}, Lv9a;->P(Lig2;Lag2;ILwv3;I)Lwr8;

    .line 922
    move-result-object v0

    .line 923
    new-instance v1, Lmj;

    .line 925
    const/4 v2, 0x5

    .line 926
    invoke-direct {v1, v8, v9, v0, v2}, Lmj;-><init>(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;I)V

    .line 929
    return-object v1

    .line 930
    :pswitch_3a1  #0xa
    iget-object v1, v0, Lqi;->c:Ljava/lang/Object;

    .line 932
    check-cast v1, Lld5;

    .line 934
    iget-object v2, v0, Lqi;->d:Ljava/lang/Object;

    .line 936
    check-cast v2, Luc5;

    .line 938
    iget-object v4, v0, Lqi;->b:Ljava/lang/Object;

    .line 940
    check-cast v4, Lry8;

    .line 942
    iget-object v0, v0, Lqi;->e:Ljava/lang/Object;

    .line 944
    check-cast v0, Ly77;

    .line 946
    move-object/from16 v5, p1

    .line 948
    check-cast v5, Ljz2;

    .line 950
    new-instance v5, Lrwa;

    .line 952
    invoke-direct {v5}, Ljava/lang/Object;-><init>()V

    .line 955
    iput-object v2, v5, Lrwa;->b:Ljava/lang/Object;

    .line 957
    iput-object v4, v5, Lrwa;->c:Ljava/lang/Object;

    .line 959
    iput-object v0, v5, Lrwa;->d:Ljava/lang/Object;

    .line 961
    const/4 v2, 0x1

    .line 962
    iput-boolean v2, v5, Lrwa;->a:Z

    .line 964
    iput-object v5, v1, Lld5;->c:Lrwa;

    .line 966
    new-instance v0, Lg7;

    .line 968
    invoke-direct {v0, v3, v1}, Lg7;-><init>(ILjava/lang/Object;)V

    .line 971
    return-object v0

    .line 972
    :pswitch_3cb  #0x9
    iget-object v1, v0, Lqi;->c:Ljava/lang/Object;

    .line 974
    check-cast v1, Ldb6;

    .line 976
    iget-object v2, v0, Lqi;->d:Ljava/lang/Object;

    .line 978
    check-cast v2, Ldl4;

    .line 980
    iget-object v3, v0, Lqi;->b:Ljava/lang/Object;

    .line 982
    check-cast v3, Lhl7;

    .line 984
    iget-object v0, v0, Lqi;->e:Ljava/lang/Object;

    .line 986
    check-cast v0, Lig2;

    .line 988
    move-object/from16 v4, p1

    .line 990
    check-cast v4, Ljava/lang/Long;

    .line 992
    invoke-virtual {v4}, Ljava/lang/Long;->longValue()J

    .line 995
    move-result-wide v4

    .line 996
    invoke-interface {v1}, Lns8;->getValue()Ljava/lang/Object;

    .line 999
    move-result-object v1

    .line 1000
    check-cast v1, Lns8;

    .line 1002
    if-eqz v1, :cond_3f6

    .line 1004
    invoke-interface {v1}, Lns8;->getValue()Ljava/lang/Object;

    .line 1007
    move-result-object v1

    .line 1008
    check-cast v1, Ljava/lang/Number;

    .line 1010
    invoke-virtual {v1}, Ljava/lang/Number;->longValue()J

    .line 1013
    move-result-wide v6

    .line 1014
    goto :goto_3f7

    .line 1015
    :cond_3f6
    move-wide v6, v4

    .line 1016
    :goto_3f7
    iget-wide v8, v2, Ldl4;->c:J

    .line 1018
    iget-object v1, v2, Ldl4;->a:Lfb6;

    .line 1020
    const-wide/high16 v10, -0x8000000000000000L

    .line 1022
    cmp-long v8, v8, v10

    .line 1024
    if-eqz v8, :cond_410

    .line 1026
    iget v8, v3, Lhl7;->a:F

    .line 1028
    invoke-interface {v0}, Lig2;->getCoroutineContext()Lag2;

    .line 1031
    move-result-object v9

    .line 1032
    invoke-static {v9}, Lge5;->I(Lag2;)F

    .line 1035
    move-result v9

    .line 1036
    cmpg-float v8, v8, v9

    .line 1038
    if-nez v8, :cond_410

    .line 1040
    goto :goto_42d

    .line 1041
    :cond_410
    iput-wide v4, v2, Ldl4;->c:J

    .line 1043
    iget-object v4, v1, Lfb6;->a:[Ljava/lang/Object;

    .line 1045
    iget v5, v1, Lfb6;->c:I

    .line 1047
    const/4 v8, 0x0

    .line 1048
    :goto_417
    if-ge v8, v5, :cond_423

    .line 1050
    aget-object v9, v4, v8

    .line 1052
    check-cast v9, Lbl4;

    .line 1054
    const/4 v10, 0x1

    .line 1055
    iput-boolean v10, v9, Lbl4;->f:Z

    .line 1057
    add-int/lit8 v8, v8, 0x1

    .line 1059
    goto :goto_417

    .line 1060
    :cond_423
    invoke-interface {v0}, Lig2;->getCoroutineContext()Lag2;

    .line 1063
    move-result-object v0

    .line 1064
    invoke-static {v0}, Lge5;->I(Lag2;)F

    .line 1067
    move-result v0

    .line 1068
    iput v0, v3, Lhl7;->a:F

    .line 1070
    :goto_42d
    iget v0, v3, Lhl7;->a:F

    .line 1072
    const/4 v3, 0x0

    .line 1073
    cmpg-float v3, v0, v3

    .line 1075
    if-nez v3, :cond_44e

    .line 1077
    iget-object v0, v1, Lfb6;->a:[Ljava/lang/Object;

    .line 1079
    iget v1, v1, Lfb6;->c:I

    .line 1081
    const/4 v8, 0x0

    .line 1082
    :goto_439
    if-ge v8, v1, :cond_4a5

    .line 1084
    aget-object v2, v0, v8

    .line 1086
    check-cast v2, Lbl4;

    .line 1088
    iget-object v3, v2, Lbl4;->d:Lm49;

    .line 1090
    iget-object v3, v3, Lm49;->c:Ljava/lang/Object;

    .line 1092
    iget-object v4, v2, Lbl4;->c:Lnv6;

    .line 1094
    invoke-virtual {v4, v3}, Lnv6;->setValue(Ljava/lang/Object;)V

    .line 1097
    const/4 v10, 0x1

    .line 1098
    iput-boolean v10, v2, Lbl4;->f:Z

    .line 1100
    add-int/lit8 v8, v8, 0x1

    .line 1102
    goto :goto_439

    .line 1103
    :cond_44e
    iget-wide v3, v2, Ldl4;->c:J

    .line 1105
    sub-long/2addr v6, v3

    .line 1106
    long-to-float v3, v6

    .line 1107
    div-float/2addr v3, v0

    .line 1108
    float-to-long v3, v3

    .line 1109
    iget-object v0, v1, Lfb6;->a:[Ljava/lang/Object;

    .line 1111
    iget v1, v1, Lfb6;->c:I

    .line 1113
    const/4 v5, 0x1

    .line 1114
    const/4 v6, 0x0

    .line 1115
    :goto_45a
    if-ge v6, v1, :cond_498

    .line 1117
    aget-object v7, v0, v6

    .line 1119
    check-cast v7, Lbl4;

    .line 1121
    iget-boolean v8, v7, Lbl4;->e:Z

    .line 1123
    if-nez v8, :cond_490

    .line 1125
    iget-object v8, v7, Lbl4;->h:Ldl4;

    .line 1127
    iget-object v8, v8, Ldl4;->b:Lnv6;

    .line 1129
    sget-object v9, Ljava/lang/Boolean;->FALSE:Ljava/lang/Boolean;

    .line 1131
    invoke-virtual {v8, v9}, Lnv6;->setValue(Ljava/lang/Object;)V

    .line 1134
    iget-boolean v8, v7, Lbl4;->f:Z

    .line 1136
    if-eqz v8, :cond_476

    .line 1138
    const/4 v8, 0x0

    .line 1139
    iput-boolean v8, v7, Lbl4;->f:Z

    .line 1141
    iput-wide v3, v7, Lbl4;->g:J

    .line 1143
    :cond_476
    iget-wide v8, v7, Lbl4;->g:J

    .line 1145
    sub-long v8, v3, v8

    .line 1147
    iget-object v10, v7, Lbl4;->d:Lm49;

    .line 1149
    invoke-virtual {v10, v8, v9}, Lm49;->g(J)Ljava/lang/Object;

    .line 1152
    move-result-object v10

    .line 1153
    iget-object v11, v7, Lbl4;->c:Lnv6;

    .line 1155
    invoke-virtual {v11, v10}, Lnv6;->setValue(Ljava/lang/Object;)V

    .line 1158
    iget-object v10, v7, Lbl4;->d:Lm49;

    .line 1160
    invoke-virtual {v10}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    .line 1163
    invoke-static {v10, v8, v9}, Los8;->g(Lol;J)Z

    .line 1166
    move-result v8

    .line 1167
    iput-boolean v8, v7, Lbl4;->e:Z

    .line 1169
    :cond_490
    iget-boolean v7, v7, Lbl4;->e:Z

    .line 1171
    if-nez v7, :cond_495

    .line 1173
    const/4 v5, 0x0

    .line 1174
    :cond_495
    add-int/lit8 v6, v6, 0x1

    .line 1176
    goto :goto_45a

    .line 1177
    :cond_498
    const/16 v16, 0x1

    .line 1179
    xor-int/lit8 v0, v5, 0x1

    .line 1181
    iget-object v1, v2, Ldl4;->d:Lnv6;

    .line 1183
    invoke-static {v0}, Ljava/lang/Boolean;->valueOf(Z)Ljava/lang/Boolean;

    .line 1186
    move-result-object v0

    .line 1187
    invoke-virtual {v1, v0}, Lnv6;->setValue(Ljava/lang/Object;)V

    .line 1190
    :cond_4a5
    sget-object v0, Llp9;->a:Llp9;

    .line 1192
    return-object v0

    .line 1193
    :pswitch_4a8  #0x8
    iget-object v1, v0, Lqi;->c:Ljava/lang/Object;

    .line 1195
    check-cast v1, Lig2;

    .line 1197
    iget-object v2, v0, Lqi;->d:Ljava/lang/Object;

    .line 1199
    move-object v8, v2

    .line 1200
    check-cast v8, Lkj2;

    .line 1202
    iget-object v2, v0, Lqi;->b:Ljava/lang/Object;

    .line 1204
    move-object v9, v2

    .line 1205
    check-cast v9, Lwv3;

    .line 1207
    iget-object v0, v0, Lqi;->e:Ljava/lang/Object;

    .line 1209
    move-object v10, v0

    .line 1210
    check-cast v10, Ljl7;

    .line 1212
    move-object/from16 v7, p1

    .line 1214
    check-cast v7, Ljava/util/List;

    .line 1216
    new-instance v6, Lz4;

    .line 1218
    const/4 v11, 0x0

    .line 1219
    const/16 v12, 0x17

    .line 1221
    invoke-direct/range {v6 .. v12}, Lz4;-><init>(Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;Ljava/lang/Object;Lhf2;I)V

    .line 1224
    const/4 v2, 0x0

    .line 1225
    const/4 v4, 0x0

    .line 1226
    invoke-static {v1, v4, v2, v6, v5}, Lv9a;->P(Lig2;Lag2;ILwv3;I)Lwr8;

    .line 1229
    sget-object v0, Llp9;->a:Llp9;

    .line 1231
    return-object v0

    .line 1232
    :pswitch_4cf  #0x7
    iget-object v1, v0, Lqi;->c:Ljava/lang/Object;

    .line 1234
    check-cast v1, Lig2;

    .line 1236
    iget-object v2, v0, Lqi;->d:Ljava/lang/Object;

    .line 1238
    move-object v7, v2

    .line 1239
    check-cast v7, Lvi2;

    .line 1241
    iget-object v2, v0, Lqi;->b:Ljava/lang/Object;

    .line 1243
","startLine":0,"startColumn":0,"endLine":2000,"endColumn":0,"lineTruncated":false,"absoluteStartLine":89,"absoluteEndLine":2089},"pagination":{"hasMore":true,"nextCursor":"Aw7QD9APBARMcWk7J2coTGphdmEvbGFuZy9PYmplY3Q7KUxqYXZhL2xhbmcvT2JqZWN0OwHYrQPQDwBfiA","returnedCount":2000,"limitMax":2000,"totalAvailableCount":2884}},"error":null,"nextActions":[{"tool":"mt_apk_continue","purpose":"continue","description":"Continue reading next page","arguments":{"workspaceId":"smjygppz","editSessionId":"","nextCursor":"Aw7QD9APBARMcWk7J2coTGphdmEvbGFuZy9PYmplY3Q7KUxqYXZhL2xhbmcvT2JqZWN0OwHYrQPQDwBfiA","limit":2000}}]}