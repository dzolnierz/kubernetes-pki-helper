#!/bin/bash

set -euo pipefail

cd "${BASH_SOURCE%/*}"
source ../lib/funcs.sh

# Helpers definitions
verlte() {
    [ "$1" = "$(printf "%s\n%s" "$1" "$2" | sort -V | head -n1)" ]
	echo $?
}

clean_on_exit()
{
	[ -n "${GPGKEYCONFIG}" ] && rm -f "${GPGKEYCONFIG}"
}

trap 'clean_on_exit' EXIT


# Variables
GPGDIR="${1:-/etc/salt/gpgkeys}"
GPGKEYNAME="${2:-SaltStack}"
GPGKEYCONFIG=$(mktemp)
KERNELVER="$(< /proc/version awk '{ print $3 }' | cut -d- -f1)"

hash gpg2 2>/dev/null && gpg="gpg2" || gpg="gpg"

# Safety checks:
command -v "$gpg" >/dev/null || { echo "Please install gnupg and gnupg-agent packages"; exit 1; }
test -d "${GPGDIR}" || mkdir --mode=0700 "${GPGDIR}"

ENTROPY_AVAIL="$(cat /proc/sys/kernel/random/entropy_avail)"
if [[ "${ENTROPY_AVAIL}" -le 1000 ]]; then
	echo -n "Available entropy (${ENTROPY_AVAIL}) is less than 1000."
	if [[ "$(verlte "${KERNELVER}" "5.15.0")" == "0" ]]; then
		echo "Install havaged or rng-tools package"
		exit 1
	fi
	echo -e "\nNOTE: No more the case on modern kernels: https://lore.kernel.org/lkml/20220527084855.501642285@linuxfoundation.org/"
fi

# Detect GPG version
GPG_VERSION_MAJ_MIN="$("$gpg" --version | awk 'NR == 1 && /^gpg/ { print $3 }' | cut -d. -f1,2)"

"$gpg" --homedir "${GPGDIR}" --list-secret-keys "${GPGKEYNAME}" >/dev/null 2>&1 && { echo "Key pair with name '${GPGKEYNAME}' already exists. Delete before continue."; exit 1; }

cat > "${GPGKEYCONFIG}" <<EOF
%echo Generating OpenPGP key
Key-Type: RSA
Key-Length: 3072
Subkey-Type: RSA
Subkey-Length: 4096
Name-Real: ${GPGKEYNAME}
Expire-Date: 0
Passphrase: ""
%commit
%echo done
EOF

gpgopts="--batch --full-gen-key -"
if [[ "$(verlte "${GPG_VERSION_MAJ_MIN}" "1.4")" == "0" ]]; then
	gpgopts="--batch --gen-key -"
fi

confirm "You're about to generate new GPG key." || { echo "Exiting..."; exit 1; }
< "${GPGKEYCONFIG}" "$gpg" --homedir "${GPGDIR}" ${gpgopts}
# Export public key
"$gpg" --homedir "${GPGDIR}" --armor --export "${GPGKEYNAME}" > "${PWD}/${GPGKEYNAME}.pub.asc"
