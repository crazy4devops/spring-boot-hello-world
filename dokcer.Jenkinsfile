pipeline { 
    agent any
    environment {
        registry = "vsiraparapu/myspringapp"
        registryCredential = 'docker-jenkins-creds'
        dockerImage = ''
    }
    stages {
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
              script {
                 dockerImage = docker.build registry + ":$BUILD_NUMBER"
              }
               
            }
        }
        stage("Push Docker"){
            steps {
                script {
                    docker.withRegistry( '', registryCredential ) {
                        dockerImage.push()
                    }
                }    
            }
        }
        stage('Remove Image') {
            steps{
                sh "docker rmi ${registry}:$BUILD_NUMBER"
            }
        }
        
    }
    post {
        always {
            cleanWs()
        }
    }
}