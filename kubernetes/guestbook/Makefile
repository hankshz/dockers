# https://github.com/kubernetes/examples/tree/master/guestbook

# Build docker images as local-* to make sure it will use the desired one

server:
	(cd server; docker build -t local-server .)
	kubectl delete -f server/frontend.yaml || true
	kubectl create -f server/frontend.yaml

redis-master:
	(cd redis-master; docker build -t local-redis-master .)
	kubectl delete -f redis-master/redis-master.yaml || true
	kubectl create -f redis-master/redis-master.yaml

redis-slave:
	(cd redis-slave; docker build -t local-redis-slave .)
	kubectl delete -f redis-slave/redis-slave.yaml || true
	kubectl create -f redis-slave/redis-slave.yaml

all:
	$(MAKE) server
	$(MAKE) redis-master
	$(MAKE) redis-slave

clean:
	kubectl delete -f server/frontend.yaml || true
	kubectl delete -f redis-master/redis-master.yaml || true
	kubectl delete -f redis-slave/redis-slave.yaml || true

.PHONY: all clean server redis-master redis-slave
