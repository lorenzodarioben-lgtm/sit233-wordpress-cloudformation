# Teardown Guide

This project can create billable AWS resources. Teardown should be planned and performed promptly in a paid account. The teardown sequence was not live-tested during this portfolio refresh.

## Recommended Order

Delete the application stack before the networking stack. The application stack depends on exports from the networking stack.

```bash
aws cloudformation delete-stack \
  --stack-name WordPress-CFN-Application \
  --region us-east-1
```

Wait for the application stack deletion before deleting networking:

```bash
aws cloudformation wait stack-delete-complete \
  --stack-name WordPress-CFN-Application \
  --region us-east-1
```

Then delete networking:

```bash
aws cloudformation delete-stack \
  --stack-name WordPress-CFN-Networking \
  --region us-east-1
```

## Deletion Protection

The primary RDS instance has parameterized deletion protection. If `EnableRDSDeletionProtection` was set to `true`, disable it through a stack update before deletion.

Keep the same parameter values used for the stack and set:

```text
EnableRDSDeletionProtection=false
```

Do this in a controlled change set or update workflow. The exact update command depends on your deployed parameters.

## RDS Snapshots

The primary RDS database uses:

- `DeletionPolicy: Snapshot`
- `UpdateReplacePolicy: Snapshot`

Deleting or replacing the primary can retain manual snapshots. Snapshots may continue to incur storage charges until deleted.

The read replica uses `DeletionPolicy: Delete` and is intended to be disposable.

## Secrets Manager

The application stack creates Secrets Manager secrets for database and WordPress bootstrap credentials. Confirm whether those secrets are deleted, scheduled for deletion, or retained according to CloudFormation and Secrets Manager behavior in your account. Also check whether any recovery window or scheduled deletion state leaves billable resources.

## S3 Bucket

CloudFormation cannot delete a non-empty S3 bucket. If media files were uploaded to the bucket, empty the bucket before deleting the application stack or be prepared to resolve a stack deletion failure.

## Networking Costs

The networking stack creates a NAT Gateway and Elastic IP. NAT Gateway charges can become significant, and an unattached Elastic IP can still incur cost. Delete the networking stack after the application stack no longer needs private-subnet egress.

## Confirm Teardown

After deletion, verify:

- No CloudFormation stacks remain for this project.
- No RDS instances, read replicas, retained snapshots, or automated backups remain unexpectedly.
- No NAT Gateway or Elastic IP remains.
- No ALB, target group, or Auto Scaling Group remains.
- No EC2 instances remain.
- No S3 bucket remains unless intentionally retained.
- No Secrets Manager secrets remain unless intentionally retained or pending deletion.
- No CloudWatch alarms remain.

Use the AWS console or AWS CLI checks appropriate to your account and region.
