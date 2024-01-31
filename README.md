# tf-azure-aws-single-account-access
Terraform code to manage the creation of AWS Single-Account access apps in Azure Enterprise Apps and EntraID


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.10 |
| <a name="requirement_awscc"></a> [awscc](#requirement\_awscc) | ~> 0.57.0 |
| <a name="requirement_azuread"></a> [azuread](#requirement\_azuread) | 2.44.0 |
| <a name="requirement_http"></a> [http](#requirement\_http) | 3.4.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.4.2 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | ~> 3.19.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.10 |
| <a name="provider_azuread"></a> [azuread](#provider\_azuread) | 2.44.0 |
| <a name="provider_http"></a> [http](#provider\_http) | 3.4.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.4.2 |
| <a name="provider_time"></a> [time](#provider\_time) | n/a |
| <a name="provider_vault"></a> [vault](#provider\_vault) | ~> 3.19.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_role.aws_admin_group_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.aws_read_only_group_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.aws_iam_policy_admin_rights](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.aws_iam_policy_read_only_rights](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_saml_provider.aws_saml_provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_saml_provider) | resource |
| [azuread_app_role_assignment.azuread_digitalis_admins](https://registry.terraform.io/providers/hashicorp/azuread/2.44.0/docs/resources/app_role_assignment) | resource |
| [azuread_app_role_assignment.azuread_read_only_user](https://registry.terraform.io/providers/hashicorp/azuread/2.44.0/docs/resources/app_role_assignment) | resource |
| [azuread_application_app_role.azuread_admin_aws_app_role](https://registry.terraform.io/providers/hashicorp/azuread/2.44.0/docs/resources/application_app_role) | resource |
| [azuread_application_app_role.azuread_aws_app_role](https://registry.terraform.io/providers/hashicorp/azuread/2.44.0/docs/resources/application_app_role) | resource |
| [azuread_application_from_template.azureas_aws_sso_application_from_template](https://registry.terraform.io/providers/hashicorp/azuread/2.44.0/docs/resources/application_from_template) | resource |
| [azuread_application_identifier_uri.azuread_aws_sso_application_uri](https://registry.terraform.io/providers/hashicorp/azuread/2.44.0/docs/resources/application_identifier_uri) | resource |
| [azuread_claims_mapping_policy.azuread_sso_policy](https://registry.terraform.io/providers/hashicorp/azuread/2.44.0/docs/resources/claims_mapping_policy) | resource |
| [azuread_service_principal.azuread_service_principal](https://registry.terraform.io/providers/hashicorp/azuread/2.44.0/docs/resources/service_principal) | resource |
| [azuread_service_principal_claims_mapping_policy_assignment.azuread_claims_mapping_policy_assignment](https://registry.terraform.io/providers/hashicorp/azuread/2.44.0/docs/resources/service_principal_claims_mapping_policy_assignment) | resource |
| [azuread_service_principal_token_signing_certificate.azuread_signing_certificate](https://registry.terraform.io/providers/hashicorp/azuread/2.44.0/docs/resources/service_principal_token_signing_certificate) | resource |
| [random_uuid.azuread_admin_app_role_id](https://registry.terraform.io/providers/hashicorp/random/3.4.2/docs/resources/uuid) | resource |
| [random_uuid.azuread_read_only_app_role_id](https://registry.terraform.io/providers/hashicorp/random/3.4.2/docs/resources/uuid) | resource |
| [time_sleep.wait_60_seconds](https://registry.terraform.io/providers/hashicorp/time/latest/docs/resources/sleep) | resource |
| [vault_generic_secret.metadata_sso_xml](https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/generic_secret) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [azuread_application.azuread_aws_sso_application](https://registry.terraform.io/providers/hashicorp/azuread/2.44.0/docs/data-sources/application) | data source |
| [azuread_application_template.azuread_aws_sso_template](https://registry.terraform.io/providers/hashicorp/azuread/2.44.0/docs/data-sources/application_template) | data source |
| [azuread_client_config.current](https://registry.terraform.io/providers/hashicorp/azuread/2.44.0/docs/data-sources/client_config) | data source |
| [azuread_group.azuread_admin_group](https://registry.terraform.io/providers/hashicorp/azuread/2.44.0/docs/data-sources/group) | data source |
| [azuread_group.azuread_read_only_group](https://registry.terraform.io/providers/hashicorp/azuread/2.44.0/docs/data-sources/group) | data source |
| [http_http.azure_metadata_xml](https://registry.terraform.io/providers/hashicorp/http/3.4.0/docs/data-sources/http) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_account"></a> [account](#input\_account) | The AWS Account you are working in. Can be a Internal Team Name, Client Name or any Name the is associated with the AWS account. | `string` | `"account"` | no |
| <a name="input_env"></a> [env](#input\_env) | Environment that the AWS account is part of, Dev, Test, Prod and PreProd are some examples | `string` | `"Dev"` | no |
| <a name="input_region"></a> [region](#input\_region) | AWS Region | `string` | `"eu-west-2"` | no |

## Outputs

No outputs.
