# Chef cluster

An example for chef cluster

  - Build chef image
  - Start a cluster with one chef server, one chef workstation and two nodes (Ubuntu 14 & 16 [docker image](https://github.com/rastasheep/ubuntu-sshd))
  - Bootstrap those two nodes with cookbook chef-repo (Currently do nothing)

Usage

  - Build the docker image of chef for both chef server and chef workstation:
    ```sh
    ./script/build-image.sh
    ```
    It runs runsvdir-start as the entrypoint because chef server requires a running runit
  - Create the cluster and bootstrap two nodes:
    ```sh
    ./script/start-cluster.sh
    ```
    It will end with a bash shell on chef-workstation. If you want to try more with chef, go to /chef-repo directory
