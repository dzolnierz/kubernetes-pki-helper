#!/bin/bash
set -ex

GPGPUBKEY="${1:-SaltStack.pub.asc}"

gpg --import "${GPGPUBKEY}"
