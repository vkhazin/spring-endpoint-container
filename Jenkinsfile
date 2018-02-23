// DOCKER_TAG = "vkhazin/spring-endpoint-container"
DOCKER_TAG = "andreichernov/spring-endpoint-container"
MAINTAINER = "vladimir.khazin@icssolutions.ca"
DOCKER_REGISTRY = "https://registry.hub.docker.com"

node {
    def app
    parameters {
        string(name: 'GIT_BRANCH', defaultValue: 'master', description: 'Which branch should use to work')
        string(name: 'REPOSITORY_URL', defaultValue: 'git@bitbucket.org:vk-smith/spring-endpoint-container.git', description: '')
    }

    stage('Clone repository') {
        checkout scm
    }

    stage('Build app') {
        /* build docker image as "docker build" from command line */
         // '-v $HOME/gradle-chache/.gradle:/home/gradle/.gradle/'
        app = docker.build(DOCKER_TAG)
    }

    stage('Push app to Docker Hub') {
        /* push the image with two tags:
         * 1) repository branch name as tag
         * 2) the 'latest' tag
         * its easy becasuse all  layers will be reused */
        docker.withRegistry(DOCKER_REGISTRY, 'docker-registry-credentials') {
            app.push("${params.GIT_BRANCH}")
            app.push("latest")
        }        
    }

    // post {
    //     success {
    //         sh "echo 'Pipeline operation completed successfully - ${currentBuild.fullDisplayName}'"
    //         // slackSend color: 'green', message: "Pipeline operation completed successfully - ${currentBuild.fullDisplayName}" 
    //         // mail to:"me@example.com", subject:"SUCCESS: ${currentBuild.fullDisplayName}", body: "Yay, we passed."
    //     }
    //     failure {
    //         sh "echo 'Pipeline operation failed - ${currentBuild.fullDisplayName}'"
    //         // slackSend color: 'red', message: "Pipeline operation failed - ${currentBuild.fullDisplayName}"    
    //         // mail to:"me@example.com", subject:"FAILURE: ${currentBuild.fullDisplayName}", body: "Boo, we failed."
    //     }
    //     unstable {
    //         sh "echo 'Pipeline unstable - ${currentBuild.fullDisplayName}'"
    //         // slackSend color: 'yellow', message: "Pipeline unstable - ${currentBuild.fullDisplayName}"    
    //         // mail to:"me@example.com", subject:"UNSTABLE: ${currentBuild.fullDisplayName}", body: "Boo, we failed."
    //     }
    // }
}
