plugins {
    application
    `java-library`
    kotlin("jvm") version "2.2.21"
    id("org.jetbrains.kotlinx.benchmark") version "0.4.15"
}

kotlin.target.compilations {
    create("bench").associateWith(getByName("main"))
}

dependencies {
    "benchImplementation"("org.jetbrains.kotlinx:kotlinx-benchmark-runtime:0.4.15")
}

application {
    mainClass = "com.github.ephemient.aoc2025.MainKt"
}

benchmark {
    targets.create("bench")
    configurations.getByName("main") {
        warmups = 1
        iterationTime = 1
        iterationTimeUnit = "s"
        mode = "avgt"
        outputTimeUnit = "us"
        project.findProperty("benchmarkInclude")?.let { include(it.toString()) }
        project.findProperty("benchmarkExclude")?.let { exclude(it.toString()) }
    }
}

tasks.test {
    useJUnitPlatform()
}
