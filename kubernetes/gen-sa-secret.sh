#!/bin/bash
set -ex

GPGPUBKEY="${1:-SaltStack}"

openssl genrsa -out sa.key 2048
openssl rsa -in sa.key -pubout -out sa.pub
< sa.key gpg --armor --batch --trust-model always --encrypt -r "${GPGPUBKEY}" > sa.key.gpg
