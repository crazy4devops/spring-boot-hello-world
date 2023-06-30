pipeline { 
    agent any
   environment {
        imagename = "vsiraparapu/myspringapp"
        registryCredential = 'docker-jenkins-creds'
        dockerImage = ''
        }
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
              //  sh "docker build -t vsiraparapu/myspringapp:${BUILD_NUMBER} ."
              script {
                 dockerImage = docker.build imagename
              }
               
            }
        }
        
        stage("Push Docker"){
            steps {
                script {
                    docker.withRegistry( '', registryCredential ) {
                        dockerImage.push("$BUILD_NUMBER")
                        dockerImage.push('latest')
                }
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