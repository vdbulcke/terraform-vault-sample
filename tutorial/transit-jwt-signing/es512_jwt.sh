#!/bin/bash

# JOSE header and JWT payload
HEADER='{"alg": "ES512","typ": "JWT"}'
PAYLOAD='{"sub": "1234567890","name": "John Doe"}'



# Prepare header and payload for signing
HEADER_B64=$(echo $HEADER | basenc --base64url | sed 's|=||g')
PAYLOAD_B64=$(echo $PAYLOAD | basenc --base64url  | sed 's|=||g')
MESSAGE=$(echo -n "$HEADER_B64.$PAYLOAD_B64" | openssl base64 -A)

# Sign the message using JWS marshaling type, and remove the vault key prefix
JWS=$(vault write -format=json transit/sign/ecdsa/sha2-512 input=$MESSAGE  marshaling_algorithm=jws | jq -r .data.signature | cut -d ":" -f3)

# Combine to build the JWT
JWT="$HEADER_B64.$PAYLOAD_B64.$JWS"
printf "\nJWT:\n"
echo $JWT

printf "\nPublic Key:\n"
vault read  transit/keys/ecdsa  -format=json | jq -r '.data.keys."1".public_key'

# You should be able to successfully decode the JWT on https://jwt.io