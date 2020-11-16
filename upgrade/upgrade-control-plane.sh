#!/bin/bash

set -e

CONTROL_PLANE_NODE=core-gw.lancaster.ac.uk
TARGET_VERSION=1.19.3-00

## Grab package and install
sudo apt update 
sudo apt install -y --allow-change-held-packages kubeadm=${TARGET_VERSION}
sudo kubeadm upgrade plan
