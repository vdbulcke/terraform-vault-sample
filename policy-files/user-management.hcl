##
## This polcies allows to 
##  * create user
##  * create user credentials
##  * assign user to group
##  * assign policies to group
##
## WARNING: this policies allows to 
##          to have vault-admin right 
##

# Configure auth methods
path "sys/auth" {
  capabilities = [ "read", "list" ]
}

# Configure auth methods
path "sys/auth/*" {
  capabilities = [ "update", "read",  "list", "sudo" ]
}

# Manage userpass auth methods
path "auth/userpass/*" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
}


# Display the Policies tab in UI
path "sys/policies" {
  // capabilities = [ "read", "list" ]
   capabilities = [ "list" ]
}

# Create and manage ACL policies from UI
path "sys/policies/acl/*" {
  capabilities = [  "list" ]
}

# Create and manage policies
path "sys/policies/acl" {
  capabilities = [  "list" ]
}

# Create and manage policies
path "sys/policies/acl/*" {
  capabilities = [ "list" ]
}

# List available secrets engines to retrieve accessor ID
path "sys/mounts" {
  capabilities = [ "read" ]
}

# Create and manage entities and groups
path "identity/*" {
  capabilities = [ "create", "read", "update", "delete", "list" ]
}


##
## fined grained policies
## 



# Manage userpass auth methods
path "auth/userpass/users/*" {
  capabilities = [ "create","update", "list", "read", "delete"]


  ## Cannot assigned policies to users uerspass
  denied_parameters = {
   token_policies = []
  }
  

}



# Create and manage entities and groups
path "identity/entity" {
  capabilities = [ "create", "read", "update", "delete", "list" ]

  ## Cannot assigned policies to users uerspass
  denied_parameters = {
    policies = []
  }
  
}

# Create and manage entities and groups
path "identity/entity/*" {
  capabilities = [ "create", "read", "update", "delete", "list" ]

  ## Cannot assigned policies to users uerspass
  denied_parameters = {
    policies = []
  }
  
}

# Create and manage entities and groups
path "identity/group" {
  capabilities = ["create",  "read", "update", "list" ]

}


# Create and manage entities and groups
path "identity/group/*" {
  capabilities = ["create",  "read", "update", "list" ]

}


