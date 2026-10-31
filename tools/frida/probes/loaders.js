'use strict';
function P(s){console.log(s);}
function first(e){return (e&&e.message)?String(e.message).split('\n')[0]:String(e);}
Java.perform(function(){
  var R=[];
  var K=Java.use('com.ishumei.smantifraud.l1111l111111Il');
  R.push('=== l111l11111Il (hook表) 作为 Map 展开 ===');
  try{
    var v=K.l111l11111Il.call(K);
    var M=Java.use('java.util.Map');
    var m=Java.cast(v,M);
    var sz=m.size();
    R.push('  Map.size()='+sz);
    var it=m.entrySet().iterator();var n=0;
    while(it.hasNext()&&n<40){var e=it.next();R.push('   key='+String(e.getKey())+'  val='+String(e.getValue()).substring(0,80));n++;}
    if(n===0)R.push('  ★ Map 是空的');
  }catch(e){R.push('  FAIL: '+first(e));}

  R.push('');
  R.push('=== mLoaders 用 Java.cast 展开 ===');
  try{
    var C=Java.use('android.app.ApplicationLoaders');
    var f=C.class.getDeclaredField('gApplicationLoaders');f.setAccessible(true);
    var gal=f.get(null);
    var f2=gal.getClass().getDeclaredField('mLoaders');f2.setAccessible(true);
    var map=f2.get(gal);
    var M2=Java.use('java.util.Map');
    var mm=Java.cast(map,M2);
    R.push('  mLoaders.size()='+mm.size());
    var it2=mm.entrySet().iterator();var c=0;
    while(it2.hasNext()&&c<30){
      var e2=it2.next();
      var ks=String(e2.getKey());
      var hit=(ks.indexOf('LspModule')>=0||ks.indexOf('little_femaleboy')>=0)?'  ★★★ 命中':'';
      R.push('   ['+c+'] '+ks.substring(0,150)+hit);
      c++;
    }
    if(c===0)R.push('  ★ mLoaders 是空的');
  }catch(e){R.push('  FAIL: '+first(e));}

  R.push('');
  R.push('=== DONE ===');
  P(R.join('\n'));
});
