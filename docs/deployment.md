# Deployment Guide

This guide describes how a fresh deployment would be performed. The refreshed templates were not deployed during the portfolio refresh, so treat these commands as a starting point for a controlled test deployment, not as verified deployment evidence.

## Prerequisites

- An AWS account where you are allowed to create VPC, EC2, Auto Scaling, ALB, RDS, S3, Secrets Manager, CloudWatch, and IAM resources.
- AWS CLI configured locally.
- CloudFormation permissions for both stacks.
- Permission to acknowledge IAM resource creation with `CAPABILITY_IAM`.
- A supported region. Current defaults and the custom AMI value are oriented around `us-east-1`.
- A valid EC2 key pair. The default `vockey` is from the original AWS Academy Learner Lab and may not exist outside that environment.
- A WordPress-capable AMI. The default AMI is lab-specific and must be replaced for another account or region.

Do not use these commands with live production workloads until the templates have been tested in a disposable environment.

## Validate Before Deployment

```powershell
cfn-lint -t networking.yaml application.yaml
cfn-lint --non-zero-exit-code error -t networking.yaml application.yaml
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\validate.ps1
```

With Git Bash:

```bash
scripts/validate.sh
```

## Parameter Files

Sanitized examples are provided in:

- [parameters/networking.example.json](../parameters/networking.example.json)
- [parameters/application.example.json](../parameters/application.example.json)

They use placeholder values. Replace the AMI ID, key pair, WordPress administrator email, and any sizing values before deploying. The application parameter file does not include password parameters because the template now generates secrets through Secrets Manager.

## Deployment Order

Deploy the networking stack first. The application stack imports networking outputs by stack name.

### 1. Create The Networking Stack

```bash
aws cloudformation create-stack \
  --stack-name WordPress-CFN-Networking \
  --template-body file://networking.yaml \
  --parameters file://parameters/networking.example.json \
  --region us-east-1
```

Wait for completion:

```bash
aws cloudformation wait stack-create-complete \
  --stack-name WordPress-CFN-Networking \
  --region us-east-1
```

### 2. Create The Application Stack

```bash
aws cloudformation create-stack \
  --stack-name WordPress-CFN-Application \
  --template-body file://application.yaml \
  --parameters file://parameters/application.example.json \
  --capabilities CAPABILITY_IAM \
  --region us-east-1
```

Wait for completion:

```bash
aws cloudformation wait stack-create-complete \
  --stack-name WordPress-CFN-Application \
  --region us-east-1
```

`CAPABILITY_IAM` is required because the application stack creates an EC2 role and instance profile for least-privilege secret retrieval. The template does not define named IAM resources, so `CAPABILITY_NAMED_IAM` is not expected to be required.

## Inspect Outputs

```bash
aws cloudformation describe-stacks \
  --stack-name WordPress-CFN-Application \
  --query "Stacks[0].Outputs" \
  --region us-east-1
```

Expected application outputs include the ALB URL, target group ARN, launch template ID, Auto Scaling Group name, CloudWatch alarm names, RDS identifiers, primary database endpoint, read replica identifier, and media bucket name.

No password values are output.

## Fresh Deployment Recommendation

The Stage 3 hardening changed credential handling, IAM, RDS encryption, and deletion policies. Use a fresh disposable deployment first.

Do not apply these templates as an untested in-place update to an old data-bearing stack. Storage encryption and credential-flow changes may require replacement or careful migration planning.

## Current Verification Status

The repository is statically validated with `cfn-lint`, local validation scripts, and GitHub Actions. Runtime behavior remains unverified until a controlled deployment is performed.
