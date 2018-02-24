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
        echo "params.GIT_BRANCH :" + params.GIT_BRANCH;
        def brancheParts = "${params.GIT_BRANCH}".tokenize('/')
        echo "brancheParts :" + brancheParts;
        
        def lastBranchePart = brancheParts.last()
        echo "lastBranchePart :" + lastBranchePart;
        docker.withRegistry(DOCKER_REGISTRY, 'docker-registry-credentials') {
            app.push(lastBranchePart)
            app.push("latest")
        }        
    }
}
