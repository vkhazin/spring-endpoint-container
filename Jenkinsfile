dockerBuildImageTag = "gradle:4.5.1-jdk8-alpine"
dockerExecImageTag = "vkhazin:spring-endpoint-container"

properties([
    parameters([
        stringParam(name: 'GIT_BRANCH',
                    defaultValue: 'master',
                    description: '')
    ])
])

node {

    stage("Build") {
        gradle = docker.image(dockerBuildImageTag)
        gradle.pull()
        gradle.inside {
            git branch: params.GIT_BRANCH, 
                url: 'https://vedarn@bitbucket.org/vedarn/spring-endpoint-container.git'
            sh 'cd app && gradle --stacktrace build'
        }
    }

    stage("Create exec Docker Image") {
        sh "cp app/build/libs/gs-actuator-service-*.jar docker/exec/app.jar"
        sh "cp app/build/libs/gs-actuator-service-*.jar ${env.WORKSPACE}"
	dir("${env.WORKSPACE}/docker/exec") {
	    execImage = docker.build(dockerExecImageTag)
//            docker.withRegistry("${dockerRegistry}", 'gitlab_docker') {
//                execImage.push('0.1.0')
//            }
	}
    }
    archiveArtifacts 'app.jar' 
} 
