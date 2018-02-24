// DOCKER_TAG = "vkhazin/spring-endpoint-container"
DOCKER_TAG = "andreichernov/spring-endpoint-container"
MAINTAINER = "vladimir.khazin@icssolutions.ca"
DOCKER_REGISTRY = "https://registry.hub.docker.com"
// GIT_BRANCH = "feature/initializr"
// REPOSITORY_URL = "https://andreichern0v@bitbucket.org/andreichern0v/spring-endpoint-container.git"

node {
    def app
    
    stage('Clone repository') {
        checkout scm
        def branchName = scm.branches[0].name
        println "branchName = ${branchName}"
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
        // https://groups.google.com/forum/#!topic/jenkinsci-users/a-9YSVVU5Bw
        def brancheParts = "${branchName}".tokenize('/')
        def lastBranchePart = brancheParts.last()
        docker.withRegistry(DOCKER_REGISTRY, 'docker-registry-credentials') {
            app.push(lastBranchePart)
            app.push("latest")
        }        
    }
}
