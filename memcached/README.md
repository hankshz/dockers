# Memcached cluster

An example for memcached cluster with mcrouter

  - Build memcached & mcrouter image
  - Start a cluster with one mcrouter master and three memcached slaves
  - Verify that the [prefix routing](https://github.com/facebook/mcrouter/wiki/Prefix-routing-setup) is working by accessing mcrouter and memcached directly

Usage

  - Build the docker image of memcached & mcrouter:
    ```sh
    ./script/build-image.sh
    ```
  - Create the cluster:
    ```sh
    ./script/start-instance.sh
    ```
  - Run the test:
    ```sh
    ./script/run-test.sh
    ```
