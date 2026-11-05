pipeline {
    agent any

    environment {
        REMOTE_HOST = '192.168.201.140'
        DEPLOY_DIR = '/var/www/html/index.html'
    }

    stages {

        stage('Checkout') {
            steps {
                echo 'Cloning application from GitHub...'
                git branch: 'main',
                url: 'https://github.com/Ramya-Padala/Remote-Server.git'
            }
        }

        stage('Build Nginx Application') {
            steps {
                echo 'Installing nginx...'
                sh '''
                    apt install nginx -y
                '''
            }
        }

        stage('Deploy to Remote Server') {
            steps {
                echo 'Connecting to remote Linux server...'

                withCredentials([
                    sshUserPrivateKey(
                        credentialsId: 'remote-linux-ssh',
                        keyFileVariable: 'SSH_KEY',
                        usernameVariable: 'SSH_USER'
                    )
                ]) 
            }
        }

        stage('Verify Deployment') {
            steps {
                echo 'Checking remote website...'
                sh '''
                    curl -f http://$192.168.201.140
                '''
            }
        }
    }

    post {
        success {
            echo 'Application deployed successfully on remote Linux server!'
        }

        failure {
            echo 'Deployment failed. Check Jenkins console output.'
        }
    }
}

