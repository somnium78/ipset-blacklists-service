#!/bin/sh

echo "🗑️  Uninstalling Blacklist Service from OPNsense..."
echo "================================================="

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "❌ Error: This script must be run as root"
    exit 1
fi

echo "🛑 Stopping and cleaning up service..."
/usr/local/bin/ipset-blacklist-cleanup 2>/dev/null || true

echo "⏰ Removing cron job..."
crontab -l 2>/dev/null | grep -v "ipset-blacklist-opnsense" | crontab -

echo "🗂️  Removing files..."
rm -f /usr/local/bin/ipset-blacklist-opnsense
rm -f /usr/local/bin/ipset-blacklist-status
rm -f /usr/local/bin/ipset-blacklist-cleanup
rm -f /usr/local/etc/blacklist-sources.conf

echo "🧹 Cleaning up data..."
rm -rf /var/db/blacklist
rm -f /var/log/blacklist.log*

echo ""
echo "✅ Uninstallation completed!"
echo ""
echo "🔧 Manual cleanup required:"
echo "1. Remove firewall rules that use 'blacklist_inbound' table"
echo "2. Check pfctl tables: pfctl -t blacklist_inbound -T show"
echo "3. Remove table if needed: pfctl -t blacklist_inbound -T flush"
