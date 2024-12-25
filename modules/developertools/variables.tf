variable "codebuild-role" {
  description = "The ARN of the IAM role that allows CodeBuild to interact with dependent AWS services on behalf of the AWS account."
  type = string
}

variable "codedeploy-role" {
  description = "The ARN of the IAM role that allows CodeDeploy to interact with dependent AWS services on behalf of the AWS account."
  type = string
}