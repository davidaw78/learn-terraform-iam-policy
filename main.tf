terraform {
 required_providers {
   aws = {
     source  = "hashicorp/aws"
     version = "~> 4.0"
   }
 }
}

provider "aws" {
 region = "us-east-1"
}

resource "aws_iam_user" "dev_user" {
  name = "dev-user"
}

resource "aws_iam_group" "dev_group" {
  name = "dev-group"
}

resource "aws_iam_user_group_membership" "dev_group_membership" {
  user = aws_iam_user.dev_user.name
  groups = [
    aws_iam_group.dev_group.name
  ]
}

resource "aws_iam_user_login_profile" "dev_user_login_profile" {
 user    = aws_iam_user.dev_user.name
# password               = "YourCustomPassword123"  # Set your custom password here
# pgp_key = "keybase:dev-user"
}

# testing staging branch
output "password" {
 value = aws_iam_user_login_profile.dev_user_login_profile.password
}

resource "aws_iam_policy" "policy" {
  name        = "test_policy"
  path        = "/"
  description = "My test policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.

  policy = <<EOF
{
 "Version": "2012-10-17",
 "Statement": [{
   "Effect": "Allow",
   "Action": [
     "ec2:Describe*"
   ],
   "Resource": "*"
 }]
}
 EOF
}
