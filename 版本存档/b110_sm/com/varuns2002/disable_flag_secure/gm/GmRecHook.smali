.class public final Lcom/varuns2002/disable_flag_secure/gm/GmRecHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmRecHook.java"


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 4

    :try_start_0
    iget-object v0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->method:Ljava/lang/reflect/Member;

    invoke-interface {v0}, Ljava/lang/reflect/Member;->getName()Ljava/lang/String;

    move-result-object v0

    new-instance v1, Ljava/lang/StringBuilder;

    invoke-direct {v1}, Ljava/lang/StringBuilder;-><init>()V

    const-string p0, "[\u901a\u8bdd][\u5f55\u97f3] AudioRecord."

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    invoke-static {v1}, Lcom/varuns2002/disable_flag_secure/gm/GmUtil;->log(Ljava/lang/String;)V

    const-string p0, "startRecording"

    invoke-virtual {v0, p0}, Ljava/lang/String;->equals(Ljava/lang/Object;)Z

    move-result p0

    if-eqz p0, :cond_28

    const-string p0, "\u8046\u542c\u4e2d\u2026"

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->stat(Ljava/lang/String;)V

    goto :goto_2d

    :cond_28
    const-string p0, "\u8bc6\u522b\u4e2d\u2026"

    invoke-static {p0}, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->stat(Ljava/lang/String;)V
    :try_end_2d
    .catchall {:try_start_0 .. :try_end_2d} :catchall_2d

    :catchall_2d
    :goto_2d
    return-void
.end method
