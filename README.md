# Terraform Templates For Managing Hashicorp Vault Config

## pre-requisites

* Install vault cli locally: https://www.vaultproject.io/downloads


## Demo

### Terraform
* Start vault dev server
```bash
make start_dev
```

* In another terminal, expose Vault Env Variables (you can use something like https://direnv.net/):
```bash

export VAULT_ADDR='http://127.0.0.1:8200'
export VAULT_TOKEN=root-token
```

* Initialize the project 
```bash
make init
```

>NOTE: the `make init` will also remove the default secret backend that is activate by default using vault in dev mode, but the secret backend will be managed via terraform. If you are not using the vault in dev mode you can simply run `terraform init`.


* Plan your changes
```bash
terraform plan
```

* Apply your change
```bash
terraform apply
```

* Navigate to Vault ui at http://127.0.0.1:8200/ (at first you can authenticate with the Vault Root Token `root-token` in the vault dev mode)

### Create test users

>NOTE: this step is just for demo purposes, for real use don't store passwords in git. 

```bash

export VAULT_ADDR='http://127.0.0.1:8200'
export VAULT_TOKEN=root-token
./tutorial/create_users.sh
```



## Project Structure


* `provider.tf` => vault provider using env variable for configuration


### Enable Secret backend

* `main.tf` => enable kv2 secret backend under `secret/`

* `secrets_kv_base.tf` => create a base secret structure (`secret/dev/`, `secret/acc/`, `secret/prod/`).

#### PKI 

* `pki.tf` => Create a RSA Root CA, with a role to generate servers certificates (with SAN restrictions), and a role for unrestricted client certificate.

* `ecpki.tf` => Create a EC Root CA, with a role to generate servers certificates (with SAN restrictions), and a role for unrestricted client certificate.


### Policies


#### Global policies

* `policies_global.tf` => create global policies
    * `global/backup` => allowing access to the raft backup endpoint
    * `global/automated-token-renew` => for renewing tokens via accessor
    * `global/prometheus-metric-readonly` => allow access to prometheus metrics
    * `global/user-management` => allow to create userpass credentials, entities, groups, and manage group membership
    * `global/user-selfservice-password-reset` => allow user to reset their own userpass credentials and activate MFA TOTP.
    * `global/vault-admin` => Vault admin policy 
    * `global/dev-team` => allow to issue certificates from the PKI backend, and have their own secret base `secret/dev-team/`.


* `policies_env.tf` => create policies for each env DEV, ACC, PROD (via `modules/policies/common`)
    * `[ENV]/readonly` => read only secrets under `secret/[ENV]/`
    * `[ENV]/admin` => all permission on secrets under `secret/[ENV]/`


### Auth Method

* `auth_backend.tf` => enable userpass auth backend
>NOTE: at the moment of writing the MFA configuration is not supported via terraform

### Groups 

Groups are used to map to a policies, so that group membership can be used to assign the corresponding policies to entities. 

* `groups_global.tf` => for global policies
    * `global/user-selfservice-password-reset` 
    * `global/vault-admin`
    * `global/dev-team` 


* `groups_env.tf` => for env policies
    * `[ENV]/readonly` 
    * `[ENV]/admin` 

### Identities entities, groups membership assignment

* `identities_all.tf` , `identities_group_assignment_env.tf`, `identities_group_assignment_global.tf` and `identities_userpass_alias.tf` are used in combination with variables defined in `variables.tf`: 

#### Variables

* Declare all vault entities, those will be member of `global/user-selfservice-password-reset`.  
```hcl
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

```

* Map userpass username to the corresponding entity
```hcl

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
```

##### Groups assignment

* Assign vault entity to the vault admin group
```hcl
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

```

>NOTE: see `variables.tf` for all groups assignment example.