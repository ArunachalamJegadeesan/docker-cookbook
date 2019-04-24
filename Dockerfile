FROM openjdk:8-jdk-alpine
LABEL app.name="catalogservoce" app.type=" microservice-springboot" app.port="7070"
MAINTAINER Arunachalam.J
RUN mkdir -p /deploy
WORKDIR /deploy
EXPOSE 7070/tcp
ARG DEPENDENCY=build/libs/catalogservice-0.0.1-SNAPSHOT.jar
COPY ${DEPENDENCY} .
ENTRYPOINT ["java", "-jar","catalogservice-0.0.1-SNAPSHOT.jar"]
