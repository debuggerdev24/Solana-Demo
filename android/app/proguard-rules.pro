# Add these rules to android/app/proguard-rules.pro

# ===== Flutter Secure Storage =====
-keep class com.it_nomads.fluttersecurestorage.** { *; }
-dontwarn com.it_nomads.fluttersecurestorage.**

# ===== Solana Wallet Adapter =====
-keep class com.solana.** { *; }
-dontwarn com.solana.**
-keepclassmembers class com.solana.** { *; }

# ===== Cryptography Package =====
-keep class org.bouncycastle.** { *; }
-dontwarn org.bouncycastle.**
-keepclassmembers class org.bouncycastle.** { *; }

# ===== JWT and Authentication =====
-keep class io.jsonwebtoken.** { *; }
-dontwarn io.jsonwebtoken.**

# ===== Reflection for Provider =====
-keep class * extends androidx.lifecycle.ViewModel { *; }
-keep class * extends androidx.lifecycle.AndroidViewModel { *; }

# ===== Keep Provider Classes =====
-keep class ** extends java.util.ListResourceBundle {
    protected java.lang.Object[][] getContents();
}

# ===== General Flutter Rules =====
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# ===== Gson (if used for JSON) =====
-keepattributes Signature
-keepattributes *Annotation*
-dontwarn sun.misc.**
-keep class com.google.gson.** { *; }
-keep class * implements com.google.gson.TypeAdapterFactory
-keep class * implements com.google.gson.JsonSerializer
-keep class * implements com.google.gson.JsonDeserializer

# ===== Keep Data Classes =====
-keepclassmembers class * {
    @com.google.gson.annotations.SerializedName <fields>;
}

# ===== Provider Package =====
-keep class androidx.lifecycle.** { *; }
-dontwarn androidx.lifecycle.**