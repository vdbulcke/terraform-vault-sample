

## https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_entity_alias
resource "vault_identity_entity_alias" "userpass_alias" {
  for_each = var.vault_userpass_entity_aliases

  name           = each.value
  mount_accessor = vault_auth_backend.userpass.accessor
  canonical_id   = vault_identity_entity.vault_entities[each.key].id
}

data "vault_auth_backend" "token_auth_backend" {
  path = "token"
}
## https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_entity_alias
resource "vault_identity_entity_alias" "token_alias" {
  for_each = var.vault_userpass_entity_aliases

  name           = each.value
  mount_accessor = data.vault_auth_backend.token_auth_backend.accessor
  canonical_id   = vault_identity_entity.vault_entities[each.key].id
}