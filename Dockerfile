FROM tomcat:latest

ADD /root/studentapp-2.5-SNAPSHOT.war /usr/local/tomcat/webapps/

EXPOSE 8080

CMD ["catalina.sh", "run"]
