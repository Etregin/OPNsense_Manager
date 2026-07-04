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

import '../models/openvpn_client_override_list_item.dart';
import '../services/demo_api_service.dart';
import 'base/base_list_view_model.dart';

/// ViewModel for the OpenVPN client overrides list screen.
class OpenvpnClientOverridesViewModel
    extends BaseListViewModel<OpenvpnClientOverrideListItem> {
  final DemoApiService _apiService;
  final Set<String> _togglingOverrides = {};

  String statusFilter;
  int rowCount;

  /// API-level search phrase sent to the server (distinct from the client-side
  /// [searchQuery] from [BaseListViewModel] which filters already-loaded items).
  String apiSearchQuery;

  OpenvpnClientOverridesViewModel(
    this._apiService, {
    this.statusFilter = 'all',
    this.rowCount = 50,
    this.apiSearchQuery = '',
  });

  /// Whether the given override UUID is currently being toggled.
  bool isToggling(String uuid) => _togglingOverrides.contains(uuid);

  @override
  Future<List<OpenvpnClientOverrideListItem>> fetchItems() async {
    final response = await _apiService.searchClientOverrides(
      current: 1,
      rowCount: rowCount,
      searchPhrase: apiSearchQuery.isNotEmpty ? apiSearchQuery : null,
    );

    List<OpenvpnClientOverrideListItem> filtered = response.rows;

    if (statusFilter != 'all') {
      filtered = filtered
          .where((item) => statusFilter == 'enabled' ? item.enabled : !item.enabled)
          .toList();
    }

    return filtered;
  }

  @override
  bool matchesFilter(OpenvpnClientOverrideListItem override, String query) {
    final lower = query.toLowerCase();
    return override.commonName.toLowerCase().contains(lower) ||
        override.description.toLowerCase().contains(lower);
  }

  /// Toggle an override enabled/disabled state
  Future<void> toggleOverride(String uuid) async {
    if (_togglingOverrides.contains(uuid)) return;

    _togglingOverrides.add(uuid);
    notifyListeners();

    try {
      await _apiService.toggleClientOverride(uuid);
      await refresh();
    } finally {
      _togglingOverrides.remove(uuid);
      notifyListeners();
    }
  }

  /// Delete an override
  Future<void> deleteOverride(String uuid) async {
    await _apiService.deleteClientOverride(uuid);
    await refresh();
  }
}
