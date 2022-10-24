
## https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy
resource "vault_policy" "backup_policy" {
  name   = "global/backup"
  policy = file("${path.module}/policy-files/backup.hcl")
}

## https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy
resource "vault_policy" "automated-token-renew" {
  name   = "global/automated-token-renew"
  policy = file("${path.module}/policy-files/automated-token-renew.hcl")
}

## https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy
resource "vault_policy" "prometheus-metric-readonly" {
  name   = "global/prometheus-metric-readonly"
  policy = file("${path.module}/policy-files/prometheus-metric-readonly.hcl")
}

## https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy
resource "vault_policy" "user-management" {
  name   = "global/user-management"
  policy = file("${path.module}/policy-files/user-management.hcl")
}

## https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy
resource "vault_policy" "user-selfservice-password-reset" {
  name   = "global/user-selfservice-password-reset"
  policy = <<EOT
##
## This policies allows to: 
##   * list auth backend
##   * list users in the userpass backend
##   * read your own userpass's user config
##   * update your own password
##


## Can list auth method
path "sys/auth" {
  capabilities = [ "read", "list" ]
}



## Need to be created after enabling userpass auth method
path "auth/userpass" {
  capabilities = [ "list" ]
}

path "auth/userpass/users" {
  capabilities = [ "list" ]
}



## Need to be created after enabling userpass auth method
## WARNING: Update userpass ID is new vault
path "auth/userpass/users/{{identity.entity.aliases.${vault_auth_backend.userpass.accessor}.name}}" {
  capabilities = [ "read", "update" ]
  allowed_parameters = {
    "password" = []
    "token_explicit_max_ttl" = []
    "token_max_ttl" = [] 
    "token_no_default_policy" = [  ]
    "token_num_uses"	= []
    "token_period" = []
    "token_ttl" = []
    "token_type" = [ ]
  }
}

## Allow user self-service MFA
path "identity/mfa/method/totp/admin-generate" {
  capabilities = [ "list", "read", "create", "update" ]
}

EOT

}


## https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy
resource "vault_policy" "vault-admin" {
  name   = "global/vault-admin"
  policy = file("${path.module}/policy-files/vault-admin.hcl")
}




## https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy
resource "vault_policy" "pki_team_policy" {
  name   = "global/pki-team"
  policy = file("${path.module}/policy-files/pki-team.hcl")
}


## https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy
resource "vault_policy" "oidc_token_create" {
  name   = "global/oidc-token"
  policy = <<EOT

## Allow user self-service MFA
path "identity/oidc/token/role" {
  capabilities = [  "read"]
}
EOT
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
