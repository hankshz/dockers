# Iron Functions Setup

Steps to setup Iron Functions on top of Kubernetes.

  - Make sure Kubernetes are working fine
    ```sh
    $ kubectl get node
	NAME      STATUS    AGE       VERSION
	ubuntu    Ready     5m        v1.7.2
    ```
  - Setup Iron Functions (Files are from https://github.com/iron-io/functions/tree/master/docs/operating/kubernetes/kubernetes-quick)
    ```sh
    $ kubectl create -f ./deployment.yaml 
	deployment "functions" created
	$ kubectl create -f ./service.yaml 
	service "functions" created
    ```
  - Download and install Iron Functions CLI
    ```sh
    $ curl -LSs https://goo.gl/VZrL8t | sh
	fn version 0.2.59
    ```
  - The deployment is not accessible from the host by default, create a port-forward for it
    ```sh
    $ kubectl get pod
	NAME                         READY     STATUS    RESTARTS   AGE
	functions-3843663462-04721   1/1       Running   0          6m
	$ kubectl port-forward functions-3843663462-04721 8080
	Forwarding from 127.0.0.1:8080 -> 8080
	Forwarding from [::1]:8080 -> 8080
	```
  - Verify the Iron Function is working by visiting http://localhost:8080/v1/apps

Steps to try the FAAS.

  - Build the docker images and create the app
    ```sh
    make setup
    ```
  - Run the test
    ```sh
    $ ./test.py
    Sorting a random list of 1000 floats 100 loops 100 round trips:
        local:
            python3: 0.018921852111816406sec
        faas:
            python3: 109.58631134033203sec
            go: 71.9281837940216sec
            nodejs: 92.43995976448059sec
    ```
  - Tear down the app
    ```sh
    make clean
    ```
