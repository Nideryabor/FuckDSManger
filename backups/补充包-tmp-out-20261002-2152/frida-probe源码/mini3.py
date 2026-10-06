import sys, time
import frida
pid=int(sys.argv[1])
dev=frida.get_device_manager().add_remote_device("127.0.0.1:27042")
sess=dev.attach(pid)
src=r"""
Java.performNow(function(){
  var P = Java.use("android.os.Process");
  send({t:"myPid", v: P.myPid()});
  send({t:"myUid", v: P.myUid()});
  var S = Java.use("java.lang.System");
  send({t:"lineSep", v: S.lineSeparator()});
  // 真·hook 一下：把 System.currentTimeMillis 拦下来
  var cur = S.currentTimeMillis;
  cur.implementation = function(){
    var real = cur.call(this);
    send({t:"hooked", v: real});
    return real;
  };
  send({t:"hook_installed", v: true});
  send({t:"t_now", v: S.currentTimeMillis()});
});
"""
s=sess.create_script(src)
s.on("message", lambda m,d: print("MSG:", m))
s.load()
time.sleep(6)
print("done")
