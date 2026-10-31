console.log('PING-OK agent alive, frida ' + Frida.version + ' runtime=' + Script.runtime);
console.log('android=' + (Java.available ? 'java-bridge-ok' : 'java-bridge-NO'));
if (Java.available) {
  Java.perform(function () {
    console.log('inside Java.perform ✓');
    try {
      var A = Java.use('android.app.ActivityThread');
      var app = A.currentApplication();
      console.log('pkg=' + (app ? app.getPackageName() : 'null'));
    } catch (e) { console.log('err=' + e); }
    console.log('PING-DONE');
  });
}
