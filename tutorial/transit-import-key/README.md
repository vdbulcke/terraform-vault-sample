# Importing Existing Private Key In Transit

## pre-requisite

- have the Vault Dev running with the applied terraform config
- Install `hc-vault-util` tool following [install instructions](https://vdbulcke.github.io/hc-vault-util/install/)


* export the standard Vault environment variables 

```bash
export VAULT_ADDR='http://127.0.0.1:8200'
export VAULT_TOKEN=root-token
```
## RSA key import example


* Generate a RSA Key
```bash
openssl genrsa 4096 > key.pem
```



* Import the key file as a "imported-rsa" transit key
```bash
$ hc-vault-util transit import --pkcs8-pem-key key.pem --transit-key imported-rsa

2022-10-31T16:50:13.834+0100 [INFO]   Importing key type: type=rsa-4096
2022-10-31T16:50:13.853+0100 [INFO]   Import successful: path=transit/keys/imported-rsa
```

* Read transit key to confirm import

```bash
$ vault read transit/keys/imported-rsa   

Key                            Value
---                            -----
allow_plaintext_backup         false
auto_rotate_period             0s
deletion_allowed               false
derived                        false
exportable                     false
imported_key                   true
imported_key_allow_rotation    false
keys                           map[1:map[creation_time:2022-10-31T16:50:13.852979012+01:00 name:rsa-4096 public_key:-----BEGIN PUBLIC KEY-----
MIICIjANBgkqhkiG9w0BAQEFAAOCAg8AMIICCgKCAgEA7a1SJyqTdmWVp2rIkItw
qb8LEijDqlkZlRoy13KxuzT9MUEYGQkKZzPRi6JiuuJ+O8PJtHIysnElq8RjLwj+
3AYNdPWls/GfA3GE/Jveze0yYEwuyh1rl/G7yibCzUIkLQmxhWk8Lae4HfBExGCn
3xGQpCNVU9wzCZ1lT1j6wYfF8gSBRcUzAYGCp29/jeBUWgBe9mLcyIkxfcmpg0yW
4Wv8en2K9Vn1F4XFp+RcKldG5Ljgq+69sqF4gG34tbtwSUtHtzCO/FjME+tytbn1
GaymK3/oKp8jkV8IOiybI1BX4yoeuVTT/ePvfJHwVbs6TTCEYAjSBUBSwGJmTPAj
LhYNnNrS7vU4kec5AvqjnP1YWiXrQHwGj4K/TiO+yWzGXddhnLvjswEAtiigvvrH
NCoMy6Rua9vBMC94YYCZwwg9ZTvlKnRQLMxhkAbm10TGNfs4tOI0sfZsUXc50tyI
Xa1Z+11c9DjqRU9/408JdmE4Ug0iU0KMITXvp784O3rvoHogQDrJr/caAp2I5KnA
2V1le+yrXvcyd1/UI7F07fPVz5YDXqCJknVxQxBJ1376lqDeZg1Y24yXUNMVNZjh
C9tIBHfuZ71rE5IwHxM0hEWItGlgWshNF4tRJbLdt2Deis8lz+RVd4ANxhi3q8oG
+fUZ97rM6ZRTCwBlUm8i1h8CAwEAAQ==
-----END PUBLIC KEY-----
]]
latest_version                 1
min_available_version          0
min_decryption_version         1
min_encryption_version         0
name                           imported-rsa
supports_decryption            true
supports_derivation            false
supports_encryption            true
supports_signing               true
type                           rsa-4096
```

## ECDSA Key import 

* Generate a ecdsa key
```bash
openssl ecparam -name secp384r1 -genkey -noout -out ecdsa.pem  
```

* Try importing generated key 

```bash
$ hc-vault-util transit import --pkcs8-pem-key ecdsa.pem --transit-key imported-ecdsa684 

2022-10-31T16:57:14.027+0100 [ERROR]  Error parsing PEM PKCS8 private key: error="x509: failed to parse private key (use ParseECPrivateKey instead for this key format)"
2022-10-31T16:57:14.027+0100 [WARN]   You can use openssl to convert your key into PKCS8 PEM format:

  openssl pkcs8 -topk8 -outform PEM -in key.pem -out key_pk8.pem -nocrypt 

2022-10-31T16:57:14.027+0100 [ERROR]  Error importing key: error="x509: failed to parse private key (use ParseECPrivateKey instead for this key format)"
```

>ERROR: the import will fail if the Key is not in the PEM PKCS8 format that Vault transit expects

* Format the private key to pkcs8 PEM 

```
openssl pkcs8 -topk8 -outform PEM -in ecdsa.pem -out key_pk8.pem -nocrypt
```

```bash
$ hc-vault-util transit import --pkcs8-pem-key key_pk8.pem --transit-key imported-ecdsa384

2022-10-31T17:00:45.938+0100 [INFO]   Importing key type: type=ecdsa-p384
2022-10-31T17:00:45.957+0100 [INFO]   Import successful: path=transit/keys/imported-ecdsa384
```

* Read imported key

```bash
$ vault read transit/keys/imported-ecdsa384

Key                            Value
---                            -----
allow_plaintext_backup         false
auto_rotate_period             0s
deletion_allowed               false
derived                        false
exportable                     false
imported_key                   true
imported_key_allow_rotation    false
keys                           map[1:map[creation_time:2022-10-31T17:00:45.952545797+01:00 name:P-384 public_key:-----BEGIN PUBLIC KEY-----
MHYwEAYHKoZIzj0CAQYFK4EEACIDYgAEBTHrTLFT6UQZEFWPUI/wwe8rP7yErqND
xQsG47nL/MPR6BcAUADY92afPO4TvGMxuQuyP4jk4onLlYGDnKdMhjThIKOGdH74
tacGnpbkCCtk8Qf4j8fvLv8a7GCFEgPc
-----END PUBLIC KEY-----
]]
latest_version                 1
min_available_version          0
min_decryption_version         1
min_encryption_version         0
name                           imported-ecdsa384
supports_decryption            false
supports_derivation            false
supports_encryption            false
supports_signing               true
type                           ecdsa-p384

```