
## 
## Dev Env 
##

### https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_group_member_entity_ids
resource "vault_identity_group_member_entity_ids" "vault_dev_env_admin" {
  exclusive         = false
  for_each          = toset(var.dev_admin_users)
  member_entity_ids = [vault_identity_entity.vault_entities[each.key].id]
  group_id          = module.env_policies["dev"].env_group_admin_id
}


### https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_group_member_entity_ids
resource "vault_identity_group_member_entity_ids" "vault_dev_env_readonly" {
  exclusive         = false
  for_each          = toset(var.dev_readonly_users)
  member_entity_ids = [vault_identity_entity.vault_entities[each.key].id]
  group_id          = module.env_policies["dev"].env_group_readonly_id
}


## 
## Acc Env 
##

### https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_group_member_entity_ids
resource "vault_identity_group_member_entity_ids" "vault_acc_env_admin" {
  exclusive         = false
  for_each          = toset(var.acc_admin_users)
  member_entity_ids = [vault_identity_entity.vault_entities[each.key].id]
  group_id          = module.env_policies["acc"].env_group_admin_id
}


### https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_group_member_entity_ids
resource "vault_identity_group_member_entity_ids" "vault_acc_env_readonly" {
  exclusive         = false
  for_each          = toset(var.acc_readonly_users)
  member_entity_ids = [vault_identity_entity.vault_entities[each.key].id]
  group_id          = module.env_policies["acc"].env_group_readonly_id
}


## 
## PROD Env 
##

### https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_group_member_entity_ids
resource "vault_identity_group_member_entity_ids" "vault_prod_env_admin" {
  exclusive         = false
  for_each          = toset(var.prod_admin_users)
  member_entity_ids = [vault_identity_entity.vault_entities[each.key].id]
  group_id          = module.env_policies["prod"].env_group_admin_id
}


### https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_group_member_entity_ids
resource "vault_identity_group_member_entity_ids" "vault_prod_env_readonly" {
  exclusive         = false
  for_each          = toset(var.prod_readonly_users)
  member_entity_ids = [vault_identity_entity.vault_entities[each.key].id]
  group_id          = module.env_policies["prod"].env_group_readonly_id
}
