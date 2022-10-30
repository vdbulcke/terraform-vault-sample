

## https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/transit_secret_backend_key
resource "vault_transit_secret_backend_key" "key" {
  backend = var.transit_mount_path
  name    = var.key_name

  ## options
  type                   = var.key_type
  min_decryption_version = var.min_decryption_version
  min_encryption_version = var.min_encryption_version
  auto_rotate_period     = var.auto_rotate_period
}




## https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy
resource "vault_policy" "transit_encrypt" {
  name   = "${var.transit_mount_path}/${var.key_name}/encrypt"
  policy = <<EOT
path "${var.transit_mount_path}/encrypt/${var.key_name}" {
   capabilities = [ "update" ]
}
EOT
}

## https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy
resource "vault_policy" "transit_decrypt" {
  name   = "${var.transit_mount_path}/${var.key_name}/decrypt"
  policy = <<EOT
path "${var.transit_mount_path}/decrypt/${var.key_name}" {
   capabilities = [ "update" ]
}
EOT
}


## https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy
resource "vault_policy" "transit_sign" {
  name   = "${var.transit_mount_path}/${var.key_name}/sign"
  policy = <<EOT
path "${var.transit_mount_path}/sign/${var.key_name}/*" {
   capabilities = [ "update" ]
}

## Ban deprecated sha1
path "${var.transit_mount_path}/sign/${var.key_name}/sha1" {
   capabilities = [ "deny" ]
}
EOT
}

## https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy
resource "vault_policy" "transit_verify" {
  name   = "${var.transit_mount_path}/${var.key_name}/verify"
  policy = <<EOT
path "${var.transit_mount_path}/verify/${var.key_name}/*" {
   capabilities = [ "update" ]
}

## Ban deprecated sha1
path "${var.transit_mount_path}/sign/${var.key_name}/sha1" {
   capabilities = [ "deny" ]
}
EOT
}


## https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy
resource "vault_policy" "transit_read" {
  name   = "${var.transit_mount_path}/${var.key_name}/read"
  policy = <<EOT
path "${var.transit_mount_path}/keys/${var.key_name}" {
   capabilities = [ "read" ]
}
EOT
}


## https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy
resource "vault_policy" "transit_update" {
  name   = "${var.transit_mount_path}/${var.key_name}/update"
  policy = <<EOT
path "${var.transit_mount_path}/keys/${var.key_name}" {
   capabilities = [ "update" ]
}
EOT
}


## https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy
resource "vault_policy" "transit_rotate" {
  name   = "${var.transit_mount_path}/${var.key_name}/rotate"
  policy = <<EOT
path "${var.transit_mount_path}/keys/${var.key_name}/rotate" {
   capabilities = [ "update" ]
}
EOT
}

## https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy
resource "vault_policy" "transit_trim" {
  name   = "${var.transit_mount_path}/${var.key_name}/trim"
  policy = <<EOT
path "${var.transit_mount_path}/keys/${var.key_name}/trim" {
   capabilities = [ "update" ]
}
EOT
}