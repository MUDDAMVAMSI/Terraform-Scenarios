# Explicit dependency:

Suppose an EC2 instance needs an IAM policy attachment to be completed before Terraform creates it.

```hcl
resource "aws_iam_role_policy_attachment" "attach_policy" {
  role       = aws_iam_role.my_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_instance" "my_ec2" {
  ami           = "ami-123456"
  instance_type = "t2.micro"

  depends_on = [
    aws_iam_role_policy_attachment.attach_policy
  ]
}
```

Here, depends_on explicitly tells Terraform to wait for the IAM policy attachment resource operation to complete before creating the EC2 instance.
