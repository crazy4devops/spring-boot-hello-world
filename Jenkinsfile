pipeline { 
    agent any 
    environment {
        def scannerHome = tool 'sonar4.8';
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
                echo "Running  Code Analysis"
                sh "${scannerHome}/bin/sonar-scanner"
            }
        }
    }
}