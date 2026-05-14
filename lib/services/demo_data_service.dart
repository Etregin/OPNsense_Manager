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
import 'package:flutter/foundation.dart';
import '../models/system_info.dart';
import '../models/firewall_rule.dart';
import '../models/firewall_alias.dart';
import '../models/vpn_connection.dart';
import '../models/network_host.dart';
import '../models/tailscale_status.dart';
import '../models/tailscale_settings.dart';

/// Service for generating realistic demo data
class DemoDataService {
  static final DemoDataService _instance = DemoDataService._internal();
  factory DemoDataService() => _instance;
  DemoDataService._internal();

  final Random _random = Random();
  
  // Simulated state for demo mode
  final Map<String, bool> _firewallRuleStates = {};
  final Map<String, bool> _firewallAliasStates = {};
  final Set<String> _deletedAliases = {};
  final Map<String, bool> _vpnConnectionStates = {};
  final Map<String, bool> _serviceStates = {};
  int _nextAliasId = 10;
  
  // Tailscale state
  bool _tailscaleServiceRunning = true;
  bool _tailscaleAuthenticated = true;
  Map<String, dynamic> _tailscaleSettings = {
    'accept_routes': true,
    'advertise_routes': '192.168.1.0/24,10.0.0.0/24',
    'exit_node': '',
    'use_exit_node': false,
    'dns_enabled': true,
    'magic_dns': true,
    'ssh_enabled': true,
    'tags': ['tag:server', 'tag:firewall'],
    'hostname': 'demo-opnsense',
  };
  
  // Tailscale subnets storage
  final Map<String, TailscaleSubnet> _tailscaleSubnets = {
    'demo-subnet-1': TailscaleSubnet(
      uuid: 'demo-subnet-1',
      subnet: '192.168.1.0/24',
      description: 'LAN Network',
    ),
    'demo-subnet-2': TailscaleSubnet(
      uuid: 'demo-subnet-2',
      subnet: '10.0.0.0/24',
      description: 'Internal Services',
    ),
  };
  int _nextSubnetId = 3;

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
      VPNConnection(
        id: 'demo-vpn-4',
        name: 'WireGuard Server',
        type: 'wireguard',
        status: _getVPNConnectionState('demo-vpn-4', true) ? 'up' : 'down',
        description: 'Main WireGuard VPN server',
        remoteAddress: null,
        localAddress: '192.168.1.1',
        virtualAddress: '10.10.0.1',
        bytesReceived: 1024 * 1024 * 450 + _random.nextInt(1024 * 1024 * 100),
        bytesSent: 1024 * 1024 * 280 + _random.nextInt(1024 * 1024 * 50),
        connectedSince: DateTime.now().subtract(Duration(days: 7, hours: _random.nextInt(24))),
        protocol: 'UDP',
        port: 51820,
        enabled: true,
      ),
      VPNConnection(
        id: 'demo-vpn-5',
        name: 'Tailscale Mesh',
        type: 'tailscale',
        status: _getVPNConnectionState('demo-vpn-5', true) ? 'up' : 'down',
        description: 'Tailscale mesh network',
        remoteAddress: null,
        localAddress: '100.64.0.1',
        virtualAddress: '100.64.0.1',
        bytesReceived: 1024 * 1024 * 95 + _random.nextInt(1024 * 1024 * 20),
        bytesSent: 1024 * 1024 * 62 + _random.nextInt(1024 * 1024 * 15),
        connectedSince: DateTime.now().subtract(Duration(days: 14, hours: _random.nextInt(24))),
        protocol: 'WireGuard',
        port: 41641,
        enabled: true,
      ),
    ];
  }

  /// Generate demo Tailscale status
  TailscaleStatus generateTailscaleStatus() {
    final isConnected = _tailscaleServiceRunning && _tailscaleAuthenticated;
    
    return TailscaleStatus(
      // Authentication fields - matching real API structure
      authenticated: _tailscaleAuthenticated,
      loginState: _tailscaleAuthenticated ? 'authenticated' : 'unauthenticated',
      // authUrl comes from status.AuthURL (empty when authenticated)
      authUrl: _tailscaleAuthenticated ? null : 'https://login.tailscale.com/admin/machines/auth/demo-key-12345',
      // tailnet comes from status.CurrentTailnet.Name
      tailnet: _tailscaleAuthenticated ? 'demo-network.ts.net' : null,
      // user comes from status.User[userID].LoginName
      user: _tailscaleAuthenticated ? 'demo-user@example.com' : null,
      // deviceName comes from status.Self.HostName
      deviceName: _tailscaleAuthenticated ? 'demo-opnsense' : null,
      
      // Settings fields - matching real API structure from settings endpoint
      // acceptRoutes from settings.acceptSubnetRoutes
      acceptRoutes: _tailscaleSettings['accept_routes'] as bool,
      // advertiseRoutes from settings.subnets (comma-separated)
      advertiseRoutes: _tailscaleSettings['advertise_routes'] as String?,
      // exitNode from settings.exitNode
      exitNode: (_tailscaleSettings['exit_node'] as String?)?.isEmpty == true
          ? null
          : _tailscaleSettings['exit_node'] as String?,
      // useExitNode from settings.useExitNode
      useExitNode: _tailscaleSettings['use_exit_node'] as bool,
      // dnsEnabled from settings.acceptDNS
      dnsEnabled: _tailscaleSettings['dns_enabled'] as bool,
      // magicDns from status.CurrentTailnet.MagicDNSEnabled
      magicDns: _tailscaleSettings['magic_dns'] as bool,
      // sshEnabled from settings.enableSSH
      sshEnabled: _tailscaleSettings['ssh_enabled'] as bool,
      tags: List<String>.from(_tailscaleSettings['tags'] as List),
      hostname: _tailscaleSettings['hostname'] as String?,
      
      // Status fields - matching real API structure
      serviceRunning: _tailscaleServiceRunning,
      // backendState from status.BackendState
      backendState: isConnected ? 'Running' : _tailscaleServiceRunning ? 'Starting' : 'Stopped',
      // ips from status.Self.TailscaleIPs
      ips: isConnected ? ['100.64.0.1', 'fd7a:115c:a1e0::1'] : [],
      // bytesReceived from status.Self.RxBytes
      bytesReceived: isConnected ? 1024 * 1024 * 95 + _random.nextInt(1024 * 1024 * 20) : null,
      // bytesSent from status.Self.TxBytes
      bytesSent: isConnected ? 1024 * 1024 * 62 + _random.nextInt(1024 * 1024 * 15) : null,
      connectedSince: isConnected ? DateTime.now().subtract(Duration(days: 14, hours: _random.nextInt(24))) : null,
      // health from status.Health array (null or empty = healthy)
      health: null,
      // peersCount from status.Peer object count
      peersCount: isConnected ? 5 + _random.nextInt(3) : 0,
      // version from status.Version
      version: '1.56.1',
    );
  }

  /// Generate demo WireGuard clients
  List<Map<String, dynamic>> generateWireGuardClients() {
    return [
      {
        'uuid': 'wg-client-1',
        'enabled': '1',
        'name': 'Mobile Device',
        'pubkey': 'xTIBA5rboUvnH4htodjb6e697QjLERt1NAB4mZqp8Dg=',
        'tunneladdress': '10.10.0.2/32',
        'serveraddress': '',
        'serverport': '',
        'keepalive': '25',
      },
      {
        'uuid': 'wg-client-2',
        'enabled': '1',
        'name': 'Laptop',
        'pubkey': 'HIgo9xNzJMWLKASShiTqIybxZ0U3wGLiUeJ1PKf8ykw=',
        'tunneladdress': '10.10.0.3/32',
        'serveraddress': '',
        'serverport': '',
        'keepalive': '25',
      },
      {
        'uuid': 'wg-client-3',
        'enabled': '0',
        'name': 'Tablet',
        'pubkey': 'gN65BkIKy1eCE9pP1wdc8ROUtkHLF2PfAqYdyYBz6EA=',
        'tunneladdress': '10.10.0.4/32',
        'serveraddress': '',
        'serverport': '',
        'keepalive': '25',
      },
    ];
  }

  /// Generate demo WireGuard servers
  List<Map<String, dynamic>> generateWireGuardServers() {
    return [
      {
        'uuid': 'wg-server-1',
        'enabled': '1',
        'name': 'Main WireGuard Server',
        'pubkey': 'qRCwZSKInrMAq5sepfCdaCsRJaoLe5jhtzfiw7CjbwM=',
        'privkey': '***',
        'port': '51820',
        'tunneladdress': '10.10.0.1/24',
        'peers': '3',
        'disableroutes': '0',
        'gateway': '',
      },
    ];
  }

  /// Generate demo IPsec connections
  List<Map<String, dynamic>> generateIPsecConnections() {
    return [
      {
        'uuid': 'ipsec-conn-1',
        'enabled': '1',
        'description': 'Site-to-Site VPN',
        'local_addrs': '192.168.1.1',
        'remote_addrs': '198.51.100.25',
        'version': '2',
        'mobike': '1',
        'reauth_time': '0',
        'rekey_time': '3600',
        'dpd_delay': '30',
        'dpd_maxfail': '5',
      },
      {
        'uuid': 'ipsec-conn-2',
        'enabled': '1',
        'description': 'Branch Office',
        'local_addrs': '192.168.1.1',
        'remote_addrs': '203.0.113.50',
        'version': '2',
        'mobike': '1',
        'reauth_time': '0',
        'rekey_time': '3600',
        'dpd_delay': '30',
        'dpd_maxfail': '5',
      },
      {
        'uuid': 'ipsec-conn-3',
        'enabled': '0',
        'description': 'Remote Workers',
        'local_addrs': '192.168.1.1',
        'remote_addrs': '%any',
        'version': '2',
        'mobike': '1',
        'reauth_time': '0',
        'rekey_time': '3600',
        'dpd_delay': '30',
        'dpd_maxfail': '5',
      },
    ];
  }

  /// Generate demo IPsec Phase 1 sessions
  List<Map<String, dynamic>> generateIPsecSessionsPhase1() {
    return [
      {
        'id': 'ipsec-sess-1',
        'name': 'Site-to-Site VPN',
        'version': 'IKEv2',
        'local-host': '192.168.1.1',
        'local-port': '500',
        'local-id': '192.168.1.1',
        'remote-host': '198.51.100.25',
        'remote-port': '500',
        'remote-id': '198.51.100.25',
        'initiator': 'yes',
        'initiator-spi': 'c6ce4fae754a6c6d',
        'responder-spi': '8d6e9c5f4b3a2e1d',
        'nat-remote': 'no',
        'nat-local': 'no',
        'encr-alg': 'AES_CBC',
        'encr-keysize': '256',
        'integ-alg': 'HMAC_SHA2_256_128',
        'prf-alg': 'PRF_HMAC_SHA2_256',
        'dh-group': 'MODP_2048',
        'established': '3600',
        'rekey-time': '3240',
        'state': 'ESTABLISHED',
      },
      {
        'id': 'ipsec-sess-2',
        'name': 'Branch Office',
        'version': 'IKEv2',
        'local-host': '192.168.1.1',
        'local-port': '500',
        'local-id': '192.168.1.1',
        'remote-host': '203.0.113.50',
        'remote-port': '500',
        'remote-id': '203.0.113.50',
        'initiator': 'yes',
        'initiator-spi': 'a1b2c3d4e5f6a7b8',
        'responder-spi': '9c8d7e6f5a4b3c2d',
        'nat-remote': 'no',
        'nat-local': 'no',
        'encr-alg': 'AES_CBC',
        'encr-keysize': '256',
        'integ-alg': 'HMAC_SHA2_256_128',
        'prf-alg': 'PRF_HMAC_SHA2_256',
        'dh-group': 'MODP_2048',
        'established': '7200',
        'rekey-time': '6480',
        'state': 'ESTABLISHED',
      },
    ];
  }

  /// Generate demo IPsec Phase 2 sessions
  List<Map<String, dynamic>> generateIPsecSessionsPhase2() {
    return [
      {
        'id': 'ipsec-child-1',
        'name': 'Site-to-Site VPN',
        'uniqueid': '1',
        'reqid': '1',
        'state': 'INSTALLED',
        'mode': 'TUNNEL',
        'protocol': 'ESP',
        'encr-alg': 'AES_CBC',
        'encr-keysize': '256',
        'integ-alg': 'HMAC_SHA2_256_128',
        'prf-alg': 'PRF_HMAC_SHA2_256',
        'dh-group': 'MODP_2048',
        'local-ts': '192.168.1.0/24',
        'remote-ts': '10.20.0.0/24',
        'bytes-in': '${1024 * 1024 * 320}',
        'bytes-out': '${1024 * 1024 * 180}',
        'packets-in': '12500',
        'packets-out': '8900',
        'install-time': '3600',
        'rekey-time': '3240',
      },
      {
        'id': 'ipsec-child-2',
        'name': 'Branch Office',
        'uniqueid': '2',
        'reqid': '2',
        'state': 'INSTALLED',
        'mode': 'TUNNEL',
        'protocol': 'ESP',
        'encr-alg': 'AES_CBC',
        'encr-keysize': '256',
        'integ-alg': 'HMAC_SHA2_256_128',
        'prf-alg': 'PRF_HMAC_SHA2_256',
        'dh-group': 'MODP_2048',
        'local-ts': '192.168.1.0/24',
        'remote-ts': '10.30.0.0/24',
        'bytes-in': '${1024 * 1024 * 150}',
        'bytes-out': '${1024 * 1024 * 95}',
        'packets-in': '6800',
        'packets-out': '4200',
        'install-time': '7200',
        'rekey-time': '6480',
      },
    ];
  }

  /// Generate demo IPsec leases
  List<Map<String, dynamic>> generateIPsecLeases() {
    return [
      {
        'id': 'lease-1',
        'pool': 'road-warrior-pool',
        'address': '10.9.0.10',
        'identity': 'user1@example.com',
        'status': 'online',
        'expires': DateTime.now().add(const Duration(hours: 8)).toIso8601String(),
      },
      {
        'id': 'lease-2',
        'pool': 'road-warrior-pool',
        'address': '10.9.0.11',
        'identity': 'user2@example.com',
        'status': 'online',
        'expires': DateTime.now().add(const Duration(hours: 6)).toIso8601String(),
      },
      {
        'id': 'lease-3',
        'pool': 'road-warrior-pool',
        'address': '10.9.0.12',
        'identity': 'user3@example.com',
        'status': 'offline',
        'expires': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
      },
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
  /// Generate demo network hosts with bandwidth usage
  List<NetworkHost> generateNetworkHosts() {
    final hosts = <NetworkHost>[
      NetworkHost(
        address: '192.168.1.10',
        hostname: 'desktop-gaming',
        manufacturer: 'Intel Corporate',
        macAddress: '00:1A:2B:3C:4D:5E',
        rateIn: 15000000 + _random.nextInt(5000000), // 15-20 Mbps download
        rateOut: 2000000 + _random.nextInt(1000000),  // 2-3 Mbps upload
        leaseExpiry: DateTime.now().add(Duration(hours: 12 + _random.nextInt(12))),
      ),
      NetworkHost(
        address: '192.168.1.15',
        hostname: 'iphone-john',
        manufacturer: 'Apple, Inc.',
        macAddress: '00:1B:63:84:45:E6',
        rateIn: 8000000 + _random.nextInt(4000000),  // 8-12 Mbps download
        rateOut: 1000000 + _random.nextInt(500000),  // 1-1.5 Mbps upload
        leaseExpiry: DateTime.now().add(Duration(hours: 6 + _random.nextInt(6))),
      ),
      NetworkHost(
        address: '192.168.1.20',
        hostname: 'smart-tv-living',
        manufacturer: 'Samsung Electronics',
        macAddress: '00:1C:42:00:00:09',
        rateIn: 25000000 + _random.nextInt(10000000), // 25-35 Mbps (4K streaming)
        rateOut: 500000 + _random.nextInt(300000),    // 0.5-0.8 Mbps upload
        leaseExpiry: DateTime.now().add(Duration(hours: 24)),
      ),
      NetworkHost(
        address: '192.168.1.25',
        hostname: 'laptop-work',
        manufacturer: 'Dell Inc.',
        macAddress: '00:1D:60:B3:01:84',
        rateIn: 5000000 + _random.nextInt(3000000),  // 5-8 Mbps download
        rateOut: 800000 + _random.nextInt(400000),   // 0.8-1.2 Mbps upload
        leaseExpiry: DateTime.now().add(Duration(hours: 8 + _random.nextInt(8))),
      ),
      NetworkHost(
        address: '192.168.1.30',
        hostname: 'nas-server',
        manufacturer: 'Synology Inc.',
        macAddress: '00:11:32:2C:A7:85',
        rateIn: 3000000 + _random.nextInt(2000000),  // 3-5 Mbps download
        rateOut: 10000000 + _random.nextInt(5000000), // 10-15 Mbps upload (backup)
        leaseExpiry: DateTime.now().add(Duration(days: 7)),
      ),
      NetworkHost(
        address: '192.168.1.35',
        hostname: 'tablet-kids',
        manufacturer: 'Amazon Technologies',
        macAddress: '00:FC:8B:33:44:55',
        rateIn: 4000000 + _random.nextInt(2000000),  // 4-6 Mbps download
        rateOut: 300000 + _random.nextInt(200000),   // 0.3-0.5 Mbps upload
        leaseExpiry: DateTime.now().add(Duration(hours: 4 + _random.nextInt(4))),
      ),
      NetworkHost(
        address: '192.168.1.40',
        hostname: 'security-camera-1',
        manufacturer: 'Hikvision',
        macAddress: '00:12:17:A0:B1:C2',
        rateIn: 100000 + _random.nextInt(50000),     // 0.1-0.15 Mbps download
        rateOut: 2000000 + _random.nextInt(1000000), // 2-3 Mbps upload (video)
        leaseExpiry: DateTime.now().add(Duration(days: 30)),
      ),
      NetworkHost(
        address: '192.168.1.45',
        hostname: 'iot-hub',
        manufacturer: 'Raspberry Pi Foundation',
        macAddress: 'B8:27:EB:12:34:56',
        rateIn: 200000 + _random.nextInt(100000),    // 0.2-0.3 Mbps download
        rateOut: 150000 + _random.nextInt(100000),   // 0.15-0.25 Mbps upload
        leaseExpiry: DateTime.now().add(Duration(days: 90)),
      ),
      NetworkHost(
        address: '192.168.1.50',
        hostname: 'android-tablet',
        manufacturer: 'Google, Inc.',
        macAddress: '00:1A:11:FF:EE:DD',
        rateIn: 6000000 + _random.nextInt(3000000),  // 6-9 Mbps download
        rateOut: 700000 + _random.nextInt(300000),   // 0.7-1 Mbps upload
        leaseExpiry: DateTime.now().add(Duration(hours: 10 + _random.nextInt(10))),
      ),
      NetworkHost(
        address: '192.168.1.55',
        hostname: '192.168.1.55', // Unknown device (no hostname)
        manufacturer: null,
        macAddress: null,
        rateIn: 1000000 + _random.nextInt(500000),   // 1-1.5 Mbps download
        rateOut: 500000 + _random.nextInt(300000),   // 0.5-0.8 Mbps upload
        leaseExpiry: null,
      ),
    ];

    // Sort by total bandwidth usage (highest first)
    hosts.sort((a, b) => b.totalRate.compareTo(a.totalRate));
    
    return hosts;
  }

  /// Generate demo DHCP leases
  List<Map<String, dynamic>> generateDhcpLeases() {
    final now = DateTime.now();
    
    return [
      {
        'address': '192.168.1.10',
        'hostname': 'desktop-gaming',
        'hwaddr': '00:1A:2B:3C:4D:5E',
        'mac_info': 'ASUS',
        'starts': now.subtract(const Duration(hours: 48)).millisecondsSinceEpoch ~/ 1000,
        'ends': now.add(const Duration(hours: 24)).millisecondsSinceEpoch ~/ 1000,
        'expire': now.add(const Duration(hours: 24)).millisecondsSinceEpoch ~/ 1000,
        'state': 'active',
        'if': 'lan',
        'type': 'static',
      },
      {
        'address': '192.168.1.15',
        'hostname': 'iphone-john',
        'hwaddr': '00:1B:63:84:45:E6',
        'mac_info': 'Apple, Inc.',
        'starts': now.subtract(const Duration(hours: 12)).millisecondsSinceEpoch ~/ 1000,
        'ends': now.add(const Duration(hours: 12)).millisecondsSinceEpoch ~/ 1000,
        'expire': now.add(const Duration(hours: 12)).millisecondsSinceEpoch ~/ 1000,
        'state': 'active',
        'if': 'lan',
        'type': 'dynamic',
      },
      {
        'address': '192.168.1.20',
        'hostname': 'smart-tv-living',
        'hwaddr': '00:1C:42:00:00:09',
        'mac_info': 'Samsung Electronics',
        'starts': now.subtract(const Duration(days: 2)).millisecondsSinceEpoch ~/ 1000,
        'ends': now.add(const Duration(hours: 24)).millisecondsSinceEpoch ~/ 1000,
        'expire': now.add(const Duration(hours: 24)).millisecondsSinceEpoch ~/ 1000,
        'state': 'active',
        'if': 'lan',
        'type': 'dynamic',
      },
      {
        'address': '192.168.1.25',
        'hostname': 'laptop-work',
        'hwaddr': '00:1D:60:B3:01:84',
        'mac_info': 'Dell Inc.',
        'starts': now.subtract(const Duration(hours: 8)).millisecondsSinceEpoch ~/ 1000,
        'ends': now.add(const Duration(hours: 16)).millisecondsSinceEpoch ~/ 1000,
        'expire': now.add(const Duration(hours: 16)).millisecondsSinceEpoch ~/ 1000,
        'state': 'active',
        'if': 'lan',
        'type': 'dynamic',
      },
      {
        'address': '192.168.1.30',
        'hostname': 'nas-server',
        'hwaddr': '00:11:32:2C:A7:85',
        'mac_info': 'Synology Inc.',
        'starts': now.subtract(const Duration(days: 7)).millisecondsSinceEpoch ~/ 1000,
        'ends': now.add(const Duration(days: 7)).millisecondsSinceEpoch ~/ 1000,
        'expire': now.add(const Duration(days: 7)).millisecondsSinceEpoch ~/ 1000,
        'state': 'active',
        'if': 'lan',
        'type': 'static',
      },
      {
        'address': '192.168.1.35',
        'hostname': 'tablet-kids',
        'hwaddr': '00:FC:8B:33:44:55',
        'mac_info': 'Amazon Technologies',
        'starts': now.subtract(const Duration(hours: 6)).millisecondsSinceEpoch ~/ 1000,
        'ends': now.add(const Duration(hours: 6)).millisecondsSinceEpoch ~/ 1000,
        'expire': now.add(const Duration(hours: 6)).millisecondsSinceEpoch ~/ 1000,
        'state': 'active',
        'if': 'lan',
        'type': 'dynamic',
      },
      {
        'address': '192.168.1.40',
        'hostname': 'security-camera-1',
        'hwaddr': '00:12:17:A0:B1:C2',
        'mac_info': 'Hikvision',
        'starts': now.subtract(const Duration(days: 30)).millisecondsSinceEpoch ~/ 1000,
        'ends': now.add(const Duration(days: 30)).millisecondsSinceEpoch ~/ 1000,
        'expire': now.add(const Duration(days: 30)).millisecondsSinceEpoch ~/ 1000,
        'state': 'active',
        'if': 'lan',
        'type': 'static',
      },
      {
        'address': '192.168.1.45',
        'hostname': 'iot-hub',
        'hwaddr': 'B8:27:EB:12:34:56',
        'mac_info': 'Raspberry Pi Foundation',
        'starts': now.subtract(const Duration(days: 90)).millisecondsSinceEpoch ~/ 1000,
        'ends': now.add(const Duration(days: 90)).millisecondsSinceEpoch ~/ 1000,
        'expire': now.add(const Duration(days: 90)).millisecondsSinceEpoch ~/ 1000,
        'state': 'active',
        'if': 'lan',
        'type': 'static',
      },
      {
        'address': '192.168.1.50',
        'hostname': 'android-tablet',
        'hwaddr': '00:1A:11:FF:EE:DD',
        'mac_info': 'Google, Inc.',
        'starts': now.subtract(const Duration(hours: 18)).millisecondsSinceEpoch ~/ 1000,
        'ends': now.add(const Duration(hours: 18)).millisecondsSinceEpoch ~/ 1000,
        'expire': now.add(const Duration(hours: 18)).millisecondsSinceEpoch ~/ 1000,
        'state': 'active',
        'if': 'lan',
        'type': 'dynamic',
      },
      {
        'address': '192.168.1.100',
        'hostname': 'old-laptop',
        'hwaddr': 'AA:BB:CC:DD:EE:FF',
        'mac_info': 'HP Inc.',
        'starts': now.subtract(const Duration(days: 5)).millisecondsSinceEpoch ~/ 1000,
        'ends': now.subtract(const Duration(hours: 2)).millisecondsSinceEpoch ~/ 1000,
        'expire': now.subtract(const Duration(hours: 2)).millisecondsSinceEpoch ~/ 1000,
        'state': 'expired',
        'if': 'lan',
        'type': 'dynamic',
      },
      {
        'address': '192.168.1.101',
        'hostname': 'guest-phone',
        'hwaddr': '11:22:33:44:55:66',
        'mac_info': 'Xiaomi Communications',
        'starts': now.subtract(const Duration(days: 1)).millisecondsSinceEpoch ~/ 1000,
        'ends': now.subtract(const Duration(minutes: 30)).millisecondsSinceEpoch ~/ 1000,
        'expire': now.subtract(const Duration(minutes: 30)).millisecondsSinceEpoch ~/ 1000,
        'state': 'expired',
        'if': 'lan',
      },
    ];
  }

  /// Generate demo firewall aliases
  List<FirewallAlias> generateFirewallAliases() {
    final aliases = <FirewallAlias>[
      FirewallAlias(
        uuid: 'demo-alias-1',
        name: 'RFC1918_Networks',
        type: 'network',
        content: '10.0.0.0/8,172.16.0.0/12,192.168.0.0/16',
        description: 'Private IPv4 address ranges',
        enabled: _getFirewallAliasState('demo-alias-1', true) ? '1' : '0',
        counters: '1',
      ),
      FirewallAlias(
        uuid: 'demo-alias-2',
        name: 'Trusted_Hosts',
        type: 'host',
        content: '192.168.1.10,192.168.1.15,192.168.1.20',
        description: 'Trusted devices on LAN',
        enabled: _getFirewallAliasState('demo-alias-2', true) ? '1' : '0',
        counters: '1',
      ),
      FirewallAlias(
        uuid: 'demo-alias-3',
        name: 'Web_Ports',
        type: 'port',
        content: '80,443,8080,8443',
        description: 'Common web service ports',
        enabled: _getFirewallAliasState('demo-alias-3', true) ? '1' : '0',
        proto: 'tcp',
      ),
      FirewallAlias(
        uuid: 'demo-alias-4',
        name: 'DNS_Servers',
        type: 'host',
        content: '8.8.8.8,8.8.4.4,1.1.1.1,1.0.0.1',
        description: 'Public DNS servers (Google, Cloudflare)',
        enabled: _getFirewallAliasState('demo-alias-4', true) ? '1' : '0',
        counters: '1',
      ),
      FirewallAlias(
        uuid: 'demo-alias-5',
        name: 'Blocked_Countries',
        type: 'geoip',
        content: 'CN,RU,KP',
        description: 'Countries to block',
        enabled: _getFirewallAliasState('demo-alias-5', false) ? '1' : '0',
      ),
      FirewallAlias(
        uuid: 'demo-alias-6',
        name: 'Mail_Ports',
        type: 'port',
        content: '25,465,587,993,995',
        description: 'Email service ports',
        enabled: _getFirewallAliasState('demo-alias-6', true) ? '1' : '0',
        proto: 'tcp',
      ),
      FirewallAlias(
        uuid: 'demo-alias-7',
        name: 'IoT_Devices',
        type: 'host',
        content: '192.168.1.40,192.168.1.45',
        description: 'IoT and smart home devices',
        enabled: _getFirewallAliasState('demo-alias-7', true) ? '1' : '0',
        counters: '1',
      ),
      FirewallAlias(
        uuid: 'demo-alias-8',
        name: 'VPN_Ports',
        type: 'port',
        content: '1194,1723,500,4500',
        description: 'VPN service ports (OpenVPN, PPTP, IPSec)',
        enabled: _getFirewallAliasState('demo-alias-8', true) ? '1' : '0',
        proto: 'udp',
      ),
    ];

    // Filter out deleted aliases
    return aliases.where((alias) => !_deletedAliases.contains(alias.uuid)).toList();
  }

  /// Get firewall alias state
  bool _getFirewallAliasState(String uuid, bool defaultState) {
    return _firewallAliasStates.putIfAbsent(uuid, () => defaultState);
  }

  /// Toggle firewall alias state
  void toggleFirewallAliasState(String uuid) {
    final currentState = _firewallAliasStates[uuid] ?? true;
    _firewallAliasStates[uuid] = !currentState;
  }

  /// Delete firewall alias
  void deleteFirewallAlias(String uuid) {
    _deletedAliases.add(uuid);
  }

  /// Get next alias ID for creating new aliases
  int getNextAliasId() {
    return _nextAliasId++;
  }

  /// Update Tailscale service state
  void updateTailscaleServiceState(String action) {
    switch (action) {
      case 'start':
        _tailscaleServiceRunning = true;
        break;
      case 'stop':
        _tailscaleServiceRunning = false;
        break;
      case 'restart':
        _tailscaleServiceRunning = true;
        break;
    }
  }

  /// Update Tailscale settings
  void updateTailscaleSettings(Map<String, dynamic> settings) {
    _tailscaleSettings = Map<String, dynamic>.from(settings);
  }

  /// Logout from Tailscale
  void logoutTailscale() {
    _tailscaleAuthenticated = false;
  }

  // ==================== Tailscale Settings Management ====================

  /// Generate Tailscale settings response
  TailscaleSettingsResponse generateTailscaleSettings() {
    return TailscaleSettingsResponse(
      settings: TailscaleSettings(
        enabled: _tailscaleServiceRunning,
        loginTimeout: '60',
        listenPort: '41641',
        acceptDNS: _tailscaleSettings['dns_enabled'] as bool,
        advertiseExitNode: false,
        useExitNode: _buildExitNodeMap(),
        acceptSubnetRoutes: _tailscaleSettings['accept_routes'] as bool,
        enableSSH: _tailscaleSettings['ssh_enabled'] as bool,
        disableSNAT: false,
        subnets: Map<String, TailscaleSubnet>.from(_tailscaleSubnets),
      ),
    );
  }

  /// Build exit node map structure
  Map<String, TailscaleExitNode> _buildExitNodeMap() {
    final exitNode = _tailscaleSettings['exit_node'] as String?;
    if (exitNode == null || exitNode.isEmpty) {
      return {
        '': TailscaleExitNode(value: 'None', selected: true),
      };
    }
    return {
      '': TailscaleExitNode(value: 'None', selected: false),
      exitNode: TailscaleExitNode(value: exitNode, selected: true),
    };
  }

  /// Update Tailscale settings data
  void updateTailscaleSettingsData(TailscaleSettings settings) {
    debugPrint('🔄 [DemoDataService] Updating Tailscale settings...');
    debugPrint('🔍 [DemoDataService] Settings: enabled=${settings.enabled}, acceptDNS=${settings.acceptDNS}');
    
    try {
      if (settings.enabled != null) {
        debugPrint('✓ [DemoDataService] Updating enabled: ${settings.enabled}');
        _tailscaleServiceRunning = settings.enabled!;
      }
      if (settings.acceptDNS != null) {
        debugPrint('✓ [DemoDataService] Updating acceptDNS: ${settings.acceptDNS}');
        _tailscaleSettings['dns_enabled'] = settings.acceptDNS!;
      }
      if (settings.acceptSubnetRoutes != null) {
        debugPrint('✓ [DemoDataService] Updating acceptSubnetRoutes: ${settings.acceptSubnetRoutes}');
        _tailscaleSettings['accept_routes'] = settings.acceptSubnetRoutes!;
      }
      if (settings.enableSSH != null) {
        debugPrint('✓ [DemoDataService] Updating enableSSH: ${settings.enableSSH}');
        _tailscaleSettings['ssh_enabled'] = settings.enableSSH!;
      }
      
      // Update exit node if provided
      if (settings.useExitNode != null) {
        debugPrint('🔍 [DemoDataService] Processing useExitNode: ${settings.useExitNode}');
        try {
          final selectedNode = settings.selectedExitNode;
          debugPrint('🔍 [DemoDataService] Selected node: $selectedNode');
          
          if (selectedNode != null && selectedNode.value != null && selectedNode.value != 'None') {
            debugPrint('✓ [DemoDataService] Setting exit node: ${selectedNode.value}');
            _tailscaleSettings['exit_node'] = selectedNode.value!;
            _tailscaleSettings['use_exit_node'] = true;
          } else {
            debugPrint('✓ [DemoDataService] Clearing exit node');
            _tailscaleSettings['exit_node'] = '';
            _tailscaleSettings['use_exit_node'] = false;
          }
        } catch (exitNodeError) {
          debugPrint('❌ [DemoDataService] Error processing exit node: $exitNodeError');
          rethrow;
        }
      }
      
      debugPrint('✅ [DemoDataService] Settings updated successfully');
    } catch (e, stackTrace) {
      debugPrint('❌ [DemoDataService] Error updating settings: $e');
      debugPrint('❌ [DemoDataService] Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Generate subnet search response
  TailscaleSubnetSearchResponse generateTailscaleSubnetSearch() {
    final subnetList = _tailscaleSubnets.values.toList();
    return TailscaleSubnetSearchResponse(
      rows: subnetList,
      rowCount: subnetList.length,
      total: subnetList.length,
      current: 1,
    );
  }

  /// Generate a specific subnet response
  TailscaleSubnetResponse generateTailscaleSubnet(String uuid) {
    final subnet = _tailscaleSubnets[uuid];
    if (subnet == null) {
      throw Exception('Subnet not found: $uuid');
    }
    return TailscaleSubnetResponse(subnet: subnet);
  }

  /// Add a new Tailscale subnet
  String addTailscaleSubnet(TailscaleSubnet subnet) {
    final uuid = 'demo-subnet-$_nextSubnetId';
    _nextSubnetId++;
    _tailscaleSubnets[uuid] = TailscaleSubnet(
      uuid: uuid,
      subnet: subnet.subnet,
      description: subnet.description,
    );
    return uuid;
  }

  /// Update an existing Tailscale subnet
  void updateTailscaleSubnet(String uuid, TailscaleSubnet subnet) {
    if (_tailscaleSubnets.containsKey(uuid)) {
      _tailscaleSubnets[uuid] = TailscaleSubnet(
        uuid: uuid,
        subnet: subnet.subnet,
        description: subnet.description,
      );
    }
  }

  /// Delete a Tailscale subnet
  void deleteTailscaleSubnet(String uuid) {
    _tailscaleSubnets.remove(uuid);
  }

  /// Reset all demo states
  void reset() {
    _firewallRuleStates.clear();
    _firewallAliasStates.clear();
    _deletedAliases.clear();
    _vpnConnectionStates.clear();
    _serviceStates.clear();
    _nextAliasId = 10;
    // Reset Tailscale state
    _tailscaleServiceRunning = true;
    _tailscaleAuthenticated = true;
    _tailscaleSettings = {
      'accept_routes': true,
      'advertise_routes': '192.168.1.0/24,10.0.0.0/24',
      'exit_node': '',
      'use_exit_node': false,
      'dns_enabled': true,
      'magic_dns': true,
      'ssh_enabled': true,
      'tags': ['tag:server', 'tag:firewall'],
      'hostname': 'demo-opnsense',
    };
    // Reset Tailscale subnets
    _tailscaleSubnets.clear();
    _tailscaleSubnets['demo-subnet-1'] = TailscaleSubnet(
      uuid: 'demo-subnet-1',
      subnet: '192.168.1.0/24',
      description: 'LAN Network',
    );
    _tailscaleSubnets['demo-subnet-2'] = TailscaleSubnet(
      uuid: 'demo-subnet-2',
      subnet: '10.0.0.0/24',
      description: 'Internal Services',
    );
    _nextSubnetId = 3;
  }
}

