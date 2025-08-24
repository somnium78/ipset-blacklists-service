#!/bin/bash
set -e

# Read version from central file
if [ -f VERSION ]; then
    VERSION=$(cat VERSION)
else
    VERSION="2.0.4"
fi

PACKAGE_NAME="ipset-blacklists-service"
ARCH="all"
BUILD_DIR="build"
DEB_DIR="${BUILD_DIR}/${PACKAGE_NAME}_${VERSION}_${ARCH}"

echo "Building ${PACKAGE_NAME} v${VERSION}"

# Rest of build script...
# (existing build logic with $VERSION variable)
