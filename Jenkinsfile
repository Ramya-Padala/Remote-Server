pipeline {
    agent any

    environment {
        REMOTE_HOST = '192.168.201.140'
        DEPLOY_DIR = '/var/www/html'
    }

    stages {

        stage('Checkout') {
            steps {
                echo 'Checking out application from GitHub...'
                checkout scm
            }
        }

        stage('Prepare Remote Server') {
            steps {
                echo 'Installing and configuring Nginx on remote server...'

                withCredentials([
                    sshUserPrivateKey(
                        credentialsId: 'remote-linux-ssh',
                        keyFileVariable: 'SSH_KEY',
                        usernameVariable: 'SSH_USER'
                    )
                ]) {
                    sh '''
                        ssh -i "$SSH_KEY" \
                            -o BatchMode=yes \
                            "$SSH_USER@$REMOTE_HOST" '
                            
                            if ! command -v nginx >/dev/null 2>&1; then
                                sudo apt-get update
                                sudo apt-get install -y nginx
                            fi

                            sudo systemctl enable nginx
                            sudo systemctl start nginx
                        '
                    '''
                }
            }
        }

        stage('Deploy Application') {
            steps {
                echo 'Copying application to remote server...'

                withCredentials([
                    sshUserPrivateKey(
                        credentialsId: 'remote-linux-ssh',
                        keyFileVariable: 'SSH_KEY',
                        usernameVariable: 'SSH_USER'
                    )
                ]) {
                    sh '''
                        tar -czf - \
                            --exclude=.git \
                            --exclude=Jenkinsfile \
                            . | ssh \
                            -i "$SSH_KEY" \
                            -o BatchMode=yes \
                            "$SSH_USER@$REMOTE_HOST" \
                            "sudo mkdir -p $DEPLOY_DIR && \
                             sudo tar -xzf - -C $DEPLOY_DIR && \
                             sudo systemctl reload nginx"
                    '''
                }
            }
        }

        stage('Verify Deployment') {
            steps {
                echo 'Verifying application...'

                sh '''
                    sleep 3
                    curl -f http://$REMOTE_HOST/
                '''
            }
        }
    }

    post {
        success {
            echo 'Application installed and deployed successfully!'
        }

        failure {
            echo 'Deployment failed. Check Jenkins Console Output.'
        }
    }
}
