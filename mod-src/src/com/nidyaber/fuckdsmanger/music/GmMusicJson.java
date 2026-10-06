// SPDX-License-Identifier: PolyForm-Noncommercial-1.0.0
// Copyright (c) 2026 尼得亚伯 (Nideryabor) & dxyabab | 仅供学习交流，禁止商业使用
package com.nidyaber.fuckdsmanger.music;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * 极简 JSON —— 只为「自己造 JSON + 读接口返回值」这两件事 🐲
 *
 * <p>为什么不直接上 {@code org.json}（Android 自带、零体积）：
 * <ul>
 *   <li>这个类**刻意不依赖任何 Android API** ⇒ 能在小窝里用 {@code javac} 直接编译、
 *       直接跑真请求验证（跟 GmMusicCrypto 同样的理由）</li>
 *   <li>只读少数字段，不需要完整实现；行为 100% 在自己手里</li>
 * </ul>
 *
 * <p>值域：{@code Map<String,Object>} / {@code List<Object>} / {@code String} /
 * {@code Double} / {@code Long} / {@code Boolean} / {@code null}
 */
public final class GmMusicJson {

    private GmMusicJson() {
    }

    // ══════════════════════════════ 解析 ══════════════════════════════

    public static Object parse(String s) {
        if (s == null) return null;
        P p = new P(s);
        p.ws();
        return p.value();
    }

    private static final class P {
        private final String s;
        private int i;

        P(String s) {
            this.s = s;
        }

        void ws() {
            while (i < s.length() && Character.isWhitespace(s.charAt(i))) i++;
        }

        char peek() {
            return i < s.length() ? s.charAt(i) : '\0';
        }

        Object value() {
            ws();
            char c = peek();
            switch (c) {
                case '{': return object();
                case '[': return array();
                case '"': return string();
                case 't': i += 4; return Boolean.TRUE;
                case 'f': i += 5; return Boolean.FALSE;
                case 'n': i += 4; return null;
                default:  return number();
            }
        }

        Map<String, Object> object() {
            Map<String, Object> m = new LinkedHashMap<String, Object>();
            i++;                       // {
            ws();
            if (peek() == '}') { i++; return m; }
            while (i < s.length()) {
                ws();
                String k = string();
                ws();
                if (peek() == ':') i++;
                m.put(k, value());
                ws();
                char c = peek();
                if (c == ',') { i++; continue; }
                if (c == '}') { i++; break; }
                break;                 // 格式坏了就停，别死循环
            }
            return m;
        }

        List<Object> array() {
            List<Object> l = new ArrayList<Object>();
            i++;                       // [
            ws();
            if (peek() == ']') { i++; return l; }
            while (i < s.length()) {
                l.add(value());
                ws();
                char c = peek();
                if (c == ',') { i++; continue; }
                if (c == ']') { i++; break; }
                break;
            }
            return l;
        }

        String string() {
            StringBuilder sb = new StringBuilder();
            if (peek() != '"') return sb.toString();
            i++;
            while (i < s.length()) {
                char c = s.charAt(i++);
                if (c == '"') break;
                if (c != '\\') { sb.append(c); continue; }
                if (i >= s.length()) break;
                char e = s.charAt(i++);
                switch (e) {
                    case 'n': sb.append('\n'); break;
                    case 't': sb.append('\t'); break;
                    case 'r': sb.append('\r'); break;
                    case 'b': sb.append('\b'); break;
                    case 'f': sb.append('\f'); break;
                    case '/': sb.append('/');  break;
                    case '"': sb.append('"');  break;
                    case '\\': sb.append('\\'); break;
                    case 'u':
                        if (i + 4 <= s.length()) {
                            try {
                                sb.append((char) Integer.parseInt(s.substring(i, i + 4), 16));
                            } catch (Throwable ignore) {
                            }
                            i += 4;
                        }
                        break;
                    default: sb.append(e);
                }
            }
            return sb.toString();
        }

        Object number() {
            int st = i;
            while (i < s.length()) {
                char c = s.charAt(i);
                if (c == '-' || c == '+' || c == '.' || c == 'e' || c == 'E'
                        || (c >= '0' && c <= '9')) {
                    i++;
                } else {
                    break;
                }
            }
            String t = s.substring(st, i);
            if (t.length() == 0) return null;
            try {
                if (t.indexOf('.') < 0 && t.indexOf('e') < 0 && t.indexOf('E') < 0) {
                    return Long.valueOf(Long.parseLong(t));
                }
                return Double.valueOf(Double.parseDouble(t));
            } catch (Throwable e) {
                return null;
            }
        }
    }

    // ══════════════════════════════ 构造 ══════════════════════════════

    /** 把值转成 JSON 文本（String 会转义；Map/List 递归）。 */
    public static String write(Object v) {
        StringBuilder sb = new StringBuilder();
        writeTo(sb, v);
        return sb.toString();
    }

    private static void writeTo(StringBuilder sb, Object v) {
        if (v == null) {
            sb.append("null");
        } else if (v instanceof String) {
            quote(sb, (String) v);
        } else if (v instanceof Boolean || v instanceof Number) {
            sb.append(String.valueOf(v));
        } else if (v instanceof Map) {
            sb.append('{');
            boolean first = true;
            for (Map.Entry<?, ?> e : ((Map<?, ?>) v).entrySet()) {
                if (!first) sb.append(',');
                first = false;
                quote(sb, String.valueOf(e.getKey()));
                sb.append(':');
                writeTo(sb, e.getValue());
            }
            sb.append('}');
        } else if (v instanceof List) {
            sb.append('[');
            boolean first = true;
            for (Object o : (List<?>) v) {
                if (!first) sb.append(',');
                first = false;
                writeTo(sb, o);
            }
            sb.append(']');
        } else {
            quote(sb, String.valueOf(v));
        }
    }

    private static void quote(StringBuilder sb, String s) {
        sb.append('"');
        for (int i = 0; i < s.length(); i++) {
            char c = s.charAt(i);
            switch (c) {
                case '"':  sb.append("\\\""); break;
                case '\\': sb.append("\\\\"); break;
                case '\n': sb.append("\\n");  break;
                case '\r': sb.append("\\r");  break;
                case '\t': sb.append("\\t");  break;
                case '\b': sb.append("\\b");  break;
                case '\f': sb.append("\\f");  break;
                default:
                    if (c < 0x20) sb.append(String.format("\\u%04x", (int) c));
                    else sb.append(c);
            }
        }
        sb.append('"');
    }

    /** 造一个有序的 JSON 对象（少打字）。 */
    public static Map<String, Object> obj() {
        return new LinkedHashMap<String, Object>();
    }

    /** 造一个有序的 JSON 对象：{@code obj("key1", v1, "key2", v2, …)}。 */
    public static Map<String, Object> obj(Object... kv) {
        Map<String, Object> m = obj();
        for (int i = 0; i + 1 < kv.length; i += 2) {
            m.put(String.valueOf(kv[i]), kv[i + 1]);
        }
        return m;
    }

    // ══════════════════════════════ 取值 ══════════════════════════════

    @SuppressWarnings("unchecked")
    public static Map<String, Object> asObj(Object o) {
        return o instanceof Map ? (Map<String, Object>) o : null;
    }

    @SuppressWarnings("unchecked")
    public static List<Object> asArr(Object o) {
        return o instanceof List ? (List<Object>) o : null;
    }

    /** 从对象里取子对象。 */
    public static Map<String, Object> sub(Object o, String key) {
        Map<String, Object> m = asObj(o);
        return m == null ? null : asObj(m.get(key));
    }

    /** 从对象里取子数组。 */
    public static List<Object> arr(Object o, String key) {
        Map<String, Object> m = asObj(o);
        return m == null ? null : asArr(m.get(key));
    }

    public static String str(Object o, String key, String def) {
        Map<String, Object> m = asObj(o);
        if (m == null) return def;
        Object v = m.get(key);
        return v == null ? def : String.valueOf(v);
    }

    public static long lng(Object o, String key, long def) {
        Map<String, Object> m = asObj(o);
        if (m == null) return def;
        Object v = m.get(key);
        if (v instanceof Number) return ((Number) v).longValue();
        if (v instanceof String) {
            try {
                return Long.parseLong((String) v);
            } catch (Throwable ignore) {
            }
        }
        return def;
    }

    public static int in(Object o, String key, int def) {
        return (int) lng(o, key, def);
    }

    public static boolean bool(Object o, String key, boolean def) {
        Map<String, Object> m = asObj(o);
        if (m == null) return def;
        Object v = m.get(key);
        if (v instanceof Boolean) return (Boolean) v;
        return def;
    }
}
