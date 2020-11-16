#!/bin/bash 


CONTROL_PLANE_NODE=core-gw.lancaster.ac.uk
TARGET_VERSION=1.19.3-00
NODES_FILE=nodes

SSH_OPTIONS="-o StrictHostKeyChecking=no"

#./get-nodes.sh

## upgrade kubeadm across cluster
#echo "upgrading kubeadm"
#for ip in `awk '{print $2}'` ${NODES_FILE}
#do
#	ssh root@${ip} "apt update && apt install -y --allow-change-held-packages kubeadm=${TARGET_VERSION}"
#done

# upgrade each node
echo "upgrading nodes"
#(cat $NODES_FILE; echo) | while read tuple
#for tuple in `kubectl get nodes -l role=worker | awk 'NR>1 {print $1" "$6}'`

## FUUUUUUCK BASH
IFS=$'\n'
for tuple in `cat nodes`
do
	echo "Upgrading: ${tuple}"

	node_id=$(echo ${tuple} | cut -d" " -f1)
	node_ip=$(echo ${tuple} | cut -d" " -f2)

	echo "$node_id ~ $node_ip"
	#upgrade kubeadm 
	ssh ${SSH_OPTIONS} root@${node_ip} "apt update && apt install -y --allow-change-held-packages kubeadm=${TARGET_VERSION}"
	
	# Drain node
	kubectl drain $node_id --ignore-daemonsets --delete-local-data
	
	# Upgrade node
	ssh ${SSH_OPTIONS} root@${node_ip} "kubeadm upgrade node"
	ssh ${SSH_OPTIONS} root@${node_ip} "apt install -y --allow-change-held-packages kubelet=${TARGET_VERSION} kubectl=${TARGET_VERSION} --allow-downgrades"

	# Restart kubelet 
	ssh ${SSH_OPTIONS} root@${node_ip} "systemctl daemon-reload && systemctl restart kubelet"

	kubectl uncordon ${node_id} || echo "Failed to uncord ${node_id}"

done 
