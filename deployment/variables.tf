variable "gcp_api_key" {
  type = string
  description = "users google cloud API key"
}

variable "aws_region" {
  default = "eu-west-2"
  description = "The default AWS region for deploying the app"
}

variable "aws_profile" {
  default = "donghead"
  description = "The profile to use for deployment, configured locally using aws configure"
}

variable "gql_port" {
  default     = 4000
  description = "The (development) port associated with the graphql API service"
}

variable "web_port" {
  default     = 3000
  description = "The (development) port associated with the web service"
}