## write a Terraform code create 2 instances in 2 regions  
```bash
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

# Region 1 - Mumbai
provider "aws" {
  region = "ap-south-1"
}

# Region 2 - Singapore
provider "aws" {
  alias  = "singapore"
  region = "ap-southeast-1"
}

# EC2 instance in Mumbai
resource "aws_instance" "mumbai" {
  ami           = "ami-xxxxxxxx"
  instance_type = "t2.micro"

  tags = {
    Name = "Mumbai-Server"
  }
}

# EC2 instance in Singapore
resource "aws_instance" "singapore" {
  provider      = aws.singapore
  ami           = "ami-yyyyyyyy"
  instance_type = "t2.micro"

  tags = {
    Name = "Singapore-Server"
  }
}

```
# Understand the important part

You have two provider configurations:

```bash
provider "aws" {
  region = "ap-south-1"
}
```

This is the default provider.

So this resource:

```
resource "aws_instance" "mumbai" {

}
```

automatically uses Mumbai.

# The second provider has an alias:
```bash
provider "aws" {
  alias  = "singapore"
  region = "ap-southeast-1"
}
```
# Therefore, you explicitly tell the second EC2:

```bash 
provider = aws.singapore
```


# Create 3 instances in Region 2 with different names

```bash
resource "aws_instance" "singapore" {
  provider = aws.singapore

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


