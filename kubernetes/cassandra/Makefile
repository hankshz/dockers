storage:
	kubectl delete -f storage.yaml || true
	sudo rm -rf /tmp/cassandra
	kubectl create -f storage.yaml

cassandra:
	kubectl delete -f cassandra.yaml || true
	kubectl create -f cassandra.yaml

all:
	$(MAKE) clean
	$(MAKE) storage
	$(MAKE) cassandra

clean:
	kubectl delete -f cassandra.yaml || true
	kubectl delete -f storage.yaml || true
	sudo rm -rf /tmp/cassandra

.PHONY: all clean storage cassandra
