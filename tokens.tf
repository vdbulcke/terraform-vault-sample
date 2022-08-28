

## https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/token
resource "vault_token" "transit_demo" {
  display_name = "transit_demo"

  policies = ["transit/demo/decrypt", "transit/demo/encrypt" ]
}


## https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/token
resource "local_file" "transit_demo_token_file" {
    content  = "export VAULT_TOKEN=${vault_token.transit_demo.client_token} \nexport VAULT_ADDR='http://127.0.0.1:8200'"
    filename = "${path.module}/tutorial/.envrc"
}