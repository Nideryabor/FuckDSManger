import frida, time, sys
PORT = sys.argv[1] if len(sys.argv)>1 else "34636"
d = frida.get_device_manager().add_remote_device("127.0.0.1:"+PORT)
procs = d.enumerate_processes()
tgt = [p for p in procs if p.pid == 21349]
if not tgt:
    tgt = [p for p in procs if "deepseek" in p.name.lower()]
print("目标:", tgt[0].name, tgt[0].pid)
sess = d.attach(tgt[0].pid)
print("attached ✓")
src = r"""
Java.performNow(function(){
  var all = Java.enumerateLoadedClassesSync();
  send({t:"ok", total: all.length});
  var hits = all.filter(function(c){ return /Modifier|DrawScope|GraphicsLayer|Semantics/.test(c); });
  send({t:"hits", n: hits.length, sample: hits.slice(0,6)});
});
"""
sc = sess.create_script(src)
sc.on("message", lambda m,dd: print("MSG:", m))
sc.load()
time.sleep(5)
print("=== done ===")
