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

import '../models/openvpn_instance_list_item.dart';
import '../services/demo_api_service.dart';
import 'base/base_list_view_model.dart';

/// ViewModel for the OpenVPN instances list screen.
class OpenvpnInstancesViewModel extends BaseListViewModel<OpenvpnInstanceListItem> {
  final DemoApiService _apiService;
  final Set<String> _togglingInstances = {};

  String roleFilter;
  String statusFilter;
  int rowCount;

  /// API-level search phrase sent to the server (distinct from the client-side
  /// [searchQuery] from [BaseListViewModel] which filters already-loaded items).
  String apiSearchQuery;

  OpenvpnInstancesViewModel(
    this._apiService, {
    this.roleFilter = 'all',
    this.statusFilter = 'all',
    this.rowCount = 50,
    this.apiSearchQuery = '',
  });

  /// Whether the given instance UUID is currently being toggled.
  bool isToggling(String uuid) => _togglingInstances.contains(uuid);

  @override
  Future<List<OpenvpnInstanceListItem>> fetchItems() async {
    final String? enabledParam = statusFilter == 'all'
        ? null
        : (statusFilter == 'enabled' ? '1' : '0');
    final String? searchParam = apiSearchQuery.isEmpty ? null : apiSearchQuery;

    final response = await _apiService.searchOpenvpnInstances(
      current: 1,
      rowCount: rowCount == -1 ? 9999 : rowCount,
      searchPhrase: searchParam,
      enabled: enabledParam,
    );

    List<OpenvpnInstanceListItem> filteredInstances = roleFilter == 'all'
        ? response.rows
        : response.filterByRole(roleFilter);

    if (statusFilter != 'all') {
      filteredInstances = filteredInstances
          .where((item) => statusFilter == 'enabled' ? item.enabled : !item.enabled)
          .toList();
    }

    return filteredInstances;
  }

  @override
  bool matchesFilter(OpenvpnInstanceListItem instance, String query) {
    final lower = query.toLowerCase();
    return instance.description.toLowerCase().contains(lower) ||
        instance.vpnid.toLowerCase().contains(lower) ||
        instance.role.toLowerCase().contains(lower);
  }

  /// Toggle an instance enabled/disabled state
  Future<void> toggleInstance(String uuid) async {
    if (_togglingInstances.contains(uuid)) return;

    _togglingInstances.add(uuid);
    notifyListeners();

    try {
      await _apiService.toggleOpenvpnInstance(uuid);
      await _apiService.reconfigureOpenvpn();
      await refresh();
    } finally {
      _togglingInstances.remove(uuid);
      notifyListeners();
    }
  }

  /// Delete an instance
  Future<void> deleteInstance(String uuid) async {
    await _apiService.deleteOpenvpnInstance(uuid);
    await refresh();
  }
}
