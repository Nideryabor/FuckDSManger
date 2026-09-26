# 主 dex 只放"启动就必须要"的：应用入口
-keep class com.nidyaber.fuckdsmanger.MainActivity { *; }
-keep class androidx.core.app.CoreComponentFactory { *; }
