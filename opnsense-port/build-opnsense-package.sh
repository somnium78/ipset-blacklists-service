#!/bin/bash

# Build script for OPNsense package
# Creates a complete distribution package

set -e

VERSION="2.0.15-opnsense"
PACKAGE_NAME="ipset-blacklists-opnsense"
BUILD_DIR="build"

echo "Building $PACKAGE_NAME v$VERSION"

# Clean and create build directory
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR/$PACKAGE_NAME-$VERSION"

# Copy all necessary files
echo "Copying files..."

# Binaries
mkdir -p "$BUILD_DIR/$PACKAGE_NAME-$VERSION/bin"
cp bin/* "$BUILD_DIR/$PACKAGE_NAME-$VERSION/bin/"

# Configuration
mkdir -p "$BUILD_DIR/$PACKAGE_NAME-$VERSION/etc"
cp etc/* "$BUILD_DIR/$PACKAGE_NAME-$VERSION/etc/"

# Scripts
mkdir -p "$BUILD_DIR/$PACKAGE_NAME-$VERSION/scripts"
cp scripts/* "$BUILD_DIR/$PACKAGE_NAME-$VERSION/scripts/"

# Monitoring
mkdir -p "$BUILD_DIR/$PACKAGE_NAME-$VERSION/monitoring"
cp monitoring/* "$BUILD_DIR/$PACKAGE_NAME-$VERSION/monitoring/"

# Documentation - simple and direct
cp README.md "$BUILD_DIR/$PACKAGE_NAME-$VERSION/"

# Version file
echo "$VERSION" > "$BUILD_DIR/$PACKAGE_NAME-$VERSION/VERSION"

# Create tarball
echo "Creating tarball..."
cd "$BUILD_DIR"
tar -czf "$PACKAGE_NAME.tar.gz" "$PACKAGE_NAME-$VERSION/"

echo "Package created: $BUILD_DIR/$PACKAGE_NAME.tar.gz"
echo "Contents:"
tar -tzf "$PACKAGE_NAME.tar.gz"

echo "Build completed successfully!"
