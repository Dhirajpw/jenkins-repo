pipeline {
    agent any
    stages {
        stage('Pull') {
            steps {
                echo "Successful pull from Git"
                git 'https://github.com/Dhirajpw/jenkins-repo.git'
            }
        }
        stage('Build') {
            steps {
                echo "Building with Maven"
                sh 'mvn clean package'
            }
        }
        stage('creating tomcat image Tomcat') {
            steps {
                script {
                    sh '''cp -r /var/lib/jenkins/workspace/deploy/target/*.war .
                    docker build -t dhirajpw/tomcat-repo . 
                    docker login 
                    docker push dhirajpw/tomcat-repo'''
                }
            }
        }
        stage('build image on k8s ') {
            steps {
                script {
                    sh 'kubectl apply -f deployment.yaml'
                }
            }
        }
        stage('getting info') {
            steps {
                script {
                    sh '''kubectl get pods -o wide 
                    kubectl get nodes -o wide 
                    kubectl get svc -o wide 
                    ls /var/lib/jenkins/workspace/deploy/target/'''
                }
            }
        }
    }
} //update
