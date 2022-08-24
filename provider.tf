provider "vault" {
  #address - VAULT_ADDR
  #token - VAULT_TOKEN 
  #max_lease_ttl_seconds - TERRAFORM_VAULT_MAX_TTL
}

terraform {
  required_providers {
    vault = {
      source  = "vault"
      version = "~> 3.7.0"
    }
  }
}