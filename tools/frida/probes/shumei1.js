/*
 * shumei1.js —— 数美 libsmsdk.so 行为探针（2026-10-24）
 *
 * 目的：看清它到底
 *   ① 调了哪些 syscall（尤其 openat/getdents64/connect/sendto）
 *   ② 扫了哪些目录（opendir/readdir）
 *   ③ 执行了哪些 shell（popen）
 *   ④ 读了哪些系统属性（__system_property_get）
 *   ⑤ 探了哪些端口（socket/connect）
 *
 * ★ 关键：只抓「调用点落在 libsmsdk.so 内」的调用 ——
 *   libc 自己内部狂调 syscall，全打印会淹掉。
 *
 * ★ 已知：libsmsdk.so 的 .text 段 0 处内联 svc ⇒ 全走 libc 函数 + syscall()，
 *   所以 hook libc 是有效的。
 */

'use strict';

var TAG = '[shu]';
var MAX = 400;          // 每类最多记多少条，防爆
var buf = { syscall: [], opendir: [], popen: [], prop: [], sock: [] };
var counts = {};

function log(s) { try { console.log(s); } catch (e) {} }
function push(kind, line) {
    counts[kind] = (counts[kind] || 0) + 1;
    if (buf[kind] && buf[kind].length < MAX) buf[kind].push(line);
}

/** 判断 returnAddress 是否落在 libsmsdk.so 里 */
function fromShumei(ctx) {
    try {
        var ra = ctx.returnAddress;
        if (!ra) return null;
        var m = Process.findModuleByAddress(ra);
        if (m && m.name && m.name.indexOf('libsmsdk') >= 0) {
            return '0x' + ra.sub(m.base).toString(16);
        }
        return null;
    } catch (e) { return null; }
}

/** AArch64 syscall 号 → 名字（只收我们关心的） */
var SYS = {
    48: 'faccessat', 49: 'chdir', 56: 'openat', 57: 'close',
    61: 'getdents64', 62: 'lseek', 63: 'read', 64: 'write',
    65: 'readv', 66: 'writev', 67: 'pread64', 78: 'readlinkat',
    79: 'newfstatat', 80: 'fstat', 203: 'connect', 206: 'sendto',
    211: 'sendmsg', 220: 'clone', 221: 'execve', 281: 'socket' /* 实际是 __NR_socket 198 */,
    198: 'socket', 200: 'bind', 242: 'accept4', 43: 'statfs'
};

function readStr(p, max) {
    try {
        if (!p || p.isNull()) return '(null)';
        return Memory.readUtf8String(p, Math.min(max || 256, 256));
    } catch (e) { return '<?>'; }
}

// ───────────────────────── ① syscall ─────────────────────────
function hookSyscall() {
    var addr = null;
    try { addr = Module.getExportByName('libc.so', 'syscall'); } catch (e) {}
    if (!addr) { log(TAG + ' ✗ 找不到 libc.syscall'); return; }
    log(TAG + ' hook syscall @ ' + addr);

    Interceptor.attach(addr, {
        onEnter: function (args) {
            var off = fromShumei(this.context);
            if (!off) return;
            var nr = args[0].toInt32();
            var name = SYS[nr] || ('nr' + nr);
            var line = name + '(' + nr + ')';
            // 关键几个：把第一个指针参数当路径读出来
            if (nr === 56 || nr === 48 || nr === 78 || nr === 79) {
                // openat(dirfd, path, ...)
                line += ' path=' + readStr(args[1]);
            } else if (nr === 203) {
                // connect(fd, sockaddr*, len)
                try {
                    var sa = args[1];
                    var fam = Memory.readU16(sa);
                    if (fam === 2) {   // AF_INET
                        var port = (Memory.readU8(sa.add(2)) << 8) | Memory.readU8(sa.add(3));
                        var ip = [];
                        for (var i = 0; i < 4; i++) ip.push(Memory.readU8(sa.add(4 + i)));
                        line += ' fd=' + args[0].toInt32() + ' → ' + ip.join('.') + ':' + port;
                    } else {
                        line += ' fd=' + args[0].toInt32() + ' family=' + fam;
                    }
                } catch (e) {}
            } else if (nr === 206) {
                // sendto(fd, buf, len, ...)
                line += ' fd=' + args[0].toInt32() + ' len=' + args[2].toInt32();
            } else if (nr === 61) {
                line += ' fd=' + args[0].toInt32();
            }
            push('syscall', line + '  @' + off);
        }
    });
}

// ───────────────────── ② opendir / readdir ─────────────────────
function hookDir() {
    var od = null, rd = null;
    try { od = Module.getExportByName('libc.so', 'opendir'); } catch (e) {}
    try { rd = Module.getExportByName('libc.so', 'readdir'); } catch (e) {}

    if (od) {
        log(TAG + ' hook opendir @ ' + od);
        Interceptor.attach(od, {
            onEnter: function (args) {
                var off = fromShumei(this.context);
                if (!off) return;
                push('opendir', 'opendir(' + readStr(args[0]) + ')  @' + off);
            }
        });
    }
    if (rd) {
        Interceptor.attach(rd, {
            onEnter: function (args) { this._from = fromShumei(this.context); },
            onExit: function (ret) {
                if (!this._from || ret.isNull()) return;
                try {
                    // struct dirent: d_name 在 offset 19 (arm64)
                    var nm = Memory.readUtf8String(ret.add(19));
                    if (nm === '.' || nm === '..') return;
                    push('opendir', '  ↳ ' + nm);
                } catch (e) {}
            }
        });
    }
}

// ───────────────────────── ③ popen ─────────────────────────
function hookPopen() {
    var a = null;
    try { a = Module.getExportByName('libc.so', 'popen'); } catch (e) {}
    if (!a) return;
    log(TAG + ' hook popen @ ' + a);
    Interceptor.attach(a, {
        onEnter: function (args) {
            var off = fromShumei(this.context);
            if (!off) return;
            push('popen', 'popen(' + readStr(args[0]) + ')  @' + off);
        }
    });
}

// ────────────────── ④ __system_property_get ──────────────────
function hookProp() {
    var a = null;
    try { a = Module.getExportByName('libc.so', '__system_property_get'); } catch (e) {}
    if (!a) return;
    log(TAG + ' hook __system_property_get @ ' + a);
    Interceptor.attach(a, {
        onEnter: function (args) {
            this._from = fromShumei(this.context);
            this._key = readStr(args[0]);
            this._out = args[1];
        },
        onExit: function (ret) {
            if (!this._from) return;
            var val = '';
            try { val = readStr(this._out, 92); } catch (e) {}
            push('prop', this._key + ' = ' + JSON.stringify(val) + '  @' + this._from);
        }
    });
}

// ───────────────────── ⑤ socket / bind ─────────────────────
function hookSock() {
    var sk = null;
    try { sk = Module.getExportByName('libc.so', 'socket'); } catch (e) {}
    if (!sk) return;
    log(TAG + ' hook socket @ ' + sk);
    Interceptor.attach(sk, {
        onEnter: function (args) {
            var off = fromShumei(this.context);
            if (!off) return;
            push('sock', 'socket(domain=' + args[0].toInt32()
                + ', type=' + args[1].toInt32() + ')  @' + off);
        }
    });
}

// ─────────────────── ⑥ 9 个 JNI fnPtr 命中 ───────────────────
// 地址来自静态分析（.data.rel.ro @ 0xc6ec8，9 项）
var JNI_OFFSETS = [0xa07c, 0xa2d8, 0xa2cc, 0xa2b4, 0xa2e4, 0xa448, 0xa73c, 0xa764, 0xa5b4];
var jniHits = {};

function hookJni() {
    var m = Process.findModuleByName('libsmsdk.so');
    if (!m) { log(TAG + ' ✗ libsmsdk.so 还没加载'); return false; }
    log(TAG + ' libsmsdk.so base=' + m.base + ' size=' + m.size);
    JNI_OFFSETS.forEach(function (off) {
        var p = m.base.add(off);
        try {
            Interceptor.attach(p, {
                onEnter: function () {
                    var k = '0x' + off.toString(16);
                    jniHits[k] = (jniHits[k] || 0) + 1;
                }
            });
            log(TAG + ' hook JNI fnPtr 0x' + off.toString(16) + ' ✓');
        } catch (e) {
            log(TAG + ' hook JNI 0x' + off.toString(16) + ' ✗ ' + e.message);
        }
    });
    return true;
}

// ───────────────────────── 主流程 ─────────────────────────
function dump() {
    log('');
    log('══════════ 数美行为汇总 ══════════');
    var order = [
        ['syscall', '① syscall'],
        ['opendir', '② 目录扫描'],
        ['popen', '③ shell'],
        ['prop', '④ 系统属性'],
        ['sock', '⑤ socket']
    ];
    order.forEach(function (kv) {
        log('--- ' + kv[1] + ' （共 ' + (counts[kv[0]] || 0) + ' 次）---');
        (buf[kv[0]] || []).forEach(function (l) { log('  ' + l); });
    });
    log('--- ⑥ JNI fnPtr 命中 ---');
    Object.keys(jniHits).forEach(function (k) { log('  ' + k + ' × ' + jniHits[k]); });
    if (Object.keys(jniHits).length === 0) log('  (无)');
    log('══════════════════════════════════');
}

rpc.exports = {
    dump: function () { dump(); return true; },
    counts: function () { return counts; }
};

function main() {
    log(TAG + ' ===== 数美探针启动 =====');
    hookSyscall();
    hookDir();
    hookPopen();
    hookProp();
    hookSock();

    // libsmsdk 可能还没加载 —— 轮询等它
    var tries = 0;
    var iv = setInterval(function () {
        tries++;
        if (hookJni()) {
            clearInterval(iv);
            log(TAG + ' JNI 钩子就位（第 ' + tries + ' 次探测）');
        }
        if (tries > 40) {
            clearInterval(iv);
            log(TAG + ' ⚠ 40 次仍未找到 libsmsdk.so');
        }
    }, 500);

    // 25 秒后自动汇总（网关是 -p attach，跑完就退）
    setTimeout(function () {
        try { dump(); } catch (e) { log(TAG + ' dump 失败: ' + e); }
        log(TAG + ' 探针结束');
        try { Java.perform(function () {}); } catch (e) {}
    }, 25000);
}

setImmediate(main);
