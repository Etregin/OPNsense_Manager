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

import '../models/firewall_alias.dart';
import '../services/demo_api_service.dart';
import 'base/base_list_view_model.dart';

/// ViewModel for managing the firewall aliases list screen.
class FirewallAliasesViewModel extends BaseListViewModel<FirewallAlias> {
  final DemoApiService _apiService;
  final Set<String> _togglingAliases = {};

  FirewallAliasesViewModel(this._apiService);

  /// Whether the given alias UUID is currently being toggled.
  bool isToggling(String uuid) => _togglingAliases.contains(uuid);

  @override
  Future<List<FirewallAlias>> fetchItems() async {
    return _apiService.getFirewallAliases();
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
