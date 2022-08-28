

// create a secret v2 path
// https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/mount
resource "vault_mount" "kv2" {
  path = "secret"
  type = "kv-v2"
}



# Enable transit secret engine
## https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/transit_secret_backend_key
resource "vault_mount" "transit" {
  path                      = "transit"
  type                      = "transit"
  default_lease_ttl_seconds = 3600
  max_lease_ttl_seconds     = 86400
}
