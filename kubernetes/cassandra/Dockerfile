FROM ubuntu:xenial

ENV CASSANDRA_VERSION 3.11.0
ENV DUMB_INIT_VERSION 1.2.0
ENV CASSANDRA_BUILD /build/cassandra
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/jre/
ENV PATH=$PATH:$CASSANDRA_BUILD/bin

ENV CASSANDRA_HOME=$CASSANDRA_BUILD \
       CASSANDRA_CONF=/etc/cassandra \
       CASSANDRA_DATA=/cassandra_data

COPY raw/ /raw/

COPY script/ /script/

RUN /script/build-cassandra.sh

VOLUME ["/$CASSANDRA_DATA"]

# 7000: intra-node communication
# 7001: TLS intra-node communication
# 7199: JMX
# 9042: CQL
# 9160: thrift service
EXPOSE 7000 7001 7199 9042 9160

CMD ["/sbin/dumb-init", "/bin/bash",  "/script/run-cassandra.sh"]
