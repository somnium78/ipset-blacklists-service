# 🛡️ ipset Blacklist Service - OPNsense Port

Professional blacklist service for OPNsense using pfctl tables and aliases instead of ipset.

## ✨ Features

- 🔄 **Diff-based updates** - Only processes changes, not entire lists
- 🚀 **pfctl integration** - Uses native FreeBSD packet filter tables
- ⏰ **Cron-based** - Automatic updates every 4 hours
- 📊 **Status monitoring** - Easy status checking and statistics
- 🧹 **Log management** - Automatic log rotation
- ✅ **Check_MK Monitoring**: Enterprise monitoring integration
- 🔧 **Easy management** - Simple install/uninstall scripts

## 🎯 Quick Start

### Installation
```bash
# Method 1: Direct download from GitHub releases
fetch https://github.com/somnium78/ipset-blacklists-service/releases/latest/download/ipset-blacklists-opnsense-2.0.17-opnsense.tar.gz
tar -xzf ipset-blacklists-opnsense-2.0.17-opnsense.tar.gz
cd ipset-blacklists-opnsense-2.0.17-opnsense

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
    - Name: blacklist_inbound
    - Type: URL Table (IPs)
    - Content: file:///var/db/blacklist/blacklist_current.txt
    - Update Frequency: every 2 hours
    - Description: Automated IP blacklist
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
    - Source: Select blacklist_inbound from dropdown
    - Destination: any
    - Log: ✓ (optional - for monitoring)
    - Description: Block blacklisted IPs
- Click "Save"
- Move rule to top for priority
- Click "Apply Changes"

### ⚡ Advanced pfctl Table Management

The service creates a pfctl table blacklist_inbound for advanced monitoring:
```bash
# View table contents
pfctl -t blacklist_inbound -T show | head -10

# Check table size
pfctl -t blacklist_inbound -T show | wc -l

# Table management (advanced)
pfctl -t blacklist_inbound -T flush    # Clear table
pfctl -t blacklist_inbound -T add 1.2.3.4  # Add IP

```
⚠️ Note: Firewall rules must be configured through OPNsense Web GUI!

### 🔧 Verification & Management
```bash
# Check service status
/usr/local/bin/ipset-blacklist-status

# Manual update
/usr/local/bin/ipset-blacklist-opnsense

# View logs
tail -f /var/log/blacklist.log

# Check persistent cron job
cat /usr/local/etc/cron.d/ipset-blacklist
```

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

## Monitoring with Check_MK
The service includes a Check_MK plugin that monitors:
- Entry Count: Number of blacklisted IPs
- pfctl Rules: Firewall rule presence
- Log Age: Last update timestamp
- Source Success: Blacklist source availability
- Cron Job: Automatic update configuration


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

# ⏰ Automatic Updates

- Update Frequency: Every 4 hours via persistent cron job
- Cron Location: /usr/local/etc/cron.d/ipset-blacklist
- Alias Refresh: Every 2 hours (set in Web GUI)
- Persistence: Survives reboots automatically
- Logging: All activities in /var/log/blacklist.log



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
- 🚫 No CLI Rules: Firewall rules configured via Web GUI only

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
# Web GUI: Firewall → Aliases → Edit blacklist_inbound → Refresh Frequency

# Force alias reload
pfctl -t blacklist_inbound -T replace -f /var/db/blacklist/blacklist_current.txt
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