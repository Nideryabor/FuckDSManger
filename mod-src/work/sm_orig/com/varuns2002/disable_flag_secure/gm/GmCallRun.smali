.class public final Lcom/varuns2002/disable_flag_secure/gm/GmCallRun;
.super Ljava/lang/Object;
.source "GmCallRun.java"

# interfaces
.implements Ljava/lang/Runnable;


# instance fields
.field private a:I

.field private b:Ljava/lang/String;


# direct methods
.method public constructor <init>(ILjava/lang/String;)V
    .registers 3

    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    iput p1, p0, Lcom/varuns2002/disable_flag_secure/gm/GmCallRun;->a:I

    iput-object p2, p0, Lcom/varuns2002/disable_flag_secure/gm/GmCallRun;->b:Ljava/lang/String;

    return-void
.end method


# virtual methods
.method public run()V
    .registers 3

    iget v0, p0, Lcom/varuns2002/disable_flag_secure/gm/GmCallRun;->a:I

    iget-object v1, p0, Lcom/varuns2002/disable_flag_secure/gm/GmCallRun;->b:Ljava/lang/String;

    invoke-static {v0, v1}, Lcom/varuns2002/disable_flag_secure/gm/GmCallDialog;->apply(ILjava/lang/String;)V

    return-void
.end method
