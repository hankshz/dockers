FROM ubuntu:xenial

ENV HBASE_VERSION 1.2.6
ENV HBASE_BUILD /build/hbase
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/jre/
ENV PATH=$PATH:$HBASE_BUILD/bin

COPY raw/ /raw/

COPY script/ /script/

RUN /script/build-hbase.sh
