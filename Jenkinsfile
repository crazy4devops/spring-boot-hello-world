pipeline { 
    agent any 
    environment {
        def scannerHome = tool 'sonar4.8'
    }
    stages {

        stage("Build Code"){
            steps {
                sh "ls -lrt"
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
    }
}