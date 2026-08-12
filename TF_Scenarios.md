## write a Terraform code create 2 instances in 2 regions  
```bash
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# Region 1 - US East 1
provider "aws" {
  region = "us-east-1"
}

# Region 2 - US West 1
provider "aws" {
  alias  = "us_west_1"
  region = "us-west-1"
}

# EC2 instance in US East 1
resource "aws_instance" "us_east_1" {
  ami           = "ami-xxxxxxxx"
  instance_type = "t2.micro"

  tags = {
    Name = "US-East-1-Server"
  }
}

# EC2 instance in US West 1
resource "aws_instance" "us_west_1" {
  provider      = aws.us_west_1
  ami           = "ami-yyyyyyyy"
  instance_type = "t2.micro"

  tags = {
    Name = "US-West-1-Server"
  }

  lifecycle {
    create_before_destroy = true
    prevent_destroy       = true
    ignore_changes       = all
  }
}

```
# Understand the important part

You have two provider configurations:

```bash
provider "aws" {
  region = "us-east-1"
}
```

This is the default provider.

So this resource:

```
resource "aws_instance" "us_east_1" {

}
```

automatically uses Mumbai.

# The second provider has an alias:
```bash
provider "aws" {
  alias  = "us_west_1"
  region = "us-west-1"
}
```
# Therefore, you explicitly tell the second EC2:

```bash 
provider      = aws.us_west_1
```


# Create 3 instances in Region 2 with different names

```bash
resource "aws_instance" "us_west_1" {
  provider      = aws.us_west_1

  count = 3

  ami           = "ami-yyyyyyyy"
  instance_type = "t2.micro"

  tags = {
    Name = "Instance-${count.index + 1}"
  }
}
```

# Result
```
Singapore (ap-southeast-1)
│
├── Instance-1
├── Instance-2
└── Instance-3
```

Terraform resources will be:
```

aws_instance.singapore[0] → Instance-1
aws_instance.singapore[1] → Instance-2
aws_instance.singapore[2] → Instance-3
```


