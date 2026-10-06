.class public final Lcom/varuns2002/disable_flag_secure/gm/GmBg;
.super Ljava/lang/Object;

.method private static clearBg(Landroid/app/Activity;)V
    .registers 6

    :try_start_0
    const-string v1, "[背景] ensure 走到挂载后：开始清 View 层背景"

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    invoke-virtual {p0}, Landroid/app/Activity;->getWindow()Landroid/view/Window;

    move-result-object v0

    if-nez v0, :end

    const/4 v1, 0x0

    invoke-virtual {v0, v1}, Landroid/view/Window;->setBackgroundDrawable(Landroid/graphics/drawable/Drawable;)V

    invoke-virtual {v0}, Landroid/view/Window;->getDecorView()Landroid/view/View;

    move-result-object v0

    instance-of v1, v0, Landroid/view/ViewGroup;

    if-eqz v1, :end

    check-cast v0, Landroid/view/ViewGroup;

    invoke-static {v0}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->clearBgGroup(Landroid/view/ViewGroup;)V

    :end
    return-void
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    :catchall_0
    move-exception v0

    return-void
.end method

.method private static clearBgGroup(Landroid/view/ViewGroup;)V
    .registers 6

    :try_start_0
    const/4 v0, 0x0

    :loop
    invoke-virtual {p0}, Landroid/view/ViewGroup;->getChildCount()I

    move-result v1

    if-ge v0, v1, :end

    invoke-virtual {p0, v0}, Landroid/view/ViewGroup;->getChildAt(I)Landroid/view/View;

    move-result-object v2

    if-eqz v2, :next

    const/4 v3, 0x0

    invoke-virtual {v2, v3}, Landroid/view/View;->setBackground(Landroid/graphics/drawable/Drawable;)V

    instance-of v3, v2, Landroid/view/ViewGroup;

    if-eqz v3, :next

    check-cast v2, Landroid/view/ViewGroup;

    invoke-static {v2}, Lcom/varuns2002/disable_flag_secure/gm/GmBg;->clearBgGroup(Landroid/view/ViewGroup;)V

    :next
    add-int/lit8 v0, v0, 0x1

    goto :loop

    :end
    return-void
    :try_end_0
    .catchall {:try_start_0 .. :try_end_0} :catchall_0

    :catchall_0
    move-exception v0

    return-void
.end method
