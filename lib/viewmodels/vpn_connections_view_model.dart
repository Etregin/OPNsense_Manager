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

import '../models/system_info.dart';
import '../models/vpn_connection.dart';
import '../services/vpn/vpn_connection_manager.dart';
import '../services/demo_api_service.dart';
import 'base/base_list_view_model.dart';

/// ViewModel for the VPN connections coordinator screen
class VpnConnectionsViewModel extends BaseListViewModel<VPNConnection> {
  final DemoApiService _apiService;
  late final VPNConnectionManager _connectionManager;

  SystemInfo? _systemInfo;
  SystemInfo? get systemInfo => _systemInfo;

  VpnConnectionsViewModel(this._apiService) {
    _connectionManager = VPNConnectionManager(_apiService);
  }

  @override
  Future<List<VPNConnection>> fetchItems() async {
    final data = await _connectionManager.loadVPNConnections();
    _systemInfo = data.systemInfo;
    return data.connections;
  }

  @override
  bool matchesFilter(VPNConnection connection, String query) {
    final lower = query.toLowerCase();
    return connection.name.toLowerCase().contains(lower) ||
        connection.type.toLowerCase().contains(lower) ||
        connection.status.toLowerCase().contains(lower);
  }
}
