

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