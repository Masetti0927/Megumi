allprojects {
    repositories {
        // 阿里云镜像
        maven { url=uri("https://maven.aliyun.com/repository/public/")}
        // 中科大镜像
        maven { url=uri("https://mirrors.ustc.edu.cn/maven/releases/")}
        // 清华大学镜像
        maven { url=uri("https://mirrors.tuna.tsinghua.edu.cn/nexus/content/repositories/central/")}
        // 添加其他需要的仓库
        google()
        mavenCentral()
    }
}

val newBuildDir: Directory = rootProject.layout.buildDirectory.dir("../../build").get()
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
