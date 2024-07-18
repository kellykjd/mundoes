#!/bin/bash

# Variables
KUBECTL_PATH=/home/ubuntu/bin/kubectl

#1- Get the ConfigMap file
echo "Get the ConfigMap file"
$KUBECTL_PATH describe configmap aws-auth -n kube-system

#2- Checking user access to the cluster
echo "Checking user access to the cluster"

$KUBECTL_PATH get nodes
if [ $? -eq 0 ]
then
  echo "El usuario está habilitado para realizar consultas al cluster."
else
  echo "El usuario no tiene acceso a datos del cluster."
fi