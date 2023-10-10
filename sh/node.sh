#!/bin/bash

set -e

export PATH=$PATH:/sbin

kubeadm join ${MASTER_IP}:6443 --token ${TOKEN} --discovery-token-unsafe-skip-ca-verification
