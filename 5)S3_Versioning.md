# How do you enable versioning  for all the buckets?

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
}

resource "aws_s3_bucket_versioning" "my_bucket_versioning" {
  for_each = var.bucket_names

  bucket = aws_s3_bucket.my_bucket[each.key].id # [REMEMBER]

  versioning_configuration {
    status = "Enabled"
  }
}
```

# Now enable for 3 instances for disable for remaining 2 ?
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
}

resource "aws_s3_bucket_versioning" "my_bucket_versioning" {
  for_each = var.bucket_names

  bucket = aws_s3_bucket.my_bucket[each.key].id # [REMEMBER]

  versioning_configuration {
    status = contains(["dev", "test", "prod"], each.key) ? "Enabled" : "Suspended"
  }
}
```
# Ternary Operator

"We use a conditional or ternary operator in Terraform. It checks a condition and assigns one value if the condition is true and another value if it is false."

```bash
condition ? value_if_true : value_if_false
```


# Decode it bucket = aws_s3_bucket.my_bucket[each.key].id

| Code | Meaning |
|---|---|
| `bucket` | Argument of the versioning resource |
| `aws_s3_bucket` | Resource type |
| `my_bucket` | S3 resource name |
| `[each.key]` | Selects the matching S3 bucket using its key |
| `.id` | Retrieves the ID of the selected S3 bucket |

| Current key | Terraform evaluates |
|---|---|
| dev | `aws_s3_bucket.my_bucket["dev"].id` |
| test | `aws_s3_bucket.my_bucket["test"].id` |
| prod | `aws_s3_bucket.my_bucket["prod"].id` |
| backup | `aws_s3_bucket.my_bucket["backup"].id` |
| logs | `aws_s3_bucket.my_bucket["logs"].id` |
