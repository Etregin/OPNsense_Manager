# Changelog

All notable changes to OPNsense Manager will be documented in this file.

## [1.8.0] -

### Added

- Added access to system log files (Audit, Backend, Boot, General, and Web GUI) with severity filtering, time range, and pagination.
- Added firmware updates with live logs, upgrade detection, and reboot handling.
- Added firewall alias management with create, edit, detail, filtering, and type-specific forms.
- Added alias autocomplete, GeoIP region selection, authentication fields, and inline API validation.

### Changed

- Refactored colors, constants, localization, ViewModels, validation, and shared widgets.
- Added long-press copying and text selection to DHCP leases.
- Added automatic firewall rules to the rule list and expanded rule editing to match the GUI/API options.
- Updated the minimum Flutter version and release version.

### Fixed

- Removed the misplaced refresh button from Neighbor Discovery.
- Made conditional WireGuard status fields nullable to prevent API deserialization errors.

## [1.8.0-Beta.1] -

### Changed

- Comprehensive refactor of the codebase covering color token migration, constants extraction, l10n cleanup, ViewModel pattern adoption, and shared utility/widget extraction.

### Fixed

- Removed the incorrectly placed floating refresh button from the neighbor discovery screen.
- Adjusted all conditionally-present fields in WireGuardStatusItem nullable to prevent runtime errors when the OPNsense API omits peer-only or interface-only fields.

## [1.7.2] -

### Changed
- Updated minimum Flutter SDK version to 3.44.2
- Updated dependency versions for improved compatibility

## [1.7.1] -

### Changed
- Adjusted gradle file to include an fdroid flavor to support fdroid builds.

## [1.7.0] - 

### Added
- Added Automatic neighbor discovery with pagination, the ability to search and start / stop / restart the service
- Added Thermal Sensors information on the dashboard screen for applicable systems (Will not work with VMs)

### Changed
- Adjusted the services section to show the description instead of the name to mimic the opnsense GUI
- Adjusted Logo and added multiple options to work smoother and look cleaner on different operating systems

### Fixed
- Resolved an issue on older android devices (Android 10) being unable to export profiles due to permission issues
- Resolved a bug for KEA DHCP not displaying the proper lease type

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