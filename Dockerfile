# Version 1.0.1

FROM ubuntu:18.04
MAINTAINER Jérôme KLAM, "jeromeklam@free.fr"

# ENV
ENV DEBIAN_FRONTEND noninteractive
ENV LANG fr_FR.UTF-8
ENV LANGUAGE fr_FR:en
ENV LC_ALL fr_FR.UTF-8
ENV MAILHOGSERVER mailhog

## Installation des utilitaires de base
RUN apt-get update && apt-get -y install software-properties-common supervisor
RUN apt-get update && apt-get -y install language-pack-en
RUN apt-get update && apt-get -y install wget tzdata curl zip rsync
RUN apt-get clean && apt-get update && apt-get install -y locales
RUN locale-gen fr_FR.UTF-8

## Installation outils de base
RUN apt-get update && apt-get install -y apt-utils git

## Mise à jour
RUN apt-get update && apt-get -y upgrade

## Go and mhsendmail
RUN apt-get update && apt-get install -y golang-go
RUN mkdir /opt/go
ENV GOPATH /opt/go

## mhsendmail
RUN go get github.com/mailhog/mhsendmail

## Installation des utilitaires
RUN apt-get install -y vim nano

## Pré-requis ORACLE
RUN apt-get install -y apt-transport-https

## Mise à jour
RUN apt-get update && apt-get -y upgrade

## TimeZone
RUN echo "Europe/Paris" > /etc/timezone
RUN rm /etc/localtime
RUN dpkg-reconfigure -f noninteractive tzdata

## Système
RUN apt-get update
RUN apt-get install -y dos2unix

## Filebeat
ADD ./docker/filebeat.sh /opt/filebeat.sh
RUN chmod 775 /opt/filebeat.sh
RUN /opt/filebeat.sh

## Mise à jour
RUN apt-get update && apt-get -y upgrade

CMD ["/bin/bash"]