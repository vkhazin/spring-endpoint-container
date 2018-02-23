pipeline {
    agent {
        docker { image 'gradle:4.5.1-jdk8-alpine' }
    }
    stages {
        stage('Test') {
            steps {
                sh 'gradle --version'
            }
        }
    }
}