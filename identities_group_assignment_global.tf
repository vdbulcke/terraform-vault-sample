
## 
## Self Service Password Reset
##
## Assign all vault user to self service password reset
### https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_group_member_entity_ids
resource "vault_identity_group_member_entity_ids" "global_user_selfservice_password_reset_members" {
  exclusive         = false
  for_each          = toset(var.vault_users)
  member_entity_ids = [vault_identity_entity.vault_entities[each.key].id]
  group_id          = vault_identity_group.global_user_selfservice_password_reset.id
}


## 
## Vault Admin Users
##
### https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_group_member_entity_ids
resource "vault_identity_group_member_entity_ids" "vault_admin_members" {
  exclusive         = false
  for_each          = toset(var.vault_admin_users)
  member_entity_ids = [vault_identity_entity.vault_entities[each.key].id]
  group_id          = vault_identity_group.global_vault_admin.id
}


## 
## Vault Dev Team Users
##
### https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_group_member_entity_ids
resource "vault_identity_group_member_entity_ids" "vault_pki_team_members" {
  exclusive         = false
  for_each          = toset(var.pki_team_users)
  member_entity_ids = [vault_identity_entity.vault_entities[each.key].id]
  group_id          = vault_identity_group.global_vault_pki_team.id
}




## 
## Vault MFA Users
##
### https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_group_member_entity_ids
resource "vault_identity_group_member_entity_ids" "vault_mfa_members" {
  exclusive         = false
  for_each          = toset(var.vault_mfa_users)
  member_entity_ids = [vault_identity_entity.vault_entities[each.key].id]
  group_id          = vault_identity_group.global_mfa.id
}
