

module "demo_key" {
  source = "./modules/transit-key"

  transit_mount_path = vault_mount.transit.path
  key_name           = "demo"

  ## After key rotation, use those variables
  ## to disallowed using older keys
  # min_decryption_version = 2
  # min_encryption_version = 2
}

## https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy
resource "vault_policy" "transit_admin" {
  name   = "${vault_mount.transit.path}/admin"
  policy = <<EOT

# Enable transit secrets engine
path "sys/mounts/${vault_mount.transit.path}" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
}

# To read enabled secrets engines
path "sys/mounts" {
  capabilities = [ "read" ]
}

# Manage the transit secrets engine
path "${vault_mount.transit.path}/*" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
}
EOT
}



