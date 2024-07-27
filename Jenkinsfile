pipeline {
    agent any

    tools {
        nodejs "NODEJS22"
    }

    stages {

        stage ('Check Tools ') {
            steps {
                sh 'npm config ls'
            }
        }

        stage('fetching code') {
            steps {
                git branch:'main', 
                    url:'git@github.com:aliraza-dev/sample-jenkins-pipeline.git',
                    credentialsId: 'sshalirazadev'
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