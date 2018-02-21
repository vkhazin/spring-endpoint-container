dockerBuildImageTag = "gradle:4.5.1-jdk8-alpine"
dockerExecImageTag = "vkhazin:spring-endpoint-container"

node {
  
    stage("Get latest docker build image") {
        sh "docker pull gradle:4.5.1-jdk8-alpine"
    }
    
    stage("Build") {
        dir("app") {
            currentDir = sh(script: "pwd")
            sh "docker run -v $(pwd):/tmp ${dockerBuildImageTag} gradle build"
        }
    }
    
}
