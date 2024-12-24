# ec2 Trust relationship
data "aws_iam_policy_document" "ec2_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# codebuild Trust relationship
data "aws_iam_policy_document" "codebuild_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# codedeploy Trust relationship
data "aws_iam_policy_document" "codedeploy_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
  
}


# Permissions policy
data "aws_iam_policy_document" "ec2_policy_document" {
  statement {
    actions   = ["s3:*"]
    resources = ["*"]
    effect    = "Allow"
  }
}

data "aws_iam_policy_document" "codebuild_policy_document" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "ec2:CreateNetworkInterface",
      "ec2:DescribeDhcpOptions",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DeleteNetworkInterface",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeVpcs",
    ]

    resources = ["*"]
  }

}

data "aws_iam_policy_document" "codedeploy_policy_document" {
  statement {
    effect = "Allow"

    actions = [
      "s3:Get*",
      "s3:List*",
      "s3:Put*",
    ]

    resources = ["*"]
  }

  statement {
    effect = "Allow"

    actions = [
      "codedeploy:*",
    ]

    resources = ["*"]
  }
  
}

# IAM Role
resource "aws_iam_role" "ec2_role" {
  name               = "ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role.json
}

resource "aws_iam_role" "codebuild_role" {
  name               = "codebuild-role"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume_role.json
}

resource "aws_iam_role" "codedeploy_role" {
  name               = "codedeploy-role"
  assume_role_policy = data.aws_iam_policy_document.codedeploy_assume_role.json
}



# Policy Resource (optional, creates a reusable policy)
resource "aws_iam_policy" "ec2_policy" {
  name        = "ec2-policy"
  description = "Policy to allow EC2 access to S3"
  policy      = data.aws_iam_policy_document.ec2_policy_document.json
}

resource "aws_iam_policy" "codebuild_policy" {
  name        = "codebuild-policy"
  description = "Policy to allow CodeBuild"
  policy      = data.aws_iam_policy_document.codebuild_policy_document.json
  
}

resource "aws_iam_policy" "codedeploy_policy" {
  name        = "codedeploy-policy"
  description = "Policy to allow CodeDeploy"
  policy      = data.aws_iam_policy_document.codedeploy_policy_document.json  
  
}




# Attach the Policy to the Role
resource "aws_iam_role_policy_attachment" "ec2_policy_attachment" {

  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_policy.arn
}

resource "aws_iam_role_policy_attachment" "codebuild_policy_attachment" {

  role       = aws_iam_role.codebuild_role.name
  policy_arn = aws_iam_policy.codebuild_policy.arn
  
}

resource "aws_iam_role_policy_attachment" "codedeploy_policy_attachment" {

  role       = aws_iam_role.codedeploy_role.name
  policy_arn = aws_iam_policy.codedeploy_policy.arn
}


# Instance Profile
resource "aws_iam_instance_profile" "ec2_profile" {
  name = "ec2-profile"
  role = aws_iam_role.ec2_role.name
}









# Output
output "ec2-profile" {
  value = aws_iam_instance_profile.ec2_profile.name
}

output "codebuild-role" {
  value = aws_iam_role.codebuild_role.arn
}

output "codedeploy-role" {
  value = aws_iam_role.codedeploy_role.arn
}

