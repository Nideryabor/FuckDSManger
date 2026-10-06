import sys, time, traceback
import frida
pid=int(sys.argv[1])
print("frida", frida.__version__)
dev=frida.get_device_manager().add_remote_device("127.0.0.1:27042")
sess=dev.attach(pid)
print("attached", pid)
src=r"""
console.log("[mini] hello");
send({tag:"mini", hasJava: (typeof Java !== 'undefined')});
try {
  Java.perform(function(){
    send({tag:"inj", n: Java.enumerateLoadedClassesSync().length});
  });
} catch (e) { send({tag:"err", e: String(e)}); }
"""
s=sess.create_script(src)
def on_msg(m,d):
    print("MSG:", m)
s.on("message", on_msg)
try:
    s.load()
    print("loaded")
except Exception as e:
    traceback.print_exc()
time.sleep(5)
print("done")
