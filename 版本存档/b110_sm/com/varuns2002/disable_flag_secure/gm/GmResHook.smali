.class public final Lcom/varuns2002/disable_flag_secure/gm/GmResHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmResHook.java"


# direct methods
.method public constructor <init>()V
    .registers 1

    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method


# virtual methods
.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 4

    sget v0, Lcom/varuns2002/disable_flag_secure/gm/GmEntry;->sTitleId:I

    if-eqz v0, :cond_14

    iget-object v1, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    const/4 p0, 0x0

    aget-object v1, v1, p0

    check-cast v1, Ljava/lang/Integer;

    invoke-virtual {v1}, Ljava/lang/Integer;->intValue()I

    move-result v1

    if-ne v1, v0, :cond_14

    invoke-static {}, Lcom/varuns2002/disable_flag_secure/gm/GmEntry;->tick()V

    :cond_14
    return-void
.end method
