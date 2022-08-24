
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