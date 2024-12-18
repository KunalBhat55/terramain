variable "instance_name" {
  type    = string
  default = "prod-web-server"
}

variable "sg_name" {
  type    = string
  default = "Work-SG"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "subnet_id" {
  type    = string
}

variable "ec2_profile" {
  type    = string
}