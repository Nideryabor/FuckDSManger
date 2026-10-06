console.log("[inject] 活着! pid=" + Process.id + " arch=" + Process.arch + " ptr=" + Process.pointerSize);
var n = Process.enumerateModules().length;
console.log("[inject] 模块数=" + n);
console.log("[inject] 主模块=" + Process.mainModule.name);
