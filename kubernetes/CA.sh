#!/bin/bash
set -ex

GPGPUBKEY="${1:-SaltStack}"

openssl genrsa -out CA.key 2048
openssl req -x509 -new -nodes -key CA.key -days $((10 * 365)) -out CA.crt -subj "/O=Kubernetes general CA/CN=kubernetes-ca"
# Print
openssl x509 -in CA.crt -noout -subject -dates
# Encrypt
< CA.key gpg --armor --batch --trust-model always --encrypt -r "${GPGPUBKEY}" > CA.key.gpg
