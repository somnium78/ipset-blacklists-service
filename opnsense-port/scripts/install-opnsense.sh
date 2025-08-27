#!/bin/sh

# OPNsense Installation Script for Blacklist Service
# Installs and configures the blacklist service on OPNsense/FreeBSD

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "🔧 Installing Blacklist Service for OPNsense..."
echo "=============================================="

# Check if running on OPNsense/FreeBSD
if [ ! -f "/usr/local/opnsense/version/base" ] && [ "$(uname)" != "FreeBSD" ]; then
    echo -e "${RED}❌ This script is designed for OPNsense/FreeBSD systems${NC}"
    echo "For Linux systems, use the DEB package or Linux installation script"
    exit 1
fi

echo -e "${GREEN}✅ OPNsense/FreeBSD system detected${NC}"

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
    echo -e "${RED}❌ This script must be run as root${NC}"
    exit 1
fi

echo "📁 Creating directories..."
mkdir -p /usr/local/bin
mkdir -p /usr/local/etc
mkdir -p /usr/local/etc/cron.d
mkdir -p /var/db/blacklist
mkdir -p /var/log

echo "📋 Installing scripts..."
cp "$PROJECT_ROOT/bin/ipset-blacklist-opnsense" /usr/local/bin/
cp "$PROJECT_ROOT/bin/ipset-blacklist-status" /usr/local/bin/
chmod +x /usr/local/bin/ipset-blacklist-opnsense
chmod +x /usr/local/bin/ipset-blacklist-status

echo "⚙️  Installing configuration..."
# FIXED: Use correct path - it was always in etc/
if [ ! -f "/usr/local/etc/blacklist-sources.conf" ]; then
    cp "$PROJECT_ROOT/etc/blacklist-sources.conf" /usr/local/etc/
    echo -e "${GREEN}   ✅ Configuration file installed${NC}"
else
    echo -e "${YELLOW}   ⚠️  Configuration file exists, skipping${NC}"
fi

echo "📝 Creating version file..."
if [ -f "$PROJECT_ROOT/../VERSION" ]; then
    cp "$PROJECT_ROOT/../VERSION" /usr/local/etc/blacklist_version
elif [ -f "$PROJECT_ROOT/VERSION" ]; then
    cp "$PROJECT_ROOT/VERSION" /usr/local/etc/blacklist_version
else
    echo "2.0.15-opnsense" > /usr/local/etc/blacklist_version
fi

echo "⏰ Setting up persistent cron job..."
cat > /usr/local/etc/cron.d/ipset-blacklist << 'CRON_EOF'
# IPSet Blacklist Service - Automatic Updates
# Updates blacklist every 4 hours
SHELL=/bin/sh
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

0 */4 * * * root /usr/local/bin/ipset-blacklist-opnsense >/dev/null 2>&1
CRON_EOF

echo "🔄 Restarting cron service..."
service cron restart

# Check_MK integration
echo "📊 Setting up Check_MK monitoring..."
CHECKMK_DIR="/usr/local/check_mk_agent/local"
if [ -d "$CHECKMK_DIR" ]; then
    echo -e "${GREEN}   ✅ Check_MK agent directory found${NC}"
    cp "$PROJECT_ROOT/monitoring/ipset_blacklist_opnsense" "$CHECKMK_DIR/ipset_blacklist"
    chmod +x "$CHECKMK_DIR/ipset_blacklist"
    echo -e "${GREEN}   ✅ Check_MK plugin installed${NC}"
else
    echo -e "${YELLOW}   ⚠️  Check_MK agent not found, skipping monitoring setup${NC}"
    echo "   Install Check_MK agent and copy monitoring/ipset_blacklist_opnsense to:"
    echo "   $CHECKMK_DIR/ipset_blacklist"
fi

echo "🔥 Creating configuration guide..."
cat > /tmp/opnsense-setup-guide.txt << 'GUIDE_EOF'
OPNsense Blacklist Service - Setup Guide
========================================

1. FIREWALL ALIAS CONFIGURATION:
   - Go to: Firewall → Aliases → All
   - Click: Add new alias
   - Name: blacklist_inbound
   - Type: URL Table (IPs)
   - Content: file:///var/db/blacklist/blacklist_current.txt
   - Description: Blacklist IPs for inbound blocking
   - Refresh Frequency: 2 hours (CRITICAL!)
   - Save and Apply

2. FIREWALL RULE CONFIGURATION:
   - Go to: Firewall → Rules → WAN (or your external interface)
   - Click: Add rule (at the top for highest priority)
   - Action: Block
   - Interface: WAN
   - Direction: in
   - TCP/IP Version: IPv4
   - Protocol: any
   - Source: Single host or alias → Select "blacklist_inbound"
   - Destination: any
   - Description: Block blacklisted IPs
   - Save and Apply Changes

3. VERIFICATION:
   - Check table: pfctl -t blacklist_inbound -T show | wc -l
   - Check rules: pfctl -sr | grep blacklist_inbound
   - Check status: /usr/local/bin/ipset-blacklist-status
   - View logs: tail -f /var/log/blacklist.log

4. MONITORING (if Check_MK is installed):
   - Plugin installed at: /usr/local/check_mk_agent/local/ipset_blacklist
   - Monitors: Entry count, rule presence, log age, source success rate
   - Thresholds: <1000 entries = WARNING, no entries = CRITICAL

IMPORTANT NOTES:
- The alias refresh frequency MUST be set to 2 hours or less
- Without proper refresh frequency, the Web GUI alias won't update
- The pfctl table updates automatically, but Web GUI alias needs refresh
- Both systems work together for complete coverage

TROUBLESHOOTING:
- If alias shows 0 entries: Check refresh frequency setting
- If pfctl table empty: Run /usr/local/bin/ipset-blacklist-opnsense manually
- If downloads fail: Check internet connectivity and DNS resolution
- For support: Check /var/log/blacklist.log for detailed error messages
GUIDE_EOF

echo ""
echo -e "${GREEN}✅ Installation completed successfully!${NC}"
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
if [ -d "$CHECKMK_DIR" ]; then
    echo "📊 Check_MK Plugin: $CHECKMK_DIR/ipset_blacklist"
fi
