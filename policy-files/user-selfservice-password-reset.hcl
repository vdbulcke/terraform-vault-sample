##
## This policies allows to: 
##   * list auth backend
##   * list users in the userpass backend
##   * read your own userpass's user config
##   * update your own password
##


## Can list auth method
path "sys/auth" {
  capabilities = [ "read", "list" ]
}



## Need to be created after enabling userpass auth method
path "auth/userpass" {
  capabilities = [ "list" ]
}

path "auth/userpass/users" {
  capabilities = [ "list" ]
}



## Need to be created after enabling userpass auth method
## WARNING: Update userpass ID is new vault
path "auth/userpass/users/{{identity.entity.aliases.[REPPLACE BY AUTH BACKEND ACCESSOR].name}}" {
  capabilities = [ "read", "update" ]
  allowed_parameters = {
    "password" = []
    "token_explicit_max_ttl" = []
    "token_max_ttl" = [] 
    "token_no_default_policy" = [  ]
    "token_num_uses"	= []
    "token_period" = []
    "token_ttl" = []
    "token_type" = [ ]
  }
}
