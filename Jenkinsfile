pipeline { 
    agent any 
    environment {
        def scannerHome = tool 'sonar4.8';
        SONAR_URL = "http://172.31.18.115:8181/"
    }
    stages {

        stage("Build Code"){
            steps {
                echo "Building Code...."
                sh """
                     ls -lrt
                     mvn install
                """
            }
        }
        stage("Code Analysis"){
            steps {
                withSonarQubeEnv('venkat-sonarqube-server') {
                    // some block
                    echo "Running  Code Analysis"
                    sh "${scannerHome}/bin/sonar-scanner -Dsonar.projectKey=springbootapp -Dsonar.projectName=SpringApp -Dsonar.sources=. -Dsonar.java.binaries=target/classes -Dsonar.sourceEncoding=UTF-8"
                }
            }
        }

        stage("Quality Gate") {
            steps {
                timeout(time: 30, unit: 'MINUTES') {
                    // Parameter indicates whether to set pipeline to UNSTABLE if Quality Gate fails
                    // true = set pipeline to UNSTABLE, false = don't
                    waitForQualityGate abortPipeline: true
                }
            }
        }
    }
}