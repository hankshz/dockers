# Network policy Demo

## How to try the demo

  - Start the cluster
    ```sh
    make all
    ```
  - Wait until the pod and the autoscaling is ready
    ```sh
    $ kubectl get hpa
	NAME      REFERENCE           TARGETS    MINPODS   MAXPODS   REPLICAS   AGE
	server    Deployment/server   0% / 50%   1         10        1          3m
	$ kubectl get pod
	NAME                      READY     STATUS    RESTARTS   AGE
	server-1347746228-5xm2j   1/1       Running   0          3m
    ```
  - Start the load
    ```sh
    $ kubectl exec server-1347746228-5xm2j -it bash
	root@server-1347746228-5xm2j:/# stress -c 4
	stress: info: [18] dispatching hogs: 4 cpu, 0 io, 0 vm, 0 hdd

    ```
  - Watch the pods to increase
    ```sh
    $ kubectl get hpa
	NAME      REFERENCE           TARGETS       MINPODS   MAXPODS   REPLICAS   AGE
	server    Deployment/server   1608% / 50%   1         10        1          6m
	$ kubectl get pod
	NAME                      READY     STATUS              RESTARTS   AGE
	server-1347746228-5xm2j   1/1       Running             0          6m
	server-1347746228-745f4   0/1       ContainerCreating   0          16s
	server-1347746228-ptv90   1/1       Running             0          16s
	server-1347746228-t29j7   1/1       Running             0          16s
    ```
  - Stop the load
  - Watch the pods to decrease
    ```sh
    $ kubectl get hpa
	NAME      REFERENCE           TARGETS    MINPODS   MAXPODS   REPLICAS   AGE
	server    Deployment/server   0% / 50%   1         10        4          11m
	$ kubectl get pod
	NAME                      READY     STATUS    RESTARTS   AGE
	server-1347746228-5xm2j   1/1       Running   0          14m
    ```
  - Tear down the cluster
    ```sh
    make clean
    ```
