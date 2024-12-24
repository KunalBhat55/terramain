resource "aws_codebuild_project" "work-codebuild-project" {
  name = "work-codebuild-project"
  source {
    type            = "GITHUB"
    location        = "https://github.com/KunalBhat55/Blogify.git"
    git_clone_depth = 1 # how many commits to clone
  }
  service_role = var.codebuild-role

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:5.0"
    type         = "LINUX_CONTAINER"

  }



  artifacts {
    type      = "S3"
    packaging = "ZIP"
    location  = "kunal-work-bucket"
  }
  build_timeout = "8" # in minutes






  logs_config {
    cloudwatch_logs {
      group_name  = "/aws/codebuild/work-codebuild-project"
      stream_name = "build"
    }
  }

}
