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
            parallel{
               stage('pytest'){
                   steps{
                      withCredentials([file(credentialsId: 'telegramToken', variable: 'TELEGRAM_TOKEN')])
                      {
                       sh "cp ${TELEGRAM_TOKEN} .telegramToken"
                       sh 'pip3 install -r requirements.txt'
                       sh "python3 -m pytest --junitxml results.xml test/*.py"
                     }
                   }
               }

                stage('pylint'){
                   steps{
                      script{
                         sh "python3 -m pytint *.py || true"
                      }
                   }
               }
            }
        }

        stage('Build') {
            steps {
                sh "docker build -t dariakalugny/polybot-${env.BUILD_NUMBER} . "
                }
              }

       stage('snyk test') {
            steps {
                sh "snyk container test dariakalugny/polybot-${env.BUILD_NUMBER} --severity-threshold=high"

                }
            }

        stage('push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dariakalugny-dockerhub', passwordVariable: 'pass', usernameVariable: 'user')])
                {
                 sh "docker login --username $user --password $pass"
                sh "docker push dariakalugny/polybot-${env.BUILD_NUMBER}"
                }
            }
        }
    }
       post{
            always{
               junit allowEmptyResults: true, testResults: 'results.xml'
                sh "docker rmi dariakalugny/polybot-${env.BUILD_NUMBER}"
           }
       }

  }