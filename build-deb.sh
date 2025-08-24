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

# Clean and create build directory
rm -rf "$BUILD_DIR"
mkdir -p "$DEB_DIR"

# Create directory structure
mkdir -p "$DEB_DIR/DEBIAN"
mkdir -p "$DEB_DIR/usr/local/bin"
mkdir -p "$DEB_DIR/usr/local/etc"
mkdir -p "$DEB_DIR/etc/systemd/system"
mkdir -p "$DEB_DIR/var/lib/blacklist"

# Copy files
cp bin/* "$DEB_DIR/usr/local/bin/"
cp etc/blacklist-sources.conf "$DEB_DIR/usr/local/etc/"
cp systemd/*.service "$DEB_DIR/etc/systemd/system/"
cp systemd/*.timer "$DEB_DIR/etc/systemd/system/"

# Make scripts executable
chmod +x "$DEB_DIR/usr/local/bin/"*

# Create control file
cat > "$DEB_DIR/DEBIAN/control" << CONTROL_EOF
Package: $PACKAGE_NAME
Version: $VERSION
Section: net
Priority: optional
Architecture: $ARCH
Depends: ipset, iptables, wget, cron
Maintainer: ipset-blacklists-service
Description: Professional blacklist service using ipset
 Automatically downloads and manages IP blacklists from multiple sources
 including Spamhaus, Firehol, and others. Uses diff-based updates for
 efficiency and integrates with iptables/netfilter.
CONTROL_EOF

# Create postinst script
cat > "$DEB_DIR/DEBIAN/postinst" << 'POSTINST_EOF'
#!/bin/bash
set -e

# Reload systemd
systemctl daemon-reload

# Create ipset if not exists
if ! ipset list blacklist-inbound >/dev/null 2>&1; then
    ipset create blacklist-inbound hash:net
fi

echo "Installation complete. Start with:"
echo "  sudo systemctl start ipset-blacklist-boot.service"
echo "  sudo systemctl enable --now ipset-blacklist-update.timer"
POSTINST_EOF

chmod +x "$DEB_DIR/DEBIAN/postinst"

# Build package
dpkg-deb --build "$DEB_DIR"
mv "${BUILD_DIR}/${PACKAGE_NAME}_${VERSION}_${ARCH}.deb" .

echo "✅ Built: ${PACKAGE_NAME}_${VERSION}_${ARCH}.deb"
ls -la *.deb
