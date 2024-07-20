#!/bin/bash

# Variables
KUBECTL_PATH=/home/ubuntu/bin/kubectl

#Create Grafana Namespace
echo "Create Grafana Namespacea"
$KUBECTL_PATH create namespace grafana

# Add Helm Repository for Grafana
echo "Add Helm Repository for Grafana"
helm repo add grafana https://grafana.github.io/helm-charts

# Update Helm Repository
echo "Update Helm Repository"
helm repo update

# Install Grafana with Persistent Volumes
echo "Install Grafana with Persistent Volumes"
helm install grafana grafana/grafana \
                          --namespace grafana \
                          --set persistence.storageClassName="gp2" \
                          --set persistence.enabled=true \
                          --set adminPassword=${GRAFANA_PASSWORD_ADMIN} \
                          --values ${HOME}/grafana.yaml \
                          --set service.type=LoadBalancer \
                          --force

# Check Grafana Deployment Status
echo "Check Grafana Deployment Status"
$KUBECTL_PATH get all -n grafana

# Get Grafana Load Balancer URL
echo "Get Grafana Load Balancer URL"
export SERVICE_IP=$($KUBECTL_PATH get svc --namespace grafana grafana -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
echo "http://$SERVICE_IP"

#7-Get Grafana Service Details
echo "Get Grafana Service Details"
$KUBECTL_PATH get svc -n grafana
