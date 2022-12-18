FROM tomcat:latest

ADD ./target/studentapp-2.5-SNAPSHOT.war /usr/local/tomcat/webapps/

EXPOSE 8080

CMD ["catalina.sh", "run"]
