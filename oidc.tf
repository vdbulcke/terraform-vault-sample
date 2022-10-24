
# https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_oidc_client
resource "vault_identity_oidc_client" "demo" {
  name        = "demo"
  client_type = "public"


  redirect_uris = [
    "http://127.0.0.1:5556/auth/callback"
  ]


  assignments = [
    "allow_all"
  ]



  id_token_ttl     = 2400
  access_token_ttl = 7200
}

## https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/identity_oidc_key
resource "vault_identity_oidc_key" "key" {
  name      = "key"
  algorithm = "RS256"
}

resource "vault_identity_oidc_role" "role" {
  name = "role"
  key  = vault_identity_oidc_key.key.name
  template = "{\"userinfo\": {\"groups\": {{identity.entity.groups.names}} },\"nbf\": {{time.now}},\"userid\": {{identity.entity.name}} }"
}

resource "vault_identity_oidc_key_allowed_client_id" "role" {
  key_name          = vault_identity_oidc_key.key.name
  allowed_client_id = vault_identity_oidc_role.role.client_id
}