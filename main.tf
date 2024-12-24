module "ec2-module" {
  source = "./modules/ec2"
  subnet_id = module.vpc-module.subnet-id 
  ec2_profile = module.iam-module.ec2-profile
}

# module "s3-module" {
#   source = "./modules/s3"
# }

module "vpc-module" {
  source = "./modules/vpc"
}

module "iam-module" {
  source = "./modules/iam"
}

module "codebuild-module" {
  source = "./modules/developertools"
  codebuild-role = module.iam-module.codebuild-role
}

# module "rds-module" {
#   source = "./modules/rds"
# }









