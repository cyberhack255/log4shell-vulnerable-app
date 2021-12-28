FROM gradle:7.3.1-jdk17 AS builder
COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src
RUN gradle bootJar --no-daemon


FROM ubuntu:16.04
EXPOSE 8080
RUN mkdir /app
RUN apt-get update && apt-get install wget dpkg -y
RUN wget https://mirror.combahton.net/ubuntu/pool/main/o/openjdk-8/openjdk-8-doc_8u131-b11-2ubuntu1.16.04.3_all.deb
RUN wget https://mirror.combahton.net/ubuntu/pool/main/o/openjdk-8/openjdk-8-source_8u131-b11-2ubuntu1.16.04.3_all.deb
RUN dpkg -i openjdk-8-doc_8u131-b11-2ubuntu1.16.04.3_all.deb
RUN dpkg -i openjdk-8-source_8u131-b11-2ubuntu1.16.04.3_all.deb
COPY --from=builder /home/gradle/src/build/libs/*.jar /app/spring-boot-application.jar
CMD ["java", "-jar", "/app/spring-boot-application.jar"]
