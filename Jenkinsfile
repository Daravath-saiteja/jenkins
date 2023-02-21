pipeline {
    agent any
    
        environment {
        AWS_ACCESS_KEY_ID = credentials('414697556934')
        AWS_SECRET_ACCESS_KEY = credentials('414697556934')
    }

    stages {
        stage('Checkout') {
            steps {
            checkout scm
            }
        }
        
                stage ("terraform init") {
            steps {
                sh ('terraform init -reconfigure') 
            }
        }
        stage ("terraform plan") {
            steps {
                sh ('terraform plan') 
            }
        }
                
        stage ("terraform Action") {
            steps {
                echo "Terraform action is --> ${action}"
                sh ('terraform ${action} --auto-approve') 
           }
        }
    }
}
