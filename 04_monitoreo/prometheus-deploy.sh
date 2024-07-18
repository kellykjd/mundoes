#!/bin/bash
# Instalar Prometheus y Grafana usnado Helm (Manejador de paquetes para kubernetes)

# Variables
KUBECTL_PATH=/home/ubuntu/bin/kubectl

#Instalación del driver EBS
echo "Installing EBS drivers"
kubectl apply -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/?ref=release-1.32"

# Agregar repo de prometheus
echo "Add prometheus repository"
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

# Agregar repo de grafana
echo "Add grafana repository"
helm repo add grafana https://grafana.github.io/helm-charts

# Actualizar repos
echo "Update repository"
helm repo update

# Crear el namespace prometheus
echo "Create prometheus namespace"
KUBECTL_PATH create namespace prometheus

# Desplegar prometheus en EKS
echo "Deploy prometheus on EKS"
helm install prometheus prometheus-community/prometheus \
--namespace prometheus \
--set alertmanager.persistentVolume.storageClass="gp2" \
--set server.persistentVolume.storageClass="gp2"

# Verificar la instalación de prometheus
echo "Check prometheus installation"
KUBECTL_PATH get all -n prometheus

# Exponer prometheus en la instancia de EC2 en el puerto 8080
echo "Expose prometheus into the port 8080 on EC2 instance"
KUBECTL_PATH port-forward -n prometheus deploy/prometheus-server 8080:9090 --address 0.0.0.0

# Desplegar Grafana en EKS
echo "Deploy prometheus on EKS"
chmod +x grafana-deploy.sh && grafana-deploy.sh