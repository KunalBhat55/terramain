resource "aws_s3_bucket" "main-terraform-bucket" {
   
}








# Outputs
output "s3-bucket-name" {
  value = aws_s3_bucket.main-terraform-bucket.arn
}