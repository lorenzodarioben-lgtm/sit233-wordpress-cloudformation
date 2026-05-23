# SIT233 Cloud Computing Final Project - CloudFormation Templates

This repository contains the CloudFormation templates used for the automated deployment of a highly available WordPress application on AWS.

## Templates

- `networking.yaml` - creates the VPC, public/private subnets, route tables, Internet Gateway, NAT Gateway, and stack outputs.
- `application.yaml` - creates the application infrastructure including security groups, ALB, target group, launch template, Auto Scaling Group, RDS MySQL, read replica, S3 bucket, scaling policies, and alarms.

## Project Context

The CloudFormation deployment recreates the manually built WordPress architecture in a separate VPC as required for the SIT233 Cloud Computing final project.

Manual VPC: `10.0.0.0/16`  
CloudFormation VPC: `10.1.0.0/16`  
Region: `us-east-1`

## Security Note

No AWS credentials, private keys, database passwords, WordPress admin passwords, or session tokens are included in this repository. Passwords are passed as CloudFormation parameters using `NoEcho: true`.
