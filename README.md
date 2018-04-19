# Demo Wordpress  on AWS

This artifact deploys a demo Wordpress on AWS using a bitnami image.

We have created a security group so that the instance only responds on port 80/443 (HTTP/S) and 22 (SSH) for ssh connection.

To get the application password (back-office) you need this packages: 
 - aws-cli
 - jq

Then, run the following cli command to get the application password: 
>  aws ec2 get-console-output  --instance-id <instanceId>  --output json | jq -r '.[]' | grep 'application password'  | cut -d "'" -f 2

We use a simple architecture with two AWS services:
 - EC2 (t2.small) with EBS backend
 - Security Group