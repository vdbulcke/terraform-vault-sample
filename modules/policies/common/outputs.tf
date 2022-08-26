

output "env_group_admin_id" {
  value       = vault_identity_group.env_admin.id
  description = "The group ID of read/write create/delete policy"
}

output "env_group_readonly_id" {
  value       = vault_identity_group.env_readonly.id
  description = "The group ID of readonly policy"
}
