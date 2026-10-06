import frida, traceback
print("frida python", frida.__version__)
dm = frida.get_device_manager()

print("--- ① 不带 token 连 ---")
try:
    d = dm.add_remote_device("127.0.0.1:27042")
    ps = d.enumerate_processes()
    print("   ✗ 居然成功了！进程数", len(ps))
except Exception as e:
    print("   ✓ 被拒:", type(e).__name__, str(e)[:160])

print("--- ② 带 token 连 ---")
try:
    d2 = dm.add_remote_device("127.0.0.1:27042", token="SECRET_DRAGON_123")
    ps = d2.enumerate_processes()
    print("   ✓ 成功！进程数", len(ps))
except TypeError as e:
    print("   (这个版本的 API 不吃 token 参数):", e)
except Exception as e:
    print("   ✗ 失败:", type(e).__name__, str(e)[:160])
