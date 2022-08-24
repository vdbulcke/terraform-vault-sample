
/*** DEV ENV ***/
## https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_group
resource "vault_identity_group" "dev_admin" {
  name                       = "dev/admin"
  type                       = "internal"
  policies                   = ["dev/admin"]
  external_member_entity_ids = true
}


## https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_group
resource "vault_identity_group" "dev_readonly" {
  name                       = "dev/readonly"
  type                       = "internal"
  policies                   = ["dev/readonly"]
  external_member_entity_ids = true
}

/*** Acc ENV ***/
## https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_group
resource "vault_identity_group" "acc_admin" {
  name                       = "acc/admin"
  type                       = "internal"
  policies                   = ["acc/admin"]
  external_member_entity_ids = true
}


## https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_group
resource "vault_identity_group" "acc_readonly" {
  name                       = "acc/readonly"
  type                       = "internal"
  policies                   = ["acc/readonly"]
  external_member_entity_ids = true
}


/*** PROD ENV ***/
## https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_group
resource "vault_identity_group" "prod_admin" {
  name                       = "prod/admin"
  type                       = "internal"
  policies                   = ["prod/admin"]
  external_member_entity_ids = true
}


## https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_group
resource "vault_identity_group" "prod_readonly" {
  name                       = "prod/readonly"
  type                       = "internal"
  policies                   = ["prod/readonly"]
  external_member_entity_ids = true
}
