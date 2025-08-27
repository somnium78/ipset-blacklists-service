#!/bin/bash

# Build script for OPNsense package
# Creates a tarball with all necessary files for OPNsense deployment

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="$SCRIPT_DIR/opnsense"
VERSION=$(cat "$PROJECT_ROOT/VERSION" 2>/dev/null || echo "2.0.17")

echo "Building OPNsense package v$VERSION..."
echo "====================================="

# Clean previous build
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

# Create package directory structure
PACKAGE_DIR="$BUILD_DIR/ipset-blacklists-opnsense-$VERSION"
mkdir -p "$PACKAGE_DIR"

echo "Creating directory structure..."
mkdir -p "$PACKAGE_DIR/bin"
mkdir -p "$PACKAGE_DIR/etc"
mkdir -p "$PACKAGE_DIR/scripts"
mkdir -p "$PACKAGE_DIR/monitoring"

echo "Copying binaries..."
cp "$PROJECT_ROOT/opnsense-port/bin/ipset-blacklist-opnsense" "$PACKAGE_DIR/bin/"
cp "$PROJECT_ROOT/opnsense-port/bin/ipset-blacklist-status" "$PACKAGE_DIR/bin/"

echo "Copying configuration..."
cp "$PROJECT_ROOT/opnsense-port/etc/blacklist-sources.conf" "$PACKAGE_DIR/etc/"

echo "Copying scripts..."
cp "$PROJECT_ROOT/opnsense-port/scripts/install-opnsense.sh" "$PACKAGE_DIR/scripts/"
cp "$PROJECT_ROOT/opnsense-port/scripts/uninstall-opnsense.sh" "$PACKAGE_DIR/scripts/"

echo "Copying monitoring..."
cp "$PROJECT_ROOT/opnsense-port/monitoring/ipset_blacklist_opnsense" "$PACKAGE_DIR/monitoring/"

echo "Copying documentation..."
cp "$PROJECT_ROOT/opnsense-port/README.md" "$PACKAGE_DIR/"
cp "$PROJECT_ROOT/LICENSE" "$PACKAGE_DIR/" 2>/dev/null || echo "LICENSE file not found, skipping"
cp "$PROJECT_ROOT/CHANGELOG.md" "$PACKAGE_DIR/" 2>/dev/null || echo "CHANGELOG file not found, skipping"

echo "Creating VERSION file..."
echo "$VERSION" > "$PACKAGE_DIR/VERSION"

echo "Creating tarball..."
cd "$BUILD_DIR"
tar -czf "ipset-blacklists-opnsense.tar.gz" "ipset-blacklists-opnsense-$VERSION/"

echo "OPNsense package built successfully!"
echo "Package: $BUILD_DIR/ipset-blacklists-opnsense.tar.gz"
echo "Contents:"
tar -tzf "ipset-blacklists-opnsense.tar.gz"

echo ""
echo "Package ready for distribution!"
