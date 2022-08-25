

## Outputs MFA TOTP UUID
output "mfa_totp_uuid" {
  value = vault_generic_endpoint.mfa_totp.write_data["method_id"]
}