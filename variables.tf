##
## ALL Vault Users
##
### NOTE: you must declare all users
###       first in this list.
variable "vault_users" {
  description = "All vault users"
  type        = list(string)
  default = [
    "alice@e-corp.com",
    "bob@e-corp.com",
    "charlie@e-corp.com",
    "david@e-corp.com",
    "eve@e-corp.com",
    "fred@e-corp.com"
  ]
}


/**** userpass Entity Alias ****/
### the username/password will be created via the 
### vault UI, but the mapping of username to a vault 
### entity is managed via terraform
variable "vault_userpass_entity_aliases" {
  description = "Mapping of vault users (entities) to userpass username alias"
  type        = map(string)
  default = {
    "alice@e-corp.com"   = "alice"
    "bob@e-corp.com"     = "bob"
    "charlie@e-corp.com" = "charlie"
    "david@e-corp.com"   = "david"
    "eve@e-corp.com"     = "eve"
    "fred@e-corp.com"    = "fred"
  }
}



/**** Groups Assignment *****/

##
## Vault MFA Users
##
variable "vault_mfa_users" {
  description = "Vault mfa users"
  type        = list(string)
  default     = []
}

##
## Vault Admin Users
##
variable "vault_admin_users" {
  description = "Vault Admin users"
  type        = list(string)
  default = [
    "alice@e-corp.com"
  ]
}

##
## Dev Users
##
variable "pki_team_users" {
  description = "PKI Team users"
  type        = list(string)
  default = [
    "bob@e-corp.com",
    "charlie@e-corp.com",
    "david@e-corp.com"
  ]
}


/*** Env DEV ***/
##
## DEV Admin Users
##
variable "dev_admin_users" {
  description = "Dev Admin users"
  type        = list(string)
  default = [
    "bob@e-corp.com",
    "charlie@e-corp.com",
    "david@e-corp.com",
    "eve@e-corp.com"
  ]
}

##
## DEV Read Only All Users
##
variable "dev_readonly_users" {
  description = "DEV Readonly users"
  type        = list(string)
  default = [
    "fred@e-corp.com"
  ]
}


/*** Env Acc ***/
##
## Acc Admin Users
##
variable "acc_admin_users" {
  description = "Acc Admin users"
  type        = list(string)
  default = [
    "bob@e-corp.com",
    "david@e-corp.com"
  ]
}

##
## Acc Read Only All Users
##
variable "acc_readonly_users" {
  description = "Acc Readonly users"
  type        = list(string)
  default = [
    "charlie@e-corp.com",
    "fred@e-corp.com"
  ]
}

/*** Env PROD ***/
##
## Prod Admin Users
##
variable "prod_admin_users" {
  description = "Prod Admin users"
  type        = list(string)
  default = [
    "bob@e-corp.com"
  ]
}

##
## Prod Read Only All Users
##
variable "prod_readonly_users" {
  description = "Prod Readonly users"
  type        = list(string)
  default = [
    "david@e-corp.com",
    "fred@e-corp.com"
  ]
}

