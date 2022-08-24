

## Allow to list metadata under secret/
## so that UI displays the list of base secret
## User will not be allow to deeper that one level
path "secret/metadata" {
  capabilities = ["list"]
}

## allow recursive create/read-write on all
## sub path, and secret under secret/dev-team/

path "secret/data/dev-team/*" {
  capabilities = ["create", "update", "read"]
  
}

## allow recursive list on all metadata
## sub path under /dev-team/
path "secret/metadata/dev-team/*" {
  capabilities = ["list", "read", "create", "update", "delete"]
}



## PKI Secret Engine
# Work with pki secrets engine
path "pki/*" {
  capabilities = [ "read", "list"]
}

### Server certifiate
path "pki/issue/server-certificates" {
  capabilities = [ "create", "update", "read", "list"]
}

### Server certifiate
path "pki/issue/client-certificates" {
  capabilities = [ "create", "update", "read", "list"]
}

# Work with pki secrets engine
path "ecpki/*" {
  capabilities = [ "read", "list"]
}

### Server certifiate
path "ecpki/issue/ec-server-certificates" {
  capabilities = [ "create", "update", "read", "list"]
}

### Server certifiate
path "ecpki/issue/ec-client-certificates" {
  capabilities = [ "create", "update", "read", "list"]
}
