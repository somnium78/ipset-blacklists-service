#!/bin/sh
set -e

echo "🗑️  Uninstalling Blacklist Service from OPNsense..."
echo "================================================="

echo "⏰ Removing cron jobs..."
# Remove user cron job (if any)
crontab -l 2>/dev/null | grep -v "ipset-blacklist-opnsense" | crontab - 2>/dev/null || true

# Remove persistent cron job
rm -f /usr/local/etc/cron.d/ipset-blacklist

# Restart cron service
service cron restart 2>/dev/null || /usr/local/etc/rc.d/cron restart 2>/dev/null || true

echo "🔥 Removing pfctl table..."
pfctl -t blacklist_inbound -T flush 2>/dev/null || true
pfctl -t blacklist_inbound -T kill 2>/dev/null || true

echo "📋 Removing scripts..."
rm -f /usr/local/bin/ipset-blacklist-opnsense
rm -f /usr/local/bin/ipset-blacklist-cleanup
rm -f /usr/local/bin/ipset-blacklist-status

echo "⚙️  Removing configuration..."
rm -f /usr/local/etc/blacklist-sources.conf

echo "📁 Removing data and logs..."
rm -rf /var/db/blacklist
rm -f /var/log/blacklist.log

echo "🧹 Removing temporary files..."
rm -f /tmp/opnsense-setup-guide.txt

echo ""
echo "✅ Uninstallation completed!"
echo ""
echo "⚠️  Manual steps required:"
echo "1. Remove alias 'blacklist_inbound' from OPNsense Web GUI"
echo "   (Firewall → Aliases)"
echo "2. Remove firewall rules using the alias"
echo "   (Firewall → Rules → WAN)"
echo ""
echo "🔄 Apply changes in OPNsense Web GUI to complete removal"
