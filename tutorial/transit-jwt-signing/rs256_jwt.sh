#!/bin/bash

## inspired by: https://groups.google.com/g/vault-tool/c/7kQ6a_1pVoQ

# JOSE header and JWT payload
HEADER='{"alg": "RS256","typ": "JWT"}'
PAYLOAD='{"sub": "1234567890","name": "John Doe"}'



# Prepare header and payload for signing
HEADER_B64=$(echo $HEADER | basenc --base64url | sed 's|=||g')
PAYLOAD_B64=$(echo $PAYLOAD |  basenc --base64url | sed 's|=||g')
MESSAGE=$(echo -n "$HEADER_B64.$PAYLOAD_B64" | openssl base64 -A )

echo "JWT Signing Payload: $MESSAGE"

# Sign the message using JWS marshaling type, and remove the vault key prefix
## MUST use pkcs1v15
JWS=$(vault write -format=json transit/sign/rsa/sha2-256  input=$MESSAGE  signature_algorithm=pkcs1v15 marshaling_algorithm=jws | jq -r .data.signature | cut -d ":" -f3)

# Combine to build the JWT
JWT="$HEADER_B64.$PAYLOAD_B64.$JWS"
printf "\nJWT:\n"
echo $JWT

#  print out the public key portion
printf "\nPublic Key:\n"
vault read  transit/keys/rsa -format=json | jq -r '.data.keys."1".public_key'


# You should be able to successfully decode the JWT on https://jwt.io