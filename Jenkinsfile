@Library('shared-lib@main') _

pipeline {
    agent { label 'jenkins-slave-01' }

    triggers {
        githubPush()
    }

    environment {
        IMAGE_NAME = "yassenn01/my-app"
        IMAGE_TAG = "${BUILD_NUMBER}"
        K8S_PATH = "k8s/"
    }

    stages {
        stage('Checkout') {
            steps {
                git url: 'https://github.com/myassen0/CloudDevOpsProject.git', branch: 'main'
            }
        }

        stage('Skip Jenkins Auto Commit') {
            steps {
                script {
                    def author = sh(script: "git log -1 --pretty=%an", returnStdout: true).trim()
                    if (author == "Jenkins CI") { // تأكد ان ده نفس الـuser.name اللي بتستخدمه في git config
                        currentBuild.result = 'NOT_BUILT'
                        error("Skipping build triggered by Jenkins auto commit.")
                    }
                }
            }
        }

        stage('Build Docker Image') { // <--- تم إضافة القوس '{' هنا
            steps {
                script {
                    buildDockerImage(IMAGE_NAME, IMAGE_TAG)
                }
            }
        } // <--- هذا القوس كان زائداً، تم إزالته أو تصحيح مكانه

        stage('Scan Docker Image') {
            when {
                expression { return true }
            }
            steps {
                script {
                    scanDockerImage(IMAGE_NAME, IMAGE_TAG)
                }
            }
        }

        stage('Push Docker Image') {
            when {
                expression { return true }
            }
            steps {
                script {
                    pushDockerImage(IMAGE_NAME, IMAGE_TAG)
                }
            }
        }

        stage('Delete Local Docker Image') {
            when {
                expression { return true }
            }
            steps {
                script {
                    deleteLocalDockerImage(IMAGE_NAME, IMAGE_TAG)
                }
            }
        }

        stage('Update K8s Manifests') {
            when {
                expression { return true }
            }
            steps {
                script {
                    updateK8sManifests(IMAGE_NAME, IMAGE_TAG, K8S_PATH)
                }
            }
        }

        stage('Push Manifests') {
            when {
                expression { return true }
            }
            steps {
                withCredentials([usernamePassword(credentialsId: 'github', usernameVariable: 'GIT_USER', passwordVariable: 'GIT_PASS')]) {
                    sh '''
                        git config user.email "jenkins@example.com"
                        git config user.name "Jenkins CI"
                        git add $K8S_PATH

                        if ! git diff --cached --quiet; then
                            git commit -m "Auto: update image tag"
                            git push https://$GIT_USER:$GIT_PASS@github.com/myassen0/CloudDevOpsProject.git HEAD:main
                        else
                            echo "No changes to commit."
                        fi
                    '''
                }
            }
        }

        stage('Test Image') {
            when {
                expression { return true }
            }
            steps {
                sh 'echo "Image tested successfully."'
            }
        }
    } 
} 
