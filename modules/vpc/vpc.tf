# fetching the vpc
data "aws_vpc" "work-vpc" {
  tags = {
    "Name" = "Work-VPC"
  }
}

data "aws_subnet" "work-subnet" {
  tags = {
    "Name" = "Public-subnet-1"
  }
}







# Outputs
output "vpc-id" {
  value = data.aws_vpc.work-vpc.id
}
output "subnet-id" {
  value = data.aws_subnet.work-subnet.id
}
