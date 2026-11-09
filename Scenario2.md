# Using toset

```bash
provider "aws" {
  region = "ap-south-1"
}

variable "instance_names" {
  default = ["web-server", "app-server"]
}

resource "aws_instance" "my_instance" {
  for_each = toset(var.instance_names)

  ami           = "ami-xxxxxxxx"
  instance_type = "t2.micro"

  tags = {
    Name = each.value
  }
}
```

# Expected output

Terraform creates two EC2 instances:

| Resource name | EC2 instance Name tag |
|---|---|
| `my_instance["web-server"]` | web-server |
| `my_instance["app-server"]` | app-server |
