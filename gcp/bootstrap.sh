#!/bin/bash
set -e

cd terraform

echo "Planning Terraform changes..."
terraform plan -var-file='dev.tfvars' -out='gcp.tfplan'


echo "Deploying Terraform plan..."
terraform apply gcp.tfplan

echo "Creating openshift inventory"
terraform output openshift-inventory > ../openshift-inventory

echo "Getting output variables..."
BASTION_IP=$(terraform output bastion_public_ip)
CONSOLE_IP=$(terraform output master_public_ip)

cd ..

echo "Transfering private key to bastion server..."
scp -o StrictHostKeychecking=no -i certs/gcp certs/gcp ale@$BASTION_IP:/home/ale/.ssh/gcp

# echo "Transfering install script to bastion server..."
# scp -o StrictHostKeychecking=no -i certs/gcp scripts/install.sh $ADMIN_USER@$BASTION_IP:/home/openshift/install.sh

echo "Transfering inventory to bastion server..."
scp -o StrictHostKeychecking=no -i certs/gcp openshift-inventory ale@$BASTION_IP:/home/ale/openshift-inventory

echo "Para conectar a Bastion:"
echo "ssh -i certs/gcp ale@$BASTION_IP"
# echo "Running install script on bastion server..."
# ssh -t -o StrictHostKeychecking=no -i certs/bastion.key $ADMIN_USER@$BASTION_IP ./install.sh $NODE_COUNT $ADMIN_USER $MASTER_DOMAIN
#
# echo "Finished!!"
# echo "Console: https://$CONSOLE_IP:8443"
# echo "Bastion: ssh -i certs/bastion.key $ADMIN_USER@$BASTION_IP"
# echo "Router: $SERVICE_IP"
