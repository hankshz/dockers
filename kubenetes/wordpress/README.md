# Wordpress Demo

## All credits go to https://github.com/kubernetes/examples/tree/master/mysql-wordpress-pd

## How to try the demo

  - Start the cluster
    ```sh
    make all
    ```
  - Get the IP of the wordpress
      ```sh
        $ kubectl get services
        NAME              CLUSTER-IP       EXTERNAL-IP    PORT(S)        AGE
        kubernetes        10.96.0.1        <none>         443/TCP        35m
        wordpress         10.111.234.177   ,80.11.12.10   80:31620/TCP   4m
        wordpress-mysql   None             <none>         3306/TCP       4m
      ```
  - Go to that IP with the browser and have fun
  - Tear down the cluster
    ```sh
    make clean
    ```
