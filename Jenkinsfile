pipeline{
agent {label 'staging'}
tools { 
        maven 'localmaven'
}
triggers {
  pollSCM '* * * * *'
}
options{
timestamps()
buildDiscarder(logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '3', daysToKeepStr: '', numToKeepStr: '3'))
}
stages{
stage ('git_checkout'){
steps {
   slackNotifications('STARTED')
   slackNotifications('git_checkout')
checkout([$class: 'GitSCM', branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[credentialsId: 'c24dc095-aa7d-471c-9968-8ea5e18e2f25', url: 'https://github.com/AWS-DEVSECOPS/mavenrepo.git']]])
}
}
stage ('Maven_Build'){
steps {
slackNotifications('Maven_Build')
sh 'mvn package'
}
}
stage('Docker Build and Tag') {
steps {
sh 'docker build -t mavenrepo:latest .' 
sh 'docker tag mavenrepo arjundevsecops/mavenrepo:latest
}
}
stage('Publish image to Docker Hub') {
steps {
withDockerRegistry([ credentialsId: "9e0d7a93-0536-4ad3-9f59-1fd7f4245df7", url: "https://hub.docker.com" ]) {
sh  'docker push arjundevsecops/mavenrepo:latest'
}
}
}	
    
      stage('Run Docker container on Jenkins Agent') {
             
            steps 
			{
                sh "docker run -d -p 8003:8080 arjundevsecops/mavenrepo"
 
            }
        }
 stage('Run Docker container on remote hosts') {
             
            steps {
                sh "docker -H ssh://root@172.31.6.20 run -d -p 8003:8080 arjundevsecops/mavenrepo"
 
            }
        }
    }
	}	
	
	
	
	
	
	


post {
  success {
    slackNotifications(currentBuild.result)
  }
  failure {
    slackNotifications(currentBuild.result)
  }
}

}//pipeline closing

//Code Snippet for sending slack notifications.

def slackNotifications(String buildStatus = 'STARTED') {
  // build status of null means successful
  buildStatus =  buildStatus ?: 'SUCCESS'

  
  // Default values
  def colorName = 'RED'
  def colorCode = '#FF0000'


  // Override default values based on build status
  if (buildStatus == 'STARTED') {
  subject = "${buildStatus}: <=== '${env.JOB_NAME} [BUILD - ${env.BUILD_NUMBER}]'"
  summary = "${subject} (${env.BUILD_URL})"
    colorName = 'YELLOW'
    colorCode = '#FFFF00'
  } else if (buildStatus == 'git_checkout') {
  subject = "${buildStatus}"
  summary = "${subject}"
    colorName = 'BLUE'
    colorCode = '#0000FF'
  } else if (buildStatus == 'Maven_Build') {
    subject = "${buildStatus}"
	  summary = "${subject}"
    colorName = 'Indigo'
    colorCode = '#3F00FF'
  } else if (buildStatus == 'Sonar_Check') {
    subject = "${buildStatus}"
	  summary = "${subject}"
    colorName = 'Turquoise'
    colorCode = '#40E0D0'
  } else if (buildStatus == 'Nexus_Upload') {
    subject = "${buildStatus}"
	  summary = "${subject}"
    colorName = 'LIME'
    colorCode = '#00FF00'
  } else if (buildStatus == 'Deploy_Tomcat') {
    subject = "${buildStatus}"
	  summary = "${subject}"
    colorName = 'Magenta'
    colorCode = '#FF00FF'	
  }  else if (buildStatus == 'SUCCESS') {
    subject = "${buildStatus}: JOB_NAME = '${env.JOB_NAME} BUILD = [${env.BUILD_NUMBER}]'"
	summary = "${subject} (${env.BUILD_URL})"
    colorName = 'GREEN'
    colorCode = '#00FF00'	
  } else {
    subject = "${buildStatus}: ===> [ Please Check build Console OUTPUT ]'"
	summary = "${subject} (${env.BUILD_URL})"
    colorName = 'RED'
    colorCode = '#FF0000'
  }

  // Send notifications
  slackSend (color: colorCode, message: summary, channel: "#declarative-pipeline")
}

