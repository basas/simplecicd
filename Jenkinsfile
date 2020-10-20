#!/usr/bin/env groovy
pipeline {
    agent any
    environment {
        TF_VAR_region = 'eu-central-1'
    }
    stages {
        stage('prepare terraform') {
            steps {
                echo "Preparing terraform"
                sh "terraform init"
            }
        }
        stage('Execute TF and create ec2') {
            steps {
                script {
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', 
                        accessKeyVariable: 'TF_VAR_access_key', 
                        secretKeyVariable: 'TF_VAR_secret_key',
                        credentialsId: 'my-aws-cred-1'
                    ]]) {
                        sh "terraform apply -auto-approve -no-color"
                    }
                }                
            }
        }
        stage('stage three') {
            steps {
                echo "Cleanup"
            }
        }
    }
}