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
        withDockerRegistry([ credentialsId: "87447f6b-99e0-46fa-9f40-c7bcc80de2c3", url: "" ]) { 
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

	
/*stage('Run Docker container on remote hosts') {
steps {
sh "docker -H ssh://root@172.31.6.20 run -d -p 8003:8080 arjundevsecops/mavenrepo"
}
}
*/
 }
}	
