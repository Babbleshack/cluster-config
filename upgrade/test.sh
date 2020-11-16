#!/bin/bash 


CONTROL_PLANE_NODE=core-gw.lancaster.ac.uk
TARGET_VERSION=1.18.8-00
NODES_FILE=nodes

#./get-nodes.sh

## upgrade kubeadm across cluster
#echo "upgrading kubeadm"
#for ip in `awk '{print $2}'` ${NODES_FILE}
#do
#	ssh root@${ip} "apt update && apt install -y --allow-change-held-packages kubeadm=${TARGET_VERSION}"
#done

# upgrade each node
set -e 
echo "upgrading nodes"

while read tuple
do
	node_id=$(echo ${tuple} | cut -d" " -f1)
	node_ip=$(echo ${tuple} | cut -d" " -f2)

	./upgrade_worker.sh $node_id $node_ip
done < nodes 
