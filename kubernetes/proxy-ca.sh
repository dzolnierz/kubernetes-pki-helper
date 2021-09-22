#!/bin/bash
set -ex

GPGPUBKEY="${1:-SaltStack}"

openssl genrsa -out proxy-ca.key 2048
openssl req -x509 -new -nodes -key proxy-ca.key -days $((10 * 365)) -out proxy-ca.crt -subj "/O=Proxy CA/CN=proxy-ca"
# Print
openssl x509 -in proxy-ca.crt -noout -subject -dates
# Encrypt
< proxy-ca.key gpg --armor --batch --trust-model always --encrypt -r "${GPGPUBKEY}" > proxy-ca.key.gpg
