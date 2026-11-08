# 1.  How can you create an S3 bucket using Terraform?

```bash
provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = "vamsi-terraform-demo-bucket"
}
```
# 2. Using count for creating 5 buckets

```bash
provider "aws" {
  region = "ap-south-1"
}

resource "aws_s3_bucket" "my_bucket" {
  count = 5

  bucket = "vamsi-demo-bucket-${count.index}"
}
```
# Output:

| Resource | S3 bucket name |
|---|---|
| `aws_s3_bucket.my_bucket[0]` | vamsi-demo-bucket-0 |
| `aws_s3_bucket.my_bucket[1]` | vamsi-demo-bucket-1 |
| `aws_s3_bucket.my_bucket[2]` | vamsi-demo-bucket-2 |
| `aws_s3_bucket.my_bucket[3]` | vamsi-demo-bucket-3 |
| `aws_s3_bucket.my_bucket[4]` | vamsi-demo-bucket-4 |

# 3. Using varibles 

```bash
variable "bucket_names" {
  default = {
    dev    = "company-dev-bucket"
    test   = "company-test-bucket"
    prod   = "company-prod-bucket"
    backup = "company-backup-bucket"
    logs   = "company-logs-bucket"
  }
}

resource "aws_s3_bucket" "my_bucket" {
  for_each = var.bucket_names

  bucket = each.value

  tags = {
    Environment = each.key
  }
}
```

# What is the use of tags here?

1. We use tags to identify and organize AWS resources. 
2. In this example, each.key dynamically assigns the environment name as the tag value, such as Dev, Test or Prod. 
3. This helps with resource identification, cost allocation and automation."

Remember:
- each.key → dev, test, prod.
- each.value → company-dev-bucket, company-test-bucket, company-prod-bucket.

# What does toset() do?

To convert a list into a set of unique values.

```bash
variable "bucket_names" {
  default = [
    "vamsi-dev-bucket-101",
    "vamsi-test-bucket-101",
    "vamsi-prod-bucket-101"
  ]
}

resource "aws_s3_bucket" "my_bucket" {
  for_each = toset(var.bucket_names)

  bucket = each.value
}
```