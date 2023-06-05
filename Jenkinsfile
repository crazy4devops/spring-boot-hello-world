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
            steps {
                echo "Running  Code Analysis"
            }
        }
    }
}