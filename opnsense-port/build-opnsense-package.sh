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
PACKAGE_DIR="${BUILD_DIR}/${PACKAGE_NAME}-${VERSION}"

echo "Building ${PACKAGE_NAME} v${VERSION}"

# Clean and create build directory
rm -rf "$BUILD_DIR"
mkdir -p "$PACKAGE_DIR"

# Create directory structure
mkdir -p "$PACKAGE_DIR/bin"
mkdir -p "$PACKAGE_DIR/etc"
mkdir -p "$PACKAGE_DIR/scripts"
mkdir -p "$PACKAGE_DIR/docs"

# Copy files
cp bin/* "$PACKAGE_DIR/bin/"
cp etc/* "$PACKAGE_DIR/etc/"
cp scripts/* "$PACKAGE_DIR/scripts/"
cp docs/* "$PACKAGE_DIR/docs/"

# Make scripts executable
chmod +x "$PACKAGE_DIR/bin/"*
chmod +x "$PACKAGE_DIR/scripts/"*

# Create tarball
cd "$BUILD_DIR"
tar -czf "../${PACKAGE_NAME}-${VERSION}.tar.gz" "${PACKAGE_NAME}-${VERSION}/"
cd ..

echo "✅ Built: ${PACKAGE_NAME}-${VERSION}.tar.gz"
ls -la *.tar.gz
