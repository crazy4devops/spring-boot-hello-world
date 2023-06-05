pipeline { 
    agent any 
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
            // environment {
            //    
            // }
            def scannerHome = tool 'sonar4.8';
            steps {
                echo "Running  Code Analysis"
                sh "${scannerHome}/bin/sonar-scanner --version"
            }
        }
    }
}