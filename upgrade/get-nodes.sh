#!/bin/bash

OUTPUT=nodes
ROLE=worker

rm -rfv ${OUTPUT}
echo "fetching node data\n"
kubectl get nodes -l role=${ROLE} -o wide | awk 'NR>1 {print $1" "$6}' > ${OUTPUT}
