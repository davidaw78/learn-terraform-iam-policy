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

resource "aws_iam_group" "dev_group_policy" {
  name = "dev-group-policy"
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

#testing adding policy to a group
resource "aws_iam_group_policy" "dev_group_policy" {
  name  = "dev_group_policy"
  group = aws_iam_group.dev_group_policy.name

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "ec2:*",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "ec2:ResourceTag/Env": "dev"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": "ec2:Describe*",
            "Resource": "*"
        },
        {
            "Effect": "Deny",
            "Action": [
                "ec2:DeleteTags",
                "ec2:CreateTags"
            ],
            "Resource": "*"
        }
    ]
}
 EOF
}

# testing attaching to user 
resource "aws_iam_user_policy" "user_policy" {
  name        = "DevPolicy"
  user = aws_iam_user.dev_user.name
  
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "ec2:*",
            "Resource": "*",
            "Condition": {
                "StringEquals": {
                    "ec2:ResourceTag/Env": "dev"
                }
            }
        },
        {
            "Effect": "Allow",
            "Action": "ec2:Describe*",
            "Resource": "*"
        },
        {
            "Effect": "Deny",
            "Action": [
                "ec2:DeleteTags",
                "ec2:CreateTags"
            ],
            "Resource": "*"
        }
    ]
}
 EOF
}
