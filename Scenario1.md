## How will you create different instances with same terraform main.tf configuration file?

We can create multiple EC2 instances using the same Terraform configuration file by using count or for_each.

These features help us avoid writing separate resource blocks for each EC2 instance.

# Real-time scenario: If a project requires three identical EC2 instances for an application, we can use count = 3.

# 1. Using count : 

The count meta-argument creates multiple instances of the same resource.
```bash
resource "aws_instance" "web" {
  count         = 3
  ami           = "ami-123456"
  instance_type = "t2.micro"

  tags = {
    Name = "web-server-${count.index}"
  }
}
```
# What happens?

Terraform creates three EC2 instances:
| Resource | Instance name |
|---|---|
| `aws_instance.web[0]` | web-server-0 |
| `aws_instance.web[1]` | web-server-1 |
| `aws_instance.web[2]` | web-server-2 |

# Why you not used key-pair?
- key_name specifies the EC2 key pair.
- The key pair is used for SSH access to Linux EC2 instances.
- The private key must be available to the person connecting.
- Without a key pair, you can still access instances using AWS Systems Manager Session Manager if configured.

# 2. Using for_each

We use for_each when we want to create multiple instances with different configurations or names.

```bash
variable "instance_types" {
  default = {
    dev  = "t2.micro"
    test = "t2.small"
    prod = "t2.medium"
  }
}

resource "aws_instance" "web" {
  for_each      = var.instance_types
  ami           = "ami-123456"
  instance_type = each.value

  tags = {
    Name = each.key
  }
}
```

# What happens?

Terraform creates three EC2 instances:

| Instance | Instance type |
|---|---|
| dev | t2.micro |
| test | t2.small |
| prod | t2.medium |

Terraform identifies them using keys:

```bash
aws_instance.web["dev"]
aws_instance.web["test"]
aws_instance.web["prod"]
```
