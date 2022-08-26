
## MFA support via terraform is not yet supported
## see https://github.com/hashicorp/terraform-provider-vault/issues/1431

## We are using the generic_endpoint as a workaround
## https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/generic_endpoint
resource "vault_generic_endpoint" "mfa_totp" {
  depends_on           = []
  path                 = "identity/mfa/method/totp"
  ignore_absent_fields = true
  disable_read         = true
  write_fields         = ["method_id"]

  data_json = jsonencode({
    ## (Required) 
    issuer = "vault_dev"

    ## Otpional: 

    ### Suported alg: "SHA1", "SHA256" and "SHA512".
    ### NOTE google authentication uses sha1
    algorithm = "SHA1"

    ### either 6 or 8
    digits = 6

    ### Max failed attempts
    max_validation_attempts = 5
  })

}