# 🛡️ ipset Blacklist Service

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Version](https://img.shields.io/github/v/release/somnium78/ipset-blacklists-service)](https://github.com/somnium78/ipset-blacklists-service/releases)
[![Platform](https://img.shields.io/badge/platform-Linux-lightgrey)](https://github.com/somnium78/ipset-blacklists-service)
[![Systemd](https://img.shields.io/badge/systemd-compatible-green)](https://systemd.io/)
[![CrowdSec](https://img.shields.io/badge/CrowdSec-compatible-orange)](https://crowdsec.net/)

Professional systemd-integrated IP blacklist service with diff-based updates and boot recovery.

## ✨ Features

- 🔄 **Diff-based updates** - Only processes changes, not entire lists
- 🚀 **Boot recovery** - Automatically restores ipset after reboot
- ⏰ **Systemd integration** - Timer-based automatic updates every 4 hours
- 📊 **Monitoring** - Check_MK plugin included
- 🧹 **Log rotation** - Automatic log management
- 🔧 **Easy management** - Simple install/uninstall scripts

## 🎯 Quick Start

### Installation

1. **Clone repository:**
```bash
git clone https://github.com/somnium78/ipset-blacklists-service.git
cd ipset-blacklists-service
```

2. **Install service:**
```bash
sudo ./install.sh
```

3. **Start services:**
```bash
sudo systemctl start ipset-blacklist-boot.service
sudo systemctl start ipset-blacklist-update.timer
```

### Usage

- **Check status:** `sudo /usr/local/bin/ipset-blacklist-status`
- **Manual update:** `sudo /usr/local/bin/ipset-blacklist-service`
- **Cleanup:** `sudo /usr/local/bin/ipset-blacklist-cleanup`

## 📋 Requirements

- Linux with ipset and iptables support
- systemd
- wget, awk, sed, sort, wc
- Root privileges for installation

## ⚙️ Configuration

Edit `/etc/ipset-blacklist/blacklist-sources.conf` to customize blacklist sources.

**Default sources:**
- 🚫 Spamhaus DROP list
- 🤖 Firehol Blocklist.de Bots
- 💀 AbuseIPDB (optional, large list)

## 📊 Monitoring

**Check_MK plugin** automatically installed to `/usr/lib/check_mk_agent/local/ipset_blacklist`

**Status codes:**
- ✅ **OK** - Service running normally
- ⚠️ **WARNING** - Low entry count or missing iptables rule
- ❌ **CRITICAL** - ipset missing or no entries

## 🔧 Systemd Services

- **ipset-blacklist-boot.service** - Boot recovery service
- **ipset-blacklist-update.service** - Update service
- **ipset-blacklist-update.timer** - Automatic updates every 4 hours

## 📝 Log Files

- **Service logs:** `/var/log/ipset-blacklist.log`
- **Systemd logs:** `journalctl -u ipset-blacklist-*`

## 🗂️ File Locations

- **Scripts:** `/usr/local/bin/ipset-blacklist-*`
- **Configuration:** `/etc/ipset-blacklist/`
- **Work directory:** `/var/lib/ipset-blacklist/`
- **Systemd files:** `/etc/systemd/system/ipset-blacklist-*`

## 💬 Support

- Create an issue on GitHub for bugs or feature requests
- Check the troubleshooting section for common problems
- Review logs in `/var/log/ipset-blacklist.log`

## 🙏 Acknowledgments

- **AbuseIPDB**: For providing high-quality threat intelligence
- **Spamhaus**: For reliable DROP and EDROP lists
- **Firehol**: For community-maintained blacklists
- **CheckMK Community**: For monitoring integration support
- **CrowdSec**: For security stack integration
- **trick77/ipset-blacklist**: For inspiration and foundational concepts

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request


## 🚨 Uninstallation
```bash
sudo ./uninstall.sh
```

## 📄 License

GPL-3.0 License - see [LICENSE](LICENSE) file for details.

## 🔗 Links

- **Repository:** https://github.com/somnium78/ipset-blacklists-service
- **Issues:** https://github.com/somnium78/ipset-blacklists-service/issues
- **Releases:** https://github.com/somnium78/ipset-blacklists-service/releases

---

**🚀 Ready for production deployment!**

For support and updates, visit: [https://github.com/somnium78/ipset-blacklists-service](https://github.com/somnium78/ipset-blacklists-service)
