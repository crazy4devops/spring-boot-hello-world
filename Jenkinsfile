pipeline { 
    agent any 
    environment {
        def scannerHome = tool 'sonar4.8'
    }
    stages {
        // Starting CI
        stage("Build Code"){
            steps {
               
                sh "mvn install"
                sh "ls -lrt target/"
                sh "mv target/*.jar target/spring-boot-2-hello-world-1.0.2-SNAPSHOT-${BUILD_NUMBER}.jar"
                sh "ls -lrt target/"
            }
        }
        stage("Run Unit Tests"){
            steps {
               sh "mvn test"
            }
        }
        stage("Code Analysis"){
            steps {
                withSonarQubeEnv('venkat-sonarqube-server') {
                    sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=springbootapp -Dsonar.projectName=SpringApp -Dsonar.sources=. -Dsonar.java.binaries=target/classes -Dsonar.sourceEncoding=UTF-8"
                }
            }
        }
        stage("Quality Gate") {
            steps {
                timeout(time: 30, unit: 'MINUTES') {
                    waitForQualityGate abortPipeline: true
                }
            }
        }
        stage("Upload Artifacts"){
            steps{
                
                rtServer (
                        id: 'jfrog-server',
                        url: 'http://172.31.21.215:8082/artifactory/',
                        // If you're using username and password:
                        username: 'admin',
                        password: 'Admin@123',
                        // If you're using Credentials ID:
                        // credentialsId: 'ccrreeddeennttiiaall',
                        // If Jenkins is configured to use an http proxy, you can bypass the proxy when using this Artifactory server:
                        // bypassProxy: true,
                        // Configure the connection timeout (in seconds).
                        // The default value (if not configured) is 300 seconds: 
                        timeout: 300
                )
                rtUpload (
                    serverId: 'jfrog-server',
                    spec: '''{
                        "files": [
                            {
                            "pattern": "target/*.jar",
                            "target": "example-repo-local/spring-boot-hello-world/"
                            }
                        ]
                    }''',
                )

                
                    
            }
        } 
        // Starting CD
        stage("Deploy - Dev"){
            steps {
                sshagent (credentials: ['ssh-creds-deploy-dev']) {
                    //  sh "ssh -o StrictHostKeyChecking=no -T cloud_user@172.31.21.226 uname -a"
                    sh """                    
                    scp -o StrictHostKeyChecking=no ./target/*.jar cloud_user@172.31.21.226:/home/cloud_user
                    ssh -o StrictHostKeyChecking=no -T cloud_user@172.31.21.226 nohup java -jar spring-boot-2-hello-world-1.0.2-SNAPSHOT-${BUILD_NUMBER}.jar &
                    """
                }
            }
        }
        stage("Deploy - UAT"){
            steps {
              echo "Deploying to UAT servers...."
            }
        }
        stage("Deploy - PRD"){
            steps {
              echo "Deploying to PRD servers...."
            }
        }
        
    }
    post {
        always {
            cleanWs()
        }
    }
}