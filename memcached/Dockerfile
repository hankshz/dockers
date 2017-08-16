FROM ubuntu:xenial

ENV MCROUTER_VERSION 36-0
ENV MCROUTER_BUILD /build/mcrouter
ENV PATH=$PATH:$MCROUTER_BUILD/install/bin

COPY raw/ /raw/

COPY script/ /script/

RUN /script/build-memcached.sh

EXPOSE 11211
CMD ["/usr/bin/memcached", "-u", "memcache", "-p", "11211"]
