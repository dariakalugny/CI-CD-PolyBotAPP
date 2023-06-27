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
    agent {
    kubernetes {

      label 'jenkins-eks-pod'
      defaultContainer 'jenkins-agent'
      cloud 'EKS'

      yaml '''
        apiVersion: v1
        kind: Pod
        metadata:
          labels:
            some-label: jenkins-eks-pod
        spec:
          serviceAccountName: jenkins-admin
          securityContext:
            runAsUser: 0
            fsGroup: 0
            runAsNonRoot: 0
          containers:
          - name: jenkins-agent
            image:  019273956931.dkr.ecr.eu-west-1.amazonaws.com/daria-ecr-repo:jenkins4
            imagePullPolicy: Always
            volumeMounts:
             - name: jenkinsagent-pvc
               mountPath: /var/run/docker.sock
            tty: true
          volumes:
          - name: jenkinsagent-pvc
            hostPath:
              path: /var/run/docker.sock
          securityContext:
            allowPrivilegeEscalation: false
            runAsUser: 0
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
           //     sh "docker build -f /home/ec2-user/PolyBot/Dockerfile -t 019273956931.dkr.ecr.eu-west-1.amazonaws.com/daria-ecr-repo-${env.BUILD_NUMBER} . "
          // sh "docker build -f /home/ec2-user/PolyBot/Dockerfile -t  daria-ecr-repo:latest 019273956931.dkr.ecr.eu-west-1.amazonaws.com/daria-ecr-repo:latest"
            sh "docker build -f /home/ec2-user/PolyBot/Dockerfile -t daria-ecr-repo ."
            sh "docker tag daria-ecr-repo:latest 019273956931.dkr.ecr.eu-west-1.amazonaws.com/daria-ecr-repo:latest"
           }
        }

       //stage('snyk test') {
       //     steps {
        //        sh "snyk container test dariakalugny/daria-repo-${env.BUILD_NUMBER} --severity-threshold=high || true"
         //    }
         //  }

        stage('push') {
            steps {
              withAWS(credentials: 'AWS-Credentials', region: 'eu-west-1')
                {
                 //sh "docker login --username $user --password $pass"
                //sh "docker push dariakalugny/daria-repo-${env.BUILD_NUMBER}"
                //sh "docker push 019273956931.dkr.ecr.eu-west-1.amazonaws.com/daria-ecr-repo-${env.BUILD_NUMBER}"
                sh "docker push  daria-ecr-repo:latest 019273956931.dkr.ecr.eu-west-1.amazonaws.com/daria-ecr-repo:latest"
              }
            }
        }
    }
       post{
            always{
               junit allowEmptyResults: true, testResults: 'results.xml'
              /// sh "docker rmi dariakalugny/daria-repo-${env.BUILD_NUMBER}"
            }

       }

  }