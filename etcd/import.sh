#!/bin/bash
set -e

PILLAR="${1:-/srv/salt/pillar/base/etcd.sls}"
FILES=(CA.crt CA.key.gpg)
MARKERS=("%CA CERT%" "%CA KEY%")

for i in "${!FILES[@]}"; do
	REPLACEMENT=$(:| paste -d ' ' - - - - - - - - - - "${FILES[$i]}")
	REPLACEMENT=$(echo -n "$REPLACEMENT" | cat -e | sed -e 's/\$/\\n/g' -e 's/\//\\\//g' | tr -d '\n')
	MARKER="${MARKERS[$i]}"
	sed -i -e s/"${MARKER}"/"${REPLACEMENT}"/ "${PILLAR}"
done
