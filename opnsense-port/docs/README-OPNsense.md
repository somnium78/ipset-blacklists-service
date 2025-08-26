# 🛡️ ipset Blacklist Service - OPNsense Port

Professional blacklist service for OPNsense using pfctl tables and aliases instead of ipset.

## ✨ Features

- 🔄 **Diff-based updates** - Only processes changes, not entire lists
- 🚀 **pfctl integration** - Uses native FreeBSD packet filter tables
- ⏰ **Cron-based** - Automatic updates every 4 hours
- 📊 **Status monitoring** - Easy status checking and statistics
- 🧹 **Log management** - Automatic log rotation
- 🔧 **Easy management** - Simple install/uninstall scripts

## 🎯 Quick Start

### Installation
```bash
# Method 1: Direct download from GitHub releases
fetch https://github.com/somnium78/ipset-blacklists-service/releases/latest/download/ipset-blacklists-opnsense-2.0.7-opnsense.tar.gz
tar -xzf ipset-blacklists-opnsense-2.0.7-opnsense.tar.gz
cd ipset-blacklists-opnsense-2.0.7-opnsense

# Install
./scripts/install-opnsense.sh

# Run initial update
/usr/local/bin/ipset-blacklist-opnsense

# Add firewall rule
# see detailed instructions below!!

# Method 2: Clone repository and build
git clone https://github.com/somnium78/ipset-blacklists-service.git
cd ipset-blacklists-service/opnsense-port
./build-opnsense-package.sh
```

### 🔥 Firewall Rule Configuration

⚠️ IMPORTANT: You must create an Alias and Firewall Rule to actually block the IPs!
Step 1: Create Blacklist Alias
- Open OPNsense Web Interface
- Navigate to: Firewall → Aliases
- Click "+" to add new alias
- Configure alias:
    - Name: blacklist_ips
    - Type: URL Table (IPs)
    - Content: file:///var/db/blacklist/blacklist_current.txt
    - Update Frequency: every 2 hours
    - Description: Blacklisted IPs from ipset-blacklist service
- Click "Save"
- Click "Apply" to activate

Step 2: Create Blocking Rule
- Navigate to: Firewall → Rules → WAN
- Click "Add" (+ icon) to create new rule
- Configure rule:
    - Action: Block
    - Quick: ✓ (checked)
    - Interface: WAN
    - Direction: in
    - TCP/IP Version: IPv4
    - Protocol: any
    - Source: Single host or Network
    - Source: Select blacklist_ips from dropdown
    - Destination: any
    - Log: ✓ (optional - for monitoring)
    - Description: Block blacklisted IPs
- Click "Save"
- Click "Apply Changes"



## Usage

- Check status: sudo /usr/local/bin/ipset-blacklist-status
- Manual update: sudo /usr/local/bin/ipset-blacklist-opnsense
- View table: pfctl -t blacklist_inbound -T show | head -10
- Cleanup: sudo /usr/local/bin/ipset-blacklist-cleanup

# 📋 Requirements

- OPNsense (or FreeBSD with pfctl)
- Root privileges for installation
- Internet access for downloading blacklists
- fetch utility (included in FreeBSD)

# ⚙️ Configuration

Edit /usr/local/etc/blacklist-sources.conf to customize blacklist sources.

## Default sources:
- 🚫 Spamhaus DROP/EDROP - Known compromised networks
- 🔥 Firehol Level 1 - Most aggressive attackers
- 💚 GreenSnow - Compromised hosts
- 🛡️ Blocklist.de - Current attacks

## Adding custom sources:
```
# Edit configuration file
vi /usr/local/etc/blacklist-sources.conf

# Add new source in format:
    "source_name"
    "https://example.com/blacklist.txt"
    "ip"
    "Description of source"
```

# 📊 Monitoring

Status command: /usr/local/bin/ipset-blacklist-status

Shows:
- ✅ pfctl table status and entry count
- 📊 Last update statistics
- ⏰ Cron job status
- 🔥 Firewall rule integration
- 📝 Recent log entries

# 🔧 Files and Locations

- Scripts: /usr/local/bin/ipset-blacklist-*
- Configuration: /usr/local/etc/blacklist-sources.conf
- Work directory: /var/db/blacklist/
- Log file: /var/log/blacklist.log
- pfctl table: blacklist_inbound

# Log Management

- Log file: /var/log/blacklist.log
- Automatic rotation when file exceeds 10MB
- View logs: tail -f /var/log/blacklist.log
- Search logs: grep "ERROR\|Warning" /var/log/blacklist.log

# 🔄 Automatic Alias Updates

The service automatically updates /var/db/blacklist/blacklist_current.txt every 4 hours. The OPNsense alias will pick up changes based on the Update Frequency setting.

To force alias update:
1. Firewall → Aliases
2. Click refresh icon next to blacklist_ips
3. Or set Update Frequency to "Daily" for automatic updates

# 🗑️ Uninstallation
```
# Run uninstall script
sudo ./scripts/uninstall-opnsense.sh

# Manual cleanup:
# 1. Remove firewall rule via Web GUI
# 2. Remove alias via Web GUI  
# 3. Clean up files:
sudo rm -f /usr/local/bin/ipset-blacklist-*
sudo rm -f /usr/local/etc/blacklist-sources.conf
sudo rm -rf /var/db/blacklist
```

# 🚨 Important Notes

- ⚠️ Alias Refresh: Should be set to 2 hours or less in OPNsense Web GUI
- 🔄 Dual System: Uses both pfctl tables and OPNsense aliases for maximum compatibility
- 📊 Monitoring: Regular status checks recommended via /usr/local/bin/ipset-blacklist-status
- 🔥 Rule Priority: Place blacklist rule at top of WAN rules for best performance
- 💾 Persistence: pfctl tables are recreated on boot, aliases persist automatically

# 🎯 Performance Notes

- Memory usage: ~1MB per 10,000 IPs
- CPU impact: Minimal (diff-based updates)
- Network: Downloads only changed data
- Firewall: pfctl tables are very efficient
- Alias updates: Based on configured frequency

# 🔍 Troubleshooting
## Alias Not Updating
```bash
# Check if alias refresh frequency is set to 2 hours or less
# Web GUI: Firewall → Aliases → Edit blacklist_ips → Refresh Frequency

# Force alias reload
pfctl -t blacklist_ips -T replace -f /var/db/blacklist/blacklist_current.txt
```

## Check Service Status
```bash
# Verify pfctl table
pfctl -t blacklist_inbound -T show | wc -l

# Check file contents
wc -l /var/db/blacklist/blacklist_current.txt

# Test manual update
/usr/local/bin/ipset-blacklist-opnsense
```

## Log Analysis
```bash
# Recent activity
tail -50 /var/log/blacklist.log

# Error checking
grep -i error /var/log/blacklist.log

# Update statistics
grep "entries from" /var/log/blacklist.log | tail -10
```

# 📄 License

GPL-3.0 License - same as main project

# 🤝 Support

- Check logs: /var/log/blacklist.log
- Run status: /usr/local/bin/ipset-blacklist-status
- GitHub Issues: Main project repository

---

# 🚀 Ready for production deployment on OPNsense with full Web GUI integration!