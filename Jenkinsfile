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
                    sh '''cp -r /home/ubuntu/workspace/demo/target/*.war /home/ubuntu/
                    docker build -t dhirajpw/tomcat-repo /home/ubuntu/ 
                    docker push dhirajpw/tomcat-repo'''
                }
            }
        }
        stage('build image on k8') {
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
                    ls /home/ubuntu/workspace/demo/target/'''
                }
            }
        }
    }
} //update
