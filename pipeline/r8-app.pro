-dontobfuscate
-dontoptimize
-keepattributes Signature,InnerClasses,EnclosingMethod,*Annotation*
# 我们自己的代码
-keep class com.nidyaber.** { *; }
# ★ 放宽：androidx / kotlinx / kotlin 全保（用体积换稳定，不再被裁剪误伤）
-keep class androidx.** { *; }
-keep class kotlinx.** { *; }
-keep class kotlin.** { *; }
-keep class org.jetbrains.** { *; }
-dontwarn **
