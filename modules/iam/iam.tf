# Trust relationship
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    } 
  }
}

# Permissions policy
data "aws_iam_policy_document" "ec2_policy" {
  statement {
    actions   = ["s3:*"]
    resources = ["*"]
    effect    = "Allow"
  }
}

# IAM Role
resource "aws_iam_role" "ec2_role" {
  name               = "ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json # 
}

# Policy Resource (optional, creates a reusable policy)
resource "aws_iam_policy" "ec2_policy" {
  name        = "ec2-policy"
  description = "Policy to allow EC2 access to S3"
  policy      = data.aws_iam_policy_document.ec2_policy.json
}

# Attach the Policy to the Role
resource "aws_iam_role_policy_attachment" "ec2_policy_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_policy.arn
}

# Instance Profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-profile"
  role = aws_iam_role.ec2_role.name
}






output "ec2-profile" {
  value = aws_iam_instance_profile.ec2_profile.name
}