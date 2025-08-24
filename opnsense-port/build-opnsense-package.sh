#!/bin/sh

VERSION="2.0.2-opnsense"
PACKAGE_NAME="ipset-blacklists-opnsense-${VERSION}"

echo "📦 Building OPNsense package: $PACKAGE_NAME"

# Clean previous builds
rm -rf build *.tar.gz

# Create package structure
mkdir -p "build/$PACKAGE_NAME"

# Copy files
cp -r bin etc scripts docs "build/$PACKAGE_NAME/"

# Create package info
cat > "build/$PACKAGE_NAME/PACKAGE_INFO" << 'INFO_EOF'
Package: ipset-blacklists-opnsense
Version: 2.0.2-opnsense
Description: Professional blacklist service for OPNsense using pfctl tables
Author: somnium78
License: GPL-3.0
Platform: OPNsense/FreeBSD
Requirements: pfctl, fetch, cron
INFO_EOF

# Create installation instructions
cat > "build/$PACKAGE_NAME/INSTALL.txt" << 'INSTALL_EOF'
OPNsense Blacklist Service Installation
======================================

1. Extract package:
   tar -xzf ipset-blacklists-opnsense-2.0.2-opnsense.tar.gz
   cd ipset-blacklists-opnsense-2.0.2-opnsense

2. Install:
   sudo ./scripts/install-opnsense.sh

3. Run initial update:
   sudo /usr/local/bin/ipset-blacklist-opnsense

4. Add firewall rule:
   block in quick on $ext_if from <blacklist_inbound> to any

5. Check status:
   sudo /usr/local/bin/ipset-blacklist-status

For detailed documentation, see docs/README-OPNsense.md
INSTALL_EOF

# Create tarball
cd build
tar -czf "../${PACKAGE_NAME}.tar.gz" "$PACKAGE_NAME"
cd ..

echo "✅ Package created: ${PACKAGE_NAME}.tar.gz"
echo "📏 Size: $(du -h ${PACKAGE_NAME}.tar.gz | cut -f1)"
echo ""
echo "🚀 Installation:"
echo "   tar -xzf ${PACKAGE_NAME}.tar.gz"
echo "   cd $PACKAGE_NAME"
echo "   sudo ./scripts/install-opnsense.sh"
