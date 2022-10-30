

## Outputs MFA TOTP UUID
output "mfa_totp_uuid" {
  value = vault_generic_endpoint.mfa_totp.write_data["method_id"]
}




## Outputs transit key info
output "transit_rsa_min_available_version" {
  value = module.transit_rsa_key.key_min_available_version
}


## Outputs transit key info
output "transit_ecsa_min_available_version" {
  value = module.transit_ecdsa_key.key_min_available_version
}