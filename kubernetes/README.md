# Kubenetes Setup

Steps to setup Kubenetes in Ubuntu 16. Due to the fact that it depends on systemd to work, I can't make it as a docker image.

Prepare the base image (Run as root or add sudo for every line)

  - Update the repository.
    ```sh
    apt-get update
    apt-get install -y apt-transport-https curl
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
    echo deb http://apt.kubernetes.io/ kubernetes-xenial main > /etc/apt/sources.list.d/kubernetes.list  
    apt-get update
    ```
  - Install docker. Skip if have other docker installed
    ```sh
    apt-get install -y docker.io
    ```
  - Install Kubenetes.
    ```sh
    apt-get install -y kubelet kubeadm kubectl kubernetes-cni
    ```

Setup the master

  - Start Kubenetes
    ```sh
    sudo kubeadm init
    ```
  - Copy the config file so kubectl can talk to the cluster.
    ```sh
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config
    ```
    Need to get the lastest /etc/kubernetes/admin.conf every time you run:
    ```sh
    sudo kubeadm init
    ```
  - Setup the network.
    ```sh
    kubectl apply -f http://docs.projectcalico.org/v2.3/getting-started/kubernetes/installation/hosted/kubeadm/1.6/calico.yaml
    ```
    Before the network is set, the node won't be ready
    ```sh
    ~$ kubectl describe nodes ubuntu
    Name:			ubuntu
    Role:			
    Labels:			beta.kubernetes.io/arch=amd64
    			beta.kubernetes.io/os=linux
    			kubernetes.io/hostname=ubuntu
    			node-role.kubernetes.io/master=
    Annotations:		node.alpha.kubernetes.io/ttl=0
    			volumes.kubernetes.io/controller-managed-attach-detach=true
    Taints:			node-role.kubernetes.io/master:NoSchedule
    CreationTimestamp:	Fri, 28 Jul 2017 12:10:42 -0700
    Conditions:
      Type			Status	LastHeartbeatTime			LastTransitionTime			Reason				Message
      ----			------	-----------------			------------------			------				-------
      OutOfDisk 		False 	Fri, 28 Jul 2017 12:11:42 -0700 	Fri, 28 Jul 2017 12:10:38 -0700 	KubeletHasSufficientDisk 	kubelet has sufficient disk space available
      MemoryPressure 	False 	Fri, 28 Jul 2017 12:11:42 -0700 	Fri, 28 Jul 2017 12:10:38 -0700 	KubeletHasSufficientMemory 	kubelet has sufficient memory available
      DiskPressure 		False 	Fri, 28 Jul 2017 12:11:42 -0700 	Fri, 28 Jul 2017 12:10:38 -0700 	KubeletHasNoDiskPressure 	kubelet has no disk pressure
      Ready 		False 	Fri, 28 Jul 2017 12:11:42 -0700 	Fri, 28 Jul 2017 12:10:38 -0700 	KubeletNotReady 		runtime network not ready: NetworkReady=false reason:NetworkPluginNotReady message:docker: network plugin is not ready: cni config uninitialized
    ...
    ```
    After the network is set, after a while, the node will be ready
    ```sh
    ~$ kubectl describe nodes ubuntu
    Name:			ubuntu
    Role:			
    Labels:			beta.kubernetes.io/arch=amd64
    			beta.kubernetes.io/os=linux
    			kubernetes.io/hostname=ubuntu
    			node-role.kubernetes.io/master=
    Annotations:		node.alpha.kubernetes.io/ttl=0
    			volumes.kubernetes.io/controller-managed-attach-detach=true
    Taints:			node-role.kubernetes.io/master:NoSchedule
    CreationTimestamp:	Fri, 28 Jul 2017 12:10:42 -0700
    Conditions:
      Type			Status	LastHeartbeatTime			LastTransitionTime			Reason				Message
      ----			------	-----------------			------------------			------				-------
      OutOfDisk 		False 	Fri, 28 Jul 2017 12:15:32 -0700 	Fri, 28 Jul 2017 12:10:38 -0700 	KubeletHasSufficientDisk 	kubelet has sufficient disk space available
      MemoryPressure 	False 	Fri, 28 Jul 2017 12:15:32 -0700 	Fri, 28 Jul 2017 12:10:38 -0700 	KubeletHasSufficientMemory 	kubelet has sufficient memory available
      DiskPressure 		False 	Fri, 28 Jul 2017 12:15:32 -0700 	Fri, 28 Jul 2017 12:10:38 -0700 	KubeletHasNoDiskPressure 	kubelet has no disk pressure
      Ready 		True 	Fri, 28 Jul 2017 12:15:32 -0700 	Fri, 28 Jul 2017 12:15:22 -0700 	KubeletReady 			kubelet is posting ready status. AppArmor enabled
    ```
  - Allow master to be deployed. (Single node mode. Optional.)
    ```sh
    kubectl taint nodes --all node-role.kubernetes.io/master-
    ```
    
Setup the slave

  - Join the cluster
    ```sh
    sudo kubeadm join --node-name slave --token 9f2192.57a8e0da9e168e5e 172.16.6.139:6443
    ```
