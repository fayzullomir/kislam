# flutter_local_notifications relies on Gson to (de)serialize the
# persisted scheduled-notification cache. R8 strips the generic
# Signature metadata that Gson's TypeToken needs, which throws
# "Missing type parameter." on cancel()/zonedSchedule() in release.
-keepattributes Signature
-keepattributes *Annotation*
-keepattributes InnerClasses,EnclosingMethod

-keep class com.dexterous.flutterlocalnotifications.** { *; }
-keep class com.dexterous.flutterlocalnotifications.models.** { *; }

# Gson type-token support
-keep class com.google.gson.reflect.TypeToken { *; }
-keep class * extends com.google.gson.reflect.TypeToken
-keep,allowobfuscation,allowshrinking class com.google.gson.reflect.TypeToken
-keep,allowobfuscation,allowshrinking class * extends com.google.gson.reflect.TypeToken
