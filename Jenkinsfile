pipeline {
    agent none
    checkout scm
    parameters {
        string(name: 'GIT_BRANCH', defaultValue: 'cicd_jenkins_job', description: 'Which branch should use to work')
        string(name: 'REPOSITORY_URL', defaultValue: 'https://andreichern0v@bitbucket.org/andreichern0v/spring-endpoint-container.git', description: '')
    }
    stages {
        stage('Build Api Inside Docker') {
            agent {
                docker { 
                    image 'frekele/gradle:4.3.1-jdk8' 
                }
                args '-v ~/gradle-chache/.gradle:/home/gradle/.gradle/'
            }
            steps {
                sh 'ls -a'
                sh 'gradle build -x test'
                sh 'ls -a'
            }
        }
        // stage('Push to dockerhub') {
        //     steps {
        //         // sh 'docker build -t vkhazin:spring-endpoint-container:initializr .'
        //         // sh 'docker push vkhazin:spring-endpoint-container:initializr'
        //     }
        // }
    }
    // post {
    //     success {
    //     mail to:"me@example.com", subject:"SUCCESS: ${currentBuild.fullDisplayName}", body: "Yay, we passed."
    //     }
    //     failure {
    //     mail to:"me@example.com", subject:"FAILURE: ${currentBuild.fullDisplayName}", body: "Boo, we failed."
    //     }
    // }
}