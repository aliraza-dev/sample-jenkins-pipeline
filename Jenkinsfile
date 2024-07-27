pipeline {
    agent any

    tools {
        nodejs "NODEJS22"
    }

    // Setting environment to push code to ECR. 
    environment {
        registryCredentials = 'ecr:us-east-1:awscreds'
        appRegistry = '437150665988.dkr.ecr.us-east-1.amazonaws.com/practice'
        feRegistry = 'https://437150665988.dkr.ecr.us-east-1.amazonaws.com'
        // cluster="cluster"
        // service="cluster"
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

        stage ('Build Docker image') {
            steps {
                script {
                    dockerImage = docker.build(appRegistry + ":$BUILD_NUMBER", ".")
                }
            }
        }

        stage ('Push image to ECR') {
            steps {
                script {
                    docker.withRegistry(feRegistry, registryCredentials) {
                        dockerImage.push('$BUILD_NUMBER')
                        dockerImage.push('latest')
                    }
                }
            }
        }
    }
}