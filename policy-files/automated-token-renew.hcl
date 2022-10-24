
## Allow tokens to look up their own properties
## for vault cli login
path "auth/token/lookup-self" {
    capabilities = ["read"]
}


## Allow list of accessors token
path "/auth/token/accessors" {
  capabilities = [ "read", "list"]
}

## Allow accessor tokens lookup 
path "/auth/token/lookup-accessor" {
  capabilities = [ "read", "update"]
}


## Allow renew of accessors token 

path "/auth/token/renew-accessor" {
  capabilities = [ "read", "update"]
}