#!/usr/bin/env groovy
// DOCKER_TAG = "vkhazin/spring-endpoint-container"
DOCKER_TAG = "andreichernov/spring-endpoint-container"
DOCKER_REGISTRY = "https://registry.hub.docker.com"
GIT_BRANCH = ""

node {
    def app
    
    stage('Clone repository') {
        checkout scm
        GIT_BRANCH = scm.branches[0].name
        println "branchName = ${GIT_BRANCH}"
    }

    stage('Build app as docker image') {
        // docker.build - same as "docker build" from command line
        // '-v $HOME/gradle-chache/.gradle:/home/gradle/.gradle/'
        app = docker.build(DOCKER_TAG)
    }

    stage('Push app to Docker Hub') {
        /* push the image with two tags: 1) repository branch name as tag; 2) the 'latest' tag
         * its not require additional space becasuse all layers are same */
        def brancheParts = GIT_BRANCH.tokenize('/')
        def lastBranchePart = brancheParts.last()
        docker.withRegistry(DOCKER_REGISTRY, 'docker-registry-credentials') {
            app.push(lastBranchePart)
            app.push("latest")
        }        
    }
}
