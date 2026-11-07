.class public final Lcom/nidyaber/fuckdsmanger/bridge/GmFileCardProbe;
.super Ljava/lang/Object;
.source "GmFileCardProbe.java"


# static fields
.field private static final FILE_HINTS:[Ljava/lang/String;

.field private static final MAX_PER_TAG:I = 0xf


# direct methods
.method static constructor <clinit>()V
    .registers 9

    .line 45
    const-string v7, "signed_path"

    const-string v8, "fetch_files"

    const-string v0, "file-"

    const-string v1, ".txt"

    const-string v2, ".pdf"

    const-string v3, ".docx"

    const-string v4, ".md"

    const-string v5, "is_image"

    const-string v6, "file_name"

    filled-new-array/range {v0 .. v8}, [Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmFileCardProbe;->FILE_HINTS:[Ljava/lang/String;

    return-void
.end method

.method private constructor <init>()V
    .registers 1

    .line 39
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method static synthetic access$000([Ljava/lang/Object;)Ljava/lang/String;
    .registers 1

    .line 37
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmFileCardProbe;->dump([Ljava/lang/Object;)Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static dump([Ljava/lang/Object;)Ljava/lang/String;
    .registers 10

    if-nez p0, :cond_5

    .line 85
    const-string p0, "args=null"

    return-object p0

    .line 86
    :cond_5
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "n="

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    array-length v1, p0

    invoke-virtual {v0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    .line 87
    array-length v1, p0

    const/16 v2, 0x8

    invoke-static {v1, v2}, Ljava/lang/Math;->min(II)I

    move-result v1

    const/4 v2, 0x0

    move v3, v2

    :goto_19
    if-ge v3, v1, :cond_98

    .line 89
    aget-object v4, p0, v3

    .line 90
    const-string v5, " |"

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v5, "="

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    if-nez v4, :cond_32

    .line 92
    const-string v4, "null"

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    goto :goto_95

    .line 95
    :cond_32
    invoke-virtual {v4}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v5

    invoke-virtual {v5}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 98
    :try_start_3d
    invoke-static {v4}, Ljava/lang/String;->valueOf(Ljava/lang/Object;)Ljava/lang/String;

    move-result-object v4
    :try_end_41
    .catchall {:try_start_3d .. :try_end_41} :catchall_42

    goto :goto_44

    .line 100
    :catchall_42
    const-string v4, "<toString \u629b\u4e86>"

    .line 102
    :goto_44
    invoke-virtual {v4}, Ljava/lang/String;->length()I

    move-result v5

    const/16 v6, 0x96

    if-le v5, v6, :cond_61

    new-instance v5, Ljava/lang/StringBuilder;

    invoke-direct {v5}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v4, v2, v6}, Ljava/lang/String;->substring(II)Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, "\u2026"

    invoke-virtual {v5, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    :cond_61
    const/16 v5, 0xa

    const/16 v6, 0x20

    .line 103
    invoke-virtual {v4, v5, v6}, Ljava/lang/String;->replace(CC)Ljava/lang/String;

    move-result-object v4

    const/16 v5, 0xd

    invoke-virtual {v4, v5, v6}, Ljava/lang/String;->replace(CC)Ljava/lang/String;

    move-result-object v4

    .line 105
    sget-object v5, Lcom/nidyaber/fuckdsmanger/bridge/GmFileCardProbe;->FILE_HINTS:[Ljava/lang/String;

    array-length v6, v5

    move v7, v2

    :goto_73
    if-ge v7, v6, :cond_83

    aget-object v8, v5, v7

    .line 106
    invoke-virtual {v4, v8}, Ljava/lang/String;->contains(Ljava/lang/CharSequence;)Z

    move-result v8

    if-eqz v8, :cond_80

    .line 111
    const-string v5, " \u2605"

    goto :goto_85

    :cond_80
    add-int/lit8 v7, v7, 0x1

    goto :goto_73

    :cond_83
    const-string v5, " "

    :goto_85
    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v5, "{"

    invoke-virtual {v0, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v4, "}"

    invoke-virtual {v0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    :goto_95
    add-int/lit8 v3, v3, 0x1

    goto :goto_19

    .line 113
    :cond_98
    array-length v2, p0

    if-le v2, v1, :cond_aa

    const-string v2, " ...(\u8fd8\u6709 "

    invoke-virtual {v0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    array-length p0, p0

    sub-int/2addr p0, v1

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, " \u4e2a\u53c2\u6570)"

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 114
    :cond_aa
    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    return-object p0
.end method

.method private static hook(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .registers 10

    .line 59
    const-string v0, "."

    .line 0
    const-string v1, "probe OK "

    .line 59
    :try_start_4
    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmRemap;->cls(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 60
    invoke-static {p1, p2}, Lcom/nidyaber/fuckdsmanger/bridge/GmRemap;->method(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    .line 61
    invoke-static {v2, p0}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object p0

    const/4 v4, 0x0

    .line 63
    filled-new-array {v4}, [I

    move-result-object v4

    .line 64
    new-instance v5, Lcom/nidyaber/fuckdsmanger/bridge/GmFileCardProbe$1;

    invoke-direct {v5, v4, p3}, Lcom/nidyaber/fuckdsmanger/bridge/GmFileCardProbe$1;-><init>([ILjava/lang/String;)V

    invoke-static {p0, v3, v5}, Lde/robv/android/xposed/XposedBridge;->hookAllMethods(Ljava/lang/Class;Ljava/lang/String;Lde/robv/android/xposed/XC_MethodHook;)Ljava/util/Set;

    .line 76
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " \u2192 "

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_3a
    .catchall {:try_start_4 .. :try_end_3a} :catchall_3b

    return-void

    :catchall_3b
    move-exception p0

    .line 79
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "probe FAIL "

    invoke-direct {v1, v2}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p3, " ("

    invoke-virtual {v1, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, ") \u2192 "

    invoke-virtual {v1, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v1, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v1}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    return-void
.end method

.method public static install(Ljava/lang/ClassLoader;)V
    .registers 4

    .line 52
    const-string v0, "a"

    const-string v1, "[FP/list]"

    const-string v2, "h91"

    invoke-static {p0, v2, v0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmFileCardProbe;->hook(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 53
    const-string v0, "c"

    const-string v1, "[FP/unit]"

    const-string v2, "pn9"

    invoke-static {p0, v2, v0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmFileCardProbe;->hook(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 54
    const-string v0, "isEmpty"

    const-string v1, "[FP/render]"

    const-string v2, "hp8"

    invoke-static {p0, v2, v0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmFileCardProbe;->hook(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    return-void
.end method
