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

import '../models/wireguard_peer.dart';
import '../services/demo_api_service.dart';
import 'base/base_list_view_model.dart';

/// ViewModel for managing WireGuard peers list
class WireGuardPeersViewModel extends BaseListViewModel<WireGuardPeer> {
  final DemoApiService _apiService;
  final Set<String> _togglingPeers = {};

  WireGuardPeersViewModel(this._apiService);

  /// Check if a peer is currently being toggled
  bool isToggling(String uuid) => _togglingPeers.contains(uuid);

  @override
  Future<List<WireGuardPeer>> fetchItems() async {
    final response = await _apiService.searchWireGuardPeers(
      current: 1,
      rowCount: 1000, // Get all peers
    );

    if (response.containsKey('rows') && response['rows'] is List) {
      final rows = response['rows'] as List;
      return rows
          .map((row) => WireGuardPeer.fromJson(row as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  @override
  bool matchesFilter(WireGuardPeer peer, String query) {
    final lowerQuery = query.toLowerCase();
    return peer.name.toLowerCase().contains(lowerQuery) ||
        (peer.serverName?.toLowerCase().contains(lowerQuery) ?? false) ||
        (peer.tunneladdress?.toLowerCase().contains(lowerQuery) ?? false) ||
        (peer.serveraddress?.toLowerCase().contains(lowerQuery) ?? false);
  }

  /// Toggle peer enabled/disabled state
  Future<void> togglePeer(String uuid, bool enabled) async {
    if (_togglingPeers.contains(uuid)) {
      return;
    }

    _togglingPeers.add(uuid);
    notifyListeners();

    try {
      await _apiService.toggleWireGuardPeer(uuid, enabled);
      await refresh();
    } finally {
      _togglingPeers.remove(uuid);
      notifyListeners();
    }
  }

  /// Delete a peer
  Future<void> deletePeer(String uuid) async {
    await _apiService.deleteWireGuardPeer(uuid);
    await refresh();
  }

  /// Refresh the peers list
  Future<void> refreshPeers() => refresh();
}


