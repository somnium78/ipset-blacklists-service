#!/bin/sh

echo "🚀 Installing Blacklist Service for OPNsense..."
echo "=============================================="

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "❌ Error: This script must be run as root"
    exit 1
fi

# Check if OPNsense
if [ ! -f /usr/local/opnsense/version/opnsense ]; then
    echo "⚠️  Warning: This doesn't appear to be an OPNsense system"
    echo "   Continuing anyway..."
fi

echo "📁 Creating directories..."
mkdir -p /var/db/blacklist
mkdir -p /var/log

echo "📋 Installing scripts..."
cp bin/ipset-blacklist-opnsense /usr/local/bin/
cp bin/ipset-blacklist-status /usr/local/bin/
cp bin/ipset-blacklist-cleanup /usr/local/bin/
chmod +x /usr/local/bin/ipset-blacklist-*

echo "⚙️  Installing configuration..."
cp etc/blacklist-sources.conf /usr/local/etc/

echo "⏰ Setting up cron job..."
# Remove existing cron job if present
crontab -l 2>/dev/null | grep -v "ipset-blacklist-opnsense" | crontab -

# Add new cron job (every 4 hours)
(crontab -l 2>/dev/null; echo "0 */4 * * * /usr/local/bin/ipset-blacklist-opnsense") | crontab -

echo "🔥 Creating sample firewall rule..."
cat > /tmp/opnsense-firewall-rule.txt << 'RULE_EOF'
# OPNsense Firewall Rule for Blacklist
# Add this rule via OPNsense Web GUI or command line:

# Method 1: Via pfctl command line
echo 'block in quick on $ext_if from <blacklist_inbound> to any' >> /tmp/pf.conf

# Method 2: Via OPNsense Web GUI
# 1. Go to Firewall → Rules → WAN
# 2. Add new rule:
#    - Action: Block
#    - Interface: WAN
#    - Source: blacklist_inbound (table)
#    - Destination: any
#    - Description: Block blacklisted IPs

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
echo "📊 The service will automatically update every 4 hours via cron"
echo "📝 Logs are written to: /var/log/blacklist.log"
echo "⚙️  Configuration: /usr/local/etc/blacklist-sources.conf"
