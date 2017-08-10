FROM ubuntu:xenial

ENV ANACONDA_VERSION 4.4.0
ENV ANACONDA_BUILD /build/anaconda
ENV PATH=$PATH:$ANACONDA_BUILD/bin

COPY raw/ /raw/

COPY script/ /script/

RUN /script/build-jupyter.sh

EXPOSE 8888
WORKDIR "/workspace"
CMD ["jupyter", "notebook", "--ip", "0.0.0.0", "--allow-root", "--no-browser"]
