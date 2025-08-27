#!/bin/bash

# ipset Blacklist Service Uninstaller
# Version: 2.0.11

set -e

echo "=== ipset Blacklist Service Uninstaller v2.0.11 ==="

# Check if running as root
if [[ $EUID -ne 0 ]]; then
    echo "ERROR: This script must be run as root"
    exit 1
fi

# Stop and disable services
echo "Stopping and disabling services..."
systemctl stop ipset-blacklist.timer ipset-blacklist-update.timer 2>/dev/null || true
systemctl stop ipset-blacklist-boot.service 2>/dev/null || true
systemctl disable ipset-blacklist.timer ipset-blacklist-update.timer 2>/dev/null || true
systemctl disable ipset-blacklist-boot.service 2>/dev/null || true

# Clean up ipset and iptables
echo "Cleaning up ipset and iptables..."
/usr/local/bin/ipset-blacklist-cleanup 2>/dev/null || true

# Remove systemd files
echo "Removing systemd files..."
rm -f /etc/systemd/system/ipset-blacklist*.service
rm -f /etc/systemd/system/ipset-blacklist*.timer
systemctl daemon-reload

# Remove scripts
echo "Removing scripts..."
rm -f /usr/local/bin/ipset-blacklist-*

# Remove configuration (with confirmation)
read -p "Remove configuration files? [y/N]: " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -rf /etc/ipset-blacklist
    echo "Configuration removed"
else
    echo "Configuration kept in /etc/ipset-blacklist"
fi

# Remove work directory (with confirmation)
read -p "Remove work directory and data? [y/N]: " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    rm -rf /var/lib/ipset-blacklist
    echo "Work directory removed"
else
    echo "Work directory kept in /var/lib/ipset-blacklist"
fi

# Remove logrotate
echo "Removing logrotate configuration..."
rm -f /etc/logrotate.d/ipset-blacklist

# Remove Check_MK plugin
echo "Removing Check_MK plugin..."
rm -f /usr/lib/check_mk_agent/local/ipset_blacklist

echo "✅ Uninstallation completed!"
