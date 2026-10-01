#!/usr/bin/env bash

set -euo pipefail

FILENAME="eid-archive_latest.deb"
DOWNLOAD_URL="https://eid.belgium.be/sites/default/files/software/${FILENAME}"
echo "This script will install the eID middleware and eID viewer for Ubuntu.\n
It will download the debian package from ${DOWNLOAD_URL} and install it on your computer.
Furthermore, it will install the eID Viewer and Middleware."

curl -sSL ${DOWNLOAD_URL} -o ${FILENAME} && dpkg --install ${FILENAME}
rm ${FILENAME}

apt-get update
apt-get install -y eid-mw eid-viewer
