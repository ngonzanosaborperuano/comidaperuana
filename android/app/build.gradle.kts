plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.ngonzano.goncook"
    compileSdk = 36
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }
    
    // Configuración para Android 15+ (API 36)
    buildFeatures {
        buildConfig = true
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.ngonzano.goncook"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review/gradle-config.
        minSdk = 35
        targetSdk = 35
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        
        // Configuración específica para permisos de micrófono y reconocimiento de voz
        manifestPlaceholders["usesMicrophone"] = "true"
        manifestPlaceholders["usesSpeechRecognition"] = "true"
    }

    flavorDimensions += "app"
    
    productFlavors {
        create("dev") {
            dimension = "app"
            applicationIdSuffix = ".dev"
            versionNameSuffix = "-dev"
            resValue("string", "app_name", "Goncook Dev")
        }
        
        create("staging") {
            dimension = "app"
            applicationIdSuffix = ".staging"
            versionNameSuffix = "-staging"
            resValue("string", "app_name", "Goncook Staging")
        }
        
        create("prod") {
            dimension = "app"
            resValue("string", "app_name", "Goncook")
        }
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
    
    // Configuración para permisos de tiempo de ejecución
    packagingOptions {
        pickFirsts += "**/libc++_shared.so"
        pickFirsts += "**/libjsc.so"
        excludes += "META-INF/DEPENDENCIES"
        excludes += "META-INF/LICENSE"
        excludes += "META-INF/LICENSE.txt"
        excludes += "META-INF/license.txt"
        excludes += "META-INF/NOTICE"
        excludes += "META-INF/NOTICE.txt"
        excludes += "META-INF/notice.txt"
        excludes += "META-INF/ASL2.0"
    }
}

flutter {
    source = "../.."
}
