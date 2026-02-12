allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory =
    rootProject.layout.buildDirectory
        .dir("../../build")
        .get()
rootProject.layout.buildDirectory.value(newBuildDir)

subprojects {
    val newSubprojectBuildDir: Directory = newBuildDir.dir(project.name)
    project.layout.buildDirectory.value(newSubprojectBuildDir)
}
subprojects {
    plugins.withId("com.android.library") {
        extensions.configure<com.android.build.gradle.LibraryExtension> {
            if (namespace.isNullOrEmpty()) {
                val manifest = project.file("src/main/AndroidManifest.xml")
                if (manifest.exists()) {
                    val content = manifest.readText()
                    val pkgMatch = Regex("""package\s*=\s*"([^"]+)"""").find(content)
                    if (pkgMatch != null) {
                        namespace = pkgMatch.groupValues[1]
                        manifest.writeText(content.replace(pkgMatch.value, ""))
                    } else {
                        namespace = "com.example.${project.name.replace(Regex("[^a-zA-Z0-9_]"), "_")}"
                    }
                } else {
                    namespace = "com.example.${project.name.replace(Regex("[^a-zA-Z0-9_]"), "_")}"
                }
            }
        }
    }
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}
