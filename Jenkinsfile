pipeline{
agent {label 'staging'}
tools { 
        maven 'mavenhome'
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
checkout([$class: 'GitSCM', branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[credentialsId: 'githubtoken', url: 'https://github.com/AWS-DEVSECOPS/mavenrepo.git']]])	
}
}
stage ('Maven_Build'){
steps {
sh 'mvn clean package'
}
}
stage('Docker Build and Tag') {
steps {

sh 'docker build -t mavenrepo:latest .' 
sh 'docker tag mavenrepo arjundevsecops/mavenrepo:latest'
}
}

stage('Publish image to Docker Hub') {
steps {
        withDockerRegistry([ credentialsId: "dockerhubtoken", url: "" ]) { 
sh  'docker push arjundevsecops/mavenrepo:${env.BUILD_NUMBER}'
}
}
}
stage ('delete running container'){
steps {
sh 'docker rm -f $(docker ps -q)'
}
}

stage('Run Docker container on Jenkins Agent') {
 steps 
{
sh "docker run -d -p 8003:8080 arjundevsecops/mavenrepo"
}
}

		stage("aplication status cURL") {
            steps {
		sh '''
            #!/bin/bash
            response=$(curl  -s --retry-connrefused --retry 10 --retry-delay 6 http://172.31.6.52:8003/studentapp-2.5-SNAPSHOT/ -o /dev/null -w "%{http_code}")
		if [ "$response" != "200" ]
		then
		 exit 1
		fi
                    '''    
            }
        }
 stage('Deploy to k8s'){
            steps{
                script{
			kubernetesDeploy (configs: 'deploykube.yaml',kubeconfigId: 'kubectlconfig')
                }
            }
        }
	
	
	
	
	
	

	
 }
}	
