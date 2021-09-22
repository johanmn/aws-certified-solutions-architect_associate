terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

# Create AWS IAM group
resource "aws_iam_group" "admingroup" {
    name = var.iam_group_name
}

# Create group policy
resource "aws_iam_policy" "adminpolicy" {
    name = var.policy_name
    description = var.policy_description
    policy = jsonencode({
      "Version": "2012-10-17",
      "Statement": [
         {
             "Effect": "Allow",
             "Action": "*",
             "Resource": "*"
         }
       ]
    })
}

# Attach policy to the group
resource "aws_iam_group_policy_attachment" "adminpolicyattachment" {
  group = aws_iam_group.admingroup.name
  policy_arn = aws_iam_policy.adminpolicy.arn
}

# Create AWS IAM user
resource "aws_iam_user" "adminuser" {
    name = var.iam_user_name
}

# Adding a user to a group
resource "aws_iam_user_group_membership" "adminmembership" {
  user = aws_iam_user.adminuser.name

  groups = [ aws_iam_group.admingroup.name ]
}

