# fetching the security group
data "aws_security_group" "work-sg" {
  name = var.sg_name
}

data "aws_ami" "amazon-linux" {
  most_recent = true
  owners      = ["amazon"]
  
}

resource "aws_instance" "web" {
  ami           = data.aws_ami.amazon-linux.id
  instance_type = var.instance_type
  tags = {
    Name = var.instance_name
  }
  vpc_security_group_ids = [data.aws_security_group.work-sg.id]

  provisioner "local-exec" {
    command = "echo ${aws_instance.web.public_ip} >> ip.txt"
  }
  associate_public_ip_address = true
  availability_zone           = "ap-south-1a"
  key_name                    = "kunal-work"
  subnet_id                   = var.subnet_id
  iam_instance_profile        = var.ec2_profile

}




# Outputs
output "instance_ip" {
  value = aws_instance.web.public_ip
}

output "security_grp" {
  value = data.aws_security_group.work-sg.id
}
