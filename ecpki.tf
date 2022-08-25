// Doc: https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/mount
resource "vault_mount" "ecpki" {
  path        = "ecpki"
  type        = "pki"
  description = "EC PKI mount"

  ## Default lease TTL  1 year
  default_lease_ttl_seconds = 31536000
  ## Max lease TTL 10 years
  max_lease_ttl_seconds = 315360000
}

// Doc: https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/pki_secret_backend_root_cert
resource "vault_pki_secret_backend_root_cert" "vault_ec_pki_ca" {
  depends_on  = [vault_mount.ecpki]
  backend     = vault_mount.ecpki.path
  type        = "internal"
  common_name = "Vault Lab EC Root CA"
  ## 10 Years (must be <= max_lease_ttl_seconds of mount pki)
  ttl    = "315360000"
  format = "pem"
  //   private_key_format    = "der"
  //  Supported Key Tye: 'rsa', 'ed25519' or 'ec'
  key_type             = "ec"
  key_bits             = 521
  exclude_cn_from_sans = true
  ou                   = "Lab"
  organization         = "Home"
}


// Doc: https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/pki_secret_backend_config_urls
resource "vault_pki_secret_backend_config_urls" "ec_config_urls" {
  backend                 = vault_mount.ecpki.path
  issuing_certificates    = ["https://iamvault.internal.e-corp.com/v1/ecpki/ca"]
  crl_distribution_points = ["https://iamvault.internal.e-corp.com/v1/ecpki/crl"]
  ## WARNING: Vault does NOT host its own OCSP Responder
  ##          This url thus point to a external OCSP responder server 
  ##          That you have to host your self (e.g. https://github.com/T-Systems-MMS/vault-ocsp)
  // ocsp_servers            = ["http://127.0.0.1:8200/v1/pki/ocsp"]
}


// Doc: https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/pki_secret_backend_crl_config
resource "vault_pki_secret_backend_crl_config" "ec_crl_config" {
  backend = vault_mount.ecpki.path
  expiry  = "72h"
  disable = false
}


// Doc: https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/pki_secret_backend_role
resource "vault_pki_secret_backend_role" "ec_server_role" {
  backend = vault_mount.ecpki.path
  name    = "ec-server-certificates"
  ## 1 Year 
  ttl = 31536000

  allow_ip_sans = true
  //  Supported Key Tye: 'rsa', 'ed25519' or 'ec'
  key_type = "ec"
  key_bits = 521

  ## SAN Restriction 
  allowed_domains = [
    "internal.e-corp.com",
    "kube.internal.e-corp.com"
  ]
  allow_subdomains = true
  allow_localhost  = true

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
resource "vault_pki_secret_backend_role" "ec_client_role" {
  backend = vault_mount.ecpki.path
  name    = "ec-client-certificates"
  ## 1 Year 
  ttl = 31536000

  allow_ip_sans = true
  //  Supported Key Tye: 'rsa', 'ed25519' or 'ec'
  key_type = "ec"
  key_bits = 521



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