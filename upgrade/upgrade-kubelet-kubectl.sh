#!/bin/bash

set -e

CONTROL_PLANE_NODE=core-gw.lancaster.ac.uk
TARGET_VERSION=1.19.3-00

## Grab package and install
sudo apt update 
sudo apt install -y --allow-change-held-packages kubelet=${TARGET_VERSION} kubectl=${TARGET_VERSION} 
sudo systemctl daemon-reload
sudo systemctl restart kubelet
