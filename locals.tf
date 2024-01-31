locals {

  aws_tags = {
    Env        = var.env
    Repository = "https://github.com/digitalis-io/tf-azure-aws-single-account-access"
    Disposable = "false"
    Scalable   = "true"
    Region     = var.region
    Account    = var.account
  }

  read_only_groups = [
    "RO_Group_Display_Name_1",
    "RO_Group_Display_Name_2",
  ]

  admin_groups = [
    "ADMIN_Group_Display_Name_1",
    "ADMIN_Group_Display_Name_2",
  ]

  notification_emails = [
    "info@digitalis.io"
    ]

}