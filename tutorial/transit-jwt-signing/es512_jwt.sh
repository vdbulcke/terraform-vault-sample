#!/bin/bash

set -e 
KEY=ecdsa
HASH=sha2-512



## Compute kid
VERSION=$(vault read -field latest_version transit/keys/${KEY})
KID="${KEY}:v:${VERSION}"


# JOSE header and JWT payload
HEADER="{\"alg\": \"ES512\",\"typ\": \"JWT\", \"kid\":\"$KID\"}"
PAYLOAD='{"sub": "1234567890","name": "John Doe"}'



# Prepare header and payload for signing
HEADER_B64=$(echo $HEADER | basenc --base64url | sed 's|=||g')
PAYLOAD_B64=$(echo $PAYLOAD | basenc --base64url  | sed 's|=||g')
MESSAGE=$(echo -n "$HEADER_B64.$PAYLOAD_B64" | openssl base64 -A)

# Sign the message using JWS marshaling type, and remove the vault key prefix
JWS=$(vault write -format=json transit/sign/${KEY}/${HASH} input=$MESSAGE  marshaling_algorithm=jws key_version=${VERSION}| jq -r .data.signature | cut -d ":" -f3)

# Combine to build the JWT
JWT="$HEADER_B64.$PAYLOAD_B64.$JWS"
printf "\nJWT:\n"
echo $JWT

printf "\nPublic Key:\n"
vault read  transit/keys/${KEY}  -format=json | jq -r '.data.keys."1".public_key'

# You should be able to successfully decode the JWT on https://jwt.io

echo "Verifying JWT sig with transit"

## get kid from jwt header
kid=$(echo $JWT | cut -d . -f 1 | basenc --base64url -d | jq -r .kid)
## get transit key name and version from kid
kName=$(echo $kid | cut -d ':' -f 1 )
kVersion=$(echo $kid | cut -d ':' -f 3 )

jwtHeader=$(echo $JWT | cut -d . -f 1)
jwtPayload=$(echo $JWT | cut -d . -f 2)
jwtSig=$(echo $JWT | cut -d . -f 3)


SIG="vault:v${kVersion}:${jwtSig}"
INPUT=$(echo -n "${jwtHeader}.${jwtPayload}" | openssl base64 -A)

echo "vault write  transit/verify/${KEY}/${HASH} input=$INPUT  signature=$SIG marshaling_algorithm=jws"
vault write  transit/verify/${KEY}/${HASH} input=$INPUT  signature=$SIG marshaling_algorithm=jws