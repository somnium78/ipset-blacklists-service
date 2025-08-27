#!/bin/bash

# ipset Blacklist Service Installer
# Version: 2.0.13

set -e

echo "=== ipset Blacklist Service Installer v2.0.1 ==="

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    echo "ERROR: This script must be run as root"
    exit 1
fi

# Check dependencies
echo "Checking dependencies..."
for cmd in ipset iptables wget systemctl; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "ERROR: Required command '$cmd' not found"
        exit 1
    fi
done
echo "✅ All dependencies found"

# Create directories
echo "Creating directories..."
mkdir -p /var/lib/ipset-blacklist /var/log /etc/ipset-blacklist
mkdir -p /tmp/ipset-blacklist
chmod 755 /tmp/ipset-blacklist
chmod 755 /var/lib/ipset-blacklist

# Install scripts
echo "Installing scripts..."
cp usr/local/bin/* /usr/local/bin/
chmod +x /usr/local/bin/ipset-blacklist-*

# Install configuration
echo "Installing configuration..."
cp etc/ipset-blacklist/* /etc/ipset-blacklist/

# Install systemd files
echo "Installing systemd services..."
cp systemd/system/* /etc/systemd/system/
systemctl daemon-reload

# Install logrotate
echo "Installing logrotate configuration..."
cp etc/logrotate.d/* /etc/logrotate.d/

# Install Check_MK plugin if directory exists
if [[ -d /usr/lib/check_mk_agent/local ]]; then
    echo "Installing Check_MK plugin..."
    cp usr/lib/check_mk_agent/local/* /usr/lib/check_mk_agent/local/
    chmod +x /usr/lib/check_mk_agent/local/ipset_blacklist
else
    echo "Check_MK agent not found - skipping plugin installation"
fi

# Enable services
echo "Enabling services..."
systemctl enable ipset-blacklist-boot.service
systemctl enable ipset-blacklist-update.timer

echo "✅ Installation completed successfully!"
echo
echo "Next steps:"
echo "1. Review configuration: /etc/ipset-blacklist/blacklist-sources.conf"
echo "2. Start boot service: systemctl start ipset-blacklist-boot.service"
echo "3. Start timer: systemctl start ipset-blacklist-update.timer"
echo "4. Check status: /usr/local/bin/ipset-blacklist-status"
