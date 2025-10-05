pipeline {
    agent any  // or: agent { docker { image 'maven:3.8.1-jdk-11' } }

    tools {
        maven 'MAVEN_HOME'  // Make sure "MAVEN_HOME" is configured in Jenkins (Global Tool Configuration)
        jdk 'JDK11'         // Make sure "JDK11" is configured as well
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

        stage('Test') {
            steps {
                echo 'Running unit tests...'
                sh 'mvn test'
            }
        }

        stage('Archive Artifacts') {
            steps {
                echo 'Archiving JAR artifacts...'
                archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
            }
        }
    }

    post {
        always {
            echo 'Pipeline finished.'
        }
        success {
            echo '✅ Pipeline successful!'
        }
        failure {
            echo '❌ Pipeline failed!'
        }
    }
}
