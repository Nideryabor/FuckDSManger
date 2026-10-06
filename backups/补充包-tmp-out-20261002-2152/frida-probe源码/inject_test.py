#!/usr/bin/env python3
"""inject_test.py —— 通过 frida-server 往一个进程里注入 agent，看它活不活

用法: python3 inject_test.py <pid>
"""
import sys
import frida

target = int(sys.argv[1])
print("frida(python) =", frida.__version__)

dev = frida.get_device_manager().add_remote_device("127.0.0.1:27042")
print("device ok:", dev)

sess = dev.attach(target)
print("attached pid", target)

src = r"""
console.log("[agent] alive! arch=" + Process.arch + " pid=" + Process.id + " ptr=" + Process.pointerSize);
console.log("[agent] version=" + Frida.version);
try {
  console.log("[agent] mainModule=" + Process.mainModule.name);
} catch (e) { console.log("[agent] mainModule err " + e); }
try {
  console.log("[agent] modules=" + Process.enumerateModules().length);
} catch (e) { console.log("[agent] enumModules err " + e); }
"""

script = sess.create_script(src)
script.on("message", lambda m, d: print("MSG:", m))
script.load()
print("=== script loaded, agent is running ===")
