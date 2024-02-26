# variable "region" {
#   description = "AWS Region"
#   default     = "eu-west-2"
# }

variable "env" {
  description = "Environment that the AWS account is part of, Dev, Test, Prod and PreProd are some examples"
  default     = "Prod"
}

variable "account" {
  description = "The AWS Account you are working in. Can be a Internal Team Name, Client Name or any Name the is associated with the AWS account."
  type        = string
  default     = "account"
}
