#!/usr/bin/env python3
"""java_test.py —— 测试 Java 桥能不能用（真正要用的那一半）

用法: python3 java_test.py <pid>
"""
import sys
import frida

pid = int(sys.argv[1])
dev = frida.get_device_manager().add_remote_device("127.0.0.1:27042")
sess = dev.attach(pid)
print("attached", pid)

src = r"""
Java.perform(function () {
  console.log("[java] Java bridge OK");
  console.log("[java] VM classes loaded = " + Java.enumerateLoadedClassesSync().length);
  var n = 0;
  Java.enumerateLoadedClassesSync().forEach(function (c) {
    if (c.indexOf("android.os.Process") === 0) { console.log("[java]   " + c); n++; }
  });
  console.log("[java] android.os.* 命中 " + n);
  try {
    var P = Java.use("android.os.Process");
    console.log("[java] myPid via Java = " + P.myPid());
  } catch (e) { console.log("[java] Process.myPid err: " + e); }
});
"""

import time

script = sess.create_script(src)
script.on("message", lambda m, d: print("MSG:", m))
script.load()
time.sleep(4)          # Java.perform 是异步的，等一等
print("=== Java 桥测试结束 ===")
