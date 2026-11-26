# 1. Real-time interview scenarios on Terraform taint

**Scenario 1: EC2 instance is not working**

**You created an EC2 instance using Terraform. Due to some configuration issue, the EC2 instance is not working properly. You want Terraform to recreate only that EC2 instance.**

Interviewer asks: How would you do it?

Expected command: 

```hcl
terraform apply -replace="aws_instance.web"
```

**Scenario 2: One resource is corrupted**

You created:
- 1 VPC
- 2 subnets
- 1 EC2 instance
Your EC2 instance is corrupted, but VPC and subnets are working fine.

**How can you recreate only the EC2 instance without recreating the entire infrastructure?**

```hcl
terraform apply -replace="aws_instance.web"
```

**Scenario 3: You want to recreate a resource without changing its configuration**

**Your EC2 configuration is correct, but the actual instance is having some issues. You want Terraform to destroy and recreate it using the same configuration.How would you achieve this?**

```hcl
terraform apply -replace="aws_instance.web"
```

**Scenario 4: You accidentally marked a resource for replacement**

**You marked an EC2 instance for replacement, but later realized that replacement is not required.What would you do?**

If you used the modern -replace option, it is not persisted in the state. Simply don't apply that replacement plan. If you used the older terraform taint command, you can use:

```hcl
terraform untaint aws_instance.web
```
## Important Terraform Commands for Interviews

| Command | Purpose |
|---|---|
| `terraform taint` | Old command to mark a resource for replacement |
| `terraform untaint` | Remove the old tainted status |
| `terraform apply -replace` | Modern recommended approach to replace a specific resource |
| `terraform plan` | Preview infrastructure changes before applying |
| `terraform state list` | List all resources tracked in Terraform state |
