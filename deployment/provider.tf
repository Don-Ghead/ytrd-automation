variable "aws_region" {
  default = "eu-west-2"
  description = "The default AWS region for deploying the app"
}

provider "aws" {
    region = var.aws_region
    profile = "donghead"
}