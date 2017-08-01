FROM ubuntu:xenial

ENV HADOOP_VERSION 2.8.0
ENV HADOOP_BUILD /build/hadoop
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/jre/

COPY raw/ /raw/

COPY script/ /script/

RUN /script/build-hadoop.sh
