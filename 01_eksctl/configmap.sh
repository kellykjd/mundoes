#!/bin/bash

#kubectl get nodes
echo "Installing kubectl"
curl -o kubectl https://s3.us-west-2.amazonaws.com/amazon-eks/1.26.2/2023-03-17/bin/linux/amd64/kubectl
chmod +x ./kubectl
mkdir -p $HOME/bin && cp ./kubectl $HOME/bin/kubectl && export PATH=$PATH:$HOME/bin
echo 'export PATH=$PATH:$HOME/bin' >> ~/.bashrc
source ~/.bashrc
kubectl version --client


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
