# Changelog

All notable changes to OPNsense Manager will be documented in this file.

## [1.6.1] - 2026-06-07

### Fixed
- Resolved an issue when enabling / disabling firewall alias indicating that the alias is getting deleted.
- Resolved a bug where firewall aliases where displaying UUID's instead of their names
- Resolved dhcp leases showing "Error type 'int' is not a subtype of type 'String?' in type cast" when kea DHCP is in use.
- Resolved a bug causing edited profiles not to show the changes instantly.
- Resolved a bug with wirgaurd status showing "Failed to load WireGuard status: type 'Null' is not a subtype of type 'String' in type cast"

## [1.6.0] - 2026-05-31

### Added

- Added WOL Support (Requires the os-wol to be pre-installed on opnsense)
- Added Wiregaurd to the VPN menu
- Added the ability to export either single profile or multiple profiles
- Added the Ability to select DHCP server type in the profile (dnsmasq, KEA and ISC) defaults to dnsmasq
- Added the ability to view and toggle firewall aliases, editing and adding aliases coming in the next patch

### Changed
- Self signed certificates are no longer enabled by default to avoid security issues / MITM attacks, If you are using Self signed certificate need to edit your profile and enable the toggle for it
- Adjusted the profiles to have multiple IPs / Ports for the same profile for different connection points 
- Added the option to edit profile at the profile selection screen
- Adjusted the buttons on profile creation / edit to either just save or save and connect
- Added the option to include / exclude credentials when exporting profiles, warning the user that credentials will be stored in plain text
- Restructured VPN to be a collapsable menu with all VPN options combined
- Restructured firewall to be a collapsable menu with all firewall options combined
- Adjusted the live firewall logs to show the rule that triggered the event, Now can click on any log lines showing in the firewall live logs to view the full details and copy

### Fixed
- Resturctured the code for better maintainability

### Known Issues
- Some items are not properly localized so might not translate which will be resolved in a seperate patch