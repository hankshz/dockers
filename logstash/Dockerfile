FROM ubuntu:xenial

ENV LOGSTASH_VERSION 5.5.1
ENV LOGSTASH_BUILD /build/logstash
ENV FILEBEAT_VERSION 5.5.1
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/jre/
ENV PATH=$PATH:$LOGSTASH_BUILD/bin:/usr/share/filebeat/bin

COPY raw/ /raw/

COPY script/ /script/

RUN /script/build-logstash.sh

CMD ["logstash", "-f", "/raw/pipeline.conf"]
