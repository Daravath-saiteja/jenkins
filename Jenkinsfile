pipeline {
    agent any
    
        environment {
        AWS_ACCESS_KEY_ID = credentials('762491bb-c257-466b-b8c3-fe31a8420a1d')
        AWS_SECRET_ACCESS_KEY = credentials('762491bb-c257-466b-b8c3-fe31a8420a1d')
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
                
        stage('Manual Approval') {
            steps {
                input "Apply Terraform changes? (type 'yes' to proceed)"
            }
        }
        
        stage('Terraform Apply') {
            steps {
                dir('terraform') {
                    sh 'terraform apply -auto-approve tfplan'
        }
    }
}
        
