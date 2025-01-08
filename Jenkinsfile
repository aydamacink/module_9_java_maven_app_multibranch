#!/usr/bin/env groovy

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
                sshagent(['ec2-server-key']) {
                    script {
                        def dockerCmd = 'docker run -p 3080:3080 -d dm1984/react-nodejs:1.0'
                        withCredentials([usernamePassword(credentialsId: 'docker-hub-credentials', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
                            sh """
                            ssh -o StrictHostKeyChecking=no ec2-user@18.194.125.89 <<EOF
docker login -u $DOCKER_USER -p $DOCKER_PASS
${dockerCmd}
EOF
                            """
                        }
                    }
                }
            }
        }
    }
}
