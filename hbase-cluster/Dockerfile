FROM ubuntu:xenial

ENV HBASE_VERSION 1.2.6
ENV HBASE_BUILD /build/hbase
ENV HADOOP_VERSION 2.8.0
ENV HADOOP_BUILD /build/hadoop
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/jre/
ENV PATH=$PATH:$HADOOP_BUILD/bin:$HADOOP_BUILD/sbin::$HBASE_BUILD/bin

COPY raw/ /raw/

COPY script/ /script/

RUN /script/build-hadoop.sh

RUN /script/build-hbase.sh

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
