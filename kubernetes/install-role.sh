#!/bin/bash

set -euo pipefail

# args
USER="${1}"
NAMESPACE="${2}"
ROLE="${3}"

MARKER="%USER%"

: "${USER:?must be set}"
: "${NAMESPACE:?must be set}"
: "${ROLE:?must be set}"

< "$ROLE" sed -e s/"${MARKER}"/"${USER}"/ | kubectl -n "$NAMESPACE" apply -f-
