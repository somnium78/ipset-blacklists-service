#!/bin/sh

# OPNsense Uninstallation Script for Blacklist Service
# Removes all components of the blacklist service

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo "🗑️  Uninstalling Blacklist Service from OPNsense..."
echo "================================================="

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
    echo -e "${RED}❌ This script must be run as root${NC}"
    exit 1
fi

# Confirmation prompt
echo -e "${YELLOW}⚠️  This will completely remove the blacklist service and all its data.${NC}"
echo -n "Are you sure you want to continue? (y/N): "
read -r confirmation
case "$confirmation" in
    [yY]|[yY][eE][sS])
        echo "Proceeding with uninstallation..."
        ;;
    *)
        echo "Uninstallation cancelled."
        exit 0
        ;;
esac

echo ""

# Stop and clear pfctl table
echo "🔥 Clearing pfctl tables..."
if pfctl -t blacklist_inbound -T show >/dev/null 2>&1; then
    pfctl -t blacklist_inbound -T flush 2>/dev/null || true
    echo -e "${GREEN}   ✅ Cleared pfctl table 'blacklist_inbound'${NC}"
else
    echo -e "${YELLOW}   ⚠️  pfctl table 'blacklist_inbound' not found${NC}"
fi

# Remove cron job
echo "⏰ Removing cron job..."
if [ -f "/usr/local/etc/cron.d/ipset-blacklist" ]; then
    rm -f /usr/local/etc/cron.d/ipset-blacklist
    echo -e "${GREEN}   ✅ Removed persistent cron job${NC}"
else
    echo -e "${YELLOW}   ⚠️  Cron job file not found${NC}"
fi

# Remove from user crontab if present
if crontab -l 2>/dev/null | grep -q "ipset-blacklist-opnsense"; then
    crontab -l 2>/dev/null | grep -v "ipset-blacklist-opnsense" | crontab -
    echo -e "${GREEN}   ✅ Removed from user crontab${NC}"
fi

# Restart cron service
echo "🔄 Restarting cron service..."
service cron restart

# Remove binaries
echo "📋 Removing binaries..."
rm -f /usr/local/bin/ipset-blacklist-opnsense
rm -f /usr/local/bin/ipset-blacklist-status
echo -e "${GREEN}   ✅ Removed binaries${NC}"

# Remove configuration (with confirmation)
echo "⚙️  Removing configuration..."
if [ -f "/usr/local/etc/blacklist-sources.conf" ]; then
    echo -n "Remove configuration file? (y/N): "
    read -r remove_config
    case "$remove_config" in
        [yY]|[yY][eE][sS])
            rm -f /usr/local/etc/blacklist-sources.conf
            echo -e "${GREEN}   ✅ Removed configuration file${NC}"
            ;;
        *)
            echo -e "${YELLOW}   ⚠️  Configuration file kept${NC}"
            ;;
    esac
fi

# Remove version file
rm -f /usr/local/etc/blacklist_version

# Remove work directory (with confirmation)
echo "📁 Removing work directory..."
if [ -d "/var/db/blacklist" ]; then
    echo -n "Remove work directory and all data? (y/N): "
    read -r remove_data
    case "$remove_data" in
        [yY]|[yY][eE][sS])
            rm -rf /var/db/blacklist
            echo -e "${GREEN}   ✅ Removed work directory${NC}"
            ;;
        *)
            echo -e "${YELLOW}   ⚠️  Work directory kept${NC}"
            ;;
    esac
fi

# Remove log file (with confirmation)
echo "📝 Removing log file..."
if [ -f "/var/log/blacklist.log" ]; then
    echo -n "Remove log file? (y/N): "
    read -r remove_log
    case "$remove_log" in
        [yY]|[yY][eE][sS])
            rm -f /var/log/blacklist.log
            rm -f /var/log/blacklist.log.old
            echo -e "${GREEN}   ✅ Removed log files${NC}"
            ;;
        *)
            echo -e "${YELLOW}   ⚠️  Log files kept${NC}"
            ;;
    esac
fi

# Remove Check_MK plugin
echo "📊 Removing Check_MK plugin..."
CHECKMK_PLUGIN="/usr/local/check_mk_agent/local/ipset_blacklist"
if [ -f "$CHECKMK_PLUGIN" ]; then
    rm -f "$CHECKMK_PLUGIN"
    echo -e "${GREEN}   ✅ Removed Check_MK plugin${NC}"
else
    echo -e "${YELLOW}   ⚠️  Check_MK plugin not found${NC}"
fi

# Remove temporary files
rm -f /tmp/opnsense-setup-guide.txt

echo ""
echo -e "${GREEN}✅ Uninstallation completed successfully!${NC}"
echo ""
echo "🔧 Manual cleanup required:"
echo "1. Remove firewall rules in OPNsense Web GUI:"
echo "   - Go to Firewall → Rules"
echo "   - Remove rules using 'blacklist_inbound' alias"
echo ""
echo "2. Remove alias in OPNsense Web GUI:"
echo "   - Go to Firewall → Aliases"
echo "   - Delete 'blacklist_inbound' alias"
echo ""
echo "3. Apply firewall changes in Web GUI"
echo ""
echo "⚠️  Note: pfctl table 'blacklist_inbound' has been cleared but may"
echo "   still exist until next reboot or manual removal."
