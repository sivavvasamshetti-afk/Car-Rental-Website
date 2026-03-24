pipeline {
    agent any

    environment {
        IMAGE_NAME = "sivav2516/car-rental"
        TAG = "latest"
    }

    stages {

        stage('Checkout Code') {
            steps {
                git branch: 'main',
                url: 'https://github.com/sivavvasamshetti-afk/Car-Rental-Website.git'
            }
        }

        stage('Build Docker Image') {
            steps {
                sh 'docker build -t $IMAGE_NAME:$TAG .'
            }
        }

        stage('DockerHub Login') {
            steps {
                withCredentials([usernamePassword(
                    credentialsId: 'Docker_cred',
                    usernameVariable: 'DOCKER_USER',
                    passwordVariable: 'DOCKER_PASS'
                )]) {
                    sh 'echo $DOCKER_PASS | docker login -u $DOCKER_USER --password-stdin'
                }
            }
        }

        stage('Push Image') {
            steps {
                sh 'docker push $IMAGE_NAME:$TAG'
            }
        }

        stage('Run Container') {
            steps {
                sh '''
                docker stop car-rental || true
                docker rm car-rental || true
                docker run -d -p 8085:80 --name car-rental $IMAGE_NAME:$TAG
                '''
            }
        }
        stage('Deploy to Kubernetes') {
            steps {
                sh '''
                    export KUBECONFIG=/var/lib/jenkins/.kube/config

                    kubectl get nodes

                    
                    kubectl apply -f flower.yml
                    kubectl apply -f car-rental.yml
                    kubectl apply -f suryatravel.yml
                    kubectl apply -f helloworld.yml.yml
                '''
            }
        }

        stage('Deploy Ingress') {
            steps {
                sh '''
                    export KUBECONFIG=/var/lib/jenkins/.kube/config

                    kubectl apply -f ingress.yml

                    echo "======================================"
                    echo "Ingress deployed successfully 🌐"
                    echo "======================================"

                    kubectl get ingress
                '''
            }
        }
    }
}
