##
## This policies allows to: 
##   * peform all admin operations on the vault UI
##
## WARNING: When mounting new path (e.g. creating new secret engine)
##          you will need to update this policies to allow operation 
##          on the new path
## 
##          If enable new 'kv/' secret backend add policie
##        
##          path "kv/*" {
##              capabilities = ["create", "read", "update", "delete", "list", "sudo"]
##          }
 



# Manage auth backends broadly across Vault
path "auth/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

## Allow creating orphan token
## https://developer.hashicorp.com/vault/docs/concepts/tokens#token-hierarchies-and-orphan-tokens
path "auth/token/create" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

path "auth/token/create-orphan" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Configure auth methods
path "sys/auth" {
  capabilities = [ "read", "list" ]
}

# List, create, update, and delete auth backends
path "sys/auth/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}


# Manage userpass auth methods
path "auth/userpass/*" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
}

# List existing policies
path "sys/policy" {
  capabilities = ["read"]
}

# Create and manage ACL policies broadly across Vault
path "sys/policy/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}


# Display the Policies tab in UI
path "sys/policies" {
  capabilities = [ "read", "list" ]
}

# Create and manage ACL policies from UI
path "sys/policies/acl/*" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
  
}

# Create and manage policies
path "sys/policies/acl" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
}

# Create and manage policies
path "sys/policies/acl/*" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
}


# List, create, update, and delete key/value secrets
path "secret/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Manage and manage secret backends broadly across Vault.
path "sys/mounts/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Read health checks
path "sys/health" {
  capabilities = ["read", "sudo"]
}


# Create and manage entities and groups
path "identity/*" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
}

# Manage everything in system leases
path "sys/leases*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

path "sys/leases/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Manage everything in system backend
path "sys/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

## 
## If enable new secret backend add 
## policies
##
## For example: 
## path "kv/*" {
##     capabilities = ["create", "read", "update", "delete", "list", "sudo"]
## }

## PKI Secret Engine
# Work with pki secrets engine
path "pki*" {
  capabilities = [ "create", "read", "update", "delete", "list", "sudo" ]
}


# Work with pki secrets engine
path "ecpki*" {
  capabilities = [ "create", "read", "update", "delete", "list", "sudo" ]
}