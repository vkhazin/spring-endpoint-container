// tags of docker images for building and executing
dockerBuildImageTag = "gradle:4.5.1-jdk8-alpine"
dockerExecImageTag = "vkhazin:spring-endpoint-container"

// build parameters
properties([
    parameters([
        stringParam(name: 'GIT_BRANCH',
                    defaultValue: 'master',
                    description: '')
    ])
])

node {

    stage("Build") {
        // init docker image, pull it from docker hub and use it to build the app
        // Jenkins workspace is automatically mounted in the container
        gradle = docker.image(dockerBuildImageTag)
        gradle.pull()
        gradle.inside {
            // checkout repo and execute build in the container
            git branch: params.GIT_BRANCH, 
                url: 'https://vedarn@bitbucket.org/vedarn/spring-endpoint-container.git'
            sh 'cd app && gradle --stacktrace build'
        }
    }

    stage("Create exec Docker Image") {
        // Copy jar file to the directory where exec docker image should be built
        sh "cp app/build/libs/gs-actuator-service-*.jar docker/exec/app.jar"
        // copy jar file to jobs workspac
        sh "cp app/build/libs/gs-actuator-service-*.jar ${env.WORKSPACE}"
	dir("${env.WORKSPACE}/docker/exec") {
            // built docker image based on Dockerfile in the same directory
	    execImage = docker.build(dockerExecImageTag)
//            docker.withRegistry("${dockerRegistry}", 'gitlab_docker') {
                  // push exec image
//                execImage.push('0.1.0')
//            }
	}
        // archive the jar
        archiveArtifacts allowEmptyArchive: true, artifacts: 'docker/exec/app.jar'
    }
} 
