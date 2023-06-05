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
            environment {
                // tool name: 'sonar4.8', type: 'hudson.plugins.sonar.SonarRunnerInstallation'
                def scannerHome = tool 'sonar4.8';
            }
            steps {
                echo "Running  Code Analysis"
                sh "${scannerHome}/bin/sonar-scanner --version"
            }
        }
    }
}