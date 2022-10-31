# Generate A Certificate Signing Request From A Transit Key

## pre-requisite

- have the Vault Dev running with the applied terraform config
- Install `hc-vault-util` tool following [install instructions](https://vdbulcke.github.io/hc-vault-util/install/)


* export the standard Vault environment variables 

```bash
export VAULT_ADDR='http://127.0.0.1:8200'
export VAULT_TOKEN=root-token
```

## Create the CSR JSON configuration file

* Create a csr.json file following the Cloudflare [cfssl json csr format](https://github.com/cloudflare/cfssl#signing). 

```bash
$ cat >csr.json<<EOF
{
    "CN": "Foo",
    "hosts": [
        "cloudflare.com",
        "www.cloudflare.com"
    ],
    "names": [
        {
            "C": "US",
            "L": "San Francisco",
            "O": "CloudFlare",
            "OU": "Systems Engineering",
            "ST": "California"
        }
    ]
}
EOF

```

### RSA CSR
* Generate a CSR using `rsa` transit key 

```bash
$ hc-vault-util transit gencsr --csr-json csr.json --transit-key rsa  

2022-10-31T17:12:38.734+0100 [INFO]   PEM encoded CSR
-----BEGIN CERTIFICATE REQUEST-----
MIIFADCCAugCAQAwezELMAkGA1UEBhMCVVMxEzARBgNVBAgTCkNhbGlmb3JuaWEx
FjAUBgNVBAcTDVNhbiBGcmFuY2lzY28xEzARBgNVBAoTCkNsb3VkRmxhcmUxHDAa
BgNVBAsTE1N5c3RlbXMgRW5naW5lZXJpbmcxDDAKBgNVBAMTA0ZvbzCCAiIwDQYJ
KoZIhvcNAQEBBQADggIPADCCAgoCggIBAPJ1yYOxtujhE++5Fe+7V/1iLegVtH5u
FNnKmywklZTytlp8FhTnfEADDLOuOloNdBBD/XODXJxlD1nw9D3umNMrjsjnMvvg
YByT7ltUo1DfY9Ww3oMGDBy/MnQHak8XTIsUvMgdX/ENlYZl4WqPBaqk+wcohqGx
2U1o4xjc8NMyU3ZzCQk7noEDidm/G7Q5WVlKgrpQxuo7k2CfZynQSB4pQwkD9f26
65SzrSmuNYMoB6X9uXrIZK8OK8j3APSuRXAk4XQ0UGtxIaZJpC37/azvwEhj95WD
jPjJRyDvuhoaIEZTgl8wYmRXTcLDC8YNzc9SCg/yeopQF02grvAGvmK+WD3Qyyqf
BnHu21KiPcRAKOHx7GPgxlf6PynZnOCAKpzXxg9kcp5yIFlbp00Zxhdg2GsQHBlu
2I0rBOIKegwRAE7jPIV/pEBloaWqxwQSrx+l4iRdyOEdptrL+hrkAr4YCROffkk6
A8NOzCJD3QeqRyhAR0Nz0jPotO5XvahJpIb7bCvvNCXiHhOckmO+XWDyqNZCQzrG
daOaoC02z0UyArPFeMAF0EzBFlHBX4uW7OWmntGPsbYxgXkuEx6q5EKzzpd5w3T6
HFx/cG9WKQ9L2aHIgsMpAFhi3LLVHwPx9QKwFhoEezguNKlhsGlQ9jkbMKYzsFEm
PqkNmW2pYwjzAgMBAAGgQDA+BgkqhkiG9w0BCQ4xMTAvMC0GA1UdEQQmMCSCDmNs
b3VkZmxhcmUuY29tghJ3d3cuY2xvdWRmbGFyZS5jb20wDQYJKoZIhvcNAQENBQAD
ggIBAGlbty2PrXwKmw9tOLJTnZzhA18PLC5lV2jPUjs8vlxeSB8usdnhgPCsbOTa
rdzhto2TfN+/ufFvmrf+yUTkC9J8Vv/NblfvlKKb+VCKxwtQ9wl5/w7Ck9VFnnFn
q67vglCkiE0O9qBLNGiUUUXvL5EjOSaAZIjrJIjCZLS3f5NOkaFI6AiTkFOIQMR5
hRJGQgkwacZ6S6rEcN8SZF9MvZ5EZFfsfAH/0UUGctrNtgnVhRdXJYmAHii4Q5+A
qLeNxjRH/1D5XU3DdZrYhpnaTOfew40fRLtw95jfpG3DZfNFUVnn36LPce8c+FL9
n6Fx4BN+mWpA0Ju9Wuav/uZihVnn29VVCt+r1yabcgfTC2bu8dVB5QaETnVwLSSD
nBjgFeQkrCjxpoTM0MowCoRGgWP3WBURVFeIiyIqe6AaB7220eoOtC8VdfGcONtW
nJCuAQVWxI+ZLX9rPBN2QR4FK+LDkky67We7I1wG5uokHunKk7SAn3Uw/iluXXmG
vThmNYi1Ihmw3JrJSHDkU9mZhAonx4Hg9zy4mVFdSPkEeBfrTXbT8mW6Cjh7Ujdm
p5+FXKjRnYGzT6wVYC7ThfuxbS3v96SucT4JFwg5i8NllFnRKT8P8aXilbPUIZOW
PYtBX4l6tbp04Hi4d/wbgnMa/N9e1UubgyynFH5DTkHCtJgh
-----END CERTIFICATE REQUEST-----

```

* For example write the generated CSR into `csr.pem ` file

* Generate a Certificate from that csr using Vault pki backend
```bash
vault write pki/sign/server-any-certificates csr=@csr.pem 
```



### ECDSA CSR

* Using the same `csr.json` generate the csr from the `ecdsa` key
```bash
$ hc-vault-util transit gencsr --csr-json csr.json --transit-key ecdsa

2022-10-31T17:13:17.675+0100 [INFO]   PEM encoded CSR
-----BEGIN CERTIFICATE REQUEST-----
MIIB/jCCAWACAQAwezELMAkGA1UEBhMCVVMxEzARBgNVBAgTCkNhbGlmb3JuaWEx
FjAUBgNVBAcTDVNhbiBGcmFuY2lzY28xEzARBgNVBAoTCkNsb3VkRmxhcmUxHDAa
BgNVBAsTE1N5c3RlbXMgRW5naW5lZXJpbmcxDDAKBgNVBAMTA0ZvbzCBmzAQBgcq
hkjOPQIBBgUrgQQAIwOBhgAEASwNCcgi2tHgVlqbEUIJoNW/TVx+ND+2C3IwHtjT
z/lBwcxxJm3bWYwTia2ii4tmSYknDbMFmt/ZJOOI5idjbQSMACnEG/ykUedStYpk
JuujJuTbRdhm3htF4CBf+t5/M+wamwug/EiJNRXzgJPQY34dXpeB8t1qxuCH7pEO
MUvEypwNoEAwPgYJKoZIhvcNAQkOMTEwLzAtBgNVHREEJjAkgg5jbG91ZGZsYXJl
LmNvbYISd3d3LmNsb3VkZmxhcmUuY29tMAoGCCqGSM49BAMEA4GLADCBhwJCAd6W
34jk79+PfYooc2/1fJcByR43PfcoPJ3V/7E8x4UKyR1UIcOAQbEX+e4K0omIMVJJ
S1nuEOyYb2W45PbJu1NEAkEGXxtrM8c3nTi5cYYF/vDj7LSmeH+DbVov+zI1LQyi
O5li3W4CF8+dEtTQlQBlaPxGQCV7EkjU9eUxj52qEvTA9g==
-----END CERTIFICATE REQUEST-----
```

*  Generate a Certificate from that csr using Vault ecpki backend
```bash
vault write ecpki/sign/ec-server-certificates csr=@csr.pem
```