FROM tomcat:latest

ADD /root/jenkins/workspace/infosys-pipeline-docker/target/studentapp-2.5-SNAPSHOT.war /usr/local/tomcat/webapps/

EXPOSE 8080

CMD ["catalina.sh", "run"]
