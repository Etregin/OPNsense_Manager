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

import 'package:flutter_test/flutter_test.dart';
import 'package:opnsense_manager/models/vpn_connection.dart';
import 'package:opnsense_manager/models/system_info.dart';
import 'package:opnsense_manager/models/tailscale_status.dart';
import 'package:opnsense_manager/services/vpn/vpn_connection_manager.dart';
import 'package:opnsense_manager/services/demo_api_service.dart';
import 'package:opnsense_manager/services/opnsense_api_service.dart';
import 'package:opnsense_manager/models/opnsense_config.dart';

void main() {
  group('VPNConnectionManager', () {
    late VPNConnectionManager manager;
    late DemoApiService demoApiService;

    setUp(() {
      // Create a demo API service for testing
      final config = OPNsenseConfig(
        host: 'test.local',
        port: 443,
        apiKey: 'test-key',
        apiSecret: 'test-secret',
      );
      final realApiService = OPNsenseApiService();
      realApiService.init(config);
      demoApiService = DemoApiService(realApiService);
      demoApiService.setDemoMode(true);
      
      manager = VPNConnectionManager(demoApiService);
    });

    test('loadVPNConnections returns data', () async {
      final data = await manager.loadVPNConnections();
      
      expect(data, isA<VPNConnectionData>());
      expect(data.connections, isA<List<VPNConnection>>());
      expect(data.systemInfo, isA<SystemInfo>());
    });

    test('loadTailscaleStatus returns data', () async {
      final data = await manager.loadTailscaleStatus();
      
      expect(data, isA<TailscaleData>());
      expect(data.status, isA<TailscaleStatus>());
      expect(data.systemInfo, isA<SystemInfo>());
    });

    test('filterConnections with "all" returns all connections', () {
      final connections = [
        VPNConnection(
          id: '1',
          name: 'OpenVPN',
          type: 'openvpn',
          status: 'up',
        ),
        VPNConnection(
          id: '2',
          name: 'WireGuard',
          type: 'wireguard',
          status: 'down',
        ),
      ];

      final filtered = manager.filterConnections(connections, 'all');
      
      expect(filtered.length, equals(2));
    });

    test('filterConnections with specific type filters correctly', () {
      final connections = [
        VPNConnection(
          id: '1',
          name: 'OpenVPN',
          type: 'openvpn',
          status: 'up',
        ),
        VPNConnection(
          id: '2',
          name: 'WireGuard',
          type: 'wireguard',
          status: 'down',
        ),
      ];

      final filtered = manager.filterConnections(connections, 'openvpn');
      
      expect(filtered.length, equals(1));
      expect(filtered.first.type, equals('openvpn'));
    });

    test('getStatistics calculates correctly', () {
      final connections = [
        VPNConnection(
          id: '1',
          name: 'OpenVPN',
          type: 'openvpn',
          status: 'up',
        ),
        VPNConnection(
          id: '2',
          name: 'WireGuard',
          type: 'wireguard',
          status: 'down',
        ),
        VPNConnection(
          id: '3',
          name: 'WireGuard',
          type: 'wireguard',
          status: 'up',
        ),
      ];

      final stats = manager.getStatistics(connections);
      
      expect(stats.totalCount, equals(3));
      expect(stats.connectedCount, equals(2));
    });

    test('toggleConnection calls API service', () async {
      final result = await manager.toggleConnection('1', 'openvpn', true);
      
      expect(result, isA<bool>());
    });

    test('restartService calls API service', () async {
      final result = await manager.restartService('openvpn');
      
      expect(result, isA<bool>());
    });
  });
}


