pipeline {
    agent {
    docker {
        image 'jenkins-agent:latest'
        args  '--user root -v /var/run/docker.sock:/var/run/docker.sock'
     }
    }


    options {
    buildDiscarder(logRotator(daysToKeepStr: '30'))
    disableConcurrentBuilds()
    timestamps()
    timeout(time: 10, unit: 'MINUTES')
    }
    environment{
        SNYK_TOKEN = credentials('snyk-token')
    }
    
    stages {
        stage('Build') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dariakalugny', passwordVariable: 'pass', usernameVariable: 'user')]) {

                sh "docker build -t dariakalugny/PolyBot-${env.BUILD_NUMBER}. "
                sh "docker login --username $user --password $pass"
                sh "docker push dariakalugny/PolyBot-${env.BUILD_NUMBER}"
                }
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
