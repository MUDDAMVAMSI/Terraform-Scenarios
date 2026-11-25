# Case 1: Without replace_triggered_by

Your Terraform code:

```hcl
resource "aws_launch_template" "web" {
  name_prefix   = "web-"
  image_id      = "ami-12345678"
  instance_type = "t2.micro"
}

resource "aws_instance" "web" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"
}
```

Now you change the launch template:

```hcl
instance_type = "t3.micro"
```

**What happens?**

1. Launch Template changes from T2 to T3.
2. Terraform updates the launch template.
3. Existing EC2 remains T2.micro.

Why? Because the EC2 resource has its own hardcoded t2.micro configuration and does not reference the launch template.

# Case 2: With replace_triggered_by

Now add the lifecycle rule to EC2:

```hcl
resource "aws_launch_template" "web" {
  name_prefix   = "web-"
  image_id      = "ami-12345678"
  instance_type = "t2.micro"
}

resource "aws_instance" "web" {
  ami           = "ami-12345678"
  instance_type = "t2.micro"

  lifecycle {
    replace_triggered_by = [
      aws_launch_template.web
    ]
  }
}
```

Now change the launch template:
```hcl
instance_type = "t3.micro"
```

**What happens?**
1. Launch Template changes from T2 to T3.
2. Terraform detects the launch template change.
3. replace_triggered_by triggers EC2 replacement.
4. But the new EC2 will still be T2.micro!

Why? Because EC2 still has instance_type = "t2.micro".

# Case 3: With replace_triggered_by AND shared variable

```hcl
variable "instance_type" {
  default = "t2.micro"
}

resource "aws_launch_template" "web" {
  name_prefix   = "web-"
  image_id      = "ami-12345678"
  instance_type = var.instance_type
}

resource "aws_instance" "web" {
  ami           = "ami-12345678"
  instance_type = var.instance_type

  lifecycle {
    replace_triggered_by = [
      aws_launch_template.web
    ]
  }
}
```

Initially:

```hcl
instance_type = "t2.micro"
```

Later, change it to:

```hcl
instance_type = "t3.micro"
```

Now:
1. Launch Template changes to T3.micro.
2. EC2's own configuration also changes to T3.micro.
3. Terraform replaces EC2.
4. New EC2 runs on T3.micro.

## Final Comparison

| Configuration | Final EC2 | EC2 Replaced? |
|---|---|---|
| No lifecycle, EC2 hardcoded T2 | T2.micro | No |
| Lifecycle, EC2 hardcoded T2 | T2.micro | Yes |
| Shared variable changed T2 → T3 | T3.micro | Yes |