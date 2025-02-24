# codebuild
resource "aws_codebuild_project" "work-codebuild-project" {
  name = "work-codebuild-project"

  source {
    type     = "GITHUB"
    location = "https://github.com/KunalBhat55/Blogify.git"
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



# codedeploy
resource "aws_codedeploy_app" "work-codedeploy-app" {
  name             = "work-codedeploy-app"
  compute_platform = "Server"

}

resource "aws_codedeploy_deployment_group" "work-codedeploy-deployment-group" {

  app_name              = aws_codedeploy_app.work-codedeploy-app.name
  deployment_group_name = "work-codedeploy-deployment-group"
  service_role_arn      = var.codedeploy-role

  ec2_tag_set {
    ec2_tag_filter {
      key   = "Name"
      type  = "KEY_AND_VALUE"
      value = "Application"
    }
    ec2_tag_filter {
      key   = "Name"
      type  = "KEY_AND_VALUE"
      value = "manage-node"
    }

  }
  outdated_instances_strategy = "UPDATE"
}

# codepipeline
resource "aws_codepipeline" "work-codepipeline" {
  name     = "work-codepipeline"
  role_arn = var.codepipeline-role 

  artifact_store {
    location = "kunal-work-bucket"
    type     = "S3"
  }

  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"      
      output_artifacts = ["source_output"]
      

    }

  }


  
  stage {
    name = "Build"
    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
    }
  }
  stage {
    name = "Deploy"
    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "CodeDeploy"
      version         = "1"
      input_artifacts = ["build_output"]
      
    }
    
  }
}








