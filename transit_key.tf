# Enable transit secret engine
## https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/transit_secret_backend_key
resource "vault_mount" "transit" {
  path                      = "transit"
  type                      = "transit"
  default_lease_ttl_seconds = 3600
  max_lease_ttl_seconds     = 86400
}

module "demo_key" {
  source = "./modules/transit-key"

  transit_mount_path = vault_mount.transit.path
  key_name           = "demo"

  ## After key rotation, use those variables
  ## to disallowed using older keys
  # min_decryption_version = 2
  # min_encryption_version = 2
}




module "transit_rsa_key" {
  source = "./modules/transit-key"

  transit_mount_path = vault_mount.transit.path
  key_name           = "rsa"
  key_type           = "rsa-4096"

  ## After key rotation, use those variables
  ## to disallowed using older keys
  # min_decryption_version = 2
  # min_encryption_version = 2
}

module "transit_ecdsa_key" {
  source = "./modules/transit-key"

  transit_mount_path = vault_mount.transit.path
  key_name           = "ecdsa"
  key_type           = "ecdsa-p521"

  ## After key rotation, use those variables
  ## to disallowed using older keys
  # min_decryption_version = 2
  # min_encryption_version = 2
}

