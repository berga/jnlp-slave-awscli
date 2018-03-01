FROM openjdk:8-jdk-alpine
MAINTAINER Don Becker <donbecker@donbeckeronline.com>

# Dockerfile: jenkins/slave
# Hub: https://hub.docker.com/r/jenkins/slave/~/dockerfile/
# FROM openjdk:8-jdk 
ENV HOME /home/jenkins
#RUN groupadd -g 10000 jenkins
RUN addgroup -g 10000 -S jenkins
#RUN useradd -c "Jenkins user" -d $HOME -u 10000 -g 10000 -m jenkins
RUN adduser -h $HOME -u 10000 -G jenkins -s /bin/sh -D jenkins
#RUN useradd -ms /bin/bash newuser -g jenkins
LABEL Description="This is a base image, which provides the Jenkins agent executable (slave.jar)" Vendor="Jenkins project" Version="3.16"

ARG VERSION=3.16
ARG AGENT_WORKDIR=/home/jenkins/agent

RUN apk --no-cache add curl
RUN apk --no-cache add py-pip
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

#temp entrypoint
#ENTRYPOINT ["sh"]

# Dockerfile: jenkins/jnlp-slave
# Hub: https://hub.docker.com/r/jenkins/jnlp-slave/~/dockerfile/
# FROM jenkins/slave:3.16-1

# no idea why this is a sep file
COPY jenkins-slave /usr/local/bin/jenkins-slave

#temp entrypoint
#ENTRYPOINT ["sh"]

ENTRYPOINT ["jenkins-slave"]
