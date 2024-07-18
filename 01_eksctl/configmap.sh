#!/bin/bash

aws eks --region us-east-1 update-kubeconfig --name mundoes-cluster-G6
kubectl get svc
aws configure --profile  mundose-aws-user
aws eks --region us-east-1 update-kubeconfig --name mundoes-cluster-G6 --profile mundose-aws-user
kubectl get nodes



#1- Map user
#echo "Mapping $AWS_USER user"

#kubectl edit -n kube-system configmap/aws-auth

#mapUsers: |
#	- groups:
#		- system:masters
#		userarn:  $ARN_AWS_USER
#		username: $AWS_USER
      
#2- Check config
#echo "Checking configuration..."
#kubectl get configmap -n kube-system

#3- Get the ConfigMap file
#echo "Get the ConfigMap file"
#kubectl describe configmap aws-auth -n kube-system

#4- Get the cluster info
#echo "Get the cluster info"
#kubectl get nodes