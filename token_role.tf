

## https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/token_auth_backend_role
resource "vault_token_auth_backend_role" "dev_impersonation" {
  role_name              = "dev-impersonation"
  allowed_policies       = ["global/oidc-token", "global/automated-token-renew"]
  disallowed_policies    = ["default"]
  allowed_entity_aliases = ["bob", "charlie", "david", "eve", "fred"]
  orphan                 = true
  # token_period           = "86400"
  renewable              = true
  token_explicit_max_ttl = "115200"
}


## https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/token_auth_backend_role
resource "vault_token_auth_backend_role" "transit_operator" {
  role_name = "transit-operator"
  allowed_policies = [
    "${vault_policy.transit_operator.name}",
    "${module.transit_rsa_key.policy_rotate}",
    "${module.transit_rsa_key.policy_trim}",
    "${module.transit_rsa_key.policy_read}",
    "${module.transit_rsa_key.policy_update}",
    "${module.transit_ecdsa_key.policy_rotate}",
    "${module.transit_ecdsa_key.policy_trim}",
    "${module.transit_ecdsa_key.policy_read}"
  ]
  disallowed_policies    = []
  allowed_entity_aliases = []
  orphan                 = true
  # token_period           = "86400"
  token_ttl              = "115200"
  renewable              = true
  token_explicit_max_ttl = "115200"
}

## https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/token_auth_backend_role
resource "vault_token_auth_backend_role" "transit_jwt_server" {
  role_name = "transit-jwt-server"
  allowed_policies = [
    "${module.transit_rsa_key.policy_sign}",
    "${module.transit_rsa_key.policy_verify}",
    "${module.transit_rsa_key.policy_read}",
    "${module.transit_ecdsa_key.policy_sign}",
    "${module.transit_ecdsa_key.policy_verify}",
    "${module.transit_ecdsa_key.policy_read}"
  ]
  disallowed_policies    = ["default"]
  allowed_entity_aliases = []
  orphan                 = true
  token_period           = "86400"
  renewable              = true
  # token_explicit_max_ttl = "115200"
}