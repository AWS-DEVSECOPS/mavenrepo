FROM tomcat:latest

ADD docker -H ssh://root@172.31.6.20 /root/jenkins/workspace/infosys-pipeline-docker/target/studentapp-2.5-SNAPSHOT.war /usr/local/tomcat/webapps/

EXPOSE 8080

CMD ["catalina.sh", "run"]
