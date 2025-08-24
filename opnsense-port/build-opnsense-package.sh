#!/bin/sh
set -e

# Read version from central file
if [ -f ../VERSION ]; then
    VERSION="$(cat ../VERSION)-opnsense"
elif [ -f VERSION ]; then
    VERSION="$(cat VERSION)-opnsense"
else
    VERSION="2.0.4-opnsense"
fi

PACKAGE_NAME="ipset-blacklists-opnsense"
BUILD_DIR="build"

echo "Building ${PACKAGE_NAME} v${VERSION}"

# Rest of build script...
