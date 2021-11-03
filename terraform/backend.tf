terraform {
  backend "s3" {
    bucket = "michaelxmcbride-jenkins-ansible-terraform-example-backend"
    key    = "terraform.tfstate"
    region = "us-east-2"
  }
}
