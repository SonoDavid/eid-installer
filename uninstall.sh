#!/usr/bin/env bash

set -euo pipefail

echo "This script will remove the eID middleware and eID viewer on Ubuntu and Linux Mint."

apt purge libbeidpkcs11-bin eid-archive

