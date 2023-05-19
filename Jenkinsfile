//@Library('shared-lib') _
library 'shared-lib@main'
import hudson.*;

pipeline {

  options {

    buildDiscarder logRotator( artifactNumToKeepStr: '10', numToKeepStr: '10')
    disableConcurrentBuilds()
    timestamps()
    timeout(time: 10, unit: 'MINUTES')
   }
  agent {
    kubernetes {
      inheritFrom 'jenkins'
      yaml '''
        apiVersion: v1
        kind: Pod
        metadata:
          labels:
            some-label: jenkins-eks-pod
        spec:
          containers:
          - name: jenkins-agent
            image: dariakalugny/daria-repo:jenkins2

            tty: true
        '''
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
                    catchError(message:'pytest ERROR',buildResult:'UNSTABLE',stageResult:'UNSTABLE'){
                      withCredentials([file(credentialsId: 'telegramToken', variable: 'TELEGRAM_TOKEN')])
                      {
                       sh "cp ${TELEGRAM_TOKEN} .telegramToken"
                       sh 'pip3 install -r requirements.txt'
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
                sh "docker build -t dariakalugny/daria-repo-${env.BUILD_NUMBER} . "
           }
        }

       stage('snyk test') {
            steps {
                sh "snyk container test dariakalugny/daria-repo-${env.BUILD_NUMBER} --severity-threshold=high || true"
             }
           }

        stage('push') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'dariakalugny-dockerhub', passwordVariable: 'pass', usernameVariable: 'user')])
                {
                 sh "docker login --username $user --password $pass"
                sh "docker push dariakalugny/daria-repo-${env.BUILD_NUMBER}"
              }
            }
        }
    }
       post{
            always{
               junit allowEmptyResults: true, testResults: 'results.xml'
               // sh "docker rmi dariakalugny/daria-repo-${env.BUILD_NUMBER}"
            }

       }

  }