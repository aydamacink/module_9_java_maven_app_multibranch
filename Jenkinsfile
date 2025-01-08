#!/usr/bin.env groovy

pipeline {   
    agent any
    stages {
        stage("test") {
            steps {
                script {
                    echo "Testing the application..."

                }
            }
        }
        stage("build") {
            steps {
                script {
                    echo "Building the application..."
                }
            }
        }

        stage("deploy") {
            steps {
                sshagent(['ec2-user']) {
                    sh 'ssh-add -l' // Lists loaded SSH keys
                }
                script {
                    def dockerCmd = 'docker run -p 3080:3080 -d dm1984/demo-app:1.1.1-7'
                    sshagent(['ec2-server-key']) {
                       sh "ssh -o StrictHostKeyChecking=no ec2-user@3.122.240.78${dockerCmd}"      
                    }
                }
            }
        }               
    }
} 
