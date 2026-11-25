```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_iam_role" "example_role" {
  name = "example-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })
}
```

**1. Provider configuration**

```hcl
provider "aws" {
  region = "us-east-1"
}
```

- provider "aws" tells Terraform to use the AWS provider.
- region = "us-east-1" specifies the AWS region (North Virginia).

**2. IAM Role creation**

```hcl
resource "aws_iam_role" "example_role" {
  name = "example-role"
```

- aws_iam_role is the Terraform resource type.
- example_role is the Terraform local resource name.
- example-role is the actual IAM role name in AWS

**3. assume_role_policy**
```hcl
assume_role_policy = jsonencode({
  Version = "2012-10-17",

  Statement = [
    {
      Effect = "Allow",

      Principal = {
        Service = "ec2.amazonaws.com"
      },

      Action = "sts:AssumeRole"
    }
  ]
})
```
This is called a Trust Policy.

It defines WHO is allowed to assume this IAM role.

| Field | Meaning |
|---|---|
| `Version` | IAM policy language version |
| `Statement` | Contains policy permissions/trust rules |
| `Effect = Allow` | Allows the specified action |
| `Principal` | Identifies who can assume the role |
| `Service = ec2.amazonaws.com` | Allows EC2 service to assume this role |
| `Action` | Specifies the allowed action |
| `sts:AssumeRole` | Allows assuming the IAM role |
