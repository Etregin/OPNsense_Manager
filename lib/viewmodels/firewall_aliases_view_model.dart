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

import 'package:flutter/material.dart';
import '../models/firewall_alias.dart';
import '../services/demo_api_service.dart';
import 'base/base_list_view_model.dart';

/// Resolved display info for a category (for the list screen).
class AliasCategoryInfo {
  final String uuid;
  final String name;
  final Color color;
  const AliasCategoryInfo({required this.uuid, required this.name, required this.color});
}

/// ViewModel for managing the firewall aliases list screen.
class FirewallAliasesViewModel extends BaseListViewModel<FirewallAlias> {
  final DemoApiService _apiService;
  final Set<String> _togglingAliases = {};

  /// UUID → resolved category info (name + color).
  Map<String, AliasCategoryInfo> _categoryMap = {};
  Map<String, AliasCategoryInfo> get categoryMap => _categoryMap;

  FirewallAliasesViewModel(this._apiService);

  /// Whether the given alias UUID is currently being toggled.
  bool isToggling(String uuid) => _togglingAliases.contains(uuid);

  @override
  Future<List<FirewallAlias>> fetchItems() async {
    // Load categories in parallel with aliases so color info is ready.
    final results = await Future.wait([
      _apiService.getFirewallAliases(),
      _loadCategories(),
    ]);
    return results[0] as List<FirewallAlias>;
  }

  Future<void> _loadCategories() async {
    try {
      final cats = await _apiService.listAliasCategories();
      _categoryMap = {
        for (final c in cats)
          c.name: AliasCategoryInfo(
            uuid: c.name,
            name: c.description,
            color: _parseHexColor(c.color),
          ),
      };
    } catch (_) {
      _categoryMap = {};
    }
  }

  /// Parse a 6-char hex color string (no #) from list_categories `color` field.
  /// Falls back to the theme primary blue if invalid.
  static Color _parseHexColor(String hex) {
    try {
      final clean = hex.replaceAll('#', '').padLeft(6, '0');
      return Color(int.parse('FF$clean', radix: 16));
    } catch (_) {
      return const Color(0xFF579BFC);
    }
  }

  @override
  bool matchesFilter(FirewallAlias alias, String query) {
    final lower = query.toLowerCase();
    return alias.name.toLowerCase().contains(lower) ||
        alias.description.toLowerCase().contains(lower) ||
        alias.content.toLowerCase().contains(lower);
  }

  /// Toggle an alias enabled/disabled state
  Future<void> toggleAlias(String uuid) async {
    if (_togglingAliases.contains(uuid)) return;

    _togglingAliases.add(uuid);
    notifyListeners();

    try {
      await _apiService.toggleFirewallAlias(uuid);
      await refresh();
    } finally {
      _togglingAliases.remove(uuid);
      notifyListeners();
    }
  }

  /// Delete an alias
  Future<void> deleteAlias(String uuid) async {
    await _apiService.deleteFirewallAlias(uuid);
    await refresh();
  }
}
