#!/bin/bash
set -e

PILLAR="${1:-/srv/salt/pillar/etcd.sls}"
FILES=(ca.crt ca.key.gpg)
MARKERS=("%CA.crt%" "%CA.key%")

for i in "${!FILES[@]}"; do
	REPLACEMENT=$(:| paste -d ' ' - - - - - - - - - - "${FILES[$i]}")
	REPLACEMENT=$(echo -n "$REPLACEMENT" | cat -e | sed -e 's/\$/\\n/g' -e 's/\//\\\//g' | tr -d '\n')
	MARKER="${MARKERS[$i]}"
	sed -i -e s/"${MARKER}"/"${REPLACEMENT}"/ "${PILLAR}"
done
