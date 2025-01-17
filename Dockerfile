FROM amazoncorretto:8-alpine3.17-jre

EXPOSE 8080

# Copy any JAR file from target/ to /usr/app/app.jar
COPY ./target/*.jar /usr/app/app.jar
WORKDIR /usr/app

ENTRYPOINT ["java", "-jar", "app.jar"]