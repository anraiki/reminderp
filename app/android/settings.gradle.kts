pluginManagement {
    val flutterSdkPath =
        run {
            val properties = java.util.Properties()
            file("local.properties").inputStream().use { properties.load(it) }
            val flutterSdkPath = properties.getProperty("flutter.sdk")
            require(flutterSdkPath != null) { "flutter.sdk not set in local.properties" }
            flutterSdkPath
        }

    includeBuild("$flutterSdkPath/packages/flutter_tools/gradle")

    repositories {
        google()
        mavenCentral()
        gradlePluginPortal()
    }
}

plugins {
    id("dev.flutter.flutter-plugin-loader") version "1.0.0"
    id("com.android.application") version "8.9.1" apply false
    id("org.jetbrains.kotlin.android") version "2.1.0" apply false
}

include(":app")

// Patch old plugins that use deprecated compileSdkVersion < 34 (needed for lStar attr)
gradle.beforeProject {
    if (name != "app" && name != rootProject.name) {
        val buildFile = project.buildFile
        if (buildFile.exists() && buildFile.name == "build.gradle") {
            val content = buildFile.readText()
            val patched = content
                .replace(Regex("""compileSdkVersion\s+(\d+)""")) { match ->
                    val ver = match.groupValues[1].toIntOrNull() ?: 0
                    if (ver < 34) "compileSdk 34" else match.value
                }
            if (patched != content) {
                buildFile.writeText(patched)
            }
        }
    }
}
