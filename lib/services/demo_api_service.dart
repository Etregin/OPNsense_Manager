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

import 'package:flutter/foundation.dart';
import '../models/system_info.dart';
import '../models/firewall_rule.dart';
import '../models/firewall_alias.dart';
import '../models/vpn_connection.dart';
import '../models/network_host.dart';
import '../models/wireguard_server.dart';
import '../models/wireguard_peer.dart';
import '../models/tailscale_status.dart';
import '../models/tailscale_settings.dart';
import 'demo_data_service.dart';
import 'opnsense_api_service.dart';
import 'demo/demo_api_decorator.dart';

/// Wrapper service that provides demo data when in demo mode
class DemoApiService {
  final OPNsenseApiService _realApiService;
  final DemoDataService _demoDataService = DemoDataService();
  bool _isDemoMode = false;

  DemoApiService(this._realApiService);

  /// Enable or disable demo mode
  void setDemoMode(bool enabled) {
    _isDemoMode = enabled;
    if (!enabled) {
      _demoDataService.reset();
    }
  }

  /// Check if demo mode is active
  bool get isDemoMode => _isDemoMode;

  /// Test connection - always succeeds in demo mode
  Future<bool> testConnection() => DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => true,
        realAction: () => _realApiService.testConnection(),
        delayMs: 500,
      );

  /// Get system info
  Future<SystemInfo> getSystemInfo() => DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => _demoDataService.generateSystemInfo(),
        realAction: () => _realApiService.getSystemInfo(),
      );

  /// Get firewall rules
  Future<List<FirewallRule>> getFirewallRules() => DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => _demoDataService.generateFirewallRules(),
        realAction: () => _realApiService.getFirewallRules(),
        delayMs: 400,
      );

  /// Get available interfaces
  Future<Map<String, dynamic>> getAvailableInterfaces() =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => _demoDataService.generateAvailableInterfaces(),
        realAction: () => _realApiService.getAvailableInterfaces(),
        delayMs: 200,
      );

  /// Get firewall rule by UUID
  Future<FirewallRule?> getFirewallRule(String uuid) =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async {
          final rules = _demoDataService.generateFirewallRules();
          try {
            return rules.firstWhere((rule) => rule.uuid == uuid);
          } catch (e) {
            return null;
          }
        },
        realAction: () => _realApiService.getFirewallRule(uuid),
        delayMs: 200,
      );

  /// Toggle firewall rule
  Future<void> toggleFirewallRule(String uuid) => DemoApiDecorator.executeVoid(
        isDemoMode: _isDemoMode,
        demoAction: () async => _demoDataService.toggleFirewallRuleState(uuid),
        realAction: () => _realApiService.toggleFirewallRule(uuid),
      );

  /// Create a new firewall rule
  Future<String> createFirewallRule(FirewallRuleRequest request) =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async =>
            'demo-rule-${DateTime.now().millisecondsSinceEpoch}',
        realAction: () => _realApiService.createFirewallRule(request),
        delayMs: 600,
      );

  /// Update an existing firewall rule
  Future<void> updateFirewallRule(String uuid, FirewallRuleRequest request) =>
      DemoApiDecorator.executeVoid(
        isDemoMode: _isDemoMode,
        demoAction: () async {},
        realAction: () => _realApiService.updateFirewallRule(uuid, request),
        delayMs: 600,
      );

  /// Delete firewall rule
  Future<void> deleteFirewallRule(String uuid) => DemoApiDecorator.executeVoid(
        isDemoMode: _isDemoMode,
        demoAction: () async {},
        realAction: () => _realApiService.deleteFirewallRule(uuid),
      );

  /// Apply firewall changes
  Future<void> applyFirewallChanges() => DemoApiDecorator.executeVoid(
        isDemoMode: _isDemoMode,
        demoAction: () async {},
        realAction: () => _realApiService.applyFirewallChanges(),
        delayMs: 500,
      );

  /// Get firewall logs
  Future<List<dynamic>> getFirewallLogs({int limit = 100}) =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async =>
            _demoDataService.generateFirewallLogs(limit: limit),
        realAction: () => _realApiService.getFirewallLogs(limit: limit),
        delayMs: 400,
      );

  /// Get services
  Future<List<dynamic>> getServices() => DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async {
          final services = _demoDataService.generateServices();
          return services['services'] as List<dynamic>;
        },
        realAction: () => _realApiService.getServices(),
      );

  /// Get gateways
  Future<List<dynamic>> getGateways() => DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => _demoDataService.generateGateways(),
        realAction: () => _realApiService.getGateways(),
      );

  /// Control service (start/stop/restart)
  Future<bool> controlService(String serviceName, String action) =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async {
          if (action == 'start' || action == 'stop') {
            _demoDataService.toggleServiceState(serviceName);
          }
          return true;
        },
        realAction: () => _realApiService.controlService(serviceName, action),
        delayMs: 500,
      );

  /// Get VPN connections
  Future<List<VPNConnection>> getVPNConnections() => DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => _demoDataService.generateVPNConnections(),
        realAction: () => _realApiService.getVPNConnections(),
        delayMs: 400,
      );

  /// Toggle VPN connection
  Future<bool> toggleVPNConnection(
          String id, String type, bool currentStatus) =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async {
          _demoDataService.toggleVPNConnectionState(id);
          return true;
        },
        realAction: () =>
            _realApiService.toggleVPNConnection(id, type, currentStatus),
        delayMs: 500,
      );

  /// Restart VPN service
  Future<bool> restartVPNService(String type) => DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => true,
        realAction: () => _realApiService.restartVPNService(type),
        delayMs: 800,
      );

  /// Get VPN connection details
  Future<VPNConnection?> getVPNConnectionDetails(String id, String type) =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async {
          final connections = _demoDataService.generateVPNConnections();
          try {
            return connections.firstWhere(
              (conn) =>
                  conn.id == id && conn.type.toLowerCase() == type.toLowerCase(),
            );
          } catch (e) {
            return null;
          }
        },
        realAction: () => _realApiService.getVPNConnectionDetails(id, type),
      );

  /// Get Tailscale connection status
  Future<VPNConnection?> getTailscaleStatus() => DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async {
          final connections = _demoDataService.generateVPNConnections();
          try {
            return connections.firstWhere(
              (conn) => conn.type.toLowerCase() == 'tailscale',
            );
          } catch (e) {
            return null;
          }
        },
        realAction: () => _realApiService.getTailscaleStatus(),
      );

  /// Get detailed Tailscale status and configuration
  Future<TailscaleStatus> getTailscaleDetails() => DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => _demoDataService.generateTailscaleStatus(),
        realAction: () => _realApiService.getTailscaleDetails(),
        delayMs: 400,
      );

  // ==================== WireGuard VPN ====================

  /// Get WireGuard peers
  Future<List<WireGuardPeer>> getWireGuardPeers() =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async {
          final demoData = _demoDataService.generateWireGuardPeers();
          return demoData.map((data) => WireGuardPeer.fromJson(data)).toList();
        },
        realAction: () => _realApiService.getWireGuardPeers(),
        delayMs: 400,
      );

  /// Get WireGuard servers
  Future<List<WireGuardServer>> getWireGuardServers() =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async {
          final demoData = _demoDataService.generateWireGuardServers();
          return demoData.map((data) => WireGuardServer.fromJson(data)).toList();
        },
        realAction: () => _realApiService.getWireGuardServers(),
        delayMs: 400,
      );

  // ==================== IPsec VPN ====================

  /// Get IPsec connections
  Future<List<Map<String, dynamic>>> getIPsecConnections() =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => _demoDataService.generateIPsecConnections(),
        realAction: () => _realApiService.getIPsecConnections(),
        delayMs: 400,
      );

  /// Get IPsec sessions (Phase 1)
  Future<List<Map<String, dynamic>>> getIPsecSessionsPhase1() =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => _demoDataService.generateIPsecSessionsPhase1(),
        realAction: () => _realApiService.getIPsecSessionsPhase1(),
        delayMs: 400,
      );

  /// Get network hosts with bandwidth usage
  Future<List<NetworkHost>> getNetworkHosts({String interface = 'lan'}) =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => _demoDataService.generateNetworkHosts(),
        realAction: () => _realApiService.getNetworkHosts(interface: interface),
        delayMs: 400,
      );

  /// Get DHCP leases
  Future<List<Map<String, dynamic>>> getDhcpLeases() =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => _demoDataService.generateDhcpLeases(),
        realAction: () => _realApiService.getDhcpLeases(),
        delayMs: 400,
      );

  /// Get firewall aliases
  Future<List<FirewallAlias>> getFirewallAliases() => DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => _demoDataService.generateFirewallAliases(),
        realAction: () => _realApiService.getFirewallAliases(),
        delayMs: 400,
      );

  /// Get firewall alias by UUID
  Future<FirewallAlias?> getFirewallAlias(String uuid) =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async {
          final aliases = _demoDataService.generateFirewallAliases();
          try {
            return aliases.firstWhere((alias) => alias.uuid == uuid);
          } catch (e) {
            return null;
          }
        },
        realAction: () => _realApiService.getFirewallAlias(uuid),
        delayMs: 200,
      );

  /// Toggle firewall alias
  Future<void> toggleFirewallAlias(String uuid) => DemoApiDecorator.executeVoid(
        isDemoMode: _isDemoMode,
        demoAction: () async => _demoDataService.toggleFirewallAliasState(uuid),
        realAction: () => _realApiService.toggleFirewallAlias(uuid),
      );

  /// Delete firewall alias
  Future<void> deleteFirewallAlias(String uuid) => DemoApiDecorator.executeVoid(
        isDemoMode: _isDemoMode,
        demoAction: () async => _demoDataService.deleteFirewallAlias(uuid),
        realAction: () => _realApiService.deleteFirewallAlias(uuid),
      );

  /// Create firewall alias
  Future<Map<String, dynamic>> createFirewallAlias(
          FirewallAliasRequest request) =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => {
          'result': 'saved',
          'uuid': 'demo-alias-${_demoDataService.getNextAliasId()}'
        },
        realAction: () => _realApiService.createFirewallAlias(request),
        delayMs: 400,
      );

  /// Update firewall alias
  Future<Map<String, dynamic>> updateFirewallAlias(
          String uuid, FirewallAliasRequest request) =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => {'result': 'saved'},
        realAction: () => _realApiService.updateFirewallAlias(uuid, request),
        delayMs: 400,
      );

  /// Reboot system
  Future<void> rebootSystem() => DemoApiDecorator.executeVoid(
        isDemoMode: _isDemoMode,
        demoAction: () async =>
            throw ApiException('Cannot reboot in demo mode', 403),
        realAction: () => _realApiService.rebootSystem(),
        delayMs: 500,
      );

  /// Control Tailscale service (start, stop, restart)
  Future<bool> controlTailscaleService(String action) =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async {
          _demoDataService.updateTailscaleServiceState(action);
          return true;
        },
        realAction: () => _realApiService.controlTailscaleService(action),
        delayMs: 500,
      );

  /// Update Tailscale settings
  Future<bool> updateTailscaleSettings(Map<String, dynamic> settings) =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async {
          _demoDataService.updateTailscaleSettings(settings);
          return true;
        },
        realAction: () => _realApiService.updateTailscaleSettings(settings),
        delayMs: 500,
      );

  /// Get Tailscale authentication settings
  Future<Map<String, String?>> getTailscaleAuthentication() =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => {
          'loginServer': 'https://login.tailscale.com',
          'preAuthKey': 'tskey-auth-demo-XXXXXXXXXXXXXXXX',
        },
        realAction: () => _realApiService.getTailscaleAuthentication(),
      );

  /// Set Tailscale authentication settings
  Future<bool> setTailscaleAuthentication(
          String loginServer, String preAuthKey) =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => true,
        realAction: () =>
            _realApiService.setTailscaleAuthentication(loginServer, preAuthKey),
        delayMs: 500,
      );

  /// Logout from Tailscale
  Future<bool> logoutTailscale() => DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async {
          _demoDataService.logoutTailscale();
          return true;
        },
        realAction: () => _realApiService.logoutTailscale(),
        delayMs: 500,
      );

  // ==================== Tailscale Settings Management ====================

  /// Get Tailscale settings
  Future<TailscaleSettingsResponse> getTailscaleSettings() =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => _demoDataService.generateTailscaleSettings(),
        realAction: () => _realApiService.getTailscaleSettings(),
      );

  /// Set Tailscale settings
  Future<Map<String, dynamic>> setTailscaleSettings(
      TailscaleSettings settings) async {
    debugPrint(
        '🌐 [DemoApiService] setTailscaleSettings called, isDemoMode: $_isDemoMode');

    return DemoApiDecorator.execute(
      isDemoMode: _isDemoMode,
      demoAction: () async {
        try {
          debugPrint('🔄 [DemoApiService] Updating demo data...');
          _demoDataService.updateTailscaleSettingsData(settings);
          debugPrint('✅ [DemoApiService] Returning success response');
          return {'result': 'saved'};
        } catch (e, stackTrace) {
          debugPrint('❌ [DemoApiService] Error in demo mode: $e');
          debugPrint('❌ [DemoApiService] Stack trace: $stackTrace');
          return {
            'result': 'failed',
            'message': e.toString(),
          };
        }
      },
      realAction: () => _realApiService.setTailscaleSettings(settings),
      delayMs: 500,
    );
  }

  /// Search Tailscale subnets
  Future<TailscaleSubnetSearchResponse> searchTailscaleSubnets() =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async =>
            _demoDataService.generateTailscaleSubnetSearch(),
        realAction: () => _realApiService.searchTailscaleSubnets(),
      );

  /// Get a specific Tailscale subnet by UUID
  Future<TailscaleSubnetResponse> getTailscaleSubnet(String uuid) =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => _demoDataService.generateTailscaleSubnet(uuid),
        realAction: () => _realApiService.getTailscaleSubnet(uuid),
        delayMs: 200,
      );

  /// Add a new Tailscale subnet
  Future<Map<String, dynamic>> addTailscaleSubnet(TailscaleSubnet subnet) =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async {
          final uuid = _demoDataService.addTailscaleSubnet(subnet);
          return {'result': 'saved', 'uuid': uuid};
        },
        realAction: () => _realApiService.addTailscaleSubnet(subnet),
        delayMs: 400,
      );

  /// Update an existing Tailscale subnet
  Future<Map<String, dynamic>> setTailscaleSubnet(
          String uuid, TailscaleSubnet subnet) =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async {
          _demoDataService.updateTailscaleSubnet(uuid, subnet);
          return {'result': 'saved'};
        },
        realAction: () => _realApiService.setTailscaleSubnet(uuid, subnet),
        delayMs: 400,
      );

  /// Delete a Tailscale subnet
  Future<Map<String, dynamic>> deleteTailscaleSubnet(String uuid) =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async {
          _demoDataService.deleteTailscaleSubnet(uuid);
          return {'result': 'deleted'};
        },
        realAction: () => _realApiService.deleteTailscaleSubnet(uuid),
      );

  /// Reload Tailscale settings
  Future<Map<String, dynamic>> reloadTailscaleSettings() =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => {'status': 'ok'},
        realAction: () => _realApiService.reloadTailscaleSettings(),
        delayMs: 600,
      );

  /// Clear service state
  void clear() {
    _demoDataService.reset();
    _realApiService.clear();
  }
}


