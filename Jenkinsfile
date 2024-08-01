pipeline {
    agent any

    tools {
        nodejs "NODEJS22"
    }

    // Setting environment to push code to ECR. 
    environment {
        REGISTRY_CREDENTIALS = 'ecr:us-east-1:awscreds'
        APP_REGISTRY = '437150665988.dkr.ecr.us-east-1.amazonaws.com/practice'
        FE_REGISTRY = 'https://437150665988.dkr.ecr.us-east-1.amazonaws.com'
        ARTVERSION = "${env.BUILD_ID}"
        cluster="sample-app"
        service="sample-vite-svc"
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
                    dockerImage = docker.build(APP_REGISTRY + ":" + ARTVERSION, ".")
                }
            }
        }

        stage ('Push image to ECR') {
            steps {
                script {
                    docker.withRegistry(FE_REGISTRY, REGISTRY_CREDENTIALS) {
                        dockerImage.push(ARTVERSION)
                        dockerImage.push('latest')
                    }
                }
            }
        }

        stage('Deploy to ECS') {
            steps {
                withAWS(credentials: 'awscreds', region: 'us-east-1') {
                    sh 'aws ecs update-service --cluster ${cluster} --service ${service} --force-new-deployment'
                }
            }

            post {
                success {
                    sh 'echo "Image build and deployed successfully"'
                }
            }
        }
    }
}