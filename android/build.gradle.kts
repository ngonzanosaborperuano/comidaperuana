plugins {
    id("com.dynatrace.instrumentation") version "8.325.1.1007"
}
extra["dynatrace.instrumentationFlavor"] = "flutter"
dynatrace {
    configurations {
        create("defaultConfig") {
            autoStart{
                applicationId("c83c5ac6-902b-4f26-94e7-4a3fc2746f5d")
                beaconUrl("https://bf87797vgl.bf.dynatrace.com/mbeacon")
            }
            userOptIn(true)
            agentBehavior.startupLoadBalancing(true)
            agentBehavior.startupWithGrailEnabled(true)
        }
    }
}
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    
    dependencies {
        classpath("com.google.gms:google-services:4.4.0")
    }
}

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
    project.evaluationDependsOn(":app")
}

tasks.register<Delete>("clean") {
    delete(rootProject.layout.buildDirectory)
}