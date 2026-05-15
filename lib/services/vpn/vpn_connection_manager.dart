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

import '../../models/vpn_connection.dart';
import '../../models/system_info.dart';
import '../../models/tailscale_status.dart';
import '../demo_api_service.dart';

/// Service for managing VPN connection operations and business logic
class VPNConnectionManager {
  final DemoApiService _apiService;

  VPNConnectionManager(this._apiService);

  /// Load VPN connections and system info
  Future<VPNConnectionData> loadVPNConnections() async {
    final results = await Future.wait([
      _apiService.getVPNConnections(),
      _apiService.getSystemInfo(),
    ]);

    return VPNConnectionData(
      connections: results[0] as List<VPNConnection>,
      systemInfo: results[1] as SystemInfo,
    );
  }

  /// Load Tailscale status and system info
  Future<TailscaleData> loadTailscaleStatus() async {
    final results = await Future.wait([
      _apiService.getTailscaleDetails(),
      _apiService.getSystemInfo(),
    ]);

    return TailscaleData(
      status: results[0] as TailscaleStatus,
      systemInfo: results[1] as SystemInfo,
    );
  }

  /// Toggle VPN connection state
  Future<bool> toggleConnection(
    String connectionId,
    String type,
    bool currentlyConnected,
  ) async {
    return await _apiService.toggleVPNConnection(
      connectionId,
      type,
      currentlyConnected,
    );
  }

  /// Restart VPN service
  Future<bool> restartService(String type) async {
    return await _apiService.restartVPNService(type);
  }

  /// Filter connections by type
  List<VPNConnection> filterConnections(
    List<VPNConnection> connections,
    String filterType,
  ) {
    if (filterType == 'all') {
      return connections;
    }
    return connections.where((conn) => conn.type == filterType).toList();
  }

  /// Get connection statistics
  VPNStatistics getStatistics(List<VPNConnection> connections) {
    final connectedCount = connections.where((c) => c.isConnected).length;
    final totalCount = connections.length;

    return VPNStatistics(
      connectedCount: connectedCount,
      totalCount: totalCount,
    );
  }
}

/// Data class for VPN connections and system info
class VPNConnectionData {
  final List<VPNConnection> connections;
  final SystemInfo systemInfo;

  VPNConnectionData({
    required this.connections,
    required this.systemInfo,
  });
}

/// Data class for Tailscale status and system info
class TailscaleData {
  final TailscaleStatus status;
  final SystemInfo systemInfo;

  TailscaleData({
    required this.status,
    required this.systemInfo,
  });
}

/// Statistics for VPN connections
class VPNStatistics {
  final int connectedCount;
  final int totalCount;

  VPNStatistics({
    required this.connectedCount,
    required this.totalCount,
  });
}


