

## https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/kv_secret_v2
resource "vault_kv_secret_v2" "secret_base" {
  for_each = toset(["dev", "acc", "prod"])

  mount = vault_mount.kv2.path
  name  = "${each.key}/test"
  data_json = jsonencode(
    {
      foo = "bar"
    }
  )
}