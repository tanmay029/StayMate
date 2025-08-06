buildscript {
    val kotlinVersion = "1.9.10"
    
    repositories {
        google()
        mavenCentral()
    }

    dependencies {
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:$kotlinVersion")
        classpath("com.google.gms:google-services:4.4.0")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}

// Set custom build directory outside source tree
val customBuildDir = File(rootProject.rootDir.parent, "build")

allprojects {
    layout.buildDirectory.set(File(customBuildDir, project.name))
}

subprojects {
    evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(customBuildDir)
}
