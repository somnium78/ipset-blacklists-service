#!/bin/sh
set -e

# Read version from central file
if [ -f ../VERSION ]; then
    BASE_VERSION=$(cat ../VERSION)
    VERSION="${BASE_VERSION}-opnsense"
elif [ -f VERSION ]; then
    BASE_VERSION=$(cat VERSION)
    VERSION="${BASE_VERSION}-opnsense"
else
    BASE_VERSION="2.0.8"
    VERSION="2.0.8-opnsense"
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

# Copy and modify main binary with embedded version
sed "s/VERSION=\$(cat VERSION)/VERSION=\"${VERSION}\"/" bin/ipset-blacklist-opnsense > "$PACKAGE_DIR/bin/ipset-blacklist-opnsense"

# Also fix any other VERSION references
sed -i "s/VERSION=\"\$VERSION\"/VERSION=\"${VERSION}\"/" "$PACKAGE_DIR/bin/ipset-blacklist-opnsense"
sed -i "s/v\$VERSION/v${VERSION}/" "$PACKAGE_DIR/bin/ipset-blacklist-opnsense"

chmod +x "$PACKAGE_DIR/bin/ipset-blacklist-opnsense"

# Copy other binaries normally
cp bin/ipset-blacklist-cleanup "$PACKAGE_DIR/bin/"
cp bin/ipset-blacklist-status "$PACKAGE_DIR/bin/"
chmod +x "$PACKAGE_DIR/bin/"*

# Copy other files
cp etc/* "$PACKAGE_DIR/etc/"
cp scripts/* "$PACKAGE_DIR/scripts/"
cp docs/* "$PACKAGE_DIR/docs/"
chmod +x "$PACKAGE_DIR/scripts/"*

# Create tarball
cd "$BUILD_DIR"
tar -czf "../${PACKAGE_NAME}-${VERSION}.tar.gz" "${PACKAGE_NAME}-${VERSION}/"
cd ..

echo "✅ Built: ${PACKAGE_NAME}-${VERSION}.tar.gz"
ls -la *.tar.gz
