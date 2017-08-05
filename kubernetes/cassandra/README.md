# Cassandra Demo

## All credits go to https://github.com/kubernetes/examples/tree/master/cassandra

## How to try the demo

  - Start the cluster
    ```sh
    make all
    ```
  - Wait until everything is ready
    ```sh
    $ kubectl get pods
    NAME          READY     STATUS    RESTARTS   AGE
    cassandra-0   1/1       Running   0          5m
    cassandra-1   1/1       Running   0          3m
    cassandra-2   1/1       Running   0          2m
    ```
  - Run the test
    ```sh
    script/test-cassandra.sh
    ```
  - Tear down the cluster
    ```sh
    make clean
    ```
