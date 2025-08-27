# 🛡️ ipset Blacklist Service

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Version](https://img.shields.io/github/v/release/somnium78/ipset-blacklists-service)](https://github.com/somnium78/ipset-blacklists-service/releases)
[![Platform](https://img.shields.io/badge/platform-Linux-lightgrey)](https://github.com/somnium78/ipset-blacklists-service)
[![Systemd](https://img.shields.io/badge/systemd-compatible-green)](https://systemd.io/)

Professional systemd-integrated IP blacklist service with diff-based updates and boot recovery.

## ✨ Features

- 🔄 **Diff-based updates** - Only processes changes, not entire lists
- 🚀 **Boot recovery** - Automatically restores ipset after reboot
- ⏰ **Systemd integration** - Timer-based automatic updates every 4 hours
- 📊 **Monitoring** - Check_MK plugin included
- 🧹 **Log rotation** - Automatic log management
- 🔧 **Easy management** - Simple install/uninstall scripts
- 📦 DEB package - Professional package management

# 🎯 Quick Start

## 📦 Installation via DEB Package (Recommended)
```bash
# Download latest release:
wget https://github.com/somnium78/ipset-blacklists-service/releases/latest/download/ipset-blacklists-service_2.0.7_all.deb

# Install package:
sudo dpkg -i ipset-blacklists-service_2.0.7_all.deb

# Start services:
sudo systemctl start ipset-blacklist-boot.service sudo systemctl start ipset-blacklist-update.timer
```


## Manual Installation
```bash
# Clone repository:
git clone https://github.com/somnium78/ipset-blacklists-service.git
cd ipset-blacklists-service

# Install service:
sudo ./install.sh

# Start services:
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

## 🔥 OPNsense Port

**NEW:** Native OPNsense/FreeBSD port available!

### 📦 OPNsense Installation

1. **Download OPNsense package:**
fetch https://github.com/somnium78/ipset-blacklists-service/releases/latest/download/ipset-blacklists-opnsense-2.0.13-opnsense.tar.gz
2. **Extract and install:**
tar -xzf ipset-blacklists-opnsense-2.0.13-opnsense.tar.gz
cd ipset-blacklists-opnsense-2.0.13-opnsense
sudo ./scripts/install-opnsense.sh
3. **Add firewall rule:**
Create Alias + Firewall Rule via Web GUI, see [OPNsense README](opnsense-port/docs/README-OPNsense.md)


### 🎯 OPNsense Features

- ✅ **pfctl tables** instead of ipset
- ✅ **Native FreeBSD** compatibility  
- ✅ **Cron-based** automatic updates
- ✅ **Same diff-logic** as Linux version
- ✅ **Easy installation** and management

**Documentation:** [OPNsense README](opnsense-port/docs/README-OPNsense.md)
