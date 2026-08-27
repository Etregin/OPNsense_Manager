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

export 'network/vip_service.dart' show CarpVipOption;

import '../models/system_info.dart';
import '../models/thermal_sensor.dart';
import '../models/firewall_rule.dart';
import '../models/firewall_form_options.dart';
import '../models/firewall_alias.dart';
import '../models/vpn_connection.dart';
import '../models/network_host.dart';
import '../models/wireguard_server.dart';
import '../models/wireguard_peer.dart';
import '../models/wireguard_status.dart';
import '../models/wireguard_key_pair.dart';
import '../models/wireguard_client_builder.dart';
import '../models/tailscale_status.dart';
import '../models/tailscale_settings.dart';
import '../models/wol_host.dart';
import '../models/openvpn_search_response.dart';
import '../models/openvpn_instance.dart';
import '../models/openvpn_static_key.dart';
import '../models/openvpn_session_search_response.dart';
import '../models/openvpn_route_search_response.dart';
import '../models/openvpn_client_override.dart';
import '../models/openvpn_client_override_search_response.dart';
import '../models/openvpn_log_search_response.dart';
import '../models/neighbor.dart';
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

  /// Get system temperature sensors
  Future<List<ThermalSensor>> getSystemTemperature() => DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => _demoDataService.generateThermalSensors(),
        realAction: () => _realApiService.getSystemTemperature(),
        delayMs: 300,
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

  /// Get firewall rule form options (dynamic dropdowns)
  Future<FirewallFormOptions> getFirewallRuleFormOptions() =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => const FirewallFormOptions(
          gateways:  {'': 'None', 'WAN_DHCP': 'WAN_DHCP - 192.168.1.1', 'Null4': 'Null4 - 127.0.0.1'},
          replyTo:   {'': 'None', 'WAN_DHCP': 'WAN_DHCP - 192.168.1.1'},
          divertTo:  {'': 'None', '8000': 'Intrusion Detection'},
          overload:  {'': 'None', 'virusprot': 'virusprot', 'sshlockout': 'sshlockout'},
          schedules: {'': 'None'},
          shapers:   {'': 'None'},
          prio:      {'': 'Any priority', '1': 'Background (1, lowest)', '7': 'Network Control (7, highest)'},
          setPrio:   {'': 'Keep current priority', '1': 'Background (1, lowest)', '7': 'Network Control (7, highest)'},
          tos:       {'': 'Any', 'lowdelay': 'lowdelay', 'throughput': 'throughput'},
          categories: {
            'LAN Rules': 'LAN Rules',
            'WAN Rules': 'WAN Rules',
            'VPN': 'VPN',
            'IoT': 'IoT',
            'Management': 'Management',
          },
          portOptions: {
            'single': 'Single port or range',
            '':       'any',
            'http':   'HTTP (80)',
            'https':  'HTTPS (443)',
            'ssh':    'SSH (22)',
            'smtp':   'SMTP (25)',
            'domain': 'DOMAIN (53)',
            'imap':   'IMAP (143)',
            'imaps':  'IMAPS (993)',
            'pop3':   'POP3 (110)',
            'pop3s':  'POP3S (995)',
            'ftp':    'FTP (21)',
            'ntp':    'NTP (123)',
            'snmp':   'SNMP (161)',
            'ldap':   'LDAP (389)',
            'ms-wbt-server': 'MS-WBT-SERVER (3389)',
          },
        ),
        realAction: () => _realApiService.getFirewallRuleFormOptions(),
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
  Future<void> toggleFirewallRule(String uuid) => DemoApiDecorator.execute<void>(
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
      DemoApiDecorator.execute<void>(
        isDemoMode: _isDemoMode,
        demoAction: () async {},
        realAction: () => _realApiService.updateFirewallRule(uuid, request),
        delayMs: 600,
      );

  /// Delete firewall rule
  Future<void> deleteFirewallRule(String uuid) => DemoApiDecorator.execute<void>(
        isDemoMode: _isDemoMode,
        demoAction: () async {},
        realAction: () => _realApiService.deleteFirewallRule(uuid),
      );

  /// Apply firewall changes
  Future<void> applyFirewallChanges() => DemoApiDecorator.execute<void>(
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

  /// Get WireGuard status response
  Future<WireGuardStatusResponse> getWireGuardStatusResponse() =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => _demoDataService.generateWireGuardStatusResponse(),
        realAction: () => _realApiService.getWireGuardStatusResponse(),
        delayMs: 400,
      );

  /// Search WireGuard peers
  Future<Map<String, dynamic>> searchWireGuardPeers({
    int current = 1,
    int rowCount = 50,
    Map<String, dynamic>? sort,
  }) =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async {
          final peers = _demoDataService.generateWireGuardPeers();
          return {
            'rows': peers,
            'rowCount': peers.length,
            'total': peers.length,
            'current': current,
          };
        },
        realAction: () => _realApiService.searchWireGuardPeers(
          current: current,
          rowCount: rowCount,
          sort: sort,
        ),
        delayMs: 400,
      );

  /// Get WireGuard peer details
  Future<Map<String, dynamic>> getPeer(String uuid) =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async {
          final peers = _demoDataService.generateWireGuardPeers();
          final peer = peers.firstWhere(
            (p) => p['uuid'] == uuid,
            orElse: () => peers.first,
          );
          return {'client': peer};
        },
        realAction: () => _realApiService.getPeer(uuid),
        delayMs: 300,
      );

  /// Toggle WireGuard server
  Future<void> toggleWireGuardServer(String uuid, bool enabled) =>
      DemoApiDecorator.execute<void>(
        isDemoMode: _isDemoMode,
        demoAction: () async {},
        realAction: () => _realApiService.toggleWireGuardServer(uuid, enabled),
        delayMs: 400,
      );

  /// Delete WireGuard server
  Future<void> deleteWireGuardServer(String uuid) =>
      DemoApiDecorator.execute<void>(
        isDemoMode: _isDemoMode,
        demoAction: () async {},
        realAction: () => _realApiService.deleteWireGuardServer(uuid),
        delayMs: 400,
      );

  /// Create WireGuard server
  Future<String> createWireGuardServer(WireGuardServerRequest request) =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async =>
            'wg-server-demo-${DateTime.now().millisecondsSinceEpoch}',
        realAction: () => _realApiService.createWireGuardServer(request),
        delayMs: 500,
      );

  /// Update WireGuard server
  Future<void> updateWireGuardServer(String uuid, WireGuardServerRequest request) =>
      DemoApiDecorator.execute<void>(
        isDemoMode: _isDemoMode,
        demoAction: () async {},
        realAction: () => _realApiService.updateWireGuardServer(uuid, request),
        delayMs: 500,
      );

  /// Toggle WireGuard peer
  Future<void> toggleWireGuardPeer(String uuid, bool enabled) =>
      DemoApiDecorator.execute<void>(
        isDemoMode: _isDemoMode,
        demoAction: () async {},
        realAction: () => _realApiService.toggleWireGuardPeer(uuid, enabled),
        delayMs: 400,
      );

  /// Delete WireGuard peer
  Future<void> deleteWireGuardPeer(String uuid) =>
      DemoApiDecorator.execute<void>(
        isDemoMode: _isDemoMode,
        demoAction: () async {},
        realAction: () => _realApiService.deleteWireGuardPeer(uuid),
        delayMs: 400,
      );

  /// Create WireGuard peer
  Future<String> createWireGuardPeer(WireGuardPeerRequest request) =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async =>
            'wg-peer-demo-${DateTime.now().millisecondsSinceEpoch}',
        realAction: () => _realApiService.createWireGuardPeer(request),
        delayMs: 500,
      );

  /// Update WireGuard peer
  Future<void> updateWireGuardPeer(String uuid, WireGuardPeerRequest request) =>
      DemoApiDecorator.execute<void>(
        isDemoMode: _isDemoMode,
        demoAction: () async {},
        realAction: () => _realApiService.updateWireGuardPeer(uuid, request),
        delayMs: 500,
      );

  /// Generate WireGuard key pair
  Future<WireGuardKeyPair> generateWireGuardKeyPair() =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => WireGuardKeyPair(
          privateKey: 'demo_private_key_${DateTime.now().millisecondsSinceEpoch}',
          publicKey: 'demo_public_key_${DateTime.now().millisecondsSinceEpoch}',
        ),
        realAction: () => _realApiService.generateWireGuardKeyPair(),
        delayMs: 300,
      );

  /// Generate WireGuard pre-shared key
  Future<String> generateWireGuardPSK() =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async =>
            'demo_psk_${DateTime.now().millisecondsSinceEpoch}',
        realAction: () => _realApiService.generateWireGuardPSK(),
        delayMs: 300,
      );

  /// Get WireGuard client builder data
  Future<WireGuardClientBuilder> getClientBuilder() =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async {
          final servers = _demoDataService.generateWireGuardServers();
          final serverMap = <String, WireGuardBuilderServer>{};
          for (final server in servers) {
            serverMap[server['uuid'] as String] = WireGuardBuilderServer(
              value: server['name'] as String,
              selected: '0',
            );
          }
          return WireGuardClientBuilder(servers: serverMap);
        },
        realAction: () => _realApiService.getClientBuilder(),
        delayMs: 400,
      );

  /// Get WireGuard server info
  Future<WireGuardServerInfo> getServerInfo(String uuid) =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async {
          final servers = _demoDataService.generateWireGuardServers();
          final server = servers.firstWhere(
            (s) => s['uuid'] == uuid,
            orElse: () => servers.first,
          );
          return WireGuardServerInfo(
            pubkey: server['pubkey'] as String? ?? 'demo_server_pubkey',
            endpoint: '203.0.113.1',
            port: server['port'] as String? ?? '51820',
            tunneladdress: '10.10.10.2/24',
            address: '10.10.10.0/24',
            peerDns: '1.1.1.1',
          );
        },
        realAction: () => _realApiService.getServerInfo(uuid),
        delayMs: 300,
      );

  /// Add WireGuard client via builder
  Future<void> addClientBuilder(WireGuardClientBuilderRequest request) =>
      DemoApiDecorator.execute<void>(
        isDemoMode: _isDemoMode,
        demoAction: () async {},
        realAction: () => _realApiService.addClientBuilder(request),
        delayMs: 500,
      );

  /// Reconfigure WireGuard service
  Future<Map<String, dynamic>> reconfigureWireGuard() =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => {'status': 'ok'},
        realAction: () => _realApiService.reconfigureWireGuard(),
        delayMs: 600,
      );

  /// Start WireGuard service
  Future<Map<String, dynamic>> startWireGuardService() =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => {'status': 'ok'},
        realAction: () => _realApiService.startWireGuardService(),
        delayMs: 500,
      );

  /// Stop WireGuard service
  Future<Map<String, dynamic>> stopWireGuardService() =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => {'status': 'ok'},
        realAction: () => _realApiService.stopWireGuardService(),
        delayMs: 500,
      );

  /// Get WireGuard logs
  Future<Map<String, dynamic>> getWireGuardLogs({
    int rowCount = 50,
    List<String>? severity,
    double? validFrom,
  }) =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => {
          'rows': [],
          'rowCount': 0,
          'total': 0,
        },
        realAction: () => _realApiService.getWireGuardLogs(
          rowCount: rowCount,
          severity: severity,
          validFrom: validFrom,
        ),
        delayMs: 400,
      );

  /// Get CARP VIP options
  Future<List<CarpVipOption>> getCarpVipOptions() =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => [],
        realAction: () => _realApiService.getCarpVipOptions(),
        delayMs: 300,
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

  // ==================== Neighbor Discovery ====================

  /// Check neighbor discovery service status
  Future<NeighborDiscoveryStatus> checkNeighborDiscoveryStatus() =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => NeighborDiscoveryStatus(status: 'running'),
        realAction: () => _realApiService.checkNeighborDiscoveryStatus(),
        delayMs: 300,
      );

  /// Get discovered neighbors
  Future<NeighborDiscoveryResponse> getNeighbors({
    int current = 1,
    int rowCount = 50,
    String? searchPhrase,
  }) async {
    return await DemoApiDecorator.execute<NeighborDiscoveryResponse>(
      isDemoMode: _isDemoMode,
      demoAction: () async {
        var neighbors = _demoDataService.generateNeighbors();
        
        // Apply search filter in demo mode
        if (searchPhrase != null && searchPhrase.isNotEmpty) {
          neighbors = neighbors.where((n) =>
            n.ipAddress.toLowerCase().contains(searchPhrase.toLowerCase()) ||
            n.etherAddress.toLowerCase().contains(searchPhrase.toLowerCase()) ||
            (n.organizationName?.toLowerCase().contains(searchPhrase.toLowerCase()) ?? false)
          ).toList();
        }
        
        final total = neighbors.length;
        
        // Apply pagination
        final startIndex = (current - 1) * rowCount;
        final endIndex = startIndex + rowCount;
        if (startIndex < neighbors.length) {
          neighbors = neighbors.sublist(
            startIndex,
            endIndex > neighbors.length ? neighbors.length : endIndex,
          );
        } else {
          neighbors = [];
        }
        
        return NeighborDiscoveryResponse(
          total: total,
          rowCount: rowCount,
          current: current,
          rows: neighbors,
        );
      },
      realAction: () => _realApiService.getNeighbors(
        current: current,
        rowCount: rowCount,
        searchPhrase: searchPhrase,
      ),
    );
  }

  /// Start neighbor discovery service
  Future<Map<String, dynamic>> startNeighborDiscoveryService() =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => {'result': 'ok'},
        realAction: () => _realApiService.startNeighborDiscoveryService(),
        delayMs: 500,
      );

  /// Stop neighbor discovery service
  Future<Map<String, dynamic>> stopNeighborDiscoveryService() =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => {'result': 'ok'},
        realAction: () => _realApiService.stopNeighborDiscoveryService(),
        delayMs: 500,
      );

  /// Restart neighbor discovery service
  Future<Map<String, dynamic>> restartNeighborDiscoveryService() =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => {'result': 'ok'},
        realAction: () => _realApiService.restartNeighborDiscoveryService(),
        delayMs: 800,
      );

  // ==================== Wake-on-LAN ====================

  /// Check if WOL plugin is available
  /// In demo mode, always return true (WOL is always available)
  Future<bool> isWolPluginAvailable() => DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => true,
        realAction: () => _realApiService.isWolPluginAvailable(),
        delayMs: 200,
      );

  /// Check if Tailscale plugin is available
  /// In demo mode, always return true (Tailscale is always available)
  Future<bool> isTailscalePluginAvailable() => DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => true,
        realAction: () => _realApiService.isTailscalePluginAvailable(),
        delayMs: 200,
      );

  /// Get WOL hosts
  Future<List<WolHost>> getWolHosts() => DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => [],
        realAction: () => _realApiService.getWolHosts(),
        delayMs: 300,
      );

  /// Get WOL interface options
  Future<Map<String, WolInterfaceOption>> getWolInterfaceOptions() =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => {
          'lan': WolInterfaceOption(value: 'LAN', selected: 1),
          'wan': WolInterfaceOption(value: 'WAN', selected: 0),
        },
        realAction: () => _realApiService.getWolInterfaceOptions(),
        delayMs: 200,
      );

  /// Add WOL host
  Future<String> addWolHost(String interface, String mac, String description) =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => 'demo-uuid-${DateTime.now().millisecondsSinceEpoch}',
        realAction: () => _realApiService.addWolHost(interface, mac, description),
        delayMs: 500,
      );

  /// Update WOL host
  Future<void> updateWolHost(
          String uuid, String interface, String mac, String description) =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async {},
        realAction: () =>
            _realApiService.updateWolHost(uuid, interface, mac, description),
        delayMs: 500,
      );

  /// Delete WOL host
  Future<void> deleteWolHost(String uuid) => DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async {},
        realAction: () => _realApiService.deleteWolHost(uuid),
        delayMs: 400,
      );

  /// Wake host
  Future<void> wakeHost(String uuid) => DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async {},
        realAction: () => _realApiService.wakeHost(uuid),
        delayMs: 300,
      );

  /// Copy WOL host
  Future<Map<String, dynamic>> copyWolHost(String uuid) =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async {
          // Return mock data matching the API response structure
          return {
            'interface': {
              'lan': {'value': 'LAN', 'selected': 1},
              'wan': {'value': 'WAN', 'selected': 0},
              'opt1': {'value': 'OPT1', 'selected': 0},
            },
            'mac': 'AA:BB:CC:DD:EE:FF',
            'descr': 'Copied Host',
          };
        },
        realAction: () => _realApiService.copyWolHost(uuid),
        delayMs: 300,
      );

  /// Wake all hosts
  Future<List<WolWakeAllResult>> wakeAllHosts() => DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => [
          WolWakeAllResult(mac: 'd8:bb:c1:9b:bc:19', status: 'OK'),
          WolWakeAllResult(mac: '00:11:22:33:44:55', status: 'OK'),
          WolWakeAllResult(mac: 'AA:BB:CC:DD:EE:FF', status: 'OK'),
        ],
        realAction: () => _realApiService.wakeAllHosts(),
        delayMs: 500,
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
  Future<void> toggleFirewallAlias(String uuid) => DemoApiDecorator.execute<void>(
        isDemoMode: _isDemoMode,
        demoAction: () async => _demoDataService.toggleFirewallAliasState(uuid),
        realAction: () => _realApiService.toggleFirewallAlias(uuid),
      );

  /// Delete firewall alias
  Future<void> deleteFirewallAlias(String uuid) => DemoApiDecorator.execute<void>(
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
  Future<void> rebootSystem() => DemoApiDecorator.execute<void>(
        isDemoMode: _isDemoMode,
        demoAction: () async =>
            throw const ApiException('Cannot reboot in demo mode', 403, ApiErrorType.unknown),
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
    return DemoApiDecorator.execute(
      isDemoMode: _isDemoMode,
      demoAction: () async {
        try {
          _demoDataService.updateTailscaleSettingsData(settings);
          return {'result': 'saved'};
        } catch (e) {
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

  // ==================== OpenVPN ====================

  /// Search OpenVPN instances
  Future<OpenvpnSearchResponse> searchOpenvpnInstances({
    int current = 1,
    int rowCount = 50,
    Map<String, dynamic>? sort,
    String? searchPhrase,
    String? enabled,
  }) =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async {
          final instances = _demoDataService.generateOpenvpnInstances();
          return OpenvpnSearchResponse(
            rows: instances,
            rowCount: instances.length,
            total: instances.length,
            current: current,
          );
        },
        realAction: () => _realApiService.searchOpenvpnInstances(
          current: current,
          rowCount: rowCount,
          sort: sort,
          searchPhrase: searchPhrase,
          enabled: enabled,
        ),
        delayMs: 400,
      );

  /// Get OpenVPN instance details
  Future<OpenvpnInstance> getOpenvpnInstance(String? vpnid) =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async {
          if (vpnid == null) {
            // Return empty form data for new instance
            return _demoDataService.generateOpenvpnInstanceFormData();
          }
          // Return existing instance data
          final instances = _demoDataService.generateOpenvpnInstances();
          final instance = instances.firstWhere(
            (i) => i.vpnid == vpnid,
            orElse: () => instances.first,
          );
          return _demoDataService.generateOpenvpnInstanceFormData(
            vpnid: instance.vpnid,
            role: instance.role,
          );
        },
        realAction: () => _realApiService.getOpenvpnInstance(vpnid),
        delayMs: 300,
      );

  /// Add OpenVPN instance
  Future<Map<String, dynamic>> addOpenvpnInstance(OpenvpnInstance instance) =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => {
          'result': 'saved',
          'uuid': 'openvpn-demo-${DateTime.now().millisecondsSinceEpoch}',
        },
        realAction: () => _realApiService.addOpenvpnInstance(instance),
        delayMs: 500,
      );

  /// Update OpenVPN instance
  Future<Map<String, dynamic>> updateOpenvpnInstance(
    String vpnid,
    OpenvpnInstance instance,
  ) =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => {'result': 'saved'},
        realAction: () => _realApiService.updateOpenvpnInstance(vpnid, instance),
        delayMs: 500,
      );

  /// Delete OpenVPN instance
  Future<Map<String, dynamic>> deleteOpenvpnInstance(String vpnid) =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => {'result': 'deleted'},
        realAction: () => _realApiService.deleteOpenvpnInstance(vpnid),
        delayMs: 400,
      );

  /// Toggle OpenVPN instance
  Future<Map<String, dynamic>> toggleOpenvpnInstance(String vpnid) =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => {'result': 'success'},
        realAction: () => _realApiService.toggleOpenvpnInstance(vpnid),
        delayMs: 300,
      );

  /// Generate auth token
  Future<String> generateOpenvpnAuthToken() => DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async =>
            'demo-auth-token-${DateTime.now().millisecondsSinceEpoch}',
        realAction: () => _realApiService.generateOpenvpnAuthToken(),
        delayMs: 200,
      );

  // ==================== OpenVPN Static Keys ====================

  /// Search OpenVPN static keys
  Future<OpenvpnStaticKeySearchResponse> searchOpenvpnStaticKeys({
    int current = 1,
    int rowCount = 50,
  }) =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async {
          final keys = _demoDataService.generateOpenvpnStaticKeys();
          return OpenvpnStaticKeySearchResponse(
            rows: keys,
            rowCount: keys.length,
            total: keys.length,
            current: current,
          );
        },
        realAction: () => _realApiService.searchOpenvpnStaticKeys(
          current: current,
          rowCount: rowCount,
        ),
        delayMs: 300,
      );

  /// Get OpenVPN static key details
  Future<OpenvpnStaticKey> getOpenvpnStaticKey(String? keyid) =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async {
          if (keyid == null) {
            // Return empty form data for new key
            return const OpenvpnStaticKey(
              description: '',
              key: '',
              mode: '0',
            );
          }
          // Return existing key data
          final keys = _demoDataService.generateOpenvpnStaticKeys();
          return keys.firstWhere(
            (k) => k.keyid == keyid,
            orElse: () => keys.first,
          );
        },
        realAction: () => _realApiService.getOpenvpnStaticKey(keyid),
        delayMs: 200,
      );

  /// Add OpenVPN static key
  Future<Map<String, dynamic>> addOpenvpnStaticKey(OpenvpnStaticKey key) =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => {
          'result': 'saved',
          'uuid': 'key-demo-${DateTime.now().millisecondsSinceEpoch}',
        },
        realAction: () => _realApiService.addOpenvpnStaticKey(key),
        delayMs: 400,
      );

  /// Update OpenVPN static key
  Future<Map<String, dynamic>> updateOpenvpnStaticKey(
    String keyid,
    OpenvpnStaticKey key,
  ) =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => {'result': 'saved'},
        realAction: () => _realApiService.updateOpenvpnStaticKey(keyid, key),
        delayMs: 400,
      );

  /// Delete OpenVPN static key
  Future<Map<String, dynamic>> deleteOpenvpnStaticKey(String keyid) =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => {'result': 'deleted'},
        realAction: () => _realApiService.deleteOpenvpnStaticKey(keyid),
        delayMs: 300,
      );

  /// Generate OpenVPN static key
  Future<String> generateOpenvpnStaticKey(String mode) =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async {
          // Generate a mock static key
          return '''#
# 2048 bit OpenVPN static key (Demo Mode)
#
-----BEGIN OpenVPN Static key V1-----
${List.generate(16, (i) => List.generate(32, (j) => '0123456789abcdef'[(i * 32 + j) % 16]).join()).join('\n')}
-----END OpenVPN Static key V1-----
''';
        },
        realAction: () => _realApiService.generateOpenvpnStaticKey(mode),
        delayMs: 500,
      );

  /// Reconfigure OpenVPN service
  Future<Map<String, dynamic>> reconfigureOpenvpn() =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => {'status': 'ok'},
        realAction: () => _realApiService.reconfigureOpenvpn(),
        delayMs: 800,
      );

  // ==================== OpenVPN Client Overrides ====================

  /// Search OpenVPN client overrides
  Future<OpenvpnClientOverrideSearchResponse> searchClientOverrides({
    int current = 1,
    int rowCount = 50,
    Map<String, dynamic>? sort,
    String? searchPhrase,
  }) =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async {
          // Return empty list for demo mode - no client overrides in demo
          return OpenvpnClientOverrideSearchResponse(
            rows: [],
            rowCount: 0,
            total: 0,
            current: current,
          );
        },
        realAction: () => _realApiService.searchClientOverrides(
          current: current,
          rowCount: rowCount,
          sort: sort,
          searchPhrase: searchPhrase,
        ),
        delayMs: 300,
      );

  /// Get OpenVPN client override details
  Future<OpenvpnClientOverride> getClientOverride(String? uuid) =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async {
          // Return empty override for demo mode
          return OpenvpnClientOverride.empty();
        },
        realAction: () => _realApiService.getClientOverride(uuid),
        delayMs: 300,
      );

  /// Set/update OpenVPN client override
  Future<Map<String, dynamic>> setClientOverride(
    String uuid,
    OpenvpnClientOverride override,
  ) =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => {
          'result': 'saved',
          'uuid': uuid.isEmpty ? 'demo-override-${DateTime.now().millisecondsSinceEpoch}' : uuid,
        },
        realAction: () => _realApiService.setClientOverride(uuid, override),
        delayMs: 400,
      );

  /// Delete OpenVPN client override
  Future<Map<String, dynamic>> deleteClientOverride(String uuid) =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => {'result': 'deleted'},
        realAction: () => _realApiService.deleteClientOverride(uuid),
        delayMs: 300,
      );

  /// Toggle OpenVPN client override enabled state
  Future<Map<String, dynamic>> toggleClientOverride(String uuid) =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => {'result': 'ok'},
        realAction: () => _realApiService.toggleClientOverride(uuid),
        delayMs: 300,
      );

  // ==================== OpenVPN Logs ====================

  /// Search OpenVPN logs
  Future<OpenvpnLogSearchResponse> searchOpenvpnLogs({
    int current = 1,
    int rowCount = 50,
    Map<String, dynamic>? sort,
    List<String>? severity,
    double? validFrom,
  }) =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async {
          // Return empty logs for demo mode
          return OpenvpnLogSearchResponse(
            filters: '',
            totalRows: 0,
            rowCount: 0,
            total: 0,
            current: current,
            rows: [],
          );
        },
        realAction: () => _realApiService.searchOpenvpnLogs(
          current: current,
          rowCount: rowCount,
          sort: sort,
          severity: severity,
          validFrom: validFrom,
        ),
        delayMs: 400,
      );

  // ==================== OpenVPN Connection Status ====================

  /// Search OpenVPN sessions
  Future<OpenvpnSessionSearchResponse> searchSessions({
    int current = 1,
    int rowCount = 50,
    Map<String, dynamic>? sort,
  }) =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => OpenvpnSessionSearchResponse(
          rows: [],
          rowCount: 0,
          total: 0,
          current: current,
        ),
        realAction: () => _realApiService.searchSessions(
          current: current,
          rowCount: rowCount,
          sort: sort,
        ),
        delayMs: 300,
      );

  /// Search OpenVPN routes
  Future<OpenvpnRouteSearchResponse> searchRoutes({
    int current = 1,
    int rowCount = 50,
    Map<String, dynamic>? sort,
  }) =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => OpenvpnRouteSearchResponse(
          rows: [],
          rowCount: 0,
          total: 0,
          current: current,
        ),
        realAction: () => _realApiService.searchRoutes(
          current: current,
          rowCount: rowCount,
          sort: sort,
        ),
        delayMs: 300,
      );

  /// Start OpenVPN service
  Future<Map<String, dynamic>> startService(String id) =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => {'result': 'ok'},
        realAction: () => _realApiService.startService(id),
        delayMs: 500,
      );

  /// Stop OpenVPN service
  Future<Map<String, dynamic>> stopService(String id) =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => {'result': 'ok'},
        realAction: () => _realApiService.stopService(id),
        delayMs: 500,
      );

  /// Restart OpenVPN service
  Future<Map<String, dynamic>> restartService(String id) =>
      DemoApiDecorator.execute(
        isDemoMode: _isDemoMode,
        demoAction: () async => {'result': 'ok'},
        realAction: () => _realApiService.restartService(id),
        delayMs: 500,
      );

  /// Clear service state
  void clear() {
    _demoDataService.reset();
    _realApiService.clear();
  }
}


