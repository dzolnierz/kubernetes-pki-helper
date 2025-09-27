#!/bin/bash
set -ex

GPGPUBKEY="${1:-SaltStack}"

openssl genrsa -out ca.key 3072
openssl req -x509 -new -nodes -key ca.key -days $((5 * 365)) -out ca.crt -subj "/O=etcd CA/CN=etcd-ca"
# Print
openssl x509 -in ca.crt -noout -subject -dates
# Encrypt
< ca.key gpg --armor --batch --trust-model always --encrypt -r "${GPGPUBKEY}" > ca.key.gpg
