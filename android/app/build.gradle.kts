plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services") // Plugin Firebase
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.almoktar"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
        //  هاد السطر المضاف
        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.almoktar"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Firebase BOM (يراعي توافق الإصدارات تلقائياً)
    implementation(platform("com.google.firebase:firebase-bom:33.16.0"))

    // Firebase Analytics كمثال - يمكنك إضافة غيرها
    implementation("com.google.firebase:firebase-analytics-ktx")
    //  هاد السطر المضاف
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")

    // أضف مكتبات أخرى حسب الحاجة:
    // implementation("com.google.firebase:firebase-auth-ktx")
    // implementation("com.google.firebase:firebase-firestore-ktx")
}
