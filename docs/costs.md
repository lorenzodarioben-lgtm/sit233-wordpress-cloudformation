# Cost Considerations

This project can create resources that incur meaningful AWS charges. Prices vary by region, usage, and date; check current official AWS pricing before deploying.

## Main Cost Drivers

- NAT Gateway hourly charges and data processing.
- Elastic IP charges, especially if left unattached.
- Application Load Balancer hourly and load-capacity usage.
- EC2 instances launched by the Auto Scaling Group.
- RDS primary DB instance.
- RDS Multi-AZ standby capacity.
- RDS read replica.
- RDS storage, backups, and retained snapshots.
- Secrets Manager secrets and API calls.
- S3 storage and requests.
- CloudWatch metrics and alarms.
- Data transfer between services, Availability Zones, and the internet.

## Cost-Conscious Defaults

The templates intentionally keep some defaults modest:

- One NAT Gateway instead of one per AZ.
- Auto Scaling desired capacity defaults to one instance.
- Web capacity is parameterized so stronger availability can be selected when cost is acceptable.
- RDS allocated storage defaults to 20 GiB.

## Reliability Trade-Offs

The cost-conscious defaults reduce baseline spend but also reduce resilience:

- A single NAT Gateway creates an AZ dependency for private-subnet outbound traffic.
- A default one-instance web tier does not provide active multi-instance web serving until capacity is increased.
- RDS Multi-AZ improves database availability, but the read replica is not used by WordPress application reads.

For a realistic portfolio demonstration, deploy in a controlled window, capture non-sensitive evidence, and tear down promptly.
