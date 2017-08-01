FROM ubuntu:xenial

ENV KIBANA_VERSION 5.5.1
ENV KIBANA_BUILD /build/kibana
ENV ELASTICSEARCH_VERSION 5.5.1
ENV ELASTICSEARCH_BUILD /build/elasticsearch
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64/jre/
ENV PATH=$PATH:$ELASTICSEARCH_BUILD/bin:$KIBANA_BUILD/bin

COPY raw/ /raw/

COPY script/ /script/

RUN /script/build-elasticsearch.sh

RUN useradd -c 'elk elk' -m -d /home/elk -s /bin/bash elk
RUN chown -R elk.elk $ELASTICSEARCH_BUILD
RUN chown -R elk.elk $KIBANA_BUILD
USER elk
ENV HOME /home/elk

CMD ["elasticsearch"]
