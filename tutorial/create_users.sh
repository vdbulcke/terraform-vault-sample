#!/bin/bash


echo "Generate default user/pass credentials"

## https://www.vaultproject.io/docs/auth/userpass
for u in alice bob charlie david  eve  fred; do 
    vault write auth/userpass/users/${u} password=foo 
done
