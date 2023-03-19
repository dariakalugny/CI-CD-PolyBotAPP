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

		sh 'python3 -m pytest --junitxml results.xml tests/*.py'
		}
	}


    post {
    always {
        junit allowEmptyResults: true, testResults: 'results.xml'
      }
	}
	stage('Build') {
                withCredentials([usernamePassword(credentialsId: 'dariakalugny-dockerhub', passwordVariable: 'pass', usernameVariable: 'user')]) {

                sh "docker build -t dariakalugny/polybot-${env.BUILD_NUMBER} . "
                sh "docker login --username $user --password $pass"
                sh "snyk container test dariakalugny/polybot-${env.BUILD_NUMBER} --severity-threshold=high"


        }
	stage('push'){


	  sh "docker push dariakalugny/polybot-${env.BUILD_NUMBER}"
	}

    }
}

