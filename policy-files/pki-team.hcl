
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
