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

import 'dart:math';
import '../models/system_info.dart';
import '../models/firewall_rule.dart';
import '../models/vpn_connection.dart';

/// Service for generating realistic demo data
class DemoDataService {
  static final DemoDataService _instance = DemoDataService._internal();
  factory DemoDataService() => _instance;
  DemoDataService._internal();

  final Random _random = Random();
  
  // Simulated state for demo mode
  final Map<String, bool> _firewallRuleStates = {};
  final Map<String, bool> _vpnConnectionStates = {};
  final Map<String, bool> _serviceStates = {};

  /// Generate demo system info
  SystemInfo generateSystemInfo() {
    final uptime = Duration(days: 15, hours: _random.nextInt(24), minutes: _random.nextInt(60));
    final cpuUsage = 15 + _random.nextInt(30); // 15-45%
    final memoryUsage = 40 + _random.nextInt(20); // 40-60%
    final diskUsage = 25 + _random.nextInt(30); // 25-55%

    return SystemInfo(
      hostname: 'demo-opnsense',
      version: '24.7.1',
      platform: 'amd64',
      uptime: uptime.inSeconds,
      cpuUsage: cpuUsage.toDouble(),
      memoryTotal: 8589934592, // 8GB
      memoryUsed: (8589934592 * memoryUsage / 100).round(),
      diskTotal: 107374182400, // 100GB
      diskUsed: (107374182400 * diskUsage / 100).round(),
      type: 'opnsense',
      architecture: 'amd64',
      commit: 'c2f076f30',
      mirror: 'https://pkg.opnsense.org',
      repositories: 'OPNsense (Priority: 11)',
      updatedOn: DateTime.now().subtract(const Duration(days: 7)).toIso8601String(),
    );
  }

  /// Generate demo firewall rules
  List<FirewallRule> generateFirewallRules() {
    final rules = <FirewallRule>[
      FirewallRule(
        uuid: 'demo-rule-1',
        type: 'pass',
        interfaceName: 'wan',
        protocol: 'tcp',
        source: 'any',
        sourcePort: '',
        destination: 'any',
        destinationPort: '443',
        description: 'Allow HTTPS from WAN',
        enabled: _getFirewallRuleState('demo-rule-1', true) ? '1' : '0',
        sequence: 1,
      ),
      FirewallRule(
        uuid: 'demo-rule-2',
        type: 'pass',
        interfaceName: 'lan',
        protocol: 'any',
        source: '192.168.1.0/24',
        sourcePort: '',
        destination: 'any',
        destinationPort: '',
        description: 'Allow LAN to any',
        enabled: _getFirewallRuleState('demo-rule-2', true) ? '1' : '0',
        sequence: 2,
      ),
      FirewallRule(
        uuid: 'demo-rule-3',
        type: 'block',
        interfaceName: 'wan',
        protocol: 'tcp',
        source: 'any',
        sourcePort: '',
        destination: 'any',
        destinationPort: '22',
        description: 'Block SSH from WAN',
        enabled: _getFirewallRuleState('demo-rule-3', false) ? '1' : '0',
        sequence: 3,
      ),
      FirewallRule(
        uuid: 'demo-rule-4',
        type: 'pass',
        interfaceName: 'wan',
        protocol: 'tcp',
        source: 'any',
        sourcePort: '',
        destination: 'any',
        destinationPort: '80',
        description: 'Allow HTTP from WAN',
        enabled: _getFirewallRuleState('demo-rule-4', true) ? '1' : '0',
        sequence: 4,
      ),
    ];

    return rules;
  }

  /// Generate demo VPN connections
  List<VPNConnection> generateVPNConnections() {
    return [
      VPNConnection(
        id: 'demo-vpn-1',
        name: 'Office VPN',
        type: 'openvpn',
        status: _getVPNConnectionState('demo-vpn-1', true) ? 'up' : 'down',
        description: 'Main office VPN connection',
        remoteAddress: '203.0.113.10',
        localAddress: '192.168.1.1',
        virtualAddress: '10.8.0.2',
        bytesReceived: 1024 * 1024 * 150 + _random.nextInt(1024 * 1024 * 50),
        bytesSent: 1024 * 1024 * 80 + _random.nextInt(1024 * 1024 * 20),
        connectedSince: DateTime.now().subtract(Duration(hours: 5, minutes: _random.nextInt(60))),
        protocol: 'UDP',
        port: 1194,
        enabled: true,
      ),
      VPNConnection(
        id: 'demo-vpn-2',
        name: 'Remote Site',
        type: 'ipsec',
        status: _getVPNConnectionState('demo-vpn-2', true) ? 'up' : 'down',
        description: 'Remote site IPsec tunnel',
        remoteAddress: '198.51.100.25',
        localAddress: '192.168.1.1',
        virtualAddress: '10.9.0.2',
        bytesReceived: 1024 * 1024 * 320 + _random.nextInt(1024 * 1024 * 80),
        bytesSent: 1024 * 1024 * 180 + _random.nextInt(1024 * 1024 * 40),
        connectedSince: DateTime.now().subtract(Duration(days: 2, hours: _random.nextInt(24))),
        protocol: 'ESP',
        port: 500,
        enabled: true,
      ),
      VPNConnection(
        id: 'demo-vpn-3',
        name: 'Mobile Users',
        type: 'openvpn',
        status: _getVPNConnectionState('demo-vpn-3', false) ? 'up' : 'down',
        description: 'Mobile user access',
        remoteAddress: '192.0.2.50',
        localAddress: '192.168.1.1',
        virtualAddress: '10.8.0.10',
        bytesReceived: 0,
        bytesSent: 0,
        connectedSince: null,
        protocol: 'TCP',
        port: 443,
        enabled: false,
      ),
    ];
  }

  /// Generate demo services
  Map<String, dynamic> generateServices() {
    return {
      'services': [
        {
          'name': 'unbound',
          'description': 'DNS Resolver',
          'status': _getServiceState('unbound', true) ? 'running' : 'stopped',
        },
        {
          'name': 'ntpd',
          'description': 'NTP Service',
          'status': _getServiceState('ntpd', true) ? 'running' : 'stopped',
        },
        {
          'name': 'sshd',
          'description': 'SSH Service',
          'status': _getServiceState('sshd', true) ? 'running' : 'stopped',
        },
        {
          'name': 'dhcpd',
          'description': 'DHCP Service',
          'status': _getServiceState('dhcpd', true) ? 'running' : 'stopped',
        },
        {
          'name': 'openvpn',
          'description': 'OpenVPN Service',
          'status': _getServiceState('openvpn', true) ? 'running' : 'stopped',
        },
      ],
    };
  }

  /// Generate demo gateways
  List<Map<String, dynamic>> generateGateways() {
    return [
      {
        'name': 'WAN_DHCP',
        'address': '203.0.113.1',
        'status': 'online',
        'delay': '${5 + _random.nextInt(10)}ms',
        'stddev': '${1 + _random.nextInt(3)}ms',
        'loss': '0%',
      },
      {
        'name': 'WAN_BACKUP',
        'address': '198.51.100.1',
        'status': 'online',
        'delay': '${8 + _random.nextInt(15)}ms',
        'stddev': '${2 + _random.nextInt(4)}ms',
        'loss': '0%',
      },
    ];
  }

  /// Generate demo firewall logs
  List<Map<String, dynamic>> generateFirewallLogs({int limit = 100}) {
    final logs = <Map<String, dynamic>>[];
    final actions = ['pass', 'block'];
    final interfaces = ['wan', 'lan', 'opt1'];
    final protocols = ['tcp', 'udp', 'icmp'];
    final sources = ['192.168.1.100', '192.168.1.101', '203.0.113.50', '198.51.100.75', '10.0.0.25'];
    final destinations = ['192.168.1.1', '8.8.8.8', '1.1.1.1', '192.168.1.50'];

    for (int i = 0; i < limit; i++) {
      final timestamp = DateTime.now().subtract(Duration(minutes: i * 2));
      logs.add({
        'timestamp': timestamp.toIso8601String(),
        'action': actions[_random.nextInt(actions.length)],
        'interface': interfaces[_random.nextInt(interfaces.length)],
        'protocol': protocols[_random.nextInt(protocols.length)],
        'source': sources[_random.nextInt(sources.length)],
        'destination': destinations[_random.nextInt(destinations.length)],
        'sourcePort': 1024 + _random.nextInt(64000),
        'destinationPort': [80, 443, 22, 53, 123][_random.nextInt(5)],
      });
    }

    return logs;
  }

  /// Generate available interfaces for firewall rules
  Map<String, dynamic> generateAvailableInterfaces() {
    return {
      'wan': {'value': 'wan', 'selected': 0, 'description': 'WAN'},
      'lan': {'value': 'lan', 'selected': 0, 'description': 'LAN'},
      'opt1': {'value': 'opt1', 'selected': 0, 'description': 'OPT1'},
    };
  }

  // State management helpers
  bool _getFirewallRuleState(String uuid, bool defaultState) {
    return _firewallRuleStates.putIfAbsent(uuid, () => defaultState);
  }

  void toggleFirewallRuleState(String uuid) {
    _firewallRuleStates[uuid] = !(_firewallRuleStates[uuid] ?? true);
  }

  bool _getVPNConnectionState(String id, bool defaultState) {
    return _vpnConnectionStates.putIfAbsent(id, () => defaultState);
  }

  void toggleVPNConnectionState(String id) {
    _vpnConnectionStates[id] = !(_vpnConnectionStates[id] ?? false);
  }

  bool _getServiceState(String name, bool defaultState) {
    return _serviceStates.putIfAbsent(name, () => defaultState);
  }

  void toggleServiceState(String name) {
    _serviceStates[name] = !(_serviceStates[name] ?? true);
  }

  /// Reset all demo states
  void reset() {
    _firewallRuleStates.clear();
    _vpnConnectionStates.clear();
    _serviceStates.clear();
  }
}

