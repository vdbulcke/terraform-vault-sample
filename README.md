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
    * `global/pki-team` => allow to issue certificates from the PKI backend
    * `global/mfa-users` => group that can be used for an MFA enforcement.



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
    * `global/pki-team` 


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



### MFA

References: 

- https://learn.hashicorp.com/tutorials/vault/active-directory-mfa-login-totp

## Tutorial

### Transit  (Encryption as a Service)

* create token (or use generated file in `tutorial/` )
```bash
vault token create -policy=transit/demo/decrypt -policy=transit/demo/encrypt
```

* encrypt data
```bash
vault write transit/encrypt/demo plaintext=$(base64 <<< "hello world")
```
* decrypt data

```bash
vault write transit/decrypt/demo ciphertext=vault:v1:RlW+DVRaky3xX9M4ZlGc4pIVgrj1wJ7nkjDa3lVNMTHmmDoBHi2PBg==  -format=json | jq '.data.plaintext' -r | base64 -d 
```

* rotate keys (as admin)
```bash
vault write -f transit/keys/demo/rotate
```

#### Transit Software Security Module: JWT Signing

In this tutorial, we have generated 2 non exportable private key pairs inside vault transit backend, and we request transit to sign a JWT payload.

* Generate a signed (`RS256`) JWT with Transit RSA key
```bash
bash tutorial/transit-jwt-signing/rs256_jwt.sh
```
* Validated the signature via https://jwt.io (copy the JWT and the Public Key)

* Generate a signed (`ES512`) JWT with Transit EC P-521 DSA with SHA-512  key
```bash
bash tutorial/transit-jwt-signing/es512_jwt.sh
```
* Validated the signature via https://jwt.io (copy the JWT and the Public Key)


#### Using Transit In Mock OIDC Server

The tutorial in [tutorial/oidc-server-integration/README.md](./tutorial/oidc-server-integration/README.md) shows how Vault transit backend has been integrated with [oidc-server](https://github.com/vdbulcke/oidc-server-demo) Mock server. 

#### Importing Existing Private Key In Transit
The tutorial in [tutorial/transit-import-key/README.md](./tutorial/transit-import-key/README.md) shows how you can import existing private key into transit backend using [https://github.com/vdbulcke/hc-vault-util](https://github.com/vdbulcke/hc-vault-util).


#### Generating CSR From Transit Key

The tutorial in [tutorial/transit-gencsr/README.md](./tutorial/transit-gencsr/README.md)  shows how you can generate Certificate Signing Request from private key in transit backend using [hc-vault-util](https://github.com/vdbulcke/hc-vault-util).

### OIDC Token Generation 

* authenticate as "alice"
```bash
vault login -method=userpass username=alice 
```

* Generate an OIDC token for that user identity
```bash
vault read identity/oidc/token/role

Key          Value
---          -----
client_id    6a1wS2Td8Xk06yJ6oJJEFnnbOA
token        eyJhbGciOiJSUzI1NiIsImtpZCI6ImJjZTIwYjBjLWRjZTAtN2Q2Ny00MzBjLWZjYWZkMDQ2ZjI0MCJ9.eyJhdWQiOiI2YTF3UzJUZDhYazA2eUo2b0pKRUZubmJPQSIsImV4cCI6MTY2NjY4MTg5MywiaWF0IjoxNjY2NTk1NDkzLCJpc3MiOiJodHRwOi8vMTI3LjAuMC4xOjgyMDAvdjEvaWRlbnRpdHkvb2lkYyIsIm5hbWVzcGFjZSI6InJvb3QiLCJuYmYiOjE2NjY1OTU0OTMsInN1YiI6ImU0YzE0MjE2LTBhYTgtZDE1My1mMTVjLTVhYzQxOTZkNWFiZCIsInVzZXJpZCI6ImFsaWNlQGUtY29ycC5jb20iLCJ1c2VyaW5mbyI6eyJncm91cHMiOlsiZ2xvYmFsL3VzZXItc2VsZnNlcnZpY2UtcGFzc3dvcmQtcmVzZXQiLCJnbG9iYWwvdmF1bHQtYWRtaW4iXX19.ZTpcgkWb_2qppROF56TYw3FnFt9m4ycd5OmNdJ3ESztRAAc3MtFPx7AqHrFbWW_9kVCcvWzPddxYTj_P7OGWByYozQGWqRW7cN8kAbemBBHoQ35XMl7JJ37iI8FdHgJN8p8ZttukDfg67rK9bQRzjxDDdxx7CPWaeqq-bbGAD1pDCMd2-M1cMrHLzG-ddLMnAiY-_yar0yzcHoQzqoesJb2Unz85RAlVMuAUSP2UKmq1dCPAwuTqiRJWyJ1Lbeyn4mh6EESMaSUZyDcY9krI35nRIwp1YclXokRSO_eJD-LgL2DK3FzqcHdGTvG36dT0wQPn3PkDHruqj-A7YCuhZQ
ttl          24h


```

* you can decode with https://jwt.io/, and see the payload
```json
{
  "aud": "6a1wS2Td8Xk06yJ6oJJEFnnbOA",
  "exp": 1666681893,
  "iat": 1666595493,
  "iss": "http://127.0.0.1:8200/v1/identity/oidc",
  "namespace": "root",
  "nbf": 1666595493,
  "sub": "e4c14216-0aa8-d153-f15c-5ac4196d5abd",
  "userid": "alice@e-corp.com",
  "userinfo": {
    "groups": [
      "global/user-selfservice-password-reset",
      "global/vault-admin"
    ]
  }
}
```


* The JWT payload can be templated
```hcl
resource "vault_identity_oidc_role" "role" {
  name = "role"
  key  = vault_identity_oidc_key.key.name
  template = "{\"userinfo\": {\"groups\": {{identity.entity.groups.names}} },\"nbf\": {{time.now}},\"userid\": {{identity.entity.name}} }"
}

```

#### Reference:

- see inside [oidc.tf](./oidc.tf) for more details about configuration
- https://developer.hashicorp.com/vault/docs/secrets/identity/identity-token

### Token Management

For example you need to generate token for performing backup:

```
vault token create -period=10m -display-name=backup -policy=global/backup -no-default-policy -orphan
```

>**WARNING:** By default (without `-orphan`) tokens created with `vault token create` inherit the identity  policies of token creator (in our demo will be the vault-admin). In most cases, this is not the desired behavior. If you only want to create a token without inheriting policies from its parent you MUST pass the  `-orphan`.


#### Using Token Role

For example, we created a token role `dev-impersonation` that allows a Vault admin to create a token for another identity


* login as Vault admin 
```bash
vault login -method=userpass username=alice
```

* Create a token for `eve´ using this `dev-impersonation` role
```bash
vault token create   -role=dev-impersonation  -entity-alias=eve -ttl=12h

Key                  Value
---                  -----
token                hvs.CAESIADTP3owDRhe2Br5_s6cI_LR0XUF6KQuPEfPV7yrf5C6Gh4KHGh2cy43cng0YWR4NDlHWGU1eDIxMno0RWl5akk
token_accessor       6YNkERf1WmX9EOlcRYepTfXD
token_duration       12h
token_renewable      true
token_policies       ["global/automated-token-renew" "global/oidc-token"]
identity_policies    ["dev/admin" "global/user-selfservice-password-reset"]
policies             ["dev/admin" "global/automated-token-renew" "global/oidc-token" "global/user-selfservice-password-reset"]

```

* Lookup this token to confirm this is for eve

```bash
vault token lookup -accessor 6YNkERf1WmX9EOlcRYepTfXD

Key                            Value
---                            -----
accessor                       6YNkERf1WmX9EOlcRYepTfXD
creation_time                  1666596304
creation_ttl                   12h
display_name                   token
entity_id                      b78f9b1b-194c-a0b3-09e0-79ebd40ef80d
expire_time                    2022-10-24T21:25:04.097814809+02:00
explicit_max_ttl               0s
external_namespace_policies    map[]
id                             n/a
identity_policies              [dev/admin global/user-selfservice-password-reset]
issue_time                     2022-10-24T09:25:04.097820264+02:00
meta                           <nil>
num_uses                       0
orphan                         true
path                           auth/token/create/dev-impersonation
policies                       [global/automated-token-renew global/oidc-token]
renewable                      true
role                           dev-impersonation
ttl                            11h59m43s
type                           service

```

* Lookup this identity

```bash
vault write identity/lookup/entity id=b78f9b1b-194c-a0b3-09e0-79ebd40ef80d

Key                    Value
---                    -----
aliases                [map[canonical_id:b78f9b1b-194c-a0b3-09e0-79ebd40ef80d creation_time:2022-10-24T07:07:35.804094348Z custom_metadata:<nil> id:a7873666-5a06-dafa-4556-8e5c59c205d3 last_update_time:2022-10-24T07:07:35.804094348Z local:false merged_from_canonical_ids:<nil> metadata:<nil> mount_accessor:auth_token_f244c3bf mount_path:auth/token/ mount_type:token name:eve] map[canonical_id:b78f9b1b-194c-a0b3-09e0-79ebd40ef80d creation_time:2022-10-24T07:07:36.014257325Z custom_metadata:map[] id:fc1f5816-2f83-5623-2641-39fbec136938 last_update_time:2022-10-24T07:07:36.014257325Z local:false merged_from_canonical_ids:<nil> metadata:<nil> mount_accessor:auth_userpass_1fad22e9 mount_path:auth/userpass/ mount_type:userpass name:eve]]
creation_time          2022-10-24T07:07:35.687744425Z
direct_group_ids       [8d54ef54-bcd0-dca8-5d16-dfedfa86affb 524fc5b6-bbb6-203a-61ce-e586e3c5fdc1]
disabled               false
group_ids              [8d54ef54-bcd0-dca8-5d16-dfedfa86affb 524fc5b6-bbb6-203a-61ce-e586e3c5fdc1]
id                     b78f9b1b-194c-a0b3-09e0-79ebd40ef80d
inherited_group_ids    []
last_update_time       2022-10-24T07:07:35.687744425Z
merged_entity_ids      <nil>
metadata               <nil>
name                   eve@e-corp.com
namespace_id           root
policies               []

```


### Token Monitoring and Auto renew

See [https://github.com/vdbulcke/vault-token-monitor](https://github.com/vdbulcke/vault-token-monitor).


#### Reference

* Role configuration can be found in [token_role.tf](./token_role.tf) and link between token alias and entity in [identities_userpass_alias.tf](./identities_userpass_alias.tf)
* https://developer.hashicorp.com/vault/api-docs/secret/identity/lookup
* https://developer.hashicorp.com/vault/docs/concepts/tokens
* https://developer.hashicorp.com/vault/api-docs/auth/token#create-update-token-role
