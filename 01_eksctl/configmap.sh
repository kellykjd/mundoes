#!/bin/bash

#1- Map user
#echo "Mapping $AWS_USER user"

#kubectl edit -n kube-system configmap/aws-auth

#mapUsers: |
#	- groups:
#		- system:masters
#		userarn: $AWS_USER
#		username: $ARN_AWS_USER
      
#2- Get the ConfigMap file
echo "Get the ConfigMap file"
kubectl describe configmap aws-auth -n kube-system

