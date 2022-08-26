
## https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_group
resource "vault_identity_group" "global_admin_user_management" {
  name                       = "global/admin-user-management"
  type                       = "internal"
  policies                   = ["global/user-management"]
  external_member_entity_ids = true
}

## https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_group
resource "vault_identity_group" "global_user_selfservice_password_reset" {
  name                       = "global/user-selfservice-password-reset"
  type                       = "internal"
  policies                   = ["global/user-selfservice-password-reset"]
  external_member_entity_ids = true
}

## https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_group
resource "vault_identity_group" "global_vault_admin" {
  name                       = "global/vault-admin"
  type                       = "internal"
  policies                   = ["global/vault-admin"]
  external_member_entity_ids = true
}


## https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_group
resource "vault_identity_group" "global_vault_pki_team" {
  name                       = "global/pki-team"
  type                       = "internal"
  policies                   = ["global/pki-team"]
  external_member_entity_ids = true
}


## https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_group
resource "vault_identity_group" "global_mfa" {
  name                       = "global/mfa-users"
  type                       = "internal"
  policies                   = []
  external_member_entity_ids = true
}
