pipeline {

  options {
    buildDiscarder(logRotator(daysToKeepStr: '30'))
    disableConcurrentBuilds()
    timestamps()
    timeout(time: 10, unit: 'MINUTES')
   }

  agent {
    docker {
        image 'jenkins-agent:latest'
        args  '--user root -v /var/run/docker.sock:/var/run/docker.sock'
    }
    }
    environment{
        SNYK_TOKEN = credentials('snyk')
    }

    stages {
        stage('test') {
                 withCredentials([file(credentialsId: 'telegramToken', variable: 'TELEGRAM_TOKEN')]) {
                 sh "cp ${TELEGRAM_TOKEN} .telegramToken"
                 sh 'pip3 install -r requirements.txt'
                 sh 'python3 -m pytest --junitxml results.xml tests/*.py'

        }
        post {
             always {
             junit allowEmptyResults: true, testResults: 'results.xml'
              }
	    }

        stage('Build') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dariakalugny-dockerhub', passwordVariable: 'pass', usernameVariable: 'user')]) {

                sh "docker build -t dariakalugny/polybot-${env.BUILD_NUMBER} . "
                sh "docker login --username $user --password $pass"
                sh "snyk container test dariakalugny/polybot-${env.BUILD_NUMBER} --severity-threshold=high"
                sh "docker push dariakalugny/polybot-${env.BUILD_NUMBER}"
                }
            }
        }
    }

}
'''
post{
  always{
      sh "docker rmi dariakalugny/polybot-${env.BUILD_NUMBER}"
   }
 }
'''