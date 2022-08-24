// Doc: https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/mount
resource "vault_mount" "pki" {
  path        = "pki"
  type        = "pki"
  description = "PKI mount"

  ## Default lease TTL  1 year
  default_lease_ttl_seconds = 31536000
  ## Max lease TTL 10 years
  max_lease_ttl_seconds = 315360000
}

// Doc: https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/pki_secret_backend_root_cert
resource "vault_pki_secret_backend_root_cert" "vault_pki_ca" {
  depends_on  = [vault_mount.pki]
  backend     = vault_mount.pki.path
  type        = "internal"
  common_name = "Vault Lab Root CA"
  ## 10 Years (must be <= max_lease_ttl_seconds of mount pki)
  ttl    = "315360000"
  format = "pem"
  //   private_key_format    = "der"
  key_type             = "rsa"
  key_bits             = 4096
  exclude_cn_from_sans = true
  ou                   = "Lab"
  organization         = "Home"
}


// Doc: https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/pki_secret_backend_config_urls
resource "vault_pki_secret_backend_config_urls" "config_urls" {
  backend                 = vault_mount.pki.path
  issuing_certificates    = ["https://vault.home.lab/v1/pki/ca"]
  crl_distribution_points = ["https://vault.home.lab/v1/pki/crl"]
  ## WARNING: Vault does NOT host its own OCSP Responder
  ##          This url thus point to a external OCSP responder server 
  ##          That you have to host your self (e.g. https://github.com/T-Systems-MMS/vault-ocsp)
  // ocsp_servers            = ["http://127.0.0.1:8200/v1/pki/ocsp"]
}


// Doc: https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/pki_secret_backend_crl_config
resource "vault_pki_secret_backend_crl_config" "crl_config" {
  backend = vault_mount.pki.path
  expiry  = "72h"
  disable = false
}


// Doc: https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/pki_secret_backend_role
resource "vault_pki_secret_backend_role" "server_role" {
  backend = vault_mount.pki.path
  name    = "server-certificates"
  ## 1 Year 
  ttl = 31536000

  allow_ip_sans = true
  key_type      = "rsa"
  key_bits      = 4096

  ## SAN Restriction 
  allowed_domains = [
    "home.lab",
    "kube.home.lab"
  ]
  allow_subdomains = true
  allow_localhost  = true

  allow_glob_domains = true

  ## CN restriction
  allow_any_name    = true
  enforce_hostnames = true

  ## Key USage
  server_flag = true
  client_flag = true
  key_usage = [
    "DigitalSignature",
    "KeyAgreement",
    "KeyEncipherment"
  ]



  ## generate Not Before 
  not_before_duration = "30s"

}


// Doc: https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/pki_secret_backend_role
resource "vault_pki_secret_backend_role" "server_any_role" {
  backend = vault_mount.pki.path
  name    = "server-any-certificates"
  ## 1 Year 
  ttl = 31536000

  allow_ip_sans = true
  key_type      = "rsa"
  key_bits      = 4096

  ## SAN Restriction 

  allow_subdomains = true
  allow_localhost  = true

  allow_glob_domains = true

  ## CN restriction
  allow_any_name    = true
  enforce_hostnames = false

  ## Key USage
  server_flag = true
  client_flag = true
  key_usage = [
    "DigitalSignature",
    "KeyAgreement",
    "KeyEncipherment"
  ]



  ## generate Not Before 
  not_before_duration = "30s"

}

// Doc: https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/pki_secret_backend_role
resource "vault_pki_secret_backend_role" "client_role" {
  backend = vault_mount.pki.path
  name    = "client-certificates"
  ## 1 Year 
  ttl = 31536000

  allow_ip_sans = true
  key_type      = "rsa"
  key_bits      = 4096



  ## CN restriction
  allow_any_name    = true
  enforce_hostnames = false

  ## Key USage
  server_flag = true
  client_flag = true
  key_usage = [
    "DigitalSignature",
    "KeyAgreement",
    "KeyEncipherment"
  ]

  ## generate Not Before 
  not_before_duration = "30s"

}