# Dockerfile: jenkins/slave
# Hub: https://hub.docker.com/r/jenkins/slave/~/dockerfile/
FROM openjdk:8-jdk-alpine
LABEL maintainer="Don Becker <donbecker@donbeckeronline.com>" \
  Description="This is a base image, which provides the Jenkins agent executable (slave.jar)" \
  Vendor="Jenkins project" \
  Version="4.3"

ENV HOME /home/jenkins
RUN addgroup -g 10000 -S jenkins
RUN adduser -h $HOME -u 10000 -G jenkins -s /bin/sh -D jenkins

ARG VERSION=4.3
ARG AGENT_WORKDIR=/home/jenkins/agent
ARG BASE_PACKAGES="curl py-pip jq"

RUN apk --no-cache add ${BASE_PACKAGES}
RUN pip install awscli

RUN curl --create-dirs -sSLo /usr/share/jenkins/slave.jar https://repo.jenkins-ci.org/public/org/jenkins-ci/main/remoting/${VERSION}/remoting-${VERSION}.jar \
  && chmod 755 /usr/share/jenkins \
  && chmod 644 /usr/share/jenkins/slave.jar

USER jenkins
ENV AGENT_WORKDIR=${AGENT_WORKDIR}
RUN mkdir /home/jenkins/.jenkins && mkdir -p ${AGENT_WORKDIR}

VOLUME /home/jenkins/.jenkins
VOLUME ${AGENT_WORKDIR}
WORKDIR /home/jenkins

# no idea why this is a sep file
COPY jenkins-slave /usr/local/bin/jenkins-slave

ENTRYPOINT ["jenkins-slave"]
