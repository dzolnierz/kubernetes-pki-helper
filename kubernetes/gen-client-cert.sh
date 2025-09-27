#!/bin/bash
set -ex 

CN="${1}"
KUBEGROUPS="$(echo -n ${2} | xargs -r -d ',' -n1 -I% echo -n '/O=%')"
EXPIRES="${3:-"365"}"

test -f ${CN}.key || openssl genrsa -out ${CN}.key 3072
openssl req -new -key ${CN}.key -out ${CN}.csr -subj "/CN=${CN}${KUBEGROUPS}"
openssl x509 -req -in ${CN}.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out ${CN}.crt -days ${EXPIRES} && rm -f ${CN}.csr
# Print
openssl x509 -in ${CN}.crt -noout -subject -dates
