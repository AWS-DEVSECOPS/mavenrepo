FROM tomcat:latest

LABEL maintainer="Nidhi Gupta"

ADD /root/jenkins/workspace/walmart-freestyle/target/studentapp-2.5-SNAPSHOT.war /usr/local/tomcat/webapps/

EXPOSE 8080

CMD ["catalina.sh", "run"]
