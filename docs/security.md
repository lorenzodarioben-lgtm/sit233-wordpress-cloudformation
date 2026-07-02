# Security Notes

This project was security-hardened compared with the original university submission, but it is not production-ready and has not been redeployed during the portfolio refresh.

## Implemented Controls

- EC2 instances run in private subnets without public IP addresses.
- RDS is placed behind a database security group and explicitly sets `PubliclyAccessible: false`.
- The ALB is the public HTTP entry point.
- Web security group ingress allows HTTP only from the ALB security group.
- Database security group ingress allows MySQL only from the web security group.
- Secrets Manager generates database and WordPress administrator passwords.
- RDS consumes the database secret through dynamic references.
- EC2 retrieves required secrets at runtime through its instance profile.
- The EC2 role is scoped to `DescribeSecret` and `GetSecretValue` on the two stack-created secrets.
- Launch template metadata options require IMDSv2.
- S3 media bucket public access is blocked.
- S3 bucket ownership controls use bucket-owner-enforced object ownership.
- S3 bucket encryption uses AES256 server-side encryption.
- S3 bucket policy denies insecure transport.
- RDS storage encryption is explicitly enabled.
- Primary RDS deletion and replacement retain snapshots.
- Stack outputs do not include passwords or secret values.
- Bootstrap no longer uses shell command tracing.
- Bootstrap uses restrictive temporary files for secret material and deletes them through a trap.
- `wp-config.php` permissions are set to `640`.

## Remaining Limitations

- The ALB listener uses HTTP only.
- No ACM certificate or HTTPS listener is configured.
- No AWS WAF is configured.
- No secret rotation workflow is configured.
- WordPress database credentials must exist at runtime on the WordPress host.
- The custom AMI remains a trust, patching, and portability concern.
- S3 media offload may not be fully automated; the bootstrap only activates the plugin if already installed.
- The repository-defined IAM role may not be allowed in restricted AWS Academy environments.
- No live deployment, penetration test, or runtime security verification was performed during the refresh.
- No Route 53 DNS, certificate renewal, centralized logging, or vulnerability scanning is included.

## Secret Handling Boundaries

The current design avoids storing resolved password values in CloudFormation parameters, launch template user data, and outputs. It does not make runtime hosts secret-free. A compromised WordPress host can still access its runtime credentials and configuration.

Do not describe `NoEcho` as encryption. The current template no longer uses password parameters for the main database or WordPress bootstrap password.
