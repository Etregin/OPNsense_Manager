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

import 'package:package_info_plus/package_info_plus.dart';

/// Provides the app version read at runtime from the platform package info,
/// eliminating the need to manually keep [AppConstants.appVersion] in sync
/// with [pubspec.yaml].
///
/// Initialise once in [main] before [runApp]:
/// ```dart
/// await AppVersionService().init();
/// ```
/// Then expose it via [Provider] so any widget can access it:
/// ```dart
/// context.read<AppVersionService>().version
/// ```
class AppVersionService {
  // ── Singleton ──────────────────────────────────────────────────────────────
  static final AppVersionService _instance = AppVersionService._internal();
  factory AppVersionService() => _instance;
  AppVersionService._internal();

  // ── State ──────────────────────────────────────────────────────────────────
  String _version = '';

  /// The app version string (e.g. `'1.7.2'`).
  /// Returns an empty string until [init] has been called.
  String get version => _version;

  // ── Initialisation ─────────────────────────────────────────────────────────

  /// Loads version info from the platform. Safe to call multiple times —
  /// subsequent calls are no-ops once the version has been loaded.
  Future<void> init() async {
    if (_version.isNotEmpty) return;
    final info = await PackageInfo.fromPlatform();
    _version = info.version;
  }
}
