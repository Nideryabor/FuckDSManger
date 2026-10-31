'use strict';
function P(s){console.log(s);}
function first(e){return (e&&e.message)?String(e.message).split('\n')[0]:String(e);}
function dump(v,label){
  var out=[];
  try{
    var s=v.toString();
    out.push('  '+label+' toString() = '+(s.length>600?s.substring(0,600)+'...':s));
  }catch(e){out.push('  '+label+' toString FAIL: '+first(e));}
  try{
    var it=v.iterator();
    var n=0,items=[];
    while(it.hasNext()&&n<30){items.push(String(it.next()));n++;}
    out.push('  '+label+' 元素数(前30)='+n+' -> '+JSON.stringify(items));
  }catch(e){out.push('  '+label+' iterator FAIL: '+first(e));}
  return out;
}
Java.perform(function(){
  var R=[];
  var SM='com.ishumei.smantifraud.l1111l111111Il';
  var K=Java.use(SM);
  R.push('=== 三个集合方法的内容 ===');
  var coll=[['l111l11111Il','XposedBridge hook表'],['l111l1111l1Il','XposedHelpers缓存'],['l111l1111llIl','maps扫描结果(xpApp)']];
  coll.forEach(function(c){
    R.push('');R.push('[ '+c[0]+' ]  '+c[1]);
    try{ var v=K[c[0]].call(K); R=R.concat(dump(v,c[0])); }catch(e){R.push('  调用失败: '+first(e));}
  });
  R.push('');
  R.push('=== mLoaders（ArrayMap toString）===');
  try{
    var C=Java.use('android.app.ApplicationLoaders');
    var f=C.class.getDeclaredField('gApplicationLoaders');f.setAccessible(true);
    var gal=f.get(null);
    var f2=gal.getClass().getDeclaredField('mLoaders');f2.setAccessible(true);
    var map=f2.get(gal);
    var s=map.toString();
    R.push('  size='+map.size());
    R.push('  '+(s.length>1500?s.substring(0,1500)+'...':s));
    R.push('  含 little_femaleboy = '+(s.indexOf('little_femaleboy')>=0?'★★★ 是':'否'));
    R.push('  含 LspModule        = '+(s.indexOf('LspModule')>=0?'★★★ 是':'否'));
  }catch(e){R.push('  FAIL: '+first(e));}
  R.push('');
  R.push('=== DONE ===');
  P(R.join('\n'));
});
