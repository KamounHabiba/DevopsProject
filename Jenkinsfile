pipeline {
    agent any

    tools {
        maven 'M2_HOME'
        jdk 'JAVA_HOME'
    }
    environment {
        SONARQUBE_ENV = 'SonarQube' 
        DOCKERHUB_CREDENTIALS = credentials('dockerhub-credentials')
        DOCKERHUB_USER = "${DOCKERHUB_CREDENTIALS_USR}"
        DOCKERHUB_PASS = "${DOCKERHUB_CREDENTIALS_PSW}"
        IMAGE_NAME = "habiba022/backend-app"
        IMAGE_TAG = "latest"
    }
    stages {
        stage('Checkout') {
            steps {
                echo 'Checking out source code...'
                checkout scm
            }
        }

        stage('Build') {
            steps {
                echo 'Building the project...'
                sh 'mvn clean install -DskipTests'
            }
        }

        stage('SonarQube') {
            steps {
                script {
                    withSonarQubeEnv("${SONARQUBE_ENV}") {
                        sh 'mvn sonar:sonar -Dsonar.projectKey=Devops-projet -Dsonar.projectName="Devops Project"'
                    }
                }
            }
        }

        stage('Archive Artifacts') {
            steps {
                echo 'Archiving JAR artifacts...'
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }
        

        stage('Build Docker Image') {
            steps {
                echo "Building Docker image..."
                sh 'docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .'
            }
        }

        stage('Push to Docker Hub') {
            steps {
                echo "Logging into Docker Hub and pushing image..."
                sh '''
                    echo $DOCKERHUB_PASS | docker login -u $DOCKERHUB_USER --password-stdin
                    docker push ${IMAGE_NAME}:${IMAGE_TAG}
                    docker logout
                '''
            }
        }

        stage('Deploy Backend to Kubernetes') {
            steps {
                echo "Updating Kubernetes deployment for Spring Boot backend..."

                // Replace the image in the existing deployment
                sh """
                    kubectl set image deployment/springboot-backend \
                    springboot-backend=${IMAGE_NAME}:${IMAGE_TAG} --record
                """

                // Optional: apply manifests if the deployment doesn't exist yet
                // sh 'kubectl apply -f k8s/springboot-backend.yaml'
            }
        }

    }

    post {
        always {
            echo 'Pipeline finished.'
        }
        success {
            echo 'Pipeline successful!'
        }
        failure {
            echo 'Pipeline failed!'
        }
    }
}
