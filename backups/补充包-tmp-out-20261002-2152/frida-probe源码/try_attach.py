import frida, time, sys
PORT = "34636"
d = frida.get_device_manager().add_remote_device("127.0.0.1:"+PORT)
procs = {p.pid: p.name for p in d.enumerate_processes()}
for want in ("RikkaHub", "Termux", "DeepSeek"):
    cand = [pid for pid,name in procs.items() if name == want]
    if not cand:
        print("%-10s 没找到" % want); continue
    pid = cand[0]
    print("--- 试 %s (pid %d) ---" % (want, pid))
    t0 = time.time()
    try:
        s = d.attach(pid)
        print("    ✓ attached (%.1fs)" % (time.time()-t0))
        try:
            s.detach()
        except Exception:
            pass
    except Exception as e:
        print("    ✗ %s: %s (%.1fs)" % (type(e).__name__, str(e)[:90], time.time()-t0))
