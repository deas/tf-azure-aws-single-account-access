data "azuread_client_config" "current" {}

data "azuread_application_template" "azuread_aws_sso_template" {
  display_name = "AWS Single-Account Access"
}

// https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_from_template
resource "azuread_application_from_template" "azureas_aws_sso_application_from_template" {
  display_name = "AWS ${title(var.env)} ${title(var.account)} SSO"
  template_id  = data.azuread_application_template.azuread_aws_sso_template.template_id
}

data "azuread_application" "azuread_aws_sso_application" {
  object_id = azuread_application_from_template.azureas_aws_sso_application_from_template.application_object_id
}
