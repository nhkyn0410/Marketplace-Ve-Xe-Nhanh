import java.util.Base64

plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// Biến --dart-define (gồm cả --dart-define-from-file=.env.*) Flutter chuyển cho Gradle: base64 từng cặp, ngăn bằng dấu phẩy.
val dartDefines: Map<String, String> =
    (project.findProperty("dart-defines") as String?)
        ?.split(",")
        ?.mapNotNull { encoded ->
            val pair = String(Base64.getDecoder().decode(encoded), Charsets.UTF_8)
            val separator = pair.indexOf('=')
            if (separator > 0) pair.substring(0, separator) to pair.substring(separator + 1) else null
        }
        ?.toMap()
        ?: emptyMap()

android {
    namespace = "com.vexenhanh.passenger_mobile"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.vexenhanh.passenger_mobile"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        // Uses the version code from pubspec.yaml. When using split APKs, 1000 * ABI_VERSION
        // is added automatically by Flutter. (https://developer.android.com/studio/build/configure-apk-splits#configure-APK-versions)
        // You can force using the value of versionCode by specifying the `-P force-version-code-ignoring-abi=true`
        // flag during build.
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        // Host App Link cổng thanh toán quay về (PASSENGER-PARITY A25) = host của PAYMENT_RETURN_BASE_URL bên API.
        // Chưa đặt APP_LINK_HOST thì dùng tên miền `.invalid` (RFC 2606): không khớp link thật nào, cổng quay về
        // trình duyệt như trước.
        manifestPlaceholders["appLinkHost"] =
            dartDefines["APP_LINK_HOST"]?.trim()?.takeIf { it.isNotEmpty() } ?: "app-link-host.invalid"
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
