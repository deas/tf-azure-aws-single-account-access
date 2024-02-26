resource "time_sleep" "wait_60_seconds" {
  depends_on = [
    azuread_service_principal.azuread_service_principal,
    azuread_application_identifier_uri.azuread_aws_sso_application_uri,
    azuread_service_principal_token_signing_certificate.azuread_signing_certificate,
    azuread_service_principal_claims_mapping_policy_assignment.azuread_claims_mapping_policy_assignment,
    azuread_claims_mapping_policy.azuread_sso_policy,
    data.azuread_application.azuread_aws_sso_application
  ]
  create_duration = "60s"
}

data "http" "azure_metadata_xml" {
  depends_on = [time_sleep.wait_60_seconds]
  url        = "https://login.microsoftonline.com/${azuread_service_principal.azuread_service_principal.application_tenant_id}/federationmetadata/2007-06/federationmetadata.xml?appid=${azuread_service_principal.azuread_service_principal.application_id}"
}

# resource "vault_generic_secret" "metadata_sso_xml" {
#   depends_on = [data.http.azure_metadata_xml]
#   path       = "secret/aws/sso/${var.env}/${var.account}"
#   data_json  = <<EOT
# {
#   "metadata_xml":   "${base64encode(data.http.azure_metadata_xml.response_body)}"
# }
# EOT
#   lifecycle {
#     ignore_changes = [data_json]
#   }
# }

resource "aws_iam_saml_provider" "aws_saml_provider" {
  # depends_on = [vault_generic_secret.metadata_sso_xml]
  name                   = "aws_azure_sso_saml_provider"
  saml_metadata_document = base64encode(data.http.azure_metadata_xml.response_body)
  # saml_metadata_document = base64decode(vault_generic_secret.metadata_sso_xml.data["metadata_xml"])
  lifecycle {
    ignore_changes = [saml_metadata_document]
  }
}

//Read Only Policy
resource "aws_iam_role" "aws_read_only_group_policy" {
  depends_on           = [aws_iam_saml_provider.aws_saml_provider]
  name                 = "aws_read_only_role"
  max_session_duration = "43200"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : aws_iam_saml_provider.aws_saml_provider.arn
        },
        "Action" : "sts:AssumeRoleWithSAML",
        "Condition" : {
          "StringEquals" : {
            "SAML:aud" : "https://signin.aws.amazon.com/saml"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "aws_iam_policy_read_only_rights" {
  role       = aws_iam_role.aws_read_only_group_policy.name
  policy_arn = "arn:aws:iam::aws:policy/ReadOnlyAccess"
}

// Admin Policy
resource "aws_iam_role" "aws_admin_group_policy" {
  depends_on           = [aws_iam_saml_provider.aws_saml_provider]
  name                 = "aws_admin_role"
  max_session_duration = "43200"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Federated" : aws_iam_saml_provider.aws_saml_provider.arn
        },
        "Action" : "sts:AssumeRoleWithSAML",
        "Condition" : {
          "StringEquals" : {
            "SAML:aud" : "https://signin.aws.amazon.com/saml"
          }
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "aws_iam_policy_admin_rights" {
  role       = aws_iam_role.aws_admin_group_policy.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}