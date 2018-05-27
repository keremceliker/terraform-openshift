#!/bin/bash
set -e

cd terraform

echo "Planning Terraform changes..."
terraform plan -var-file='dev.tfvars' -var-file='aws.tfvars' -out='aws.tfplan'


echo "Deploying Terraform plan..."
terraform apply aws.tfplan

echo "Creating openshift inventory"
terraform output openshift-inventory > ../openshift-inventory

echo "Getting output variables..."
BASTION_IP=$(terraform output bastion_public_ip)
CONSOLE_URL=$(terraform output master_public_dns)
# CONSOLE_IP=$(terraform output master_public_ip)

cd ..

echo "Transfering private key to bastion server..."
scp -o StrictHostKeychecking=no -i certs/anieto.pem certs/anieto.pem centos@$BASTION_IP:/home/centos/.ssh/aws



echo "Transfering inventory to bastion server..."
scp -o StrictHostKeychecking=no -i certs/anieto.pem openshift-inventory centos@$BASTION_IP:/home/centos/openshift-inventory

echo "Transfering ansible requirements to bastion server..."
scp -o StrictHostKeychecking=no -i certs/anieto.pem -r ansible centos@$BASTION_IP:/home/centos/ansible



ssh -t -o StrictHostKeychecking=no -i certs/anieto.pem centos@$BASTION_IP ansible-playbook -i /home/centos/openshift-inventory ansible/main.yml
ssh -t -o StrictHostKeychecking=no -i certs/anieto.pem centos@$BASTION_IP ansible-playbook -i /home/centos/openshift-inventory openshift-ansible/playbooks/prerequisites.yml
ssh -t -o StrictHostKeychecking=no -i certs/anieto.pem centos@$BASTION_IP ansible-playbook -i /home/centos/openshift-inventory openshift-ansible/playbooks/deploy_cluster.yml




echo "Console: https://$CONSOLE_URL:8443"
echo "Bastion: ssh -i ~/.ssh/anieto.pem centos@$BASTION_IP"



# echo "Finished!!"
# echo "Console: https://$CONSOLE_IP:8443"
# echo "Bastion: ssh -i certs/bastion.key $ADMIN_USER@$BASTION_IP"
# echo "Router: $SERVICE_IP"
