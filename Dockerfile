FROM gradle:7.3.1-jdk17 AS builder
COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src
RUN gradle bootJar --no-daemon


FROM ubuntu:16.04
EXPOSE 8080
RUN mkdir /app
RUN apt-get update && apt-get install wget dpkg -y
RUN wget https://launchpad.net/~ubuntu-security-proposed/+archive/ubuntu/ppa/+build/5935007/+files/openjdk-7-jre-headless_7u55-2.4.7-1ubuntu1~0.12.04.2_amd64.deb
RUN wget https://launchpad.net/~ubuntu-security-proposed/+archive/ubuntu/ppa/+build/5935007/+files/openjdk-7-jre-zero_7u55-2.4.7-1ubuntu1~0.12.04.2_amd64.deb
RUN wget https://launchpad.net/~ubuntu-security-proposed/+archive/ubuntu/ppa/+build/5935007/+files/openjdk-7-jre_7u55-2.4.7-1ubuntu1~0.12.04.2_amd64.deb
RUN wget https://launchpad.net/~ubuntu-security-proposed/+archive/ubuntu/ppa/+build/5935007/+files/openjdk-7-jdk_7u55-2.4.7-1ubuntu1~0.12.04.2_amd64.deb
RUN dpkg -i openjdk-7-jre-headless_7u55-2.4.7-1ubuntu1~0.12.04.2_amd64.deb
RUN dpkg -i openjdk-7-jre-zero_7u55-2.4.7-1ubuntu1~0.12.04.2_amd64.deb
RUN dpkg -i openjdk-7-jre_7u55-2.4.7-1ubuntu1~0.12.04.2_amd64.deb
RUN dpkg -i openjdk-7-jdk_7u55-2.4.7-1ubuntu1~0.12.04.2_amd64.deb
RUN apt-get -f install
COPY --from=builder /home/gradle/src/build/libs/*.jar /app/spring-boot-application.jar
CMD ["java", "-jar", "/app/spring-boot-application.jar"]
