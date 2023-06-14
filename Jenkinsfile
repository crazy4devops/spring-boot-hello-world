pipeline { 
    agent { 
        label 'ubuntu-machine' 
    }
    environment {
        def scannerHome = tool 'sonar4.8'
    }
    triggers {
        GenericTrigger(
            genericVariables: [
            [key: 'ref', value: '$.ref']
            ],
            causeString: 'Triggered on $ref',
            token: 'abcd1234'
        )
    }
    stages {
        // Starting CI -
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
                sshagent (credentials: ['ssh-creds-deploy-uat']) {
                        //  sh "ssh -o StrictHostKeyChecking=no -T cloud_user@172.31.21.226 uname -a"
                        sh """                    
                        scp -o StrictHostKeyChecking=no ./target/*.jar ubuntu@44.201.255.119:/home/ubuntu
                        ssh -o StrictHostKeyChecking=no -T ubuntu@44.201.255.119 nohup java -jar spring-boot-2-hello-world-1.0.2-SNAPSHOT-${BUILD_NUMBER}.jar &
                        """
                }
            }
        }
        stage("Deploy - PRD"){
            input{
                 message "Do you want to proceed for production deployment?"
            }
            steps {
              echo "Deploying to PRD servers...."
              sshagent (credentials: ['ssh-creds-deploy-prd']) {
                        //  sh "ssh -o StrictHostKeyChecking=no -T cloud_user@172.31.21.226 uname -a"
                        sh """                    
                        scp -o StrictHostKeyChecking=no ./target/*.jar ubuntu@3.93.58.233:/home/ubuntu
                        ssh -o StrictHostKeyChecking=no -T ubuntu@3.93.58.233 nohup java -jar spring-boot-2-hello-world-1.0.2-SNAPSHOT-${BUILD_NUMBER}.jar &
                        """
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