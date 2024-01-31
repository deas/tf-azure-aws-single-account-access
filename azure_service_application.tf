# // https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_app_role

//Read Only Random UUID
resource "random_uuid" "azuread_read_only_app_role_id" {
}

//Admin Random UUID
resource "random_uuid" "azuread_admin_app_role_id" {
}

// https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal
resource "azuread_service_principal" "azuread_service_principal" {
  account_enabled              = true
  app_role_assignment_required = true
  application_id               = data.azuread_application.azuread_aws_sso_application.application_id
  feature_tags {
    custom_single_sign_on = false
    enterprise            = true
    gallery               = false
    hide                  = false
  }
  notification_email_addresses  = local.notification_emails
  preferred_single_sign_on_mode = "saml"
  use_existing                  = true
}

// https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_identifier_uri
resource "azuread_application_identifier_uri" "azuread_aws_sso_application_uri" {
  depends_on     = [azuread_service_principal.azuread_service_principal]
  application_id = "/applications/${data.azuread_application.azuread_aws_sso_application.id}"
  identifier_uri = "https://signin.aws.amazon.com/saml#AWS_${title(var.env)}_${title(var.account)}_SSO"
}

// https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal_token_signing_certificate
resource "azuread_service_principal_token_signing_certificate" "azuread_signing_certificate" {
  service_principal_id = azuread_service_principal.azuread_service_principal.id
}

// https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/service_principal_claims_mapping_policy_assignment
resource "azuread_service_principal_claims_mapping_policy_assignment" "azuread_claims_mapping_policy_assignment" {
  claims_mapping_policy_id = azuread_claims_mapping_policy.azuread_sso_policy.id
  service_principal_id     = azuread_service_principal.azuread_service_principal.id
}

// https://registry.terraform.io/providers/hashicorp/azuread/2.44.1/docs/resources/claims_mapping_policy
resource "azuread_claims_mapping_policy" "azuread_sso_policy" {
  definition = [
    jsonencode(
      {
        "ClaimsMappingPolicy" : {
          "Version" : 1,
          "IncludeBasicClaimSet" : "true",
          "ClaimsSchema" : [
            {
              "Source" : "user",
              "ID" : "assignedroles",
              "SamlClaimType" : "https://aws.amazon.com/SAML/Attributes/Role"
            },
            {
              "Source" : "user",
              "ID" : "mail",
              "SamlClaimType" : "https://aws.amazon.com/SAML/Attributes/RoleSessionName"
            },
            {
              "Value" : "43200",
              "SamlClaimType" : "https://aws.amazon.com/SAML/Attributes/SessionDuration"
            }
          ]
        }

  }), ]
  display_name = "AWS ${title(var.env)} ${title(var.account)} SSO Policy"
}


# // Setup roles and users and groups to access the SSO Enterprise App
# // https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/resources/application_app_role

// Read Only Role
// ---------------------------------------------------------- //
resource "azuread_application_app_role" "azuread_aws_app_role" {
  depends_on = [
    aws_iam_saml_provider.aws_saml_provider,
    aws_iam_role.aws_read_only_group_policy
  ]
  display_name         = "https://aws.amazon.com/SAML/Attributes/Role"
  role_id              = random_uuid.azuread_read_only_app_role_id.id
  application_id       = "/applications/${data.azuread_application.azuread_aws_sso_application.id}"
  description          = "AWS Azure Read Only SSO"
  allowed_member_types = ["Application", "User", ]
  value                = "${aws_iam_role.aws_read_only_group_policy.arn},${aws_iam_saml_provider.aws_saml_provider.arn}"
}

//Get Read Only AWS User Group
// https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group
data "azuread_group" "azuread_read_only_group" {
  for_each     = toset(local.read_only_groups)
  display_name = each.key
}

//Assign Read Only Group
resource "azuread_app_role_assignment" "azuread_read_only_user" {
  for_each            = toset(local.read_only_groups)
  depends_on          = [aws_iam_saml_provider.aws_saml_provider]
  app_role_id         = azuread_application_app_role.azuread_aws_app_role.role_id
  principal_object_id = data.azuread_group.azuread_read_only_group[each.key].object_id
  resource_object_id  = azuread_service_principal.azuread_service_principal.object_id
}

// Admin Role
// ---------------------------------------------------------- //

resource "azuread_application_app_role" "azuread_admin_aws_app_role" {
  depends_on = [
    aws_iam_saml_provider.aws_saml_provider,
    aws_iam_role.aws_admin_group_policy
  ]
  display_name         = "https://aws.amazon.com/SAML/Attributes/Role"
  role_id              = random_uuid.azuread_admin_app_role_id.id
  application_id       = "/applications/${data.azuread_application.azuread_aws_sso_application.id}"
  description          = "AWS Azure Admin SSO"
  allowed_member_types = ["Application", "User", ]
  value                = "${aws_iam_role.aws_admin_group_policy.arn},${aws_iam_saml_provider.aws_saml_provider.arn}"
}

//Get Digitalis Admin User Group
// https://registry.terraform.io/providers/hashicorp/azuread/latest/docs/data-sources/group
data "azuread_group" "azuread_admin_group" {
  for_each     = toset(local.admin_groups)
  display_name = each.key
}

// Assign Digitalis Admin User Group
// https://registry.terraform.io/providers/hashicorp/azuread/2.44.1/docs/resources/app_role_assignment
resource "azuread_app_role_assignment" "azuread_digitalis_admins" {
  for_each     = toset(local.admin_groups)
  depends_on          = [aws_iam_saml_provider.aws_saml_provider]
  app_role_id         = azuread_application_app_role.azuread_admin_aws_app_role.role_id
  principal_object_id = data.azuread_group.azuread_admin_group[each.key].object_id
  resource_object_id  = azuread_service_principal.azuread_service_principal.object_id
}