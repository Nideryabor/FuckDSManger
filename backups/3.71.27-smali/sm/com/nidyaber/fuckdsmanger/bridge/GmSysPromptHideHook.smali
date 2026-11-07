.class public final Lcom/nidyaber/fuckdsmanger/bridge/GmSysPromptHideHook;
.super Lde/robv/android/xposed/XC_MethodHook;
.source "GmSysPromptHideHook.java"


# annotations
.annotation system Ldalvik/annotation/MemberClasses;
    value = {
        Lcom/nidyaber/fuckdsmanger/bridge/GmSysPromptHideHook$RetHook;
    }
.end annotation


# static fields
.field private static final ANNOTATED_STRING_CANDS:[Ljava/lang/String;

.field private static final MAX_ARGS:I = 0x10

.field private static final MAX_DEPTH:I = 0x4

.field private static final MAX_FIELDS:I = 0x28

.field private static final MAX_ITEMS:I = 0x3c

.field private static final SKIP_PKG:[Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .registers 12

    .line 55
    const-string v10, "androidx.collection."

    const-string v11, "androidx.compose.foundation.layout."

    const-string v0, "java."

    const-string v1, "javax."

    const-string v2, "kotlin."

    const-string v3, "kotlinx.coroutines"

    const-string v4, "android."

    const-string v5, "dalvik."

    const-string v6, "sun."

    const-string v7, "androidx.compose.runtime."

    const-string v8, "androidx.compose.ui.node."

    const-string v9, "androidx.compose.ui.platform."

    filled-new-array/range {v0 .. v11}, [Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmSysPromptHideHook;->SKIP_PKG:[Ljava/lang/String;

    .line 62
    const-string v0, "androidx.compose.ui.text.AnnotatedString"

    const-string v1, "androidx.compose.ui.text.AnnotatedStringKt"

    const-string v2, "ln"

    filled-new-array {v2, v0, v1}, [Ljava/lang/String;

    move-result-object v0

    sput-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmSysPromptHideHook;->ANNOTATED_STRING_CANDS:[Ljava/lang/String;

    return-void
.end method

.method public constructor <init>()V
    .registers 1

    .line 48
    invoke-direct {p0}, Lde/robv/android/xposed/XC_MethodHook;-><init>()V

    return-void
.end method

.method static synthetic access$000(Ljava/lang/String;II)V
    .registers 3

    .line 48
    invoke-static {p0, p1, p2}, Lcom/nidyaber/fuckdsmanger/bridge/GmSysPromptHideHook;->hit(Ljava/lang/String;II)V

    return-void
.end method

.method private static hit(Ljava/lang/String;II)V
    .registers 6

    const-string v0, "\u62b9\u6389\u5b9a\u754c\u6bb5 \u2192 "

    const-string v1, "syspromptHide.hit."

    .line 237
    :try_start_4
    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    new-instance v2, Ljava/lang/StringBuilder;

    invoke-direct {v2, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p0, "\uff08"

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, " \u2192 "

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2, p2}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string p0, " \u5b57\u7b26\uff09"

    invoke-virtual {v2, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v2}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {v1, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V
    :try_end_34
    .catchall {:try_start_4 .. :try_end_34} :catchall_34

    :catchall_34
    return-void
.end method

.method private static hookAnnotatedString(Ljava/lang/ClassLoader;)V
    .registers 7

    .line 293
    sget-object v0, Lcom/nidyaber/fuckdsmanger/bridge/GmSysPromptHideHook;->ANNOTATED_STRING_CANDS:[Ljava/lang/String;

    array-length v1, v0

    const/4 v2, 0x0

    move v3, v2

    :goto_5
    if-ge v3, v1, :cond_43

    aget-object v4, v0, v3

    .line 294
    invoke-static {v4, p0}, Lde/robv/android/xposed/XposedHelpers;->findClassIfExists(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object v5

    if-nez v5, :cond_12

    add-int/lit8 v3, v3, 0x1

    goto :goto_5

    .line 297
    :cond_12
    invoke-virtual {v5}, Ljava/lang/Class;->getDeclaredConstructors()[Ljava/lang/reflect/Constructor;

    move-result-object p0

    array-length v0, p0

    move v1, v2

    :goto_18
    if-ge v2, v0, :cond_29

    aget-object v3, p0, v2

    .line 299
    :try_start_1c
    new-instance v5, Lcom/nidyaber/fuckdsmanger/bridge/GmSysPromptHideHook;

    invoke-direct {v5}, Lcom/nidyaber/fuckdsmanger/bridge/GmSysPromptHideHook;-><init>()V

    invoke-static {v3, v5}, Lde/robv/android/xposed/XposedBridge;->hookMethod(Ljava/lang/reflect/Member;Lde/robv/android/xposed/XC_MethodHook;)Lde/robv/android/xposed/XC_MethodHook$Unhook;
    :try_end_24
    .catchall {:try_start_1c .. :try_end_24} :catchall_26

    add-int/lit8 v1, v1, 0x1

    :catchall_26
    add-int/lit8 v2, v2, 0x1

    goto :goto_18

    .line 304
    :cond_29
    new-instance p0, Ljava/lang/StringBuilder;

    const-string v0, "hookM syspromptHide/annStr count="

    invoke-direct {p0, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, " cls="

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    return-void

    .line 307
    :cond_43
    const-string p0, "hookM syspromptHide/annStr \u2192 \u7c7b\u6ca1\u627e\u5230\uff08\u5927\u6982\u88ab R8 \u6539\u540d\u4e86\uff09\uff0c\u8df3\u8fc7"

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    return-void
.end method

.method private static hookArgs(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    .registers 9

    .line 261
    const-string v0, "."

    .line 0
    const-string v1, "hookM syspromptHide/"

    .line 261
    :try_start_4
    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmRemap;->cls(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v2

    .line 262
    invoke-static {p1, p2}, Lcom/nidyaber/fuckdsmanger/bridge/GmRemap;->method(Ljava/lang/String;Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    .line 263
    invoke-static {v2, p0}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object p0

    .line 264
    new-instance v4, Lcom/nidyaber/fuckdsmanger/bridge/GmSysPromptHideHook;

    invoke-direct {v4}, Lcom/nidyaber/fuckdsmanger/bridge/GmSysPromptHideHook;-><init>()V

    invoke-static {p0, v3, v4}, Lde/robv/android/xposed/XposedBridge;->hookAllMethods(Ljava/lang/Class;Ljava/lang/String;Lde/robv/android/xposed/XC_MethodHook;)Ljava/util/Set;

    .line 265
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {p0, p3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " count=1 cls="

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_35
    .catchall {:try_start_4 .. :try_end_35} :catchall_36

    return-void

    :catchall_36
    move-exception p0

    .line 267
    new-instance v1, Ljava/lang/StringBuilder;

    const-string v2, "hookM FAIL syspromptHide/"

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

.method private static hookStringGetters(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;)V
    .registers 10

    .line 274
    :try_start_0
    invoke-static {p1}, Lcom/nidyaber/fuckdsmanger/bridge/GmRemap;->cls(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v0

    .line 275
    invoke-static {v0, p0}, Lde/robv/android/xposed/XposedHelpers;->findClass(Ljava/lang/String;Ljava/lang/ClassLoader;)Ljava/lang/Class;

    move-result-object p0

    .line 277
    invoke-virtual {p0}, Ljava/lang/Class;->getDeclaredMethods()[Ljava/lang/reflect/Method;

    move-result-object p0

    array-length v1, p0

    const/4 v2, 0x0

    move v3, v2

    :goto_f
    if-ge v2, v1, :cond_2a

    aget-object v4, p0, v2

    .line 278
    invoke-virtual {v4}, Ljava/lang/reflect/Method;->getReturnType()Ljava/lang/Class;

    move-result-object v5

    const-class v6, Ljava/lang/String;
    :try_end_19
    .catchall {:try_start_0 .. :try_end_19} :catchall_4f

    if-eq v5, v6, :cond_1c

    goto :goto_27

    .line 280
    :cond_1c
    :try_start_1c
    new-instance v5, Lcom/nidyaber/fuckdsmanger/bridge/GmSysPromptHideHook$RetHook;

    const/4 v6, 0x0

    invoke-direct {v5, v6}, Lcom/nidyaber/fuckdsmanger/bridge/GmSysPromptHideHook$RetHook;-><init>(Lcom/nidyaber/fuckdsmanger/bridge/GmSysPromptHideHook$1;)V

    invoke-static {v4, v5}, Lde/robv/android/xposed/XposedBridge;->hookMethod(Ljava/lang/reflect/Member;Lde/robv/android/xposed/XC_MethodHook;)Lde/robv/android/xposed/XC_MethodHook$Unhook;
    :try_end_25
    .catchall {:try_start_1c .. :try_end_25} :catchall_27

    add-int/lit8 v3, v3, 0x1

    :catchall_27
    :goto_27
    add-int/lit8 v2, v2, 0x1

    goto :goto_f

    .line 285
    :cond_2a
    :try_start_2a
    new-instance p0, Ljava/lang/StringBuilder;

    invoke-direct {p0}, Ljava/lang/StringBuilder;-><init>()V

    const-string v1, "hookM syspromptHide/ret-"

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, " count="

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v3}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v1, " cls="

    invoke-virtual {p0, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {p0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_4e
    .catchall {:try_start_2a .. :try_end_4e} :catchall_4f

    goto :goto_71

    :catchall_4f
    move-exception p0

    .line 287
    new-instance v0, Ljava/lang/StringBuilder;

    const-string v1, "hookM FAIL syspromptHide/ret-"

    invoke-direct {v0, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p2, " ("

    invoke-virtual {v0, p2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string p1, ") \u2192 "

    invoke-virtual {v0, p1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v0, p0}, Ljava/lang/StringBuilder;->append(Ljava/lang/Object;)Ljava/lang/StringBuilder;

    invoke-virtual {v0}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object p0

    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V

    :goto_71
    return-void
.end method

.method public static install(Ljava/lang/ClassLoader;)V
    .registers 5

    .line 247
    const-string v0, "c"

    const-string v1, "unit"

    const-string v2, "pn9"

    invoke-static {p0, v2, v0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmSysPromptHideHook;->hookArgs(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 248
    const-string v0, "a"

    const-string v1, "list"

    const-string v3, "h91"

    invoke-static {p0, v3, v0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmSysPromptHideHook;->hookArgs(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V

    .line 251
    const-string v0, "i93"

    invoke-static {p0, v2, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmSysPromptHideHook;->hookStringGetters(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;)V

    .line 252
    const-string v0, "vq"

    const-string v1, "mr"

    invoke-static {p0, v0, v1}, Lcom/nidyaber/fuckdsmanger/bridge/GmSysPromptHideHook;->hookStringGetters(Ljava/lang/ClassLoader;Ljava/lang/String;Ljava/lang/String;)V

    .line 255
    invoke-static {p0}, Lcom/nidyaber/fuckdsmanger/bridge/GmSysPromptHideHook;->hookAnnotatedString(Ljava/lang/ClassLoader;)V

    return-void
.end method

.method private static scrub(Ljava/lang/Object;ILjava/util/Map;)V
    .registers 14
    .annotation system Ldalvik/annotation/Signature;
        value = {
            "(",
            "Ljava/lang/Object;",
            "I",
            "Ljava/util/Map<",
            "Ljava/lang/Object;",
            "Ljava/lang/Boolean;",
            ">;)V"
        }
    .end annotation

    if-eqz p0, :cond_168

    if-gtz p1, :cond_6

    goto/16 :goto_168

    .line 132
    :cond_6
    invoke-virtual {p0}, Ljava/lang/Object;->getClass()Ljava/lang/Class;

    move-result-object v0

    .line 133
    invoke-virtual {v0}, Ljava/lang/Class;->isPrimitive()Z

    move-result v1

    if-eqz v1, :cond_12

    goto/16 :goto_168

    .line 134
    :cond_12
    invoke-virtual {v0}, Ljava/lang/Class;->getName()Ljava/lang/String;

    move-result-object v1

    .line 135
    sget-object v2, Lcom/nidyaber/fuckdsmanger/bridge/GmSysPromptHideHook;->SKIP_PKG:[Ljava/lang/String;

    array-length v3, v2

    const/4 v4, 0x0

    move v5, v4

    :goto_1b
    if-ge v5, v3, :cond_2a

    aget-object v6, v2, v5

    .line 136
    invoke-virtual {v1, v6}, Ljava/lang/String;->startsWith(Ljava/lang/String;)Z

    move-result v6

    if-eqz v6, :cond_27

    goto/16 :goto_168

    :cond_27
    add-int/lit8 v5, v5, 0x1

    goto :goto_1b

    .line 138
    :cond_2a
    invoke-interface {p2, p0}, Ljava/util/Map;->containsKey(Ljava/lang/Object;)Z

    move-result v2

    if-eqz v2, :cond_32

    goto/16 :goto_168

    .line 139
    :cond_32
    sget-object v2, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    invoke-interface {p2, p0, v2}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    const/4 v2, 0x1

    .line 142
    :try_start_38
    instance-of v3, p0, Ljava/util/Collection;

    const/16 v5, 0x3c

    if-eqz v3, :cond_80

    .line 143
    move-object v3, p0

    check-cast v3, Ljava/util/Collection;

    .line 145
    invoke-interface {v3}, Ljava/util/Collection;->iterator()Ljava/util/Iterator;

    move-result-object v6

    move v7, v4

    :catchall_46
    :cond_46
    :goto_46
    invoke-interface {v6}, Ljava/util/Iterator;->hasNext()Z

    move-result v8

    if-eqz v8, :cond_168

    invoke-interface {v6}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v8

    add-int/2addr v7, v2

    if-le v7, v5, :cond_55

    goto/16 :goto_168

    .line 147
    :cond_55
    instance-of v9, v8, Ljava/lang/String;

    if-eqz v9, :cond_7a

    .line 148
    move-object v9, v8

    check-cast v9, Ljava/lang/String;

    .line 149
    invoke-static {v9}, Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;->hasPlainMark(Ljava/lang/String;)Z

    move-result v10

    if-eqz v10, :cond_46

    .line 150
    invoke-static {v9}, Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;->strip(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v10
    :try_end_66
    .catchall {:try_start_38 .. :try_end_66} :catchall_105

    .line 152
    :try_start_66
    invoke-interface {v3, v8}, Ljava/util/Collection;->remove(Ljava/lang/Object;)Z

    .line 153
    invoke-interface {v3, v10}, Ljava/util/Collection;->add(Ljava/lang/Object;)Z

    .line 154
    const-string v8, "collection"

    invoke-virtual {v9}, Ljava/lang/String;->length()I

    move-result v9

    invoke-virtual {v10}, Ljava/lang/String;->length()I

    move-result v10

    invoke-static {v8, v9, v10}, Lcom/nidyaber/fuckdsmanger/bridge/GmSysPromptHideHook;->hit(Ljava/lang/String;II)V
    :try_end_79
    .catchall {:try_start_66 .. :try_end_79} :catchall_46

    goto :goto_46

    :cond_7a
    add-int/lit8 v9, p1, -0x1

    .line 159
    :try_start_7c
    invoke-static {v8, v9, p2}, Lcom/nidyaber/fuckdsmanger/bridge/GmSysPromptHideHook;->scrub(Ljava/lang/Object;ILjava/util/Map;)V

    goto :goto_46

    .line 164
    :cond_80
    instance-of v3, p0, Ljava/util/Map;

    if-eqz v3, :cond_cc

    .line 165
    move-object v3, p0

    check-cast v3, Ljava/util/Map;

    .line 167
    invoke-interface {v3}, Ljava/util/Map;->entrySet()Ljava/util/Set;

    move-result-object v3

    invoke-interface {v3}, Ljava/util/Set;->iterator()Ljava/util/Iterator;

    move-result-object v3

    move v6, v4

    :catchall_90
    :cond_90
    :goto_90
    invoke-interface {v3}, Ljava/util/Iterator;->hasNext()Z

    move-result v7

    if-eqz v7, :cond_168

    invoke-interface {v3}, Ljava/util/Iterator;->next()Ljava/lang/Object;

    move-result-object v7

    check-cast v7, Ljava/util/Map$Entry;

    add-int/2addr v6, v2

    if-le v6, v5, :cond_a1

    goto/16 :goto_168

    .line 169
    :cond_a1
    invoke-interface {v7}, Ljava/util/Map$Entry;->getValue()Ljava/lang/Object;

    move-result-object v8

    .line 170
    instance-of v9, v8, Ljava/lang/String;

    if-eqz v9, :cond_c6

    .line 171
    check-cast v8, Ljava/lang/String;

    .line 172
    invoke-static {v8}, Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;->hasPlainMark(Ljava/lang/String;)Z

    move-result v9

    if-eqz v9, :cond_90

    .line 173
    invoke-static {v8}, Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;->strip(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v9
    :try_end_b5
    .catchall {:try_start_7c .. :try_end_b5} :catchall_105

    .line 175
    :try_start_b5
    invoke-interface {v7, v9}, Ljava/util/Map$Entry;->setValue(Ljava/lang/Object;)Ljava/lang/Object;

    .line 176
    const-string v7, "map"

    invoke-virtual {v8}, Ljava/lang/String;->length()I

    move-result v8

    invoke-virtual {v9}, Ljava/lang/String;->length()I

    move-result v9

    invoke-static {v7, v8, v9}, Lcom/nidyaber/fuckdsmanger/bridge/GmSysPromptHideHook;->hit(Ljava/lang/String;II)V
    :try_end_c5
    .catchall {:try_start_b5 .. :try_end_c5} :catchall_90

    goto :goto_90

    :cond_c6
    add-int/lit8 v7, p1, -0x1

    .line 181
    :try_start_c8
    invoke-static {v8, v7, p2}, Lcom/nidyaber/fuckdsmanger/bridge/GmSysPromptHideHook;->scrub(Ljava/lang/Object;ILjava/util/Map;)V

    goto :goto_90

    .line 186
    :cond_cc
    instance-of v3, p0, [Ljava/lang/Object;

    if-eqz v3, :cond_105

    .line 187
    move-object v3, p0

    check-cast v3, [Ljava/lang/Object;

    .line 188
    array-length v6, v3

    invoke-static {v6, v5}, Ljava/lang/Math;->min(II)I

    move-result v5

    move v6, v4

    :goto_d9
    if-ge v6, v5, :cond_168

    .line 190
    aget-object v7, v3, v6

    .line 191
    instance-of v8, v7, Ljava/lang/String;

    if-eqz v8, :cond_fd

    .line 192
    check-cast v7, Ljava/lang/String;

    .line 193
    invoke-static {v7}, Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;->hasPlainMark(Ljava/lang/String;)Z

    move-result v8

    if-eqz v8, :cond_102

    .line 194
    invoke-static {v7}, Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;->strip(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v8

    .line 195
    aput-object v8, v3, v6

    .line 196
    const-string v9, "array"

    invoke-virtual {v7}, Ljava/lang/String;->length()I

    move-result v7

    invoke-virtual {v8}, Ljava/lang/String;->length()I

    move-result v8

    invoke-static {v9, v7, v8}, Lcom/nidyaber/fuckdsmanger/bridge/GmSysPromptHideHook;->hit(Ljava/lang/String;II)V

    goto :goto_102

    :cond_fd
    add-int/lit8 v8, p1, -0x1

    .line 199
    invoke-static {v7, v8, p2}, Lcom/nidyaber/fuckdsmanger/bridge/GmSysPromptHideHook;->scrub(Ljava/lang/Object;ILjava/util/Map;)V
    :try_end_102
    .catchall {:try_start_c8 .. :try_end_102} :catchall_105

    :cond_102
    :goto_102
    add-int/lit8 v6, v6, 0x1

    goto :goto_d9

    .line 209
    :catchall_105
    :cond_105
    :try_start_105
    invoke-virtual {v0}, Ljava/lang/Class;->getDeclaredFields()[Ljava/lang/reflect/Field;

    move-result-object v0

    .line 210
    array-length v3, v0

    const/16 v5, 0x28

    invoke-static {v3, v5}, Ljava/lang/Math;->min(II)I

    move-result v3

    :goto_110
    if-ge v4, v3, :cond_168

    .line 212
    aget-object v5, v0, v4

    .line 213
    invoke-virtual {v5}, Ljava/lang/reflect/Field;->getModifiers()I

    move-result v6

    invoke-static {v6}, Ljava/lang/reflect/Modifier;->isStatic(I)Z

    move-result v6
    :try_end_11c
    .catchall {:try_start_105 .. :try_end_11c} :catchall_168

    if-eqz v6, :cond_11f

    goto :goto_165

    .line 215
    :cond_11f
    :try_start_11f
    invoke-virtual {v5, v2}, Ljava/lang/reflect/Field;->setAccessible(Z)V

    .line 216
    invoke-virtual {v5, p0}, Ljava/lang/reflect/Field;->get(Ljava/lang/Object;)Ljava/lang/Object;

    move-result-object v6

    if-nez v6, :cond_129

    goto :goto_165

    .line 218
    :cond_129
    instance-of v7, v6, Ljava/lang/String;

    if-eqz v7, :cond_160

    .line 219
    check-cast v6, Ljava/lang/String;

    .line 220
    invoke-static {v6}, Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;->hasPlainMark(Ljava/lang/String;)Z

    move-result v7

    if-eqz v7, :cond_165

    .line 221
    invoke-static {v6}, Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;->strip(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v7

    .line 222
    invoke-virtual {v5, p0, v7}, Ljava/lang/reflect/Field;->set(Ljava/lang/Object;Ljava/lang/Object;)V

    .line 223
    new-instance v8, Ljava/lang/StringBuilder;

    invoke-direct {v8}, Ljava/lang/StringBuilder;-><init>()V

    invoke-virtual {v8, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v9, "."

    invoke-virtual {v8, v9}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v5}, Ljava/lang/reflect/Field;->getName()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v8, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v8}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v5

    invoke-virtual {v6}, Ljava/lang/String;->length()I

    move-result v6

    invoke-virtual {v7}, Ljava/lang/String;->length()I

    move-result v7

    invoke-static {v5, v6, v7}, Lcom/nidyaber/fuckdsmanger/bridge/GmSysPromptHideHook;->hit(Ljava/lang/String;II)V

    goto :goto_165

    :cond_160
    add-int/lit8 v5, p1, -0x1

    .line 226
    invoke-static {v6, v5, p2}, Lcom/nidyaber/fuckdsmanger/bridge/GmSysPromptHideHook;->scrub(Ljava/lang/Object;ILjava/util/Map;)V
    :try_end_165
    .catchall {:try_start_11f .. :try_end_165} :catchall_165

    :catchall_165
    :cond_165
    :goto_165
    add-int/lit8 v4, v4, 0x1

    goto :goto_110

    :catchall_168
    :cond_168
    :goto_168
    return-void
.end method


# virtual methods
.method protected beforeHookedMethod(Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;)V
    .registers 8

    .line 73
    :try_start_0
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;->carrier()I

    move-result p0

    const/4 v0, 0x1

    if-eq p0, v0, :cond_8

    goto :goto_70

    .line 74
    :cond_8
    const-string p0, "syspromptHide.alive"

    const-string v0, "hide hook \u5df2\u547d\u4e2d\u6e32\u67d3\u8def\u5f84\uff08before \u88ab\u8c03\u7528\uff09"

    invoke-static {p0, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logOnce(Ljava/lang/String;Ljava/lang/String;)V

    .line 76
    iget-object p0, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->args:[Ljava/lang/Object;

    if-nez p0, :cond_14

    goto :goto_70

    .line 79
    :cond_14
    new-instance v0, Ljava/util/IdentityHashMap;

    invoke-direct {v0}, Ljava/util/IdentityHashMap;-><init>()V

    .line 80
    iget-object p1, p1, Lde/robv/android/xposed/XC_MethodHook$MethodHookParam;->thisObject:Ljava/lang/Object;

    sget-object v1, Ljava/lang/Boolean;->TRUE:Ljava/lang/Boolean;

    invoke-interface {v0, p1, v1}, Ljava/util/Map;->put(Ljava/lang/Object;Ljava/lang/Object;)Ljava/lang/Object;

    .line 82
    array-length p1, p0

    const/16 v1, 0x10

    invoke-static {p1, v1}, Ljava/lang/Math;->min(II)I

    move-result p1

    const/4 v1, 0x0

    :goto_28
    if-ge v1, p1, :cond_70

    .line 84
    aget-object v2, p0, v1

    if-nez v2, :cond_2f

    goto :goto_67

    .line 86
    :cond_2f
    instance-of v3, v2, Ljava/lang/String;

    if-eqz v3, :cond_5e

    .line 87
    check-cast v2, Ljava/lang/String;

    .line 88
    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;->hasPlainMark(Ljava/lang/String;)Z

    move-result v3

    if-eqz v3, :cond_67

    .line 89
    invoke-static {v2}, Lcom/nidyaber/fuckdsmanger/gm/GmSysPrompt;->strip(Ljava/lang/String;)Ljava/lang/String;

    move-result-object v3

    .line 90
    aput-object v3, p0, v1

    .line 91
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4}, Ljava/lang/StringBuilder;-><init>()V

    const-string v5, "arg"

    invoke-virtual {v4, v5}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4, v1}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v4

    invoke-virtual {v2}, Ljava/lang/String;->length()I

    move-result v2

    invoke-virtual {v3}, Ljava/lang/String;->length()I

    move-result v3

    invoke-static {v4, v2, v3}, Lcom/nidyaber/fuckdsmanger/bridge/GmSysPromptHideHook;->hit(Ljava/lang/String;II)V

    goto :goto_67

    .line 95
    :cond_5e
    instance-of v3, v2, Ljava/lang/CharSequence;

    if-eqz v3, :cond_63

    goto :goto_67

    :cond_63
    const/4 v3, 0x4

    .line 96
    invoke-static {v2, v3, v0}, Lcom/nidyaber/fuckdsmanger/bridge/GmSysPromptHideHook;->scrub(Ljava/lang/Object;ILjava/util/Map;)V
    :try_end_67
    .catchall {:try_start_0 .. :try_end_67} :catchall_6a

    :cond_67
    :goto_67
    add-int/lit8 v1, v1, 0x1

    goto :goto_28

    :catchall_6a
    move-exception p0

    .line 100
    :try_start_6b
    const-string p1, "syspromptHide"

    invoke-static {p1, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V
    :try_end_70
    .catchall {:try_start_6b .. :try_end_70} :catchall_70

    :catchall_70
    :cond_70
    :goto_70
    return-void
.end method
