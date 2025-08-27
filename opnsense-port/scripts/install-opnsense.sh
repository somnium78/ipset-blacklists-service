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
mkdir -p /usr/local/etc/cron.d
mkdir -p /var/db/blacklist
mkdir -p /var/log

echo "📋 Installing scripts..."
cp bin/* /usr/local/bin/
chmod +x /usr/local/bin/ipset-blacklist-*

echo "⚙️  Installing configuration..."
cp etc/blacklist-sources.conf /usr/local/etc/

echo "📝 Creating version file..."
echo "2.0.9-opnsense" > /usr/local/etc/blacklist_version

echo "⏰ Setting up persistent cron job..."
# Remove any existing user cron jobs
crontab -l 2>/dev/null | grep -v "ipset-blacklist-opnsense" | crontab - 2>/dev/null || true

# Create persistent cron job in system directory
cat > /usr/local/etc/cron.d/ipset-blacklist << 'CRON_EOF'
# IPSet Blacklist Service - Automatic Updates
# Updates blacklist every 4 hours
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

0 */4 * * * root /usr/local/bin/ipset-blacklist-opnsense >/dev/null 2>&1
CRON_EOF

echo "🔄 Restarting cron service..."
service cron restart 2>/dev/null || /usr/local/etc/rc.d/cron restart 2>/dev/null || true

echo "🔥 Creating configuration guide..."
cat > /tmp/opnsense-setup-guide.txt << 'GUIDE_EOF'
# OPNsense Blacklist Setup Guide
===============================

## RECOMMENDED: Web GUI Method

1. Create Alias:
   - Go to: Firewall → Aliases
   - Name: blacklist_inbound
   - Type: URL Table (IPs)
   - Content: file:///var/db/blacklist/blacklist_current.txt
   - Refresh Frequency: 2 hours (IMPORTANT!)

2. Create Firewall Rule:
   - Go to: Firewall → Rules → WAN
   - Action: Block
   - Source: blacklist_inbound (your alias)
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
echo "   - Create alias 'blacklist_inbound' in Web GUI"
echo "   - Set refresh frequency to 2 hours"
echo "   - Create blocking rule using the alias"
echo ""
echo "4. Verify setup:"
echo "   pfctl -t blacklist_inbound -T show | wc -l"
echo ""
echo "⏰ Persistent cron job: /usr/local/etc/cron.d/ipset-blacklist"
echo "📝 Logs: /var/log/blacklist.log"
echo "⚙️  Config: /usr/local/etc/blacklist-sources.conf"
echo "🔧 Version: /usr/local/etc/blacklist_version"
echo "📋 Setup Guide: /tmp/opnsense-setup-guide.txt"
