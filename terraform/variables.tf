variable "aws_region" {
  description = "The region of the AWS resources."
  default     = "us-east-2"
}

variable "s3_bucket_name" {
  description = "The name of the Amazon S3 bucket."
  default     = "michaelxmcbride-jenkins-ansible-terraform-example"
}
