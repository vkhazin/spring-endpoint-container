//  https://gist.github.com/abayer/925c68132b67254147efd8b86255fd76
pipeline {
    agent none
    parameters {
        string(name: 'GIT_BRANCH', defaultValue: 'cicd_jenkins_job', description: 'Which branch should use to work')
        string(name: 'REPOSITORY_URL', defaultValue: 'https://andreichern0v@bitbucket.org/andreichern0v/spring-endpoint-container.git', description: '')
    }
    stages {
        stage ("Checkout SCM") {
            agent any
            steps {
                checkout scm
                script {
                    projectName = git.getGitRepositoryName()
                    githubOrg = git.getGitOrgName()
                    gitCommit = manifest.getGitCommit()
                }
                echo "projectName: ${env.projectName}"
                echo "githubOrg: ${env.githubOrg}"
                echo "gitCommit: ${env.gitCommit}"
                
            }
        }

        stage('Build App') {
            agent {
                docker { 
                    image 'frekele/gradle:4.3.1-jdk8'
                    args '-v ~/gradle-chache/.gradle:/home/gradle/.gradle/'
                }
            }
            steps {
                sh 'whoami'
                sh 'ls -a'
                sh 'gradle build -x test'
                sh 'ls -a'
                sh 'pwd'
            }
        }

        stage('Build Docker image') {
            agent {
                docker { 
                    image 'openjdk:jre-alpine'
                    args '-v ~/gradle-chache/.gradle:/home/gradle/.gradle/'
                }
            }
            steps {
                sh 'whoami'
                sh 'ls -a'
                sh 'pwd'
            }
        }

        stage('Push to DockerHub') {
            steps {
                sh 'whoami'
                sh 'ls -a'
                sh 'pwd'
                // sh 'docker build -t vkhazin:spring-endpoint-container:initializr .'
                // sh 'docker push vkhazin:spring-endpoint-container:initializr'
            }
        }
    }

    post {
        success {
            sh "echo 'Pipeline operation completed successfully - ${currentBuild.fullDisplayName}'"
            // slackSend color: 'green', message: "Pipeline operation completed successfully - ${currentBuild.fullDisplayName}" 
            // mail to:"me@example.com", subject:"SUCCESS: ${currentBuild.fullDisplayName}", body: "Yay, we passed."
        }
        failure {
            sh "echo 'Pipeline operation failed - ${currentBuild.fullDisplayName}'"
            // slackSend color: 'red', message: "Pipeline operation failed - ${currentBuild.fullDisplayName}"    
            // mail to:"me@example.com", subject:"FAILURE: ${currentBuild.fullDisplayName}", body: "Boo, we failed."
        }
        unstable {
            sh "echo 'Pipeline unstable - ${currentBuild.fullDisplayName}'"
            // slackSend color: 'yellow', message: "Pipeline unstable - ${currentBuild.fullDisplayName}"    
            // mail to:"me@example.com", subject:"UNSTABLE: ${currentBuild.fullDisplayName}", body: "Boo, we failed."
        }
    }
}