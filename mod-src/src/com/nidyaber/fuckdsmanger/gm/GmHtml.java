package com.nidyaber.fuckdsmanger.gm;

import android.content.Context;

/**
 * GmHtml —— 「AI 气泡渲染任意 HTML」的核心工具 🐲 2026-10-04 · 尼得亚伯
 *
 * <h3>链路（全部真机 / frida 实证）</h3>
 * <pre>
 *   ```html 代码块
 *     → 语言闸门 v7a.M("html","mermaid",true) ⇒ 我们放行 ⇒ 宿主当成 Diagram
 *         → new MermaidGeneratorWebView(Context)
 *             → loadUrl("file:///android_asset/generator.html")   ★ 我们换成 data: URL
 *                 → evaluateJavascript("… window.generateMermaid(源码, "dark") …")
 *                     → 命中<b>我们页面里</b>的 generateMermaid
 *                         → HTML → foreignObject → canvas → PNG
 *                             → window.AndroidBridge.onImageRendered(png, "")
 * </pre>
 *
 * <h3>四个"换了就废"的坑（全部踩过，全部有实测证据）</h3>
 * <ol>
 *   <li><b>不能写文件再 file:// 加载</b> —— {@code targetSdk >= 30} 时 WebView
 *       默认 {@code setAllowFileAccess(false)}。frida 实测 title 直接是「网页无法打开」，
 *       页面没加载 ⇒ {@code window.generateMermaid} 不存在 ⇒ 卡在"生成中"。
 *       ⇒ 改用 {@code data:} URL。</li>
 *   <li><b>回执对象名是 {@code AndroidBridge} 不是 {@code NativeBridge}</b> ——
 *       内联渲染（generator）走前者、全屏预览（viewer）才走后者。</li>
 *   <li><b>宽度取内容宽度，不能取容器宽度</b> —— 否则表格只占图里一小条，铺满后显小。
 *       包一层 {@code inline-block}，它的 offsetWidth 就是内容自然宽。</li>
 *   <li><b>★★★ 不能拼 {@code innerHTML} 进 SVG</b> —— SVG 是 <b>XML</b>，
 *       {@code <br>} / {@code <img>} 这类空元素在 XML 里<b>必须自闭合</b>。
 *       写成 {@code <br>} 就是格式错误 ⇒ 整份 SVG 解析失败 ⇒ img.onerror ⇒ 渲染失败。
 *       <b>这正是"简单表格能过、复杂文档过不去"的真正原因</b>（表格里没有空标签）。
 *       ⇒ 改用 {@link #buildJs() 里的 XMLSerializer}，它把 {@code <br>} 自动写成 {@code <br />}。</li>
 * </ol>
 *
 * <h3>诊断出口：{@code document.title}</h3>
 * 页面把状态写成 {@code FDM|xxx} 放进 title —— frida 一句 {@code getTitle()} 就能读到。
 * （{@code Java.registerClass} 做回调在 attach+25s 窗口下不稳，实测 status=empty。）
 */
public final class GmHtml {

    /** 总开关 */
    public static final String K_ON = "fuckds_html_on";
    /** 浅色页面（默认跟随宿主深色主题） */
    public static final String K_LIGHT = "fuckds_html_light";

    /** 缓存住已算好的 data URL（base64 不便宜，一个进程只算一次） */
    private static volatile String sDataUrl = null;

    private GmHtml() {}

    // ─────────────────────────── 配置 ───────────────────────────

    public static boolean on() {
        return GmRichText.boolOf(GmUtil.app(), K_ON, false);
    }

    public static void setOn(boolean v) {
        Context ctx = GmUtil.app();
        if (ctx == null) return;
        try {
            GmStore.write(ctx, K_ON, v ? "true" : "false", "b");
        } catch (Throwable t) {
            GmUtil.logFail("html.setOn", t);
        }
    }

    public static boolean light() {
        return GmRichText.boolOf(GmUtil.app(), K_LIGHT, false);
    }

    // ─────────────────────────── 判据 ───────────────────────────

    /** 这个 URL 是不是宿主那两个 mermaid 内置页之一 */
    public static boolean isBuiltinPage(String url) {
        if (url == null) return false;
        return url.indexOf("generator.html") >= 0 || url.indexOf("viewer.html") >= 0;
    }

    /** 这段源码像不像 HTML？（探针判据用） */
    public static boolean looksLikeHtml(String src) {
        if (src == null) return false;
        String t = src.trim();
        if (t.isEmpty()) return false;
        if (t.charAt(0) == '<') return true;
        return t.indexOf("</") >= 0;
    }

    // ─────────────────────────── 页面 ───────────────────────────

    /** 自建页的 {@code data:} URL；生成失败返回 {@code null}（调用方放行原逻辑） */
    public static String pageDataUrl() {
        String cached = sDataUrl;
        if (cached != null) return cached;
        synchronized (GmHtml.class) {
            if (sDataUrl != null) return sDataUrl;
            try {
                byte[] bytes = buildPage().getBytes("UTF-8");
                String b64 = android.util.Base64.encodeToString(bytes, android.util.Base64.NO_WRAP);
                String u = "data:text/html;charset=utf-8;base64," + b64;
                sDataUrl = u;
                GmUtil.log("【HTML】自建页已就绪（data URL，" + u.length() + " 字符）");
                return u;
            } catch (Throwable t) {
                GmUtil.logFail("html.pageDataUrl", t);
                return null;
            }
        }
    }

    /** 完整页面：基础样式 + 实现两套接口的脚本 */
    private static String buildPage() {
        boolean light = light();
        String fg = light ? "#1a1a1a" : "#e8e8e8";
        String border = light ? "#d0d0d0" : "#4a4a4a";
        String codeBg = light ? "#f0f0f0" : "#2a2a2a";

        StringBuilder sb = new StringBuilder(8192);
        sb.append("<!doctype html><html><head><meta charset=\"utf-8\">");
        sb.append("<meta name=\"viewport\" content=\"width=device-width,initial-scale=1,maximum-scale=1\">");
        // ★ 这段 CSS 会被内联进 foreignObject（截图时必须带上，否则样式全丢）
        sb.append("<style id=\"fdmCss\">");
        sb.append("html,body{margin:0;padding:0;background:transparent;}");
        sb.append("body{padding:2px 0;font-family:-apple-system,Roboto,'Noto Sans CJK SC',sans-serif;");
        sb.append("font-size:15px;line-height:1.6;color:").append(fg).append(";");
        sb.append("word-wrap:break-word;overflow-wrap:break-word;-webkit-text-size-adjust:100%;}");
        sb.append("h1,h2,h3,h4{margin:.6em 0 .3em;font-weight:600;line-height:1.3;}");
        sb.append("h1{font-size:1.35em;}h2{font-size:1.2em;}h3{font-size:1.08em;}");
        sb.append("p{margin:.4em 0;}ul,ol{margin:.4em 0;padding-left:1.4em;}");
        sb.append("table{border-collapse:collapse;margin:.5em 0;font-size:.95em;}");
        sb.append("th,td{border:1px solid ").append(border).append(";padding:4px 8px;text-align:left;}");
        sb.append("th{font-weight:600;}");
        sb.append("code{font-family:monospace;background:").append(codeBg)
                .append(";padding:1px 4px;border-radius:3px;font-size:.92em;}");
        sb.append("pre{background:").append(codeBg)
                .append(";padding:8px;border-radius:6px;overflow-x:auto;}");
        sb.append("pre code{background:none;padding:0;}");
        sb.append("blockquote{margin:.5em 0;padding-left:.8em;border-left:3px solid ")
                .append(border).append(";opacity:.9;}");
        sb.append("hr{border:none;border-top:1px solid ").append(border).append(";margin:.8em 0;}");
        sb.append("a{color:#4a9eff;}img{max-width:100%;height:auto;}");
        sb.append("</style></head><body>");
        sb.append("<script>").append(buildJs()).append("</script>");
        sb.append("</body></html>");
        return sb.toString();
    }

    /** 页面里的 JS —— 两套接口都实现，谁调都接得住 */
    private static String buildJs() {
        return
                "(function(){"
                        + "var seq=0;"
                        // 诊断用：把最近一次的尺寸/SVG 长度记下来，供 failImg 展示
                        + "var lastW=0,lastH=0,lastSvgLen=0;"

                        // ★ 诊断出口：状态写进 document.title ⇒ frida 一句 getTitle() 就读到
                        + "function diag(s){try{document.title='FDM|'+s;}catch(e){}}"
                        + "function esc(s){return String(s).replace(/&/g,'&amp;').replace(/</g,'&lt;');}"

                        + "function okImg(u){diag('OK len='+u.length);"
                        + "try{if(window.AndroidBridge&&window.AndroidBridge.onImageRendered)"
                        + "window.AndroidBridge.onImageRendered(u,'');}catch(e){}}"
                        + "function failImg(m){"
                        + "diag('ERR '+String(m));"
                        // ★★ 把失败原因**画成一张图**回给宿主 ——
                        //    主人一眼就能看到是哪一步炸的，不用回读 DIAG、不用 frida。
                        //    （之前几轮全靠日志/Frida，代价太高：DIAG 会轮转、Frida 吃内存）
                        + "try{"
                        + "var c=document.createElement('canvas');c.width=660;c.height=96;"
                        + "var x=c.getContext('2d');"
                        + "x.fillStyle='#3a1414';x.fillRect(0,0,660,96);"
                        + "x.strokeStyle='#ff6b6b';x.lineWidth=2;x.strokeRect(1,1,658,94);"
                        + "x.fillStyle='#ff9b9b';x.font='bold 17px monospace';"
                        + "x.fillText('FDM: HTML 渲染失败',14,32);"
                        + "x.fillStyle='#ffd9d9';x.font='13px monospace';"
                        + "x.fillText(String(m).substring(0,72),14,58);"
                        + "x.fillText('size='+lastW+'x'+lastH+'  svg='+lastSvgLen+' 字节',14,80);"
                        + "var url=c.toDataURL('image/png');"
                        + "if(window.AndroidBridge&&window.AndroidBridge.onImageRendered)"
                        + "window.AndroidBridge.onImageRendered(url,'');"
                        + "return;"
                        + "}catch(e2){}"
                        + "try{if(window.AndroidBridge&&window.AndroidBridge.onImageRenderFailed)"
                        + "window.AndroidBridge.onImageRenderFailed('RENDER_FAILED',String(m));}catch(e){}"
                        + "}"
                        + "function okSvg(id){diag('OK_SVG');"
                        + "try{if(window.NativeBridge&&window.NativeBridge.onMermaidRendered)"
                        + "window.NativeBridge.onMermaidRendered('FINISHED',(id===undefined?0:id));}catch(e){}}"

                        // 把内容摆进文档，宽度由内容自己决定（inline-block 的 offsetWidth = 内容自然宽）
                        + "function layout(src){"
                        + "var box=document.createElement('div');"
                        + "box.style.display='inline-block';"
                        + "box.style.width='auto';"
                        + "box.style.maxWidth='100%';"
                        + "box.style.boxSizing='border-box';"
                        + "box.innerHTML=(src==null?'':String(src));"
                        + "document.body.innerHTML='';"
                        + "document.body.appendChild(box);"
                        + "runScripts(box);"
                        + "return box;"
                        + "}"

                        // ★★ <script> 用 innerHTML/XMLSerializer 插进 DOM 是**不会执行**的
                        //    （浏览器安全规则）⇒ 打字机、数字滚动、滚动显现这些"回调驱动"的元素
                        //    渲染出来全是一片空白。真机症状：「打字机没有字」。
                        //    ⇒ 把脚本抠出来手动跑一次。在我们自己的 WebView 沙箱里，
                        //      风险等同于宿主原本就在跑的那套 mermaid 页面，可控。
                        + "function runScripts(box){"
                        + "try{"
                        + "var ss=box.querySelectorAll('script');"
                        + "for(var i=0;i<ss.length;i++){"
                        + "var code=ss[i].textContent;"
                        + "if(code&&code.trim()){try{(new Function(code))();}catch(e){diag('JS_ERR '+e);}}"
                        + "ss[i].parentNode.removeChild(ss[i]);"
                        + "}"
                        + "}catch(e){diag('JS_ERR '+e);}"
                        + "}"

                        // ★★★ 核心：拼 innerHTML 会毁掉 SVG —— 见类注释第 4 条
                        + "function toPng(el,dark,cb){"
                        + "try{"
                        + "var w=Math.max(1,Math.ceil(el.offsetWidth||el.scrollWidth||320));"
                        + "var h=Math.max(1,Math.ceil(el.offsetHeight||el.scrollHeight||120));"
                        + "lastW=w;lastH=h;"
                        + "diag('size='+w+'x'+h);"
                        + "if(w>4000||h>8000){cb('TOO_LARGE '+w+'x'+h,null);return;}"
                        + "var cs=document.getElementById('fdmCss');"
                        + "var css=cs?cs.textContent:'';"
                        + "var fg=dark?'#e8e8e8':'#1a1a1a';"

                        + "var holder=document.createElement('div');"
                        + "holder.setAttribute('xmlns','http://www.w3.org/1999/xhtml');"
                        + "holder.setAttribute('style','padding:10px;color:'+fg+';width:'+w"
                        + "+'px;box-sizing:border-box');"
                        + "while(el.firstChild){holder.appendChild(el.firstChild);}"

                        + "var innerXml;"
                        + "try{innerXml=new XMLSerializer().serializeToString(holder);}"
                        + "catch(e){innerXml=holder.outerHTML;}"

                        + "var svg='<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"'+w+'\" height=\"'+h+'\">'"
                        + "+'<foreignObject width=\"100%\" height=\"100%\">'"
                        + "+'<style>'+esc(css)+'</style>'"
                        + "+innerXml"
                        + "+'</foreignObject></svg>';"
                        + "lastSvgLen=svg.length;"

                        + "var img=new Image();"
                        + "img.onload=function(){try{"
                        + "var c=document.createElement('canvas');c.width=w;c.height=h;"
                        + "var x=c.getContext('2d');x.drawImage(img,0,0);"      // 不 fillRect ⇒ 保留透明
                        + "cb(c.toDataURL('image/png'),null);"
                        + "}catch(e){cb(null,e);}};"
                        + "img.onerror=function(){cb('IMG_LOAD_FAILED(svg解析失败)',null);};"
                        + "img.src='data:image/svg+xml;charset=utf-8,'+encodeURIComponent(svg);"
                        + "}catch(e){cb(null,e);}}"

                        // ① 内联渲染（generator.html）→ 回 PNG 给 AndroidBridge
                        + "window.generateMermaid=function(src,theme){"
                        + "var my=++seq;"
                        + "try{"
                        + "var box=layout(src);"
                        + "setTimeout(function(){"
                        + "if(my!==seq)return;"
                        + "toPng(box,theme==='dark',function(u,e){"
                        + "if(my!==seq)return;"
                        + "if(e)failImg(e);else okImg(u);"
                        + "});"
                        + "},260);"
                        + "}catch(e){failImg(e);}"
                        + "};"

                        // ② 全屏预览（viewer.html）→ 回 FINISHED 给 NativeBridge
                        + "window.JSBridge=window.JSBridge||{};"
                        + "window.JSBridge.requestRenderMermaid=function(src,id){"
                        + "var my=++seq;"
                        + "try{"
                        + "layout(src);"
                        + "setTimeout(function(){if(my!==seq)return;okSvg(id);},260);"
                        + "}catch(e){okSvg(id);}"
                        + "};"
                        + "window.JSBridge.exportPngBase64=function(id){try{if(window.AndroidBridge"
                        + "&&window.AndroidBridge.onImageRenderFailed)window.AndroidBridge"
                        + ".onImageRenderFailed('RENDER_FAILED','no png');}catch(e){}};"
                        + "})();";
    }
}
