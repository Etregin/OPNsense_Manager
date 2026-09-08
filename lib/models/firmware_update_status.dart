/*
 * OPNsense Manager - Flutter application for managing OPNsense firewalls
 * Copyright (C) 2026 OPNsense Manager
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

/// Firmware update status model.
///
/// Parsed from `GET /api/core/firmware/status` with optional changelog
/// data from `POST /api/core/firmware/changelog/{version}`.
class FirmwareUpdateStatus {
  /// The currently installed version (product.product_version).
  final String currentVersion;

  /// The latest available version (product.product_latest).
  final String latestVersion;

  /// Whether any updates are available (upgrade_packages or new_packages non-empty).
  final bool updatesAvailable;

  /// Whether a reboot is required after upgrade (needs_reboot == "1").
  final bool needsReboot;

  /// Human-readable download size string (download_size).
  final String downloadSize;

  /// Timestamp of the last firmware check (last_check).
  final String lastCheck;

  /// Number of packages to be upgraded (upgrade_packages.length).
  final int upgradeCount;

  /// Number of new packages to be installed (new_packages.length).
  final int newPackageCount;

  /// Packages to be upgraded. Each map has keys: name, current_version, new_version.
  final List<Map<String, String>> upgradePackages;

  /// New packages to be installed. Each map has keys: name, version.
  final List<Map<String, String>> newPackages;

  /// Plain text changelog (HTML tags stripped from changelog endpoint response).
  final String? changelogText;

  /// Changelog date string from the changelog endpoint.
  final String? changelogDate;

  const FirmwareUpdateStatus({
    required this.currentVersion,
    required this.latestVersion,
    required this.updatesAvailable,
    required this.needsReboot,
    required this.downloadSize,
    required this.lastCheck,
    required this.upgradeCount,
    required this.newPackageCount,
    required this.upgradePackages,
    required this.newPackages,
    this.changelogText,
    this.changelogDate,
  });

  /// Returns an "up to date" status with no pending packages.
  factory FirmwareUpdateStatus.noUpdates({
    String currentVersion = '',
    String latestVersion = '',
  }) {
    return FirmwareUpdateStatus(
      currentVersion: currentVersion,
      latestVersion: latestVersion,
      updatesAvailable: false,
      needsReboot: false,
      downloadSize: '',
      lastCheck: '',
      upgradeCount: 0,
      newPackageCount: 0,
      upgradePackages: const [],
      newPackages: const [],
    );
  }

  /// Total number of packages affected (upgraded + new).
  int get totalPackageCount => upgradeCount + newPackageCount;

  @override
  String toString() {
    return 'FirmwareUpdateStatus('
        'currentVersion: $currentVersion, '
        'latestVersion: $latestVersion, '
        'updatesAvailable: $updatesAvailable, '
        'upgradeCount: $upgradeCount, '
        'newPackageCount: $newPackageCount'
        ')';
  }
}
