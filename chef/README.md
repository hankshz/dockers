# Chef cluster

An example for chef cluster

  - Build chef image
  - Start a cluster with one chef server, one chef workstation and multiple (default 3 each) balancer nodes and web nodes (Ubuntu 14 [docker image](https://github.com/rastasheep/ubuntu-sshd)) bootstraped
    - The reason I gave up on Ubuntu 16 is that many existing chef cookbooks on chef supermarket have [similar issue](https://github.com/chef-cookbooks/openssh/issues/60) to support systemd.
    - And even after I [fixed](https://github.com/chef-cookbooks/openssh/commit/625e716a093d9a6b1c6656b001e76d6368ce7647#diff-55bf87238c9b8af164c5133a60721f12) them manually, it will hit [another issue](https://askubuntu.com/questions/813588/systemctl-failed-to-connect-to-bus-docker-ubuntu16-04-container) related to run systemd inside container.
  - Deploy nginx and etc. to balancer nodes and nodejs and etc. to web nodes

Usage

  - Build the docker image of chef for both chef server and chef workstation:
    ```sh
    ./script/build-image.sh
    ```
    It runs runsvdir-start as the entrypoint because chef server requires a running runit
  - Create the cluster and bootstrap all nodes:
    ```sh
    ./script/start-cluster.sh
    ```
    It will end with a bash shell on chef-workstation. If you want to try more with chef, go to /chef-repo directory
  - Deploy the cookbooks to the nodes:
    ```sh
    ./script/start-service.sh
    ```
    It will allow you to access the web nodes in a round robin way from multiple balancer node
    ```sh
    root@chef-workstation:/# curl balancer1
    <html>
      <body>
        <h1>Hello from nginx in balancer1</h1>
      </body>
    </html>
    root@chef-workstation:/# curl balancer1/backend/
    Hello from nodejs in web1
    root@chef-workstation:/# curl balancer1/backend/
    Hello from nodejs in web2
    root@chef-workstation:/# curl balancer2
    <html>
      <body>
        <h1>Hello from nginx in balancer2</h1>
      </body>
    </html>
    root@chef-workstation:/# curl balancer2/backend/
    Hello from nodejs in web1
    root@chef-workstation:/# curl balancer2/backend/
    Hello from nodejs in web2
    root@chef-workstation:/# curl balancer2/backend/
    Hello from nodejs in web3
    root@chef-workstation:/# curl balancer3
    <html>
      <body>
        <h1>Hello from nginx in balancer3</h1>
      </body>
    </html>
    root@chef-workstation:/# curl balancer3/backend/
    Hello from nodejs in web1
    root@chef-workstation:/#
    ```
