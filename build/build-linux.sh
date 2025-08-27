#!/bin/bash

# Build script for Linux DEB package
# Creates a professional DEB package for Ubuntu/Debian systems

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
BUILD_DIR="$SCRIPT_DIR/linux"
VERSION=$(cat "$PROJECT_ROOT/VERSION" 2>/dev/null || echo "2.0.17")

echo "Building Linux DEB package v$VERSION..."
echo "======================================"

# Clean previous build
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

# Create package directory structure
PACKAGE_DIR="$BUILD_DIR/ipset-blacklist-service_$VERSION"
mkdir -p "$PACKAGE_DIR/DEBIAN"
mkdir -p "$PACKAGE_DIR/usr/local/bin"
mkdir -p "$PACKAGE_DIR/etc/ipset-blacklist"
mkdir -p "$PACKAGE_DIR/lib/systemd/system"
mkdir -p "$PACKAGE_DIR/usr/lib/check_mk_agent/local"
mkdir -p "$PACKAGE_DIR/usr/share/doc/ipset-blacklist-service"

echo "Creating DEBIAN control files..."
cat > "$PACKAGE_DIR/DEBIAN/control" << CONTROL_EOF
Package: ipset-blacklist-service
Version: $VERSION
Section: net
Priority: optional
Architecture: all
Depends: ipset, iptables, wget, cron
Maintainer: IPSet Blacklist Service <noreply@example.com>
Description: Professional blacklist management service for Linux
 Multi-source IP blacklist service with automatic updates.
 Integrates with ipset and iptables for high-performance blocking.
 Supports Spamhaus, Firehol, GreenSnow, and Blocklist.de sources.
 Includes systemd integration and Check_MK monitoring.
CONTROL_EOF

cat > "$PACKAGE_DIR/DEBIAN/postinst" << POSTINST_EOF
#!/bin/bash
set -e

# Enable and start services
systemctl daemon-reload
systemctl enable ipset-blacklist-boot.service
systemctl enable ipset-blacklist-update.service
systemctl enable ipset-blacklist-update.timer

# Start the timer
systemctl start ipset-blacklist-update.timer

echo "IPSet Blacklist Service installed successfully!"
echo "Service will update blacklists automatically every 4 hours."
echo "Run 'systemctl start ipset-blacklist-update.service' for immediate update."
POSTINST_EOF

cat > "$PACKAGE_DIR/DEBIAN/prerm" << PRERM_EOF
#!/bin/bash
set -e

# Stop and disable services before removal
systemctl stop ipset-blacklist-update.timer 2>/dev/null || true
systemctl stop ipset-blacklist-update.service 2>/dev/null || true
systemctl stop ipset-blacklist-boot.service 2>/dev/null || true
systemctl disable ipset-blacklist-update.timer 2>/dev/null || true
systemctl disable ipset-blacklist-update.service 2>/dev/null || true
systemctl disable ipset-blacklist-boot.service 2>/dev/null || true
PRERM_EOF

chmod +x "$PACKAGE_DIR/DEBIAN/postinst"
chmod +x "$PACKAGE_DIR/DEBIAN/prerm"

echo "Copying binaries..."
# FIXED: Use the ORIGINAL structure - usr/local/bin/
cp "$PROJECT_ROOT/usr/local/bin/ipset-blacklist-service" "$PACKAGE_DIR/usr/local/bin/"
cp "$PROJECT_ROOT/usr/local/bin/ipset-blacklist-status" "$PACKAGE_DIR/usr/local/bin/"
cp "$PROJECT_ROOT/usr/local/bin/ipset-blacklist-cleanup" "$PACKAGE_DIR/usr/local/bin/"

echo "Copying configuration..."
# FIXED: Use the ORIGINAL structure - etc/ipset-blacklist/
cp "$PROJECT_ROOT/etc/ipset-blacklist/blacklist-sources.conf" "$PACKAGE_DIR/etc/ipset-blacklist/"

echo "Copying systemd units..."
# FIXED: Use the ORIGINAL structure - systemd/system/
cp "$PROJECT_ROOT/systemd/system/ipset-blacklist-boot.service" "$PACKAGE_DIR/lib/systemd/system/"
cp "$PROJECT_ROOT/systemd/system/ipset-blacklist-update.service" "$PACKAGE_DIR/lib/systemd/system/"
cp "$PROJECT_ROOT/systemd/system/ipset-blacklist-update.timer" "$PACKAGE_DIR/lib/systemd/system/"

echo "Copying monitoring..."
# FIXED: Use the ORIGINAL structure - usr/lib/check_mk_agent/local/
cp "$PROJECT_ROOT/usr/lib/check_mk_agent/local/ipset_blacklist" "$PACKAGE_DIR/usr/lib/check_mk_agent/local/"

echo "Copying documentation..."
cp "$PROJECT_ROOT/README.md" "$PACKAGE_DIR/usr/share/doc/ipset-blacklist-service/"
cp "$PROJECT_ROOT/LICENSE" "$PACKAGE_DIR/usr/share/doc/ipset-blacklist-service/" 2>/dev/null || echo "LICENSE file not found, skipping"
cp "$PROJECT_ROOT/CHANGELOG.md" "$PACKAGE_DIR/usr/share/doc/ipset-blacklist-service/" 2>/dev/null || echo "CHANGELOG file not found, skipping"

echo "Creating VERSION file..."
echo "$VERSION" > "$PACKAGE_DIR/usr/share/doc/ipset-blacklist-service/VERSION"

echo "Building DEB package..."
cd "$BUILD_DIR"
dpkg-deb --build "ipset-blacklist-service_$VERSION"

echo "Linux DEB package built successfully!"
echo "Package: $BUILD_DIR/ipset-blacklist-service_$VERSION.deb"

if command -v dpkg >/dev/null 2>&1; then
    echo "Package info:"
    dpkg -I "ipset-blacklist-service_$VERSION.deb"
else
    echo "Package created (dpkg not available for info display)"
fi

echo ""
echo "Package ready for distribution!"
