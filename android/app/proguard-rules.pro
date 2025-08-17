# Reglas específicas para reconocimiento de voz y micrófono
-keep class com.google.android.gms.speech.** { *; }
-keep class android.speech.** { *; }
-keep class com.google.android.tts.** { *; }

# Reglas para Flutter y plugins
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Reglas para permission_handler
-keep class com.baseflow.permissionhandler.** { *; }
-keep class androidx.core.app.** { *; }

# Reglas para speech_to_text
-keep class com.csdcorp.speech_to_text.** { *; }
-keep class com.google.android.gms.** { *; }

# Reglas para Firebase (si usas Firebase)
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }

# Reglas generales de Android
-keepattributes *Annotation*
-keepattributes SourceFile,LineNumberTable
-keep public class * extends java.lang.Exception

# Reglas para micrófono y audio
-keep class android.media.** { *; }
-keep class android.media.audiofx.** { *; }

# Reglas para servicios de reconocimiento
-keep class android.speech.RecognitionService { *; }
-keep class android.speech.SpeechRecognizer { *; }

# Reglas para Google Play Services
-keep class com.google.android.gms.common.** { *; }
-keep class com.google.android.gms.auth.** { *; }
