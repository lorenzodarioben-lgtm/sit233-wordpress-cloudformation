# Limitations

The repository is now stronger and better documented, but several boundaries remain important.

- The refreshed templates were not deployed during this portfolio refresh.
- Static validation is not proof of successful runtime deployment.
- The default AMI is custom, lab-specific, and region/account dependent.
- The default `vockey` key pair may not exist outside AWS Academy Learner Lab environments.
- The repository-defined IAM role and instance profile may be restricted in AWS Academy.
- Default ASG desired capacity is one instance.
- One NAT Gateway creates an Availability Zone dependency for private egress.
- The ALB listener is HTTP only.
- No ACM certificate, HTTPS listener, Route 53 record, or custom domain is configured.
- The read replica is not used by WordPress for application reads.
- No automated credential rotation is configured.
- No tested migration path exists from the original deployed university stack.
- RDS encryption and credential-flow changes may cause replacement or require migration planning.
- S3 media offload requires deployment verification.
- Bootstrap still depends on external package repositories and WP-CLI download availability.
- No live disaster-recovery test was performed.
- No fresh deployment evidence was produced after the refresh.
- The templates are not described as production-ready.

These limitations should remain visible in any employer-facing presentation of the project.
