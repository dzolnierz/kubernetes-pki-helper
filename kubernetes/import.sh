#!/bin/bash
set -e

PILLAR="${1:-/srv/salt/pillar/base/kubernetes.sls}"
FILES=(CA.crt CA.key.gpg sa.key.gpg sa.pub proxy-ca.crt proxy-ca.key.gpg)
MARKERS=("%CA CERT%" "%CA KEY%" "%SA KEY%" "%SA PUB%" "%PROXY CA CERT%" "%PROXY CA KEY%")

for i in "${!FILES[@]}"; do
	REPLACEMENT=$(:| paste -d ' ' - - - - - - - - - - "${FILES[$i]}")
	REPLACEMENT=$(echo -n "$REPLACEMENT" | cat -e | sed -e 's/\$/\\n/g' -e 's/\//\\\//g' | tr -d '\n')
	MARKER="${MARKERS[$i]}"
	sed -i -e s/"${MARKER}"/"${REPLACEMENT}"/ "${PILLAR}"
done
