pipeline {
    agent any
    stages {
        stage('fetching code') {
            steps {
                git branch:'main', url:'git@github.com:aliraza-dev/sample-jenkins-pipeline.git'
            }
        }
        
        stage('Build Code') {
            steps {
                sh 'npm install && npm run build'
            }

            post {
                success {
                    archiveArtifacts artifacts: 'dist/*'
                }
            }
        }
    
    }
}