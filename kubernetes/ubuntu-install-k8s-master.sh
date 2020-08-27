#! /bin/bash

curl https://raw.githubusercontent.com/actini/utilities/master/docker/ubuntu-install.sh | sudo bash -x

curl https://raw.githubusercontent.com/actini/utilities/master/kubernetes/ubuntu-install-kubeadm.sh | sudo bash -x

curl https://raw.githubusercontent.com/actini/utilities/master/kubernetes/ubuntu-install-kubectl.sh | sudo bash -x

sudo kubeadm init --pod-network-cidr=10.244.0.0/16

mkdir -p $HOME/.kube && sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config && sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
