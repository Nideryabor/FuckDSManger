import sys, time
import frida
pid=int(sys.argv[1])
dev=frida.get_device_manager().add_remote_device("127.0.0.1:27042")
sess=dev.attach(pid)
src=r"""
function S(o){ send(o); }
S({t:"java_available", v: (typeof Java !== 'undefined' ? Java.available : null)});
try { S({t:"libart", v: Process.getModuleByName("libart.so").name, base: Process.getModuleByName("libart.so").base.toString()}); }
catch(e){ S({t:"libart_err", e:String(e)}); }
try {
  var mods = Process.enumerateModules().map(function(m){return m.name;}).filter(function(n){return /art|dvm|jni/i.test(n);});
  S({t:"art_modules", v: mods});
} catch(e){ S({t:"enum_err", e:String(e)}); }
try { Java.performNow(function(){ S({t:"performNow_ok", n: Java.enumerateLoadedClassesSync().length}); }); }
catch(e){ S({t:"performNow_err", e:String(e)}); }
"""
s=sess.create_script(src)
s.on("message", lambda m,d: print("MSG:", m))
s.load()
time.sleep(6)
print("done")
