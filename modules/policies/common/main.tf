
## https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy
resource "vault_policy" "readonly" {
  name   = "${var.env}/readonly"
  policy = <<EOT
## Allow to list metadata under secret/
## so that UI displays the list of base secret
## User will not be allow to deeper that one level
path "secret/metadata" {
  capabilities = ["list", "read"]
}

path "secret/config" {
  capabilities = ["list", "read"]
}

path "secret/data/${var.env}" {
  capabilities = [ "list", "read"]
}

path "secret/metadata/${var.env}" {
  capabilities = ["list", "read"]
}
## allow recursive read on all
## sub path, and secret under secret/
path "secret/data/${var.env}/*" {
  capabilities = ["read"]
}

## allow recursive list on all metadata
## sub path under 
path "secret/metadata/${var.env}/*" {
  capabilities = ["list","read"]
}
EOT
}

## https://registry.terraform.io/providers/hashicorp/vault/latest/docs/resources/policy
resource "vault_policy" "admin" {
  name   = "${var.env}/admin"
  policy = <<EOT


## Allow to list metadata under secret/
## so that UI displays the list of base secret
## User will not be allow to deeper that one level
path "secret/metadata" {
  capabilities = ["list", "read"]
}

path "secret/config" {
  capabilities = ["list", "read"]
}

path "secret/data/${var.env}" {
  capabilities = [ "list", "read","create", "update", "delete"]
}

path "secret/metadata/${var.env}" {
  capabilities = ["list", "read"]
}


## allow recursive all actions on all
## sub path, 
path "secret/data/${var.env}/*" {
  capabilities = [ "list", "read","create", "update", "delete"]
  
  
}

## allow recursive all actions on all
## sub path, 
path "secret/${var.env}/*" {
  capabilities = [ "list", "read","create", "update", "delete"]
}

## allow recursive all actions on all metadata
## sub path under 
path "secret/metadata/${var.env}/*" {
  capabilities = ["list", "read", "create", "update", "delete"]
}

EOT
}
