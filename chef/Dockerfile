FROM ubuntu:xenial

ENV CHEF_SERVER_VERSION 12.16.2-1
ENV CHEFDK_VERSION 0.18.30

COPY raw/ /raw/

COPY script/ /script/

RUN /script/build-chef-server.sh

EXPOSE 80 443
ENTRYPOINT ["/opt/opscode/embedded/bin/runsvdir-start"]
