@Library('jenkins-shared-library@main') _

pipeline {
    agent any
    tools {
        maven 'Maven'
    }
    stages {
        stage('increment version') {
            steps {
                script {
                    echo 'incrementing app version...'
                    sh 'mvn build-helper:parse-version versions:set \
                        -DnewVersion=\\\${parsedVersion.majorVersion}.\\\${parsedVersion.minorVersion}.\\\${parsedVersion.nextIncrementalVersion} \
                        versions:commit'
                    def matcher = readFile('pom.xml') =~ '<version>(.+)</version>'
                    def version = matcher[0][1]
                    env.TAG_NAME = "$version-$BUILD_NUMBER"
                    env.IMAGE_REPO = "dm1984/demo-app"
                }
            }
        }
        stage('build app') {
            steps {
                echo 'building application jar...'
                sh 'mvn clean package'
            }
        }
        stage('build image') {
            steps {
                script {
                    echo 'building the docker image...'
                    def docker = new com.example.Docker(this) // Create an instance of Docker class
                    docker.buildDockerImage("${env.IMAGE_REPO}:${env.TAG_NAME}")
                    docker.dockerLogin()
                    docker.dockerPush("$env.IMAGE_REPO:$env.TAG_NAME")
                }
            }
        } 
        stage("deploy") {
            steps {
                script {
                    echo 'deploying docker image to EC2...'

                    def shellCmd = "bash ./server-cmds.sh ${TAG_NAME}"
                    def ec2Instance = "ec2-user@h3.120.115.251"

                    sshagent(['ec2-server-key']) {
                        sh "scp server-cmds.sh ${ec2Instance}:/home/ec2-user"
                        sh "scp docker-compose.yaml ${ec2Instance}:/home/ec2-user"
                        sh "ssh -o StrictHostKeyChecking=no ${ec2Instance} ${shellCmd}"
                    }
                }
            }               
        }
        stage('commit version update') {
            steps {
                script {
                    withCredentials([usernamePassword(credentialsId: 'github-credentials', passwordVariable: 'PASS', usernameVariable: 'USER')]) {
                        sh 'git remote set-url origin https://$USER:$PASS@github.com/module_9_java_maven_app_multibranch'
                        sh 'git add .'
                        sh 'git commit -m "ci: version bump"'
                        sh 'git push origin HEAD:jenkins-jobs'
                    }
                }
            }
        }
    }
}
