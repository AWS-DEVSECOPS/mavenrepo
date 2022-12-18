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
checkout([$class: 'GitSCM', branches: [[name: '*/master']], extensions: [], userRemoteConfigs: [[credentialsId: 'c24dc095-aa7d-471c-9968-8ea5e18e2f25', url: 'https://github.com/AWS-DEVSECOPS/mavenrepo.git']]])
}
}
stage ('Maven_Build'){
steps {
sh 'mvn package'
sh 'rm -f /root/*war'
sh 'cp  /root/jenkins/workspace/infosys-pipeline-docker/target/studentapp-2.5-SNAPSHOT.war /root/ '
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
	
