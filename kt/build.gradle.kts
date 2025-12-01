plugins {
    application
    `java-library`
    kotlin("jvm") version "2.2.21"
}

application {
    mainClass = "com.github.ephemient.aoc2025.MainKt"
}

tasks.test {
    useJUnitPlatform()
}
