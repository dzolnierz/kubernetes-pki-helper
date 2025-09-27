#!/bin/bash
set -ex

CN="${1:-master1}"
CLIENTIP="${2:-100.64.0.1}"
EXPIRES="${3:-365}"

export ETCD_CLIENT_IP="${CLIENTIP}"

openssl genrsa -out ${CN}.key 3072
openssl req -new -key ${CN}.key -out ${CN}.csr -subj "/CN=${CN}"
openssl x509 -req -in ${CN}.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out ${CN}.crt -days ${EXPIRES} && rm -f ${CN}.csr
# Print
openssl x509 -in ${CN}.crt -noout -subject -dates
