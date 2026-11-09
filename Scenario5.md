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

  bucket = aws_s3_bucket.my_bucket[each.key].id

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

  bucket = aws_s3_bucket.my_bucket[each.key].id

  versioning_configuration {
    status = contains(["dev", "test", "prod"], each.key) ? "Enabled" : "Suspended"
  }
}
```
