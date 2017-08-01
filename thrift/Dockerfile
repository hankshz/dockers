FROM ubuntu:xenial

ENV THRIFT_VERSION 0.10.0
ENV THRIFT_BUILD /build/thrift

COPY raw/ /raw/

COPY script/ /script/

RUN /script/build-thrift.sh

RUN /script/build-example.sh

CMD cd /build; ./PythonServer.py
