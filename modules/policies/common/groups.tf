
/*** DEV ENV ***/
## https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_group
resource "vault_identity_group" "env_admin" {
  name                       = "${var.env}/admin"
  type                       = "internal"
  policies                   = ["${var.env}/admin"]
  external_member_entity_ids = true
}


## https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_group
resource "vault_identity_group" "env_readonly" {
  name                       = "${var.env}/readonly"
  type                       = "internal"
  policies                   = ["${var.env}/readonly"]
  external_member_entity_ids = true
}
