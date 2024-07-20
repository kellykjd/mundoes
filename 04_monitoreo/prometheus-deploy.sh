#!/bin/bash
# Instalar Prometheus y Grafana usnado Helm (Manejador de paquetes para kubernetes)

# Variables
KUBECTL_PATH=/home/ubuntu/bin/kubectl
CLUSTER_NAME=mundoes-cluster-G7
AWS_REGION=us-east-1
SERVICE_ACCOUNT_ROLE_ARN=arn:aws:iam::710500364490:role/driver_EBS_controller_EKS
export AWS_DEFAULT_REGION=$AWS_REGION

# Applying Amazon EBS CSI resources
echo "Applying Amazon EBS CSI resources"
$KUBECTL_PATH apply -k "github.com/kubernetes-sigs/aws-ebs-csi-driver/deploy/kubernetes/overlays/stable/?ref=release-1.32"

# Create prometheus namespace
echo "Create prometheus namespace"
$KUBECTL_PATH create namespace prometheus

# Add prometheus repository
echo "Add prometheus repository"
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

# Install Prometheus and Alertmanager with Persistent Volume
echo "Install Prometheus and Alertmanager with Persistent Volume"
helm install prometheus prometheus-community/prometheus --namespace prometheus --set alertmanager.persistentVolume.storageClass="gp2"

helm install alertmanager prometheus-community/alertmanager --namespace prometheus --set alertmanager.persistentVolume.storageClass="gp2"

# Verify Prometheus Pods Status
echo "Verify Prometheus Pods Status"
$KUBECTL_PATH get pods --namespace=prometheus

# Set storageClass to storage-alertmanager-0 pvc
echo "Set storageClass to storage-alertmanager-0 pvc"
$KUBECTL_PATH patch pvc -n prometheus storage-alertmanager-0 -p '{"spec": {"storageClassName": "gp2"}}'

# Set storageClass to storage-prometheus-alertmanager-0 pvc
echo "Set storageClass to storage-prometheus-alertmanager-0 pvc"
$KUBECTL_PATH patch pvc -n prometheus storage-prometheus-alertmanager-0 -p '{"spec": {"storageClassName": "gp2"}}'

# Set storageClass to prometheus-server pvc
echo "Set storageClass to prometheus-server pvc"
$KUBECTL_PATH patch pvc -n prometheus prometheus-server -p '{"spec": {"storageClassName": "gp2"}}'

# Create IAM OIDC Provider
echo "Create IAM OIDC Provider"
eksctl upgrade cluster --name $CLUSTER_NAME --approve
eksctl utils associate-iam-oidc-provider --region=$AWS_REGION --cluster=$CLUSTER_NAME --approve

# Create the driver_EBS_controller_EKS role
echo "Create the driver_EBS_controller_EKS role"
eksctl create iamserviceaccount \
  --name ebs-csi-controller-sa \
  --namespace kube-system \
  --cluster $CLUSTER_NAME \
  --attach-policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy \
  --approve \
  --role-only \
  --role-name driver_EBS_controller_EKS

# Check Amazon EBS CSI Driver Addon Versions
echo "Check Amazon EBS CSI Driver Addon Versions"
aws eks describe-addon-versions --addon-name aws-ebs-csi-driver

# Install Amazon EBS CSI Driver Addon
echo "Install Amazon EBS CSI Driver Addon"
eksctl create addon --name aws-ebs-csi-driver --cluster $CLUSTER_NAME --service-account-role-arn $SERVICE_ACCOUNT_ROLE_ARN --force

# Verify EBS CSI Driver Addon Version
echo "Verify EBS CSI Driver Addon Version"
eksctl get addon --name aws-ebs-csi-driver --cluster $CLUSTER_NAME

# Update EBS CSI Driver Addon
echo "Update EBS CSI Driver Addon"
eksctl upgrade cluster --name $CLUSTER_NAME --approve

# Verify service account
echo "Verify service account"
$KUBECTL_PATH describe serviceaccount ebs-csi-controller-sa -n kube-system

# Verify Prometheus Pods Status Again
echo "Verify Prometheus Pods Status Again"
$KUBECTL_PATH get pods --namespace=prometheus

# Set port forward
echo "Set port forward"
$KUBECTL_PATH port-forward -n prometheus deploy/prometheus-server 8080:9090 --address 0.0.0.0