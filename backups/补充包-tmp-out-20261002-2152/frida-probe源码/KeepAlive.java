// KeepAlive.java —— 一个常驻的 ART 进程，专门给 frida 当靶子（零风险：只是 sleep）
public class KeepAlive {
    public static void main(String[] args) throws Exception {
        System.out.println("[keepalive] pid=" + android.os.Process.myPid()
                + " uid=" + android.os.Process.myUid());
        System.out.println("[keepalive] 挂着等 frida……");
        while (true) Thread.sleep(60000);
    }
}
