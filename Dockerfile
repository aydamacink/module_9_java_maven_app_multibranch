FROM amazoncorretto:8-alpine3.17-jre

EXPOSE 8080

# Rename the JAR file to app.jar during copy
COPY ./target/java-maven-app-1.1.1.jar /usr/app/app.jar

WORKDIR /usr/app


ENTRYPOINT ["java", "-jar", "app.jar"]