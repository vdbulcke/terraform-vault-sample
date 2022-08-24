
## 
## Create vault Users
##
## https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_entity
resource "vault_identity_entity" "vault_entities" {
  name     = each.key
  for_each = toset(var.vault_users)
}


