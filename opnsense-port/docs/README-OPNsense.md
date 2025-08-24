# 🛡️ ipset Blacklist Service - OPNsense Port

Professional blacklist service for OPNsense using pfctl tables instead of ipset.

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
# Download from GitHub releases or clone repository
cd opnsense-port

# Install
./scripts/install-opnsense.sh

# Run initial update
/usr/local/bin/ipset-blacklist-opnsense

# Add firewall rule
pfctl -f /dev/stdin <<; EOF
block in quick on \$ext_if from <blacklist_inbound> to any
EOF
# Or via OPNsense Web GUI (permanent)
# Firewall → Rules → WAN → Add Rule
# Action: Block, Source: blacklist_inbound (table)
```

Usage

    Check status: sudo /usr/local/bin/ipset-blacklist-status
    Manual update: sudo /usr/local/bin/ipset-blacklist-opnsense
    View table: pfctl -t blacklist_inbound -T show | head -10
    Cleanup: sudo /usr/local/bin/ipset-blacklist-cleanup

📋 Requirements

    OPNsense (or FreeBSD with pfctl)
    Root privileges for installation
    Internet access for downloading blacklists
    fetch utility (included in FreeBSD)

⚙️ Configuration

Edit /usr/local/etc/blacklist-sources.conf to customize blacklist sources.

Default sources:
- 🚫 Spamhaus DROP/EDROP lists
- 🤖 Firehol Blocklist.de Bots
- 💚 GreenSnow Blacklist
📊 Monitoring

Status command: /usr/local/bin/ipset-blacklist-status

Shows:
- ✅ pfctl table status and entry count
- 📊 Last update statistics
- ⏰ Cron job status
- 🔥 Firewall rule integration
- 📝 Recent log entries
🔧 Files and Locations

    Scripts: /usr/local/bin/ipset-blacklist-*
    Configuration: /usr/local/etc/blacklist-sources.conf
    Work directory: /var/db/blacklist/
    Log file: /var/log/blacklist.log
    pfctl table: blacklist_inbound

🔥 Firewall Integration


