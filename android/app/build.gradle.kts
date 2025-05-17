plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    id("com.google.gms.google-services")
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.ngonzano.comidaperuana"
    compileSdk = 35 // o flutter.compileSdkVersion si está disponible

    defaultConfig {
        applicationId = "com.ngonzano.comidaperuana"
        minSdk = 21 // o flutter.minSdkVersion
        targetSdk = 35 // o flutter.targetSdkVersion
        versionCode = 1 // o flutter.versionCode
        versionName = "1.0" // o flutter.versionName
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    implementation(platform("com.google.firebase:firebase-bom:33.13.0"))
    implementation("com.google.firebase:firebase-analytics")
}

flutter {
    source = "../.."
}
