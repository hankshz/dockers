FROM ubuntu:xenial

COPY raw/ /raw/

COPY script/ /script/

RUN /script/build-app.sh

WORKDIR "/workspace"

EXPOSE 80 8545
CMD ["/usr/bin/testrpc"]
