pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dariakalugny', passwordVariable: 'pass', usernameVariable: 'user')]) {

                sh "sudo docker build -t dariakalugny/PolyBot-${env.BUILD_NUMBER} ."
                sh "sudo docker login --username $user --password $pass"
                sh "sudo docker push dariakalugny/PolyBot-${env.BUILD_NUMBER}"

                sh '''
                docker login --username $user --password $pass
                docker build ...
                docker tag ...
                docker push ...
           '''
                }
            }
        }
        stage('Stage II') {
            steps {
                sh 'echo "stage II..."'
            }
        }
        stage('Stage III ...') {
            steps {
                sh 'echo echo "stage III..."'
            }
        }
    }
}
