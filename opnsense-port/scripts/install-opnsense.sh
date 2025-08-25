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
cat > /tmp/opnsense-firewall-rule.txt << 'RULE_EOF'
# Add this rule to your OPNsense firewall (Firewall -> Rules -> WAN):
# Action: Block
# Interface: WAN
# Source: blacklist_ips (alias)
# Description: Block blacklisted IPs

# Or via pfctl command line:
block in quick on $ext_if from <blacklist_inbound> to any
RULE_EOF

echo ""
echo "✅ Installation completed successfully!"
echo ""
echo "🚀 Next steps:"
echo "1. Run initial update:"
echo "   /usr/local/bin/ipset-blacklist-opnsense"
echo ""
echo "2. Check status:"
echo "   /usr/local/bin/ipset-blacklist-status"
echo ""
echo "3. Add firewall rule (see /tmp/opnsense-firewall-rule.txt):"
echo "   block in quick on \$ext_if from <blacklist_inbound> to any"
echo ""
echo "4. Verify table contents:"
echo "   pfctl -t blacklist_inbound -T show | head -10"
echo ""
echo "⏰ The service will automatically update every 4 hours via cron"
echo "📝 Logs are written to: /var/log/blacklist.log"
echo "⚙️  Configuration: /usr/local/etc/blacklist-sources.conf"
