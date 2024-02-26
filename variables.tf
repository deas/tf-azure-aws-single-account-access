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

variable "read_only_groups" {
  type = list(string)
  default = [
    "RO_Group_Display_Name_1",
    #"RO_Group_Display_Name_2",
  ]
}


variable "admin_groups" {
  default = [
    "ADMIN_Group_Display_Name_1",
    #"ADMIN_Group_Display_Name_2",
  ]
  type = list(string)
}

variable "notification_emails" {
  default = [
    "info@digitalis.io"
  ]
}
