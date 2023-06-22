//@Library('shared-lib') _
library 'shared-lib@main'
//import hudson.*;

pipeline {
  options {

    buildDiscarder logRotator( artifactNumToKeepStr: '10', numToKeepStr: '10')
    disableConcurrentBuilds()
    timestamps()
    timeout(time: 10, unit: 'MINUTES')

   }
     agent{ label 'ec2-fleet'  }



    environment{
        SNYK_TOKEN = credentials('snyk')
    }

    stages {
        stage('test') {
            parallel{
               stage('pytest'){
                   steps{
                    catchError(message:'pytest ERROR',buildResult:'UNSTABLE',stageResult:'UNSTABLE'){
                      withCredentials([file(credentialsId: 'telegramToken', variable: 'TELEGRAM_TOKEN')])
                      {
                       sh "cp ${TELEGRAM_TOKEN} .telegramToken"
                       sh 'pip install -r requirements.txt'
                       sh "python3 -m pytest --junitxml results.xml test/*.py"
                      }
                    }
                  }
               }

                stage('pylint'){
                   steps{
                   catchError(message:'pylint ERROR',buildResult:'UNSTABLE',stageResult:'UNSTABLE'){
                          script {
                            logs.info 'Starting'
                            logs.warning 'Nothing to do!'
                            sh "python3 -m pylint *.py || true"
                        }
                      }
                   }
               }
            }
        }

        stage('Build') {
           steps {
                sh "docker build -f Dockerfile -t 019273956931.dkr.ecr.eu-west-1.amazonaws.com/daria-ecr-repo-${env.BUILD_NUMBER}:polybot . "
           }
        }

       //stage('snyk test') {
       //     steps {
        //        sh "snyk container test dariakalugny/daria-repo-${env.BUILD_NUMBER} --severity-threshold=high || true"
         //    }
         //  }

        stage('push') {
            steps {
               docker.withRegistry('https://019273956931.dkr.ecr.eu-west-1.amazonaws.com/daria-ecr-repo', 'ecr:eu-west-1:AWS-Credentials')
                {
                 //sh "docker login --username $user --password $pass"
                //sh "docker push dariakalugny/daria-repo-${env.BUILD_NUMBER}"
                sh "docker push 019273956931.dkr.ecr.eu-west-1.amazonaws.com/daria-ecr-repo-${env.BUILD_NUMBER}:polybot"
              }
            }
        }
    }
       post{
            always{
               junit allowEmptyResults: true, testResults: 'results.xml'
               sh "docker rmi dariakalugny/daria-repo-${env.BUILD_NUMBER}"
            }

       }

  }