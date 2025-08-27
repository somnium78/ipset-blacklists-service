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
    BASE_VERSION="2.0.9"
    VERSION="2.0.9-opnsense"
fi

PACKAGE_NAME="ipset-blacklists-opnsense"
BUILD_DIR="build"
PACKAGE_DIR="${BUILD_DIR}/${PACKAGE_NAME}-${BASE_VERSION}"

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
sed "s/VERSION=\"2\.0\.9-opnsense\"/VERSION=\"${VERSION}\"/" bin/ipset-blacklist-opnsense > "$PACKAGE_DIR/bin/ipset-blacklist-opnsense"
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

# Update install script with correct version
sed -i "s/echo \"2\.0\.9-opnsense\"/echo \"${VERSION}\"/" "$PACKAGE_DIR/scripts/install-opnsense.sh"

# Create tarball
cd "$BUILD_DIR"
tar -czf "../${PACKAGE_NAME}-${BASE_VERSION}-opnsense.tar.gz" "${PACKAGE_NAME}-${BASE_VERSION}/"
cd ..

echo "✅ Built: ${PACKAGE_NAME}-${BASE_VERSION}-opnsense.tar.gz"
ls -la *.tar.gz
