#!/bin/bash

VERSION="2.0.2"
PACKAGE_DIR="debian-package/ipset-blacklists-service-${VERSION}"

echo "🚀 Building .deb package for ipset-blacklists-service v${VERSION}"

# Clean previous builds
rm -rf debian-package *.deb

# Create package structure
mkdir -p "${PACKAGE_DIR}"/{DEBIAN,usr/local/bin,etc/ipset-blacklist,etc/systemd/system,etc/logrotate.d,usr/lib/check_mk_agent/local}

# Copy files
cp usr/local/bin/* "${PACKAGE_DIR}/usr/local/bin/"
cp etc/ipset-blacklist/* "${PACKAGE_DIR}/etc/ipset-blacklist/"
cp systemd/system/* "${PACKAGE_DIR}/etc/systemd/system/"
cp etc/logrotate.d/* "${PACKAGE_DIR}/etc/logrotate.d/"
cp usr/lib/check_mk_agent/local/* "${PACKAGE_DIR}/usr/lib/check_mk_agent/local/"

# Set permissions
chmod +x "${PACKAGE_DIR}/usr/local/bin/"*
chmod +x "${PACKAGE_DIR}/usr/lib/check_mk_agent/local/"*

echo "📝 Creating DEBIAN control files..."

# Create control file
cat > "${PACKAGE_DIR}/DEBIAN/control" << 'CONTROL_EOF'
Package: ipset-blacklists-service
Version: 2.0.1
Section: net
Priority: optional
Architecture: all
Depends: ipset, iptables, wget, systemd, coreutils
Maintainer: somnium78 <somnium78@users.noreply.github.com>
Description: Professional systemd-integrated IP blacklist service
 ipset Blacklist Service provides automated IP blacklist management
 with diff-based updates, boot recovery, and systemd integration.
 .
 Features:
  - Diff-based updates for optimal performance
  - Boot recovery functionality
  - Complete systemd integration with timer
  - Check_MK monitoring plugin
  - Automated log management
  - Easy installation and maintenance tools
Homepage: https://github.com/somnium78/ipset-blacklists-service
CONTROL_EOF

# Create postinst script
cat > "${PACKAGE_DIR}/DEBIAN/postinst" << 'POSTINST_EOF'
#!/bin/bash
set -e

echo "🔧 Configuring ipset-blacklists-service..."

# Create directories
mkdir -p /var/lib/ipset-blacklist /tmp/ipset-blacklist
chmod 755 /var/lib/ipset-blacklist /tmp/ipset-blacklist

# Reload systemd
systemctl daemon-reload

# Enable services
systemctl enable ipset-blacklist-boot.service
systemctl enable ipset-blacklist-update.timer

echo "✅ ipset-blacklists-service installed successfully!"
echo ""
echo "🚀 Next steps:"
echo "   sudo systemctl start ipset-blacklist-boot.service"
echo "   sudo systemctl start ipset-blacklist-update.timer"
echo ""
echo "📊 Check status:"
echo "   sudo /usr/local/bin/ipset-blacklist-status"
POSTINST_EOF

# Create prerm script
cat > "${PACKAGE_DIR}/DEBIAN/prerm" << 'PRERM_EOF'
#!/bin/bash
set -e

echo "🛑 Stopping ipset-blacklists-service..."

# Stop and disable services
systemctl stop ipset-blacklist-update.timer 2>/dev/null || true
systemctl stop ipset-blacklist-boot.service 2>/dev/null || true
systemctl disable ipset-blacklist-update.timer 2>/dev/null || true
systemctl disable ipset-blacklist-boot.service 2>/dev/null || true

# Clean up ipset and iptables
if command -v /usr/local/bin/ipset-blacklist-cleanup >/dev/null 2>&1; then
    /usr/local/bin/ipset-blacklist-cleanup 2>/dev/null || true
fi

echo "✅ ipset-blacklists-service stopped and disabled"
PRERM_EOF

# Create postrm script
cat > "${PACKAGE_DIR}/DEBIAN/postrm" << 'POSTRM_EOF'
#!/bin/bash
set -e

if [ "$1" = "purge" ]; then
    echo "🧹 Purging ipset-blacklists-service data..."

    # Remove work directories
    rm -rf /var/lib/ipset-blacklist 2>/dev/null || true

    # Remove logs
    rm -f /var/log/ipset-blacklist.log* 2>/dev/null || true

    echo "✅ ipset-blacklists-service data purged"
fi

# Reload systemd
systemctl daemon-reload 2>/dev/null || true
POSTRM_EOF

# Set permissions for DEBIAN scripts
chmod 755 "${PACKAGE_DIR}/DEBIAN/postinst"
chmod 755 "${PACKAGE_DIR}/DEBIAN/prerm"
chmod 755 "${PACKAGE_DIR}/DEBIAN/postrm"

echo "📦 Building DEB package..."

# Build package
dpkg-deb --build "${PACKAGE_DIR}"

# Move to root and rename
mv "${PACKAGE_DIR}.deb" "./ipset-blacklists-service_${VERSION}_all.deb"

echo ""
echo "✅ Package built successfully!"
echo "📦 File: ipset-blacklists-service_${VERSION}_all.deb"
echo "📏 Size: $(du -h ipset-blacklists-service_${VERSION}_all.deb | cut -f1)"
echo ""
echo "🚀 Install with:"
echo "   sudo dpkg -i ipset-blacklists-service_${VERSION}_all.deb"
echo ""
echo "🗑️  Uninstall with:"
echo "   sudo apt remove ipset-blacklists-service"
