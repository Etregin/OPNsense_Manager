<a id="readme-top"></a>

<div align="center">

# OPNsense Manager

A Flutter mobile application for managing OPNsense firewalls and routers.

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![License][license-shield]][license-url]

<p>
  <a href="https://play.google.com/store/apps/details?id=com.dt.opnsense_manager"><img src="https://raw.githubusercontent.com/Etregin/OPNsense_Manager/main/assets/getiton/GooglePlayStore.svg" alt="Get it on Google Play" height="40"></a>
  <a href="https://apps.apple.com/us/app/opnsense-manager/id6767634059"><img src="https://developer.apple.com/assets/elements/badges/download-on-the-app-store.svg" alt="Download on the App Store" height="50"></a>
  <a href="https://f-droid.org/en/packages/com.dt.opnsense_manager/"><img src="https://raw.githubusercontent.com/Etregin/OPNsense_Manager/main/assets/getiton/F-Droid.svg" alt="Get it on F-Droid" height="55"></a>
</p>

</div>

## About

OPNsense Manager lets you monitor and manage OPNsense from a mobile device. It supports firewall management, network monitoring, VPN management, services, profiles, and system information through the OPNsense API.

## Features

### Authentication and profiles

- API key and secret authentication.
- Multiple OPNsense profiles.
- Encrypted credential storage.
- Profile import and export.
- PIN and biometric app locking.
- Demo mode for exploring the app without a firewall connection.

### Dashboard and system

- System information, version, platform, uptime, and resource usage.
- Gateway and service status.
- Thermal sensor information where supported.
- Firmware update checks, live logs, upgrade detection, and reboot handling.
- Start, stop, restart, and inspect OPNsense services.

### Firewall

- Create, edit, delete, enable, and disable firewall rules.
- Automatic rules with read-only restrictions where applicable.
- Advanced rule options, protocols, ports, aliases, categories, and interfaces.
- Live firewall logs with filtering, search, detail views, and copy support.
- Firewall alias management with search, filtering, create, edit, delete, enable, disable, and detail views.
- Host, network, port, URL, GeoIP, and other alias types.
- Alias autocomplete, GeoIP region selection, URL authentication, expiry fields, and API validation.

### Network

- Live network monitoring with connection details, filtering, and device controls.
- DHCP lease management with search, supported DHCP backends, text selection, and long-press copy.
- Neighbor discovery with pagination, search, and service controls.
- Wake-on-LAN support where the OPNsense plugin is available.

### VPN

- OpenVPN instances, client overrides, connection status, and logs.
- WireGuard servers, peers, peer generation, status, and logs.
- Tailscale authentication, settings, status, and subnet management.

### Other

- Light and dark themes.
- Multiple languages.
- Configurable automatic refresh.
- Material Design interface for phones and supported screen sizes.

## Screenshots

> [Screenshot: Dashboard]

> [Screenshot: System Information and Firmware Updates]

> [Screenshot: Firewall Rules and Aliases]

> [Screenshot: Firewall Alias Editor]

> [Screenshot: Firewall Logs]

> [Screenshot: Live Network Monitor]

> [Screenshot: DHCP Leases and Neighbor Discovery]

> [Screenshot: VPN Management]

> [Screenshot: Services and Settings]

## Requirements

- OPNsense with API access enabled.
- An API key and secret.
- Android 5.0 or newer for Android builds.
- Flutter 3.44.2 or newer when building from source.

## OPNsense API Setup

1. Open **System → Access → Users** in OPNsense.
2. Create or edit the API user.
3. Generate an API key and secret.
4. Add the user to the **admins** group, or create a custom group with the permissions required by the features you use.

Use HTTPS whenever possible. If the OPNsense instance uses a self-signed certificate, enable the self-signed certificate option for the profile in the app.

## Installation

### Android

Download the app from [Google Play](https://play.google.com/store/apps/details?id=com.dt.opnsense_manager), [F-Droid](https://f-droid.org/en/packages/com.dt.opnsense_manager/), or the [latest GitHub release](https://github.com/Etregin/OPNsense_Manager/releases).

### Build from source

```bash
git clone https://github.com/Etregin/OPNsense_Manager.git
cd OPNsense_Manager
flutter pub get
flutter run
```

Build an APK with:

```bash
flutter build apk
```

## Security

- API credentials are stored using platform-specific encrypted storage.
- HTTPS is recommended for all API communication.
- Self-signed certificates are disabled by default.
- PIN and biometric locking protect local app access.
- Destructive actions require confirmation.
- Do not share API keys, secrets, or sensitive logs in issues or screenshots.

## Troubleshooting

### API connection issues

- Confirm the OPNsense address, port, API key, and secret.
- Check that the API user has the required permissions.
- Verify network access from the mobile device.
- Check the self-signed certificate setting if applicable.

### Biometric authentication issues

Confirm that biometrics are enabled on the device, enrolled, and available to the app. Use the configured PIN as a fallback.

### Service or firewall actions do not work

Check the API user's permissions and confirm that the relevant service, plugin, or OPNsense feature is installed and available.

## Support the Project

If you find OPNsense Manager useful, support its development:

**USDT / USDC:**

```text
0xe0b9015117a4a69131481c2e9c1553dde839df18
```

![Donation QR code](https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=0xe0b9015117a4a69131481c2e9c1553dde839df18)

Supported networks include BEP20, BSC, ERC20, Base, Polygon, Arbitrum, and Avalanche C-Chain. Binance gift cards can be sent to `etreginwow@gmail.com`.

## Contributing

1. Fork the repository.
2. Create a feature branch.
3. Make and test your changes.
4. Run `flutter analyze`.
5. Open a pull request with a clear description.

For bug reports, include the OPNsense version, app version, steps to reproduce, and relevant logs. Do not include credentials or other sensitive data.

## Architecture

The app uses Flutter with an MVVM structure. Screens, ViewModels, services, models, and shared widgets are organized under `lib/`.

## License

This project is licensed under the GNU General Public License v3.0. See [`LICENSE`](LICENSE).

## Support and Links

- [Report a bug](https://github.com/Etregin/OPNsense_Manager/issues)
- [Ask a question or start a discussion](https://github.com/Etregin/OPNsense_Manager/discussions)
- [View the project](https://github.com/Etregin/OPNsense_Manager)
- [Contributing guide](CONTRIBUTING.md)
- Report security issues to `Etreginwow@gmail.com` instead of using the issue tracker.

[contributors-shield]: https://img.shields.io/github/contributors/Etregin/OPNsense_Manager.svg?style=for-the-badge&color=green
[contributors-url]: https://github.com/Etregin/OPNsense_Manager/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/Etregin/OPNsense_Manager.svg?style=for-the-badge&color=blue
[forks-url]: https://github.com/Etregin/OPNsense_Manager/network/members
[stars-shield]: https://img.shields.io/github/stars/Etregin/OPNsense_Manager.svg?style=for-the-badge&color=yellow
[stars-url]: https://github.com/Etregin/OPNsense_Manager/stargazers
[issues-shield]: https://img.shields.io/github/issues/Etregin/OPNsense_Manager.svg?style=for-the-badge&color=red
[issues-url]: https://github.com/Etregin/OPNsense_Manager/issues
[license-shield]: https://img.shields.io/badge/License-GPLv3-blue
[license-url]: https://github.com/Etregin/OPNsense_Manager/blob/main/LICENSE
