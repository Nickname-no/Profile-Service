#
# for build
#
FROM maven:3.6.3-jdk-11-slim AS MAVEN_TOOL_CHAIN

COPY pom.xml /tmp/

COPY src /tmp/src/

WORKDIR /tmp/

RUN mvn package


#
# for deploy
#
FROM tomcat:9.0-jdk11

MAINTAINER "admin"

USER root

# to get access to admin page
COPY /tomcat-config/tomcat-users.xml $CATALINA_HOME/conf/tomcat-users.xml
COPY /tomcat-config/settings.xml $CATALINA_HOME/conf/settings.xml
COPY /tomcat-config/context.xml $CATALINA_HOME/webapps/manager/META-INF/

#
# just in case i want to check my files
# cd ~/../usr/local/tomcat/conf
# cd ~/../usr/local/tomcat/webapps/manager/META-INF/
#

WORKDIR $CATALINA_HOME/webapps/

COPY --from=MAVEN_TOOL_CHAIN /tmp/target/*.war ./profiler.war

RUN cp -r $CATALINA_HOME/webapps.dist/* $CATALINA_HOME/webapps/

EXPOSE 8080

CMD ["catalina.sh", "run"]
