plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.thongjoon.ocsc_exam_prep"
    compileSdk = flutter.compileSdkVersion
    //ndkVersion = flutter.ndkVersion
    ndkVersion = "27.0.12077973"
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.thongjoon.ocsc_exam_prep"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

// Groovy-style syntax -- Not working for newer versions of Gradle
//    signingConfigs {
//        release {
//            keyAlias 'tjkOcscExamPrep'
//            keyPassword 'OcscExamPrepTjk'
//            storeFile file('C://_flutter/keystore/ocsc_exam_prep.jks')
//            storePassword 'OcscExamPrepTjk'
//        }
//    }



// Kotlin DSL syntax
    signingConfigs {
        create("release") {
            keyAlias = "tjkOcscExamPrep"
            keyPassword = "OcscExamPrepTjk"
            storeFile = file("C:/_flutter/keystore/ocsc_exam_prep.jks")
            storePassword = "OcscExamPrepTjk"
        }
    }


//    buildTypes {
//        release {
//            // TODO: Add your own signing config for the release build.
//            // Signing with the debug keys for nofigw, so `flutter run --release` works.
//            // signingConfig = signingConfigs.debug
//            signingConfig = signingConfigs.release  // ถ้าไม่เปลี่ยนเป็น release จะทำให้ได้ SHA1 คนละอัน ส่งขึ้น Play store ไม่ได้
//
//        }
//    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            // signingConfig = signingConfigs.getByName("debug")
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}
