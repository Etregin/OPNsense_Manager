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

import '../models/wireguard_server.dart';
import '../services/demo_api_service.dart';
import 'base/base_list_view_model.dart';

/// ViewModel for managing the WireGuard servers list screen.
class WireGuardServersViewModel extends BaseListViewModel<WireGuardServer> {
  final DemoApiService _apiService;
  final Set<String> _togglingServers = {};

  WireGuardServersViewModel(this._apiService);

  /// Whether the given server UUID is currently being toggled.
  bool isToggling(String uuid) => _togglingServers.contains(uuid);

  @override
  Future<List<WireGuardServer>> fetchItems() async {
    return _apiService.getWireGuardServers();
  }

  @override
  bool matchesFilter(WireGuardServer server, String query) {
    final lower = query.toLowerCase();
    return server.name.toLowerCase().contains(lower) ||
        server.tunnelAddressList.any((addr) => addr.toLowerCase().contains(lower)) ||
        server.port.contains(lower);
  }

  /// Toggle a server enabled/disabled state
  Future<void> toggleServer(String uuid, bool currentlyEnabled) async {
    if (_togglingServers.contains(uuid)) return;

    _togglingServers.add(uuid);
    notifyListeners();

    try {
      await _apiService.toggleWireGuardServer(uuid, !currentlyEnabled);
      await refresh();
    } finally {
      _togglingServers.remove(uuid);
      notifyListeners();
    }
  }

  /// Delete a server
  Future<void> deleteServer(String uuid) async {
    await _apiService.deleteWireGuardServer(uuid);
    await refresh();
  }
}
