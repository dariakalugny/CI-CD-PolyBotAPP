pipeline {
    agent any

    options {
    buildDiscarder(logRotator(daysToKeepStr: '30'))
    disableConcurrentBuilds()
    timestamps()
    timeout(time: 10, unit: 'MINUTES')
    }

    stages {
        stage('Build') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dariakalugny', passwordVariable: 'pass', usernameVariable: 'user')]) {

                sh sudo docker build -t dariakalugny/PolyBot-${env.BUILD_NUMBER}.
                sh sudo docker login --username $user --password $pass
                sh sudo docker push dariakalugny/PolyBot-${env.BUILD_NUMBER}
                }
            }
        }

        post('Stage II') {
            always {
                  bat "docker image prune -a"

            }
        }

        stage('Stage III ...') {
            steps {
                sh 'echo echo "stage III..."'
            }
        }

        post{
            always{
                bat "docker image prune -a"
            }
        }

    }
}
