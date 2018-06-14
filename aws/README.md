terraform-aws-openshift
=========================
[OpenShift Reference Architecture](https://access.redhat.com/documentation/en-us/reference_architectures/2018/html/deploying_and_managing_openshift_3.9_on_amazon_web_services/) implementation on AWS using Terraform.


![OpenShift Reference Architecture](https://blog.openshift.com/wp-content/uploads/refarch-ocp-on-aws-v4.png)

Bootstraping
------------
### Setup
For working with this repo is necessary to work with terraform workspaces. There is a .tfvars file for each workspace. For example, for working at workspace 'dev' you need the 'dev.tfvars' (already created at this repo) and the workspace 'dev'

Fill in the variables in ```aws.tfvars``` with your AWS credentials:
```
aws_access_key = "xxxxxxxx"
aws_secret_key = "xxxxxxxx"
```

Modify the variables in ```<workspace>.tfvars``` to change amount of machines, resources names and cidr blocks.

It's mandatory to change the following vars for your scenario:
```
key_name        = "anieto"   # RSA Key
hosted_zone     = "mithrandir.gq." # Your domain
console_domain  = "openshift-dev.mithrandir.gq" # URL for Console Web
```


### Bootstrap

Simply run:
```
./bootstrap.sh
```
When finished, you will get the public IP for the Bastion host and the Openshift Web Console URL.

In order to SSH into the Bastion host use the key in the ```certs``` folder.
