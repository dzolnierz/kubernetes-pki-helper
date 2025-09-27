#!/bin/bash
set -ex

GPGPUBKEY="${1:-SaltStack}"

openssl genrsa -out front-proxy-ca.key 3072
openssl req -x509 -new -nodes -key front-proxy-ca.key -days $((3 * 365)) -out front-proxy-ca.crt -subj "/O=Kubernetes Proxy CA/CN=kubernetes-front-proxy-ca"
# Print
openssl x509 -in front-proxy-ca.crt -noout -subject -dates
# Encrypt
< front-proxy-ca.key gpg --armor --batch --trust-model always --encrypt -r "${GPGPUBKEY}" > front-proxy-ca.key.gpg
