// DlopenProbe.java —— 把 frida-agent 当普通 .so 直接 dlopen
//
//  目的：复现 frida-agent 在 dlopen 阶段（.init_array 构造函数）的 NULL 解引用，
//        但完全不经过 frida 注入器 / zygote / 系统 App。
//
//  跑法（shell 身份就够）：
//    adb shell 'CLASSPATH=/data/local/tmp/dlopen_probe.jar app_process /system/bin DlopenProbe'
//
//  顺带把「agent 初始化要读的 /proc 入口」也读一遍（auxv / maps / status），
//  看这台机器上的 susfs 有没有在这几个地方动手脚。

import java.io.*;

public class DlopenProbe {

    static void p(String s) { System.out.println("[probe] " + s); }

    /** 把一个文件整个读掉，返回字节数（失败返回 -1），不打印内容。 */
    static long drain(File f) {
        InputStream in = null;
        try {
            in = new FileInputStream(f);
            byte[] buf = new byte[8192];
            long n = 0;
            int r;
            while ((r = in.read(buf)) > 0) n += r;
            return n;
        } catch (Throwable t) {
            p("read " + f + " FAILED: " + t);
            return -1;
        } finally {
            if (in != null) try { in.close(); } catch (Throwable ignored) {}
        }
    }

    /** auxv 是 (type,value) 的 u64 对，必须 8 字节对齐；半截数据就是「读坏了」。 */
    static void probeAuxv() {
        InputStream in = null;
        try {
            in = new FileInputStream("/proc/self/auxv");
            ByteArrayOutputStream bo = new ByteArrayOutputStream();
            byte[] buf = new byte[4096];
            int r;
            while ((r = in.read(buf)) > 0) bo.write(buf, 0, r);
            byte[] d = bo.toByteArray();
            p("/proc/self/auxv: " + d.length + " bytes, %8=" + (d.length % 8));
            StringBuilder sb = new StringBuilder();
            for (int i = 0; i + 15 < d.length && i < 16 * 3; i += 16) {
                long t = 0, v = 0;
                for (int k = 0; k < 8; k++) t |= (long) (d[i + k] & 0xff) << (8 * k);
                for (int k = 0; k < 8; k++) v |= (long) (d[i + 8 + k] & 0xff) << (8 * k);
                sb.append(String.format("  AT_%d=%#x", t, v));
            }
            p("auxv head:" + sb);
        } catch (Throwable t) {
            p("/proc/self/auxv FAILED: " + t);
        } finally {
            if (in != null) try { in.close(); } catch (Throwable ignored) {}
        }
    }

    static void probeMaps() {
        BufferedReader br = null;
        try {
            br = new BufferedReader(new FileReader("/proc/self/maps"));
            String l;
            int n = 0, frida = 0, exec = 0;
            while ((l = br.readLine()) != null) {
                n++;
                if (l.contains("frida")) frida++;
                if (l.contains(" r-x") || l.contains("r-xp")) exec++;
            }
            p("/proc/self/maps: lines=" + n + " frida=" + frida + " exec=" + exec);
        } catch (Throwable t) {
            p("/proc/self/maps FAILED: " + t);
        } finally {
            if (br != null) try { br.close(); } catch (Throwable ignored) {}
        }
    }

    public static void main(String[] args) {
        p("uid=" + android.os.Process.myUid() + " pid=" + android.os.Process.myPid());
        p("sdk=" + android.os.Build.VERSION.SDK_INT
          + " abi=" + (android.os.Build.SUPPORTED_ABIS.length > 0
                       ? android.os.Build.SUPPORTED_ABIS[0] : "?"));

        // ① 先把 agent 初始化会碰的 /proc 入口全读一遍
        probeAuxv();
        probeMaps();
        p("/proc/self/status bytes=" + drain(new File("/proc/self/status")));
        p("/proc/self/cmdline bytes=" + drain(new File("/proc/self/cmdline")));
        p("/proc/self/exe -> " + drain(new File("/proc/self/exe")));
        p("/proc/mounts bytes=" + drain(new File("/proc/mounts")));

        // ② 真正的那一刀：dlopen 这只 agent
        String path = args.length > 0 ? args[0]
                                      : "/data/local/tmp/frida-agent-64.so";
        p("=== dlopen: " + path + " ===");
        long t0 = System.currentTimeMillis();
        try {
            System.load(path);
            p("System.load OK  (+" + (System.currentTimeMillis() - t0) + " ms)");
        } catch (Throwable t) {
            p("System.load THREW  (+" + (System.currentTimeMillis() - t0) + " ms): " + t);
            t.printStackTrace(System.out);
        }
        p("=== 活下来了（说明构造函数跑完了）===");
    }
}
