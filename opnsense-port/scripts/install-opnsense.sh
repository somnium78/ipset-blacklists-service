#!/bin/sh
set -e

echo "🔧 Installing Blacklist Service for OPNsense..."
echo "=============================================="

# Corrected OPNsense detection
if [ -f /usr/local/opnsense/version/base ] || [ -f /etc/inc/config.inc ] || [ -d /usr/local/etc/rc.d ]; then
    echo "✅ OPNsense/FreeBSD system detected"
else
    echo "⚠️  Warning: This doesn't appear to be an OPNsense/FreeBSD system"
    echo "   Detected OS: $(uname -s)"
    echo "   Continuing anyway..."
fi

echo "📁 Creating directories..."
mkdir -p /usr/local/bin
mkdir -p /usr/local/etc
mkdir -p /var/db/blacklist
mkdir -p /var/log

echo "📋 Installing scripts..."
cp bin/* /usr/local/bin/
chmod +x /usr/local/bin/ipset-blacklist-*

echo "⚙️  Installing configuration..."
cp etc/blacklist-sources.conf /usr/local/etc/

echo "⏰ Setting up cron job..."
# Remove existing cron job
crontab -l 2>/dev/null | grep -v "ipset-blacklist-opnsense" | crontab -

# Add new cron job (every 4 hours)
(crontab -l 2>/dev/null; echo "0 */4 * * * /usr/local/bin/ipset-blacklist-opnsense >/dev/null 2>&1") | crontab -

echo "🔥 Creating sample firewall rule..."
cat > /tmp/opnsense-setup-guide.txt << 'GUIDE_EOF'
# OPNsense Blacklist Setup Guide
===============================

## RECOMMENDED: Web GUI Method

1. Create Alias:
   - Go to: Firewall → Aliases
   - Name: blacklist_ips
   - Type: URL Table (IPs)
   - Content: file:///var/db/blacklist/blacklist_current.txt
   - Refresh Frequency: 2 hours (IMPORTANT!)

2. Create Firewall Rule:
   - Go to: Firewall → Rules → WAN
   - Action: Block
   - Source: blacklist_ips (your alias)
   - Move rule to top for priority

## Advanced: pfctl Table Commands

View table: pfctl -t blacklist_inbound -T show | head -10
Table size: pfctl -t blacklist_inbound -T show | wc -l

Note: Firewall rules must be configured via Web GUI!
GUIDE_EOF


echo ""
echo "✅ Installation completed successfully!"
echo ""
echo "🚀 Next Steps:"
echo "1. Run initial update:"
echo "   /usr/local/bin/ipset-blacklist-opnsense"
echo ""
echo "2. Check status:"
echo "   /usr/local/bin/ipset-blacklist-status"
echo ""
echo "3. Configure firewall (see /tmp/opnsense-setup-guide.txt):"
echo "   - Create alias 'blacklist_ips' in Web GUI"
echo "   - Set refresh frequency to 2 hours"
echo "   - Create blocking rule using the alias"
echo ""
echo "4. Verify setup:"
echo "   pfctl -t blacklist_inbound -T show | head -10"
echo ""
echo "⏰ Automatic updates: Every 4 hours via cron"
echo "📝 Logs: /var/log/blacklist.log"
echo "⚙️  Config: /usr/local/etc/blacklist-sources.conf"
echo "📋 Setup Guide: /tmp/opnsense-setup-guide.txt"

