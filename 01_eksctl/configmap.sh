#!/bin/bash

# Variables
KUBECTL_PATH=/home/ubuntu/bin/kubectl

1- Map user
echo "Mapping $AWS_USER user"

$KUBECTL_PATH edit -n kube-system configmap/aws-auth

mapUsers: |
	- groups:
		- system:masters
		userarn: $AWS_USER
		username: $ARN_AWS_USER
      
#2- Get the ConfigMap file
echo "Get the ConfigMap file"
kubectl describe configmap aws-auth -n kube-system

#3- Get the cluster info
kubectl get nodes
