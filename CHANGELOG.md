# 📋 Changelog

All notable changes to ipset-blacklists-service will be documented here.

## [2.0.1] - 2025-08-24

### 🐛 Fixed
- **Installation bug** - Create required directories during installation
- **Systemd service failure** - `/tmp/ipset-blacklist` directory now created by installer
- **Fresh install issue** - Service now starts correctly on first boot without manual intervention

### 🔧 Changed
- **install.sh** - Added creation of `/tmp/ipset-blacklist` and `/var/lib/ipset-blacklist` directories
- **Directory permissions** - Set proper permissions (755) for work directories

## [2.0.0] - 2025-08-24

### 🎉 Initial Release

**Complete rewrite** of ipset blacklist service with professional features.

### ✨ Added
- 🔄 **Diff-based updates** - Only processes IP changes, dramatically faster updates
- 🚀 **Boot recovery** - Automatically restores ipset after system reboot
- ⏰ **Systemd integration** - Full systemd service and timer support
- 📊 **Check_MK monitoring** - Professional monitoring plugin included
- 🧹 **Log rotation** - Automatic log management with logrotate
- 🔧 **Management scripts** - Status, cleanup, and maintenance tools
- 📦 **Easy installation** - Automated install/uninstall scripts
- 🛡️ **Security hardening** - Systemd security settings applied

### 🏗️ Architecture
- **Main service:** `ipset-blacklist-service` with diff algorithm
- **Boot service:** `ipset-blacklist-boot.service` for system startup
- **Update service:** `ipset-blacklist-update.service` for scheduled updates  
- **Timer:** `ipset-blacklist-update.timer` runs every 4 hours
- **Status tool:** `ipset-blacklist-status` for monitoring
- **Cleanup tool:** `ipset-blacklist-cleanup` for maintenance

### 📊 Default Sources
- **Spamhaus DROP** - Known malicious networks
- **Firehol Blocklist.de** - Recent bot attacks (48h)
- **AbuseIPDB** - High confidence IPs (optional, large list)

### 🔧 Technical Details
- **Diff algorithm** reduces update time from 10+ minutes to <30 seconds
- **Boot recovery** preserves blacklist across reboots
- **Systemd hardening** with security restrictions
- **Professional logging** with rotation and monitoring
- **Modular configuration** for easy customization

### 📁 File Structure
```
├── usr/local/bin/ # Main scripts
├── etc/ipset-blacklist/ # Configuration
├── systemd/system/ # Systemd integration
├── etc/logrotate.d/ # Log rotation
└── usr/lib/check_mk_agent/ # Monitoring plugin
```

### 🎯 Performance
- **Small lists** (2k entries): ~6 seconds
- **Large lists** (200k entries): ~10 minutes first run, <30 seconds updates
- **Memory efficient** with ipset hash tables
- **Network optimized** with timeout and retry logic

---

*This project follows [Semantic Versioning](https://semver.org/)*