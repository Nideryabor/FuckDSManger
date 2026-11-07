.class Lcom/nidyaber/fuckdsmanger/bridge/GmSender$1;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmSender.java"


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->install(Ljava/lang/ClassLoader;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# direct methods
.method constructor <init>()V
    .registers 1

    .line 220
    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected afterHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 4

    .line 224
    :try_start_0
    iget-object p0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;

    if-nez p0, :cond_5

    goto :goto_61

    .line 226
    :cond_5
    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->sInst:Ljava/util/ArrayList;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->access$000()Ljava/util/ArrayList;

    move-result-object p1

    monitor-enter p1
    :try_end_a
    .catchall {:try_start_0 .. :try_end_a} :catchall_61

    .line 228
    :try_start_a
    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->sInst:Ljava/util/ArrayList;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->access$000()Ljava/util/ArrayList;

    move-result-object v0

    invoke-virtual {v0}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object v0

    .line 229
    :cond_12
    invoke-interface {v0}, Ljava/util/Iterator;->hasNext()Z

    move-result v1

    if-eqz v1, :cond_26

    .line 230
    invoke-interface {v0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v1

    check-cast v1, Ljava/lang/ref/WeakReference;

    invoke-virtual {v1}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v1

    if-ne v1, p0, :cond_12

    monitor-exit p1

    return-void

    .line 232
    :cond_26
    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->sInst:Ljava/util/ArrayList;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->access$000()Ljava/util/ArrayList;

    move-result-object v0

    new-instance v1, Ljava/lang/ref/WeakReference;

    invoke-direct {v1, p0}, Ljava/lang/ref/WeakReference;-><init>(Ljava/lang/Object;)V

    invoke-virtual {v0, v1}, Ljava/util/ArrayList;->add(Ljava/lang/Object;)Z

    .line 233
    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->sInst:Ljava/util/ArrayList;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->access$000()Ljava/util/ArrayList;

    move-result-object p0

    invoke-virtual {p0}, Ljava/util/ArrayList;->size()I

    move-result p0

    const/16 v0, 0x10

    if-le p0, v0, :cond_5c

    .line 235
    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->sInst:Ljava/util/ArrayList;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmSender;->access$000()Ljava/util/ArrayList;

    move-result-object p0

    invoke-virtual {p0}, Ljava/util/ArrayList;->iterator()Ljava/util/Iterator;

    move-result-object p0

    .line 236
    :cond_46
    :goto_46
    invoke-interface {p0}, Ljava/util/Iterator;->hasNext()Z

    move-result v0

    if-eqz v0, :cond_5c

    .line 237
    invoke-interface {p0}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v0

    check-cast v0, Ljava/lang/ref/WeakReference;

    invoke-virtual {v0}, Ljava/lang/ref/WeakReference;->get()Ljava/lang/Object;

    move-result-object v0

    if-nez v0, :cond_46

    invoke-interface {p0}, Ljava/util/Iterator;->remove()V

    goto :goto_46

    .line 240
    :cond_5c
    monitor-exit p1

    return-void

    :catchall_5e
    move-exception p0

    monitor-exit p1
    :try_end_60
    .catchall {:try_start_a .. :try_end_60} :catchall_5e

    :try_start_60
    throw p0
    :try_end_61
    .catchall {:try_start_60 .. :try_end_61} :catchall_61

    :catchall_61
    :goto_61
    return-void
.end method
