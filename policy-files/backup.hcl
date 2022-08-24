## Allow to take snaptshot for backups

path "/sys/storage/raft/snapshot" {
  capabilities = ["create", "read"]
}

path "/sys/storage/raft/configuration" {
  capabilities = ["read"]
}