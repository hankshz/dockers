FROM iron/go

RUN mkdir -p /go/src/testpackage

WORKDIR /function

ADD testbin /function/

ENTRYPOINT ["./testbin"]
