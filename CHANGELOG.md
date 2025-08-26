# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [2.0.8] - 2025-08-26

### Fixed
- **OPNsense**: Fixed VERSION display showing only "-opnsense" instead of full version number
- **Documentation**: Corrected invalid pfctl firewall rule command in documentation
- **Documentation**: Clarified confusion between pfctl table `blacklist_inbound` and OPNsense alias `blacklist_ips`

### Added
- **Documentation**: Clear explanation of dual-system approach (pfctl + OPNsense alias)
- **Documentation**: Method recommendations (Web GUI vs Command Line)
- **Documentation**: Comprehensive setup guide with step-by-step instructions
- **Installation**: Enhanced setup guide created during installation at `/tmp/opnsense-setup-guide.txt`

### Changed
- **Documentation**: Removed incorrect pfctl firewall rule syntax
- **Documentation**: Emphasized Web GUI method as recommended approach
- **Build**: Improved VERSION handling in OPNsense build script
- **Installation**: Better user guidance during OPNsense installation process

### Clarified
- **OPNsense**: The service creates BOTH a pfctl table AND an OPNsense alias for maximum flexibility
- **Usage**: Web GUI method with `blacklist_ips` alias is recommended for most users
- **Advanced**: pfctl table `blacklist_inbound` available for command-line monitoring
- **Rules**: All firewall rules must be configured through OPNsense Web GUI, not command line

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
