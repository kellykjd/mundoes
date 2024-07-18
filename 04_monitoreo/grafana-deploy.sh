#!/bin/bash

# Variables
KUBECTL_PATH=/home/ubuntu/bin/kubectl

#1- Create grafana namespace
echo "Create grafana namespace"
$KUBECTL_PATH create namespace grafana

#2-Install grafana
echo "Install grafana"
helm install grafana grafana/grafana \
    --namespace grafana \
    --set persistence.storageClassName="gp2" \
    --set persistence.enabled=true \
    --set adminPassword='EKS!sAWSome' \
    --values ${HOME}/environment/grafana/grafana.yaml \
    --set service.type=LoadBalancer