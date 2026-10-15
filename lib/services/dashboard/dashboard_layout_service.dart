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

import 'dart:convert';

import '../../models/dashboard_layout.dart';
import '../storage_service.dart';

/// Persists and loads per-profile dashboard layouts using [StorageService].
class DashboardLayoutService {
  final StorageService _storageService;

  DashboardLayoutService(this._storageService);

  static String _key(String profileId) => 'dashboard_layout_$profileId';

  /// Loads the saved layout for [profileId], or returns defaults if none saved.
  /// Also merges in any new card types that were added after the layout was saved.
  Future<DashboardLayout> loadLayout(String profileId) async {
    try {
      final json = await _storageService.loadString(_key(profileId));
      if (json == null) return DashboardLayout.defaults();
      final decoded = jsonDecode(json) as Map<String, dynamic>;
      return DashboardLayout.fromJson(decoded).mergedWithDefaults();
    } catch (_) {
      return DashboardLayout.defaults();
    }
  }

  /// Saves [layout] for [profileId].
  Future<void> saveLayout(String profileId, DashboardLayout layout) async {
    final json = jsonEncode(layout.toJson());
    await _storageService.saveString(_key(profileId), json);
  }
}
