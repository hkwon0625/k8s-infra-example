#! /bin/bash
sudo apt-get update
sudo apt-get install -y docker.io
sudo -s
sudo swapoff -a
sudo echo 0 > /proc/sys/vm/swappiness
sudo sed -e '/swap/ s/^#*/#/' -i /etc/fstab

echo -e " #regeister hosts\n10.0.2.10 master-node\n10.0.4.10 worker-node1\n10.0.5.10 worker-node2" | sudo tee -a /etc/hosts

sudo hostnamectl set-hostname master-node

sudo apt-get update && sudo apt-get install -y apt-transport-https curl

sudo curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -

cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb https://apt.kubernetes.io/ kubernetes-xenial main
EOF

sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl

sudo apt-mark hold kubelet kubeadm kubectl

sudo sed -i '14s/.*/ExecStart=\/usr\/bin\/dockerd -H fd:\/\/ --containerd=\/run\/containerd\/containerd.sock --exec-opt native.cgroupdriver=systemd/g' /lib/systemd/system/docker.service

sudo systemctl daemon-reload
sudo systemctl restart docker

sudo modprobe br_netfilter

cat <<EOF | sudo tee /etc/modules-load.d/k8s.conf
br_netfilter
EOF

cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
EOF
sudo sysctl --system

sudo kubeadm init \
    --apiserver-advertise-address=0.0.0.0 \
    --pod-network-cidr=192.168.0.0/16 \
    --apiserver-cert-extra-sans=10.0.2.10

sudo -i
sudo mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config


sudo curl https://projectcalico.docs.tigera.io/manifests/calico.yaml -O
sudo kubectl apply -f calico.yaml

