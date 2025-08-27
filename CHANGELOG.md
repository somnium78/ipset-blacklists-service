# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.14] - 2025-08-27

### Added
- **Monitoring**: Complete Check_MK integration for OPNsense deployments
- **Monitoring**: Tracks entry count, pfctl rules, log age, source success rate, and cron job status
- **Installation**: Automatic Check_MK plugin deployment during installation
- **Documentation**: Comprehensive OPNsense README with monitoring section
- **Uninstall**: Enhanced uninstall script with Check_MK plugin removal

### Enhanced
- **Installation**: Check_MK agent detection and automatic plugin installation
- **Monitoring**: FreeBSD-specific monitoring with pfctl table checks
- **Documentation**: Complete monitoring setup and troubleshooting guide
- **Uninstall**: Interactive confirmation for data removal

### Fixed
- **Monitoring**: FreeBSD-compatible stat commands for log age detection
- **Monitoring**: pfctl rule detection instead of iptables
- **Installation**: Proper Check_MK plugin permissions and location

### Technical Details
- Check_MK plugin monitors pfctl tables instead of ipset
- FreeBSD-specific file stat commands (`stat -f %m`)
- Automatic detection of Check_MK agent directory
- Professional monitoring thresholds and performance data

## [2.0.13] - 2025-08-27

### Fixed
- **Status**: Cron job detection now checks correct location `/usr/local/etc/cron.d/`
- **Status**: Enhanced cron service status detection with PID display
- **Status**: FreeBSD-compatible system log checking for cron activity
- **Diagnostics**: Better cron job schedule display and next run calculation

### Enhanced
- **Status**: More detailed cron job information and diagnostics
- **Logging**: FreeBSD-specific log file locations for cron monitoring
- **Documentation**: Improved troubleshooting information

### Technical Details
- Fixed cron job detection path in status script
- Added FreeBSD-specific process checking with `pgrep`
- Enhanced system log analysis for cron execution tracking

## [2.0.12] - 2025-08-27

### Fixed
- **Performance**: Restored original fast pfctl bulk operations (reverted from slow individual IP additions)
- **Performance**: Script now completes in ~2 seconds instead of 30-60 seconds for 22,000+ IPs
- **Naming**: All references now consistently use `blacklist_inbound` (eliminated remaining `blacklist_ips` references)
- **Version**: Proper version file integration with fallback to embedded version

### Changed
- **OPNsense**: Reverted to proven v2.0.8 performance architecture with v2.0.11+ fixes
- **pfctl**: Uses bulk operations (`pfctl -t table -T add -f file`) instead of individual IP loops
- **Logging**: All user messages now reference `blacklist_inbound` consistently
- **Version**: Enhanced version handling with `/usr/local/etc/blacklist_version` file

### Performance
- **Initial Load**: ~2 seconds for 22,424 IPs (was 30-60 seconds)
- **Differential Updates**: Bulk add/remove operations for maximum efficiency
- **Memory**: Optimized temporary file handling and cleanup

### Technical Details
- Restored original AWK-based config parser (fast and reliable)
- Maintained 4-line configuration format compatibility
- Enhanced error handling with performance optimizations
- Proper FreeBSD/OPNsense compatibility maintained

## [2.0.11] - 2025-08-27

### Fixed
- **OPNsense**: VERSION file now created in `/usr/local/etc/blacklist_version`
- **Naming**: All output messages now use 'blacklist_inbound' consistently
- **Installation**: Enhanced version file creation during installation

### Added
- **Version**: Embedded version fallback if file doesn't exist
- **Build**: Version file creation in build and install scripts

### Changed
- **Output**: All user-facing messages reference `blacklist_inbound`
- **Installation**: Version file properly managed during installation

## [2.0.10] - 2025-08-27

### Fixed
- **OPNsense**: Cron job now persistent in `/usr/local/etc/cron.d/` - survives reboots
- **Documentation**: Fixed wildcard URLs that don't work with `fetch`/`wget` commands
- **Naming**: Unified all references to use `blacklist_inbound` (eliminated confusion)

### Added
- **OPNsense**: Persistent cron job configuration in system directory
- **Documentation**: Alternative installation methods (latest vs specific version)

### Changed
- **OPNsense**: Cron job location moved from user crontab to `/usr/local/etc/cron.d/ipset-blacklist`
- **URLs**: Replaced wildcard download URLs with working concrete versions

## [2.0.9] - 2025-08-26

### Fixed
- **Documentation**: Fixed wildcard URLs that don't work with `fetch`/`wget` commands
- **Documentation**: All download links now use concrete version numbers
- **Naming**: Unified all references to use `blacklist_inbound` (eliminated confusion)

### Added
- **Documentation**: Alternative installation methods (latest vs specific version)
- **Installation**: Better cron service restart handling

### Changed
- **Documentation**: All aliases and references now consistently use `blacklist_inbound`
- **URLs**: Replaced wildcard download URLs with working concrete versions

## [2.0.8] - 2025-08-26

### Fixed
- **OPNsense**: Fixed VERSION display showing only "-opnsense" instead of full version number
- **Documentation**: Corrected invalid pfctl firewall rule command in documentation
- **Documentation**: Clarified confusion between pfctl table `blacklist_inbound` and OPNsense alias

### Added
- **Documentation**: Clear explanation of dual-system approach (pfctl + OPNsense alias)
- **Documentation**: Method recommendations (Web GUI vs Command Line)
- **Installation**: Enhanced setup guide created during installation

### Changed
- **Documentation**: Removed incorrect pfctl firewall rule syntax
- **Documentation**: Emphasized Web GUI method as recommended approach

## [2.0.7] - 2025-08-25

### Fixed
- **OPNsense**: Fixed system detection to use correct path `/usr/local/opnsense/version/base`
- **OPNsense**: Embedded VERSION directly in binary to eliminate "VERSION file not found" error
- **OPNsense**: Improved installation script with better error handling and feedback

### Added
- **Documentation**: Comprehensive OPNsense setup guide with critical alias refresh configuration
- **Documentation**: Detailed troubleshooting section for OPNsense deployments
- **OPNsense**: Automatic cronjob configuration during installation (every 4 hours)

### Changed
- **OPNsense**: Installation process now runs without warnings on proper OPNsense systems
- **Documentation**: Emphasized critical 2-hour alias refresh frequency requirement

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

### Added
- **Core**: Multi-source blacklist aggregation system
- **Sources**: Integration with Spamhaus, Firehol, GreenSnow, and Blocklist.de
- **Linux**: Complete systemd integration with boot and update services
- **Linux**: Professional DEB package with proper dependencies
- **Management**: Cleanup utilities and status monitoring tools

### Enhanced
- **Performance**: Efficient ipset management with hash:net tables
- **Reliability**: Atomic updates to prevent service interruption
- **Documentation**: Complete installation and usage documentation

## [2.0.0] - 2025-08-24

### Added
- **Architecture**: Complete rewrite for production environments
- **Multi-Platform**: Native support for Linux (ipset) and OPNsense (pfctl)
- **Automation**: Systemd timers and cron-based automatic updates
- **Professional**: Enterprise-grade logging, monitoring, and error handling
- **Packaging**: Professional DEB packages and OPNsense-compatible tarballs

### Changed
- **Breaking**: Complete API and configuration format changes
- **Performance**: Switched to differential updates for efficiency
- **Security**: Enhanced input validation and sanitization
- **Reliability**: Atomic operations and rollback capabilities

---

## Version History Summary

- **2.0.14**: Check_MK monitoring integration and enhanced uninstall
- **2.0.13**: Fixed cron job detection and enhanced diagnostics
- **2.0.12**: Performance restoration and consistency fixes
- **2.0.11**: VERSION file handling and naming consistency
- **2.0.10**: Persistent cron job and documentation fixes
- **2.0.9**: Unified naming and URL fixes
- **2.0.8**: Documentation fixes and VERSION display correction
- **2.0.7**: OPNsense fixes and comprehensive documentation
- **2.0.6**: Build system improvements and VERSION file handling
- **2.0.5**: Complete automated CI/CD pipeline
- **2.0.4**: Initial automated build system
- **2.0.3**: OPNsense port and dual-platform support
- **2.0.2**: Professional logging and monitoring
- **2.0.1**: Multi-source integration and systemd
- **2.0.0**: Production rewrite and multi-platform architecture

## Links

- [GitHub Repository](https://github.com/somnium78/ipset-blacklists-service)
- [Latest Release](https://github.com/somnium78/ipset-blacklists-service/releases/latest)
- [Issues](https://github.com/somnium78/ipset-blacklists-service/issues)
