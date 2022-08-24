
// https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/auth_backend
resource "vault_auth_backend" "userpass" {
  type = "userpass"
  tune {
    ## enough for good day of work
    default_lease_ttl = "10h"
  }

}
