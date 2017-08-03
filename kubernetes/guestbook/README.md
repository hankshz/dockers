# Guestbook Demo

## All credits go to https://github.com/kubernetes/examples/tree/master/guestbook

## How to try the demo

  - Start the cluster
    ```sh
    make all
    ```
  - Get the IP of the frontend
      ```sh
        $ kubectl get service
        NAME           CLUSTER-IP       EXTERNAL-IP   PORT(S)    AGE
        frontend       10.107.213.141   <none>        80/TCP     19s
        kubernetes     10.96.0.1        <none>        443/TCP    22h
        redis-master   10.98.116.152    <none>        6379/TCP   18s
        redis-slave    10.99.156.230    <none>        6379/TCP   18s
      ```
  - Go to that IP with the browser
  - Try to type and submit
  - Tear down the cluster
    ```sh
    make clean
    ```
