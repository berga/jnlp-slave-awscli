# https://github.com/jenkinsci/docker-inbound-agent/blob/master/8/alpine/Dockerfile
FROM jenkins/jnlp-slave:alpine
LABEL maintainer="Marco Bergantin <marco@bergant.in>"

ARG BASE_PACKAGES="py-pip jq"

USER root
RUN apk add --update --no-cache ${BASE_PACKAGES} && \
  pip install --no-cache-dir awscli

USER ${user}