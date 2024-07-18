#!/bin/bash

# Variables
KUBECTL_PATH=/home/ubuntu/bin/kubectl

#2-Install grafana
echo "Install grafana"
helm install grafana grafana/grafana \
    --namespace grafana \
    --set persistence.storageClassName="gp2" \
    --set persistence.enabled=true \
    --set adminPassword='EKS!sAWSome' \
    --values ${HOME}/grafana.yaml \
    --set service.type=LoadBalancer