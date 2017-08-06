heapster:
	kubectl delete -f heapster-rbac.yaml || true
	kubectl delete -f heapster.yaml || true
	kubectl delete -f influxdb.yaml || true
	kubectl create -f influxdb.yaml 
	kubectl create -f heapster.yaml
	kubectl create -f heapster-rbac.yaml

server:
	docker build -t server .
	kubectl delete -f autoscaling.yaml || true
	kubectl delete -f server.yaml || true
	kubectl create -f server.yaml
	kubectl create -f autoscaling.yaml

all:
	$(MAKE) clean
	$(MAKE) heapster
	$(MAKE) server

clean:
	kubectl delete -f autoscaling.yaml || true
	kubectl delete -f server.yaml || true
	kubectl delete -f heapster-rbac.yaml || true
	kubectl delete -f heapster.yaml || true
	kubectl delete -f influxdb.yaml  || true

.PHONY: all clean server heapster
