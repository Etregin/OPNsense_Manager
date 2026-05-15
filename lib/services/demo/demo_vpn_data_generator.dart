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
import '../../models/vpn_connection.dart';
import 'demo_state_manager.dart';

/// Generator for VPN-related demo data
/// 
/// Handles generation of:
/// - VPN connections (OpenVPN, IPsec, WireGuard, Tailscale)
/// - WireGuard clients and servers
/// - IPsec connections, sessions (Phase 1 & 2), and leases
class DemoVPNDataGenerator {
  final DemoStateManager _stateManager;
  final Random _random = Random();

  DemoVPNDataGenerator(this._stateManager);

  /// Generate demo VPN connections with various types
  List<VPNConnection> generateVPNConnections() {
    return [
      VPNConnection(
        id: 'demo-vpn-1',
        name: 'Office VPN',
        type: 'openvpn',
        status: _stateManager.getVPNConnectionState('demo-vpn-1', true) ? 'up' : 'down',
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
        status: _stateManager.getVPNConnectionState('demo-vpn-2', true) ? 'up' : 'down',
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
        status: _stateManager.getVPNConnectionState('demo-vpn-3', false) ? 'up' : 'down',
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
        status: _stateManager.getVPNConnectionState('demo-vpn-4', true) ? 'up' : 'down',
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
        status: _stateManager.getVPNConnectionState('demo-vpn-5', true) ? 'up' : 'down',
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
}


