#!/bin/bash

kubectl get nodes



#1- Map user
#echo "Mapping $AWS_USER user"

#kubectl edit -n kube-system configmap/aws-auth

#mapUsers: |
#	- groups:
#		- system:masters
#		userarn:  mundose-aws-user
#		username: arn:aws:iam::710500364490:user/mundose-aws-user
      
#2- Check config
#echo "Checking configuration..."
#kubectl get configmap -n kube-system

#3- Get the ConfigMap file
#echo "Get the ConfigMap file"
#kubectl describe configmap aws-auth -n kube-system

#4- Get the cluster info
#echo "Get the cluster info"
#kubectl get nodes