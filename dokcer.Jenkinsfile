pipeline { 
    agent any
    stages {
        // Starting CI ---
        stage("Build Code"){
            steps {
                sh "mvn install"
                sh "mv target/*.jar target/spring-boot-2-hello-world-1.0.2-SNAPSHOT-${BUILD_NUMBER}.jar"
            }
        }
        stage("Run Unit Tests"){
            steps {
               sh "mvn test"
            }
        }
        stage("Build Docker"){
            steps {
                sh "docker build -t vsiraparapu/myspringapp:${BUILD_NUMBER} ."
            }
        }
        stage("Push Docker"){
            steps {
                withCredentials([usernameColonPassword(credentialsId: 'ubuntu-machine-creds', variable: 'mycreds-docker')]) {
                sh "docker push vsiraparapu/myspringapp:${BUILD_NUMBER}"
               }
                
            }
        }
        
    }
    post {
        always {
            cleanWs()
        }
    }
}