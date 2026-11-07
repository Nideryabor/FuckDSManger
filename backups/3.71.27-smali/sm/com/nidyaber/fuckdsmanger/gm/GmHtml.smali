.class public final Lcom/nidyaber/fuckdsmanger/gm/GmHtml;
.super Ljava/lang/Object;
.source "GmHtml.java"


# static fields
.field public static final K_LIGHT:Ljava/lang/String; = "fuckds_html_light"

.field public static final K_ON:Ljava/lang/String; = "fuckds_html_on"

.field private static volatile sDataUrl:Ljava/lang/String;


# direct methods
.method static constructor <clinit>()V
    .registers 0

    return-void
.end method

.method private constructor <init>()V
    .registers 1

    .line 53
    invoke-direct {p0}, Ljava/lang/Object;-><init>()V

    return-void
.end method

.method private static buildJs()Ljava/lang/String;
    .registers 1

    .line 153
    const-string v0, "(function(){var seq=0;var lastW=0,lastH=0,lastSvgLen=0;function diag(s){try{document.title=\'FDM|\'+s;}catch(e){}}function esc(s){return String(s).replace(/&/g,\'&amp;\').replace(/</g,\'&lt;\');}function okImg(u){diag(\'OK len=\'+u.length);try{if(window.AndroidBridge&&window.AndroidBridge.onImageRendered)window.AndroidBridge.onImageRendered(u,\'\');}catch(e){}}function failImg(m){diag(\'ERR \'+String(m));try{var c=document.createElement(\'canvas\');c.width=660;c.height=96;var x=c.getContext(\'2d\');x.fillStyle=\'#3a1414\';x.fillRect(0,0,660,96);x.strokeStyle=\'#ff6b6b\';x.lineWidth=2;x.strokeRect(1,1,658,94);x.fillStyle=\'#ff9b9b\';x.font=\'bold 17px monospace\';x.fillText(\'FDM: HTML \u6e32\u67d3\u5931\u8d25\',14,32);x.fillStyle=\'#ffd9d9\';x.font=\'13px monospace\';x.fillText(String(m).substring(0,72),14,58);x.fillText(\'size=\'+lastW+\'x\'+lastH+\'  svg=\'+lastSvgLen+\' \u5b57\u8282\',14,80);var url=c.toDataURL(\'image/png\');if(window.AndroidBridge&&window.AndroidBridge.onImageRendered)window.AndroidBridge.onImageRendered(url,\'\');return;}catch(e2){}try{if(window.AndroidBridge&&window.AndroidBridge.onImageRenderFailed)window.AndroidBridge.onImageRenderFailed(\'RENDER_FAILED\',String(m));}catch(e){}}function okSvg(id){diag(\'OK_SVG\');try{if(window.NativeBridge&&window.NativeBridge.onMermaidRendered)window.NativeBridge.onMermaidRendered(\'FINISHED\',(id===undefined?0:id));}catch(e){}}function layout(src){var box=document.createElement(\'div\');box.style.display=\'inline-block\';box.style.width=\'auto\';box.style.maxWidth=\'100%\';box.style.boxSizing=\'border-box\';box.innerHTML=(src==null?\'\':String(src));document.body.innerHTML=\'\';document.body.appendChild(box);runScripts(box);return box;}function runScripts(box){try{var ss=box.querySelectorAll(\'script\');for(var i=0;i<ss.length;i++){var code=ss[i].textContent;if(code&&code.trim()){try{(new Function(code))();}catch(e){diag(\'JS_ERR \'+e);}}ss[i].parentNode.removeChild(ss[i]);}}catch(e){diag(\'JS_ERR \'+e);}}function toPng(el,dark,cb){try{var w=Math.max(1,Math.ceil(el.offsetWidth||el.scrollWidth||320));var h=Math.max(1,Math.ceil(el.offsetHeight||el.scrollHeight||120));lastW=w;lastH=h;diag(\'size=\'+w+\'x\'+h);if(w>4000||h>8000){cb(\'TOO_LARGE \'+w+\'x\'+h,null);return;}var cs=document.getElementById(\'fdmCss\');var css=cs?cs.textContent:\'\';var fg=dark?\'#e8e8e8\':\'#1a1a1a\';var holder=document.createElement(\'div\');holder.setAttribute(\'xmlns\',\'http://www.w3.org/1999/xhtml\');holder.setAttribute(\'style\',\'padding:10px;color:\'+fg+\';width:\'+w+\'px;box-sizing:border-box\');while(el.firstChild){holder.appendChild(el.firstChild);}var innerXml;try{innerXml=new XMLSerializer().serializeToString(holder);}catch(e){innerXml=holder.outerHTML;}var svg=\'<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"\'+w+\'\" height=\"\'+h+\'\">\'+\'<foreignObject width=\"100%\" height=\"100%\">\'+\'<style>\'+esc(css)+\'</style>\'+innerXml+\'</foreignObject></svg>\';lastSvgLen=svg.length;var img=new Image();img.onload=function(){try{var c=document.createElement(\'canvas\');c.width=w;c.height=h;var x=c.getContext(\'2d\');x.drawImage(img,0,0);cb(c.toDataURL(\'image/png\'),null);}catch(e){cb(null,e);}};img.onerror=function(){cb(\'IMG_LOAD_FAILED(svg\u89e3\u6790\u5931\u8d25)\',null);};img.src=\'data:image/svg+xml;charset=utf-8,\'+encodeURIComponent(svg);}catch(e){cb(null,e);}}window.generateMermaid=function(src,theme){var my=++seq;try{var box=layout(src);setTimeout(function(){if(my!==seq)return;toPng(box,theme===\'dark\',function(u,e){if(my!==seq)return;if(e)failImg(e);else okImg(u);});},260);}catch(e){failImg(e);}};window.JSBridge=window.JSBridge||{};window.JSBridge.requestRenderMermaid=function(src,id){var my=++seq;try{layout(src);setTimeout(function(){if(my!==seq)return;okSvg(id);},260);}catch(e){okSvg(id);}};window.JSBridge.exportPngBase64=function(id){try{if(window.AndroidBridge&&window.AndroidBridge.onImageRenderFailed)window.AndroidBridge.onImageRenderFailed(\'RENDER_FAILED\',\'no png\');}catch(e){}};})();"

    return-object v0
.end method

.method private static buildPage()Ljava/lang/String;
    .registers 5

    .line 116
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmHtml;->light()Z

    move-result v0

    if-eqz v0, :cond_9

    .line 117
    const-string v1, "#1a1a1a"

    goto :goto_b

    :cond_9
    const-string v1, "#e8e8e8"

    :goto_b
    if-eqz v0, :cond_10

    .line 118
    const-string v2, "#d0d0d0"

    goto :goto_12

    :cond_10
    const-string v2, "#4a4a4a"

    :goto_12
    if-eqz v0, :cond_17

    .line 119
    const-string v0, "#f0f0f0"

    goto :goto_19

    :cond_17
    const-string v0, "#2a2a2a"

    .line 121
    :goto_19
    new-instance v3, Ljava/lang/StringBuilder;

    const/16 v4, 0x2000

    invoke-direct {v3, v4}, Ljava/lang/StringBuilder;-><init>(I)V

    .line 122
    const-string v4, "<!doctype html><html><head><meta charset=\"utf-8\"><meta name=\"viewport\" content=\"width=device-width,initial-scale=1,maximum-scale=1\"><style id=\"fdmCss\">html,body{margin:0;padding:0;background:transparent;}body{padding:2px 0;font-family:-apple-system,Roboto,\'Noto Sans CJK SC\',sans-serif;font-size:15px;line-height:1.6;color:"

    invoke-virtual {v3, v4}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 128
    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ";word-wrap:break-word;overflow-wrap:break-word;-webkit-text-size-adjust:100%;}h1,h2,h3,h4{margin:.6em 0 .3em;font-weight:600;line-height:1.3;}h1{font-size:1.35em;}h2{font-size:1.2em;}h3{font-size:1.08em;}p{margin:.4em 0;}ul,ol{margin:.4em 0;padding-left:1.4em;}table{border-collapse:collapse;margin:.5em 0;font-size:.95em;}th,td{border:1px solid "

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 134
    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ";padding:4px 8px;text-align:left;}th{font-weight:600;}code{font-family:monospace;background:"

    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 136
    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v1, ";padding:1px 4px;border-radius:3px;font-size:.92em;}pre{background:"

    .line 137
    invoke-virtual {v3, v1}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 138
    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, ";padding:8px;border-radius:6px;overflow-x:auto;}pre code{background:none;padding:0;}blockquote{margin:.5em 0;padding-left:.8em;border-left:3px solid "

    .line 139
    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 142
    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, ";opacity:.9;}hr{border:none;border-top:1px solid "

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 143
    invoke-virtual {v3, v2}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, ";margin:.8em 0;}a{color:#4a9eff;}img{max-width:100%;height:auto;}</style></head><body><script>"

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 146
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmHtml;->buildJs()Ljava/lang/String;

    move-result-object v0

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    const-string v0, "</script></body></html>"

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    .line 148
    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    return-object v0
.end method

.method public static isBuiltinPage(Ljava/lang/String;)Z
    .registers 3

    const/4 v0, 0x0

    if-nez p0, :cond_4

    return v0

    .line 80
    :cond_4
    const-string v1, "generator.html"

    invoke-virtual {p0, v1}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result v1

    if-gez v1, :cond_16

    const-string v1, "viewer.html"

    invoke-virtual {p0, v1}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result p0

    if-ltz p0, :cond_15

    goto :goto_16

    :cond_15
    return v0

    :cond_16
    :goto_16
    const/4 p0, 0x1

    return p0
.end method

.method public static light()Z
    .registers 3

    .line 72
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v0

    const-string v1, "fuckds_html_light"

    const/4 v2, 0x0

    invoke-static {v0, v1, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->boolOf(Landroid/content/Context;Ljava/lang/String;Z)Z

    move-result v0

    return v0
.end method

.method public static looksLikeHtml(Ljava/lang/String;)Z
    .registers 5

    const/4 v0, 0x0

    if-nez p0, :cond_4

    return v0

    .line 86
    :cond_4
    invoke-virtual {p0}, Ljava/lang/String;->trim()Ljava/lang/String;

    move-result-object p0

    .line 87
    invoke-virtual {p0}, Ljava/lang/String;->isEmpty()Z

    move-result v1

    if-eqz v1, :cond_f

    return v0

    .line 88
    :cond_f
    invoke-virtual {p0, v0}, Ljava/lang/String;->charAt(I)C

    move-result v1

    const/16 v2, 0x3c

    const/4 v3, 0x1

    if-ne v1, v2, :cond_19

    return v3

    .line 89
    :cond_19
    const-string v1, "</"

    invoke-virtual {p0, v1}, Ljava/lang/String;->indexOf(Ljava/lang/String;)I

    move-result p0

    if-ltz p0, :cond_22

    return v3

    :cond_22
    return v0
.end method

.method public static on()Z
    .registers 3

    .line 58
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v0

    const-string v1, "fuckds_html_on"

    const/4 v2, 0x0

    invoke-static {v0, v1, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmRichText;->boolOf(Landroid/content/Context;Ljava/lang/String;Z)Z

    move-result v0

    return v0
.end method

.method public static pageDataUrl()Ljava/lang/String;
    .registers 5

    .line 96
    const-string v0, "\u3010HTML\u3011\u81ea\u5efa\u9875\u5df2\u5c31\u7eea\uff08data URL\uff0c"

    const-string v1, "data:text/html;charset=utf-8;base64,"

    sget-object v2, Lcom/nidyaber/fuckdsmanger/gm/GmHtml;->sDataUrl:Ljava/lang/String;

    if-eqz v2, :cond_9

    return-object v2

    .line 98
    :cond_9
    const-class v2, Lcom/nidyaber/fuckdsmanger/gm/GmHtml;

    monitor-enter v2

    .line 99
    :try_start_c
    sget-object v3, Lcom/nidyaber/fuckdsmanger/gm/GmHtml;->sDataUrl:Ljava/lang/String;

    if-eqz v3, :cond_14

    sget-object v0, Lcom/nidyaber/fuckdsmanger/gm/GmHtml;->sDataUrl:Ljava/lang/String;

    monitor-exit v2
    :try_end_13
    .catchall {:try_start_c .. :try_end_13} :catchall_54

    return-object v0

    .line 101
    :cond_14
    :try_start_14
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmHtml;->buildPage()Ljava/lang/String;

    move-result-object v3

    const-string v4, "UTF-8"

    invoke-virtual {v3, v4}, Ljava/lang/String;->getBytes(Ljava/lang/String;)[B

    move-result-object v3

    const/4 v4, 0x2

    .line 102
    invoke-static {v3, v4}, Landroid/util/Base64;->encodeToString([BI)Ljava/lang/String;

    move-result-object v3

    .line 103
    new-instance v4, Ljava/lang/StringBuilder;

    invoke-direct {v4, v1}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v4, v3}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v4}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v1

    .line 104
    sput-object v1, Lcom/nidyaber/fuckdsmanger/gm/GmHtml;->sDataUrl:Ljava/lang/String;

    .line 105
    new-instance v3, Ljava/lang/StringBuilder;

    invoke-direct {v3, v0}, Ljava/lang/StringBuilder;-><init>(Ljava/lang/String;)V

    invoke-virtual {v1}, Ljava/lang/String;->length()I

    move-result v0

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(I)Ljava/lang/StringBuilder;

    const-string v0, " \u5b57\u7b26\uff09"

    invoke-virtual {v3, v0}, Ljava/lang/StringBuilder;->append(Ljava/lang/String;)Ljava/lang/StringBuilder;

    invoke-virtual {v3}, Ljava/lang/StringBuilder;->toString()Ljava/lang/String;

    move-result-object v0

    invoke-static {v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->log(Ljava/lang/String;)V
    :try_end_49
    .catchall {:try_start_14 .. :try_end_49} :catchall_4b

    .line 106
    :try_start_49
    monitor-exit v2

    return-object v1

    :catchall_4b
    move-exception v0

    .line 108
    const-string v1, "html.pageDataUrl"

    invoke-static {v1, v0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    .line 109
    monitor-exit v2

    const/4 v0, 0x0

    return-object v0

    :catchall_54
    move-exception v0

    .line 111
    monitor-exit v2
    :try_end_56
    .catchall {:try_start_49 .. :try_end_56} :catchall_54

    throw v0
.end method

.method public static setOn(Z)V
    .registers 4

    .line 62
    invoke-static {}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->app()Landroid/content/Context;

    move-result-object v0

    if-nez v0, :cond_7

    return-void

    .line 65
    :cond_7
    :try_start_7
    const-string v1, "fuckds_html_on"

    if-eqz p0, :cond_e

    const-string p0, "true"

    goto :goto_10

    :cond_e
    const-string p0, "false"

    :goto_10
    const-string v2, "b"

    invoke-static {v0, v1, p0, v2}, Lcom/nidyaber/fuckdsmanger/gm/GmStore;->write(Landroid/content/Context;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V
    :try_end_15
    .catchall {:try_start_7 .. :try_end_15} :catchall_16

    return-void

    :catchall_16
    move-exception p0

    .line 67
    const-string v0, "html.setOn"

    invoke-static {v0, p0}, Lcom/nidyaber/fuckdsmanger/gm/GmUtil;->logFail(Ljava/lang/String;Ljava/lang/Throwable;)V

    return-void
.end method
