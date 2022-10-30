

output "key_name" {
  description = "The transit key name"
  value = "${var.key_name}"
}

output "key_min_available_version" {
  description = "The transit key min_available_version "
  value = "${vault_transit_secret_backend_key.key.min_available_version}"
}

output "policy_encrypt" {
  value = "${vault_policy.transit_encrypt.name}"
}

output "policy_decrypt" {
  value = "${vault_policy.transit_decrypt.name}"
}


output "policy_sign" {
  value = "${vault_policy.transit_sign.name}"
}


output "policy_verify" {
  value = "${vault_policy.transit_verify.name}"
}


output "policy_read" {
  value = "${vault_policy.transit_read.name}"
}



output "policy_update" {
  value = "${vault_policy.transit_update.name}"
}

output "policy_rotate" {
  value = "${vault_policy.transit_rotate.name}"
}

output "policy_trim" {
  value = "${vault_policy.transit_trim.name}"
}
