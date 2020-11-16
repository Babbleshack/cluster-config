#!/bin/bash
node_id=$1
node_ip=$2

TARGET_VERSION=1.18.8-00
SSH_OPTIONS="-o StrictHostKeyChecking=no"

#upgrade kubeadm 
ssh ${SSH_OPTIONS} root@${node_ip} "apt update && apt install -y --allow-change-held-packages kubeadm=${TARGET_VERSION}"

# Drain node
kubectl drain $node_id --ignore-daemonsets --delete-local-data

# Upgrade node
ssh ${SSH_OPTIONS} root@${node_ip} "kubeadm upgrade node"
ssh ${SSH_OPTIONS} root@${node_ip} "apt install -y --allow-change-held-packages kubelet=${TARGET_VERSION} kubectl=${TARGET_VERSION}"

# Restart kubelet 
ssh ${SSH_OPTIONS} root@${node_ip} "systemctl daemon-reload && systemctl restart kubelet"

kubectl uncordon ${node_id} || echo "Failed to uncord ${node_id}"
