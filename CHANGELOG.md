# 📋 Changelog

All notable changes to ipset-blacklists-service will be documented here.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).


## [2.0.7] - 2025-08-25

### Fixed
- **OPNsense**: Fixed system detection to use correct path `/usr/local/opnsense/version/base`
- **OPNsense**: Embedded VERSION directly in binary to eliminate "VERSION file not found" error
- **OPNsense**: Improved installation script with better error handling and feedback

### Added
- **Documentation**: Comprehensive OPNsense setup guide with critical alias refresh configuration
- **Documentation**: Detailed troubleshooting section for OPNsense deployments
- **Documentation**: Performance metrics and monitoring guidelines
- **OPNsense**: Automatic cronjob configuration during installation (every 4 hours)

### Changed
- **OPNsense**: Installation process now runs without warnings on proper OPNsense systems
- **Documentation**: Emphasized critical 2-hour alias refresh frequency requirement
- **Build**: OPNsense package no longer requires external VERSION file

## [2.0.6] - 2025-08-24

### Fixed
- **Build**: Include VERSION file in OPNsense package to prevent runtime errors
- **OPNsense**: Improved system detection logic

### Added
- **Build**: Better OPNsense package structure with all required files

## [2.0.5] - 2025-08-24

### Added
- **CI/CD**: Complete automated multi-platform build system
- **Build**: Professional DEB package creation with proper dependencies
- **Build**: OPNsense tarball package with FreeBSD compatibility
- **Release**: Automated GitHub releases with both Linux and OPNsense packages

### Fixed
- **Build**: Corrected file paths in build scripts to match actual repository structure
- **Build**: Proper inclusion of all required files (binaries, configs, systemd units)

### Changed
- **Versioning**: Centralized version management through single VERSION file
- **CI/CD**: GitHub Actions workflow for automated builds on tag creation

## [2.0.4] - 2025-08-24

### Added
- **Core**: Initial automated build system setup
- **Documentation**: Comprehensive README with installation instructions
- **Build**: Basic build scripts for both platforms

### Fixed
- **Build**: Repository structure cleanup and organization

## [2.0.3] - 2025-08-24

### Added
- **OPNsense**: Complete FreeBSD/OPNsense port with pfctl integration
- **OPNsense**: Dual-mode operation (pfctl tables + OPNsense aliases)
- **OPNsense**: Native FreeBSD installation and uninstallation scripts
- **Monitoring**: Check_MK agent integration for both Linux and OPNsense

### Enhanced
- **Core**: Improved error handling and logging across all platforms
- **Performance**: Optimized differential updates for large blacklists
- **Documentation**: Platform-specific installation guides

## [2.0.2] - 2025-08-24

### Added
- **Core**: Professional logging system with timestamps and structured output
- **Core**: Comprehensive status reporting with detailed statistics
- **Security**: Input validation and sanitization for all external data
- **Performance**: Differential update system to minimize network usage

### Enhanced
- **Reliability**: Robust error handling with graceful degradation
- **Monitoring**: Detailed success/failure tracking per blacklist source
- **Usability**: Color-coded status output and clear user feedback

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