

// create a secret v2 path
// https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/mount
resource "vault_mount" "kv2" {
  path = "secret"
  type = "kv-v2"
}



