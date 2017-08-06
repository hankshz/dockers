FROM ubuntu:xenial

RUN apt-get update \
	&& apt-get install -y openssh-server

RUN mkdir /var/run/sshd \
	&& ssh-keygen -t rsa -P '' -f ~/.ssh/id_rsa \
	&& cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys \
	&& chmod 0600 ~/.ssh/authorized_keys

EXPOSE 22
CMD ["/usr/sbin/sshd", "-D"]
