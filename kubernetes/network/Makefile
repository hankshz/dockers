nginx:
	kubectl delete -f nginx.yaml || true
	kubectl create -f nginx.yaml

client:
	docker build -t client .
	kubectl delete -f client.yaml || true
	kubectl create -f client.yaml

policy:
	kubectl delete -f policy.yaml || true
	kubectl create -f policy.yaml

all:
	$(MAKE) clean
	$(MAKE) nginx
	$(MAKE) client
	$(MAKE) policy

clean:
	kubectl delete -f policy.yaml || true
	kubectl delete -f client.yaml || true
	kubectl delete -f nginx.yaml || true

.PHONY: all clean nginx client network
