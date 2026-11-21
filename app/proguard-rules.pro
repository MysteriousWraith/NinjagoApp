-keepattributes *Annotation*, InnerClasses
-dontnote kotlinx.serialization.AnnotationsKt
-keepclassmembers class kotlinx.serialization.json.** {
    *** Companion;
}
-keepclasseswithmembers class kotlinx.serialization.json.** {
    kotlinx.serialization.KSerializer serializer(...);
}
-keep,includedescriptorclasses class ua.ninjago.archive.data.model.**$$serializer { *; }
-keepclassmembers class ua.ninjago.archive.data.model.** {
    *** Companion;
}
-keepclasseswithmembers class ua.ninjago.archive.data.model.** {
    kotlinx.serialization.KSerializer serializer(...);
}
