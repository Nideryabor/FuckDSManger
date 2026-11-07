.class Lcom/nidyaber/fuckdsmanger/bridge/GmMusicLogin$1;
.super Ljava/lang/Object;
.source "GmMusicLogin.java"

# interfaces
.implements Ljava/lang/Runnable;


# annotations
.annotation system Ldalvik/annotation/EnclosingMethod;
    value = Lcom/nidyaber/fuckdsmanger/bridge/GmMusicLogin;->apply(Landroid/content/Context;)V
.end annotation

.annotation system Ldalvik/annotation/InnerClass;
    accessFlags = 0x0
    name = null
.end annotation


# direct methods
.method constructor <init>()V
    .registers 1

    .line 157
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method


# virtual methods
.method public run()V
    .registers 9

    .line 161
    const-string p0, "code"

    const-string v0, ""

    .line 0
    const-string v1, "\u3010MusicLogin\u3011\u51ed\u8bc1\u6709\u6548 \u2713 \u6635\u79f0=["

    const-string v2, "\u3010MusicLogin\u3011\u26a0\ufe0f \u51ed\u8bc1\u53ef\u80fd\u5df2\u5931\u6548\uff08code="

    .line 161
    :try_start_8
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->loginStatus()Ljava/util/Map;

    move-result-object v3

    .line 162
    invoke-interface {v3, p0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v4

    instance-of v4, v4, Ljava/lang/Number;

    if-eqz v4, :cond_1f

    .line 163
    invoke-interface {v3, p0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    check-cast p0, Ljava/lang/Number;

    invoke-virtual {p0}, Ljava/lang/Number;->longValue()J

    move-result-wide v4

    goto :goto_21

    :cond_1f
    const-wide/16 v4, -0x1

    :goto_21
    const-wide/16 v6, 0xc8

    cmp-long p0, v4, v6

    if-nez p0, :cond_8e

    .line 165
    const-string p0, "nick"

    invoke-interface {v3, p0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    .line 167
    const-string p0, "raw"

    invoke-interface {v3, p0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->asObj(Ljava/lang/Object;)Ljava/util/Map;

    move-result-object p0
    :try_end_36
    .catchall {:try_start_8 .. :try_end_36} :catchall_b1

    .line 171
    :try_start_36
    const-string v2, "profile"

    invoke-static {p0, v2}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->sub(Ljava/lang/Object;Ljava/lang/String;)Ljava/util/Map;

    move-result-object p0

    if-eqz p0, :cond_55

    .line 173
    const-string v2, "nickname"

    invoke-static {p0, v2, v0}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->str(Ljava/lang/Object;Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2
    :try_end_44
    .catchall {:try_start_36 .. :try_end_44} :catchall_57

    .line 174
    :try_start_44
    const-string v3, "userId"

    const-wide/16 v4, 0x0

    invoke-static {p0, v3, v4, v5}, Lcom/nidyaber/fuckdsmanger/music/GmMusicJson;->lng(Ljava/lang/Object;Ljava/lang/String;J)J

    move-result-wide v6

    cmp-long p0, v6, v4

    if-lez p0, :cond_58

    .line 175
    invoke-static {v6, v7}, Ljava/lang/String;->valueOf(J)Ljava/lang/String;

    move-result-object p0
    :try_end_54
    .catchall {:try_start_44 .. :try_end_54} :catchall_58

    goto :goto_59

    :cond_55
    move-object p0, v0

    goto :goto_5a

    :catchall_57
    move-object v2, v0

    :catchall_58
    :cond_58
    move-object p0, v0

    :goto_59
    move-object v0, v2

    .line 179
    :goto_5a
    :try_start_5a
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "] uid=["

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, "]"

    invoke-virtual {v2, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    .line 180
    invoke-virtual {v0}, Ljava/lang/String;->length()I

    move-result v1

    if-gtz v1, :cond_82

    invoke-virtual {p0}, Ljava/lang/String;->length()I

    move-result v1

    if-lez v1, :cond_c3

    .line 181
    :cond_82
    # getter for: Lcom/nidyaber/fuckdsmanger/bridge/GmMusicLogin;->sApp:Landroid/content/Context;
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicLogin;->access$000()Landroid/content/Context;

    move-result-object v1

    invoke-static {}, Lcom/nidyaber/fuckdsmanger/music/GmMusicApi;->login()Ljava/lang/String;

    move-result-object v2

    invoke-static {v1, v2, p0, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmMusicLogin;->save(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)Z

    goto :goto_c3

    .line 184
    :cond_8e
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0, v4, v5}, Ljava/lang/StringBuilder;->append(J)Ljava/lang/StringBuilder;

    const-string v0, " msg="

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, "msg"

    .line 185
    invoke-interface {v3, v0}, Ljava/util/Map;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v0

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    const-string v0, "\uff09"

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    .line 184
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_b0
    .catchall {:try_start_5a .. :try_end_b0} :catchall_b1

    goto :goto_c3

    :catchall_b1
    move-exception p0

    .line 188
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "\u3010MusicLogin\u3011\u9a8c\u8bc1\u51ed\u8bc1\u5931\u8d25\uff1a"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    :cond_c3
    :goto_c3
    return-void
.end method
