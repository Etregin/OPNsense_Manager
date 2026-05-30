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
import '../../models/wireguard_status.dart';
import '../../models/openvpn_instance_list_item.dart';
import '../../models/openvpn_instance.dart';
import '../../models/openvpn_static_key.dart';
import 'demo_state_manager.dart';

/// Generator for VPN-related demo data
/// 
/// Handles generation of:
/// - VPN connections (OpenVPN, WireGuard, Tailscale)
/// - WireGuard clients and servers
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
        type: 'wireguard',
        status: _stateManager.getVPNConnectionState('demo-vpn-2', true) ? 'up' : 'down',
        description: 'Remote site WireGuard tunnel',
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

  /// Generate demo WireGuard peers
  List<Map<String, dynamic>> generateWireGuardPeers() {
    return [
      {
        'uuid': 'wg-peer-1',
        'enabled': '1',
        'name': 'Mobile Device',
        'pubkey': 'xTIBA5rboUvnH4htodjb6e697QjLERt1NAB4mZqp8Dg=',
        'tunneladdress': '10.10.0.2/32',
        'serveraddress': '',
        'serverport': '',
        'keepalive': '25',
      },
      {
        'uuid': 'wg-peer-2',
        'enabled': '1',
        'name': 'Laptop',
        'pubkey': 'HIgo9xNzJMWLKASShiTqIybxZ0U3wGLiUeJ1PKf8ykw=',
        'tunneladdress': '10.10.0.3/32',
        'serveraddress': '',
        'serverport': '',
        'keepalive': '25',
      },
      {
        'uuid': 'wg-peer-3',
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

  /// Generate demo OpenVPN instances for list view
  List<OpenvpnInstanceListItem> generateOpenvpnInstances() {
    return [
      OpenvpnInstanceListItem(
        vpnid: 'openvpn-1',
        uuid: 'demo-uuid-openvpn-1',
        enabled: true,
        role: 'server',
        description: 'Main Office VPN Server',
        devType: 'tun',
        protocol: 'udp',
        port: '1194',
        local: '192.168.1.1',
        remote: null,
        server: '10.8.0.0/24',
      ),
      OpenvpnInstanceListItem(
        vpnid: 'openvpn-2',
        uuid: 'demo-uuid-openvpn-2',
        enabled: true,
        role: 'client',
        description: 'Remote Site Connection',
        devType: 'tun',
        protocol: 'tcp',
        port: '443',
        local: null,
        remote: '203.0.113.10',
        server: null,
      ),
      OpenvpnInstanceListItem(
        vpnid: 'openvpn-3',
        uuid: 'demo-uuid-openvpn-3',
        enabled: false,
        role: 'server',
        description: 'Mobile Users VPN',
        devType: 'tun',
        protocol: 'udp',
        port: '1195',
        local: '192.168.1.1',
        remote: null,
        server: '10.9.0.0/24',
      ),
    ];
  }

  /// Generate demo OpenVPN static keys
  List<OpenvpnStaticKey> generateOpenvpnStaticKeys() {
    return [
      OpenvpnStaticKey(
        keyid: 'key-1',
        description: 'Main TLS Auth Key',
        key: '''-----BEGIN OpenVPN Static key V1-----
6acef03f62675b4b1bdd0a0a6c78a5b3
e69e4cc2f4a00e9c1b3e8c5d7f2a1b4c
3d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a
0b1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e
-----END OpenVPN Static key V1-----''',
        mode: '0',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        modifiedAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      OpenvpnStaticKey(
        keyid: 'key-2',
        description: 'Backup TLS Key',
        key: '''-----BEGIN OpenVPN Static key V1-----
7bdef14g73786c5c2cee1b1b7d89b6c4
f70f5dd3g5b11f0d2c4f9d6e8g3b2c5d
4e6f7g8b9c0d1e2f3a4b5c6d7e8f9a0b
1c2d3e4f5a6b7c8d9e0f1a2b3c4d5e6f
-----END OpenVPN Static key V1-----''',
        mode: '1',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
        modifiedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }

  /// Generate demo OpenVPN instance form data for add/edit
  OpenvpnInstance generateOpenvpnInstanceFormData({String? vpnid, String role = 'server'}) {
    if (role == 'server') {
      return OpenvpnInstance(
        vpnid: vpnid,
        enabled: true,
        role: 'server',
        description: vpnid != null ? 'Main Office VPN Server' : '',
        devType: 'tun',
        proto: 'udp',
        port: '1194',
        local: null,
        portShare: null,
        topology: 'subnet',
        remote: null,
        server: '10.8.0.0/24',
        serverIpv6: null,
        nopool: false,
        bridgeGateway: null,
        bridgePool: null,
        route: [],
        pushRoute: [],
        pushExcludedRoutes: [],
        cert: 'cert1',
        crl: null,
        ca: 'ca1',
        certDepth: '1',
        remoteCertTls: 'client',
        verifyClientCert: 'require',
        useOcsp: false,
        tlsKey: null,
        auth: 'SHA256',
        dataCiphers: 'AES-256-GCM',
        dataCiphersFallback: 'AES-256-CBC',
        authmode: 'local',
        localGroup: null,
        usernameAsCommonName: false,
        strictusercn: '0',
        username: null,
        password: null,
        maxclients: '100',
        keepaliveInterval: '10',
        keepaliveTimeout: '60',
        renegSec: '3600',
        authGenToken: '0',
        authGenTokenRenewal: null,
        authGenTokenSecret: null,
        provisionExclusive: false,
        redirectGateway: '',
        routeMetric: null,
        registerDns: true,
        dnsDomain: ['example.com'],
        dnsDomainSearch: [],
        dnsServers: ['8.8.8.8', '8.8.4.4'],
        ntpServers: [],
        tunMtu: null,
        fragment: null,
        mssfix: null,
        carpDependOn: null,
        variousFlags: {
          'duplicate_cn': false,
          'client_to_client': false,
          'comp_lzo': false,
        },
        variousPushFlags: {
          'block_outside_dns': false,
          'register_dns': true,
        },
        pushInactive: null,
        compressMigrate: null,
        ifconfigPoolPersist: false,
        httpProxy: null,
        verifyX509Name: null,
        verb: '3',
      );
    } else {
      // Client configuration
      return OpenvpnInstance(
        vpnid: vpnid,
        enabled: true,
        role: 'client',
        description: vpnid != null ? 'Remote Site Connection' : '',
        devType: 'tun',
        proto: 'tcp',
        port: '443',
        local: null,
        portShare: null,
        topology: 'subnet',
        remote: '203.0.113.10',
        server: null,
        serverIpv6: null,
        nopool: false,
        bridgeGateway: null,
        bridgePool: null,
        route: [],
        pushRoute: [],
        pushExcludedRoutes: [],
        cert: 'cert1',
        crl: null,
        ca: 'ca1',
        certDepth: '1',
        remoteCertTls: 'server',
        verifyClientCert: null,
        useOcsp: false,
        tlsKey: null,
        auth: 'SHA256',
        dataCiphers: 'AES-256-GCM',
        dataCiphersFallback: 'AES-256-CBC',
        authmode: null,
        localGroup: null,
        usernameAsCommonName: false,
        strictusercn: '0',
        username: 'vpnuser',
        password: null,
        maxclients: null,
        keepaliveInterval: '10',
        keepaliveTimeout: '60',
        renegSec: '3600',
        authGenToken: '0',
        authGenTokenRenewal: null,
        authGenTokenSecret: null,
        provisionExclusive: false,
        redirectGateway: 'local,def1',
        routeMetric: null,
        registerDns: true,
        dnsDomain: [],
        dnsDomainSearch: [],
        dnsServers: [],
        ntpServers: [],
        tunMtu: null,
        fragment: null,
        mssfix: null,
        carpDependOn: null,
        variousFlags: {
          'comp_lzo': false,
        },
        variousPushFlags: {},
        pushInactive: null,
        compressMigrate: null,
        ifconfigPoolPersist: false,
        httpProxy: null,
        verifyX509Name: null,
        verb: '3',
      );
    }
  }

  /// Generate demo WireGuard status response
  WireGuardStatusResponse generateWireGuardStatusResponse() {
    final now = DateTime.now();
    final items = [
      WireGuardStatusItem(
        interfaceName: 'wg0',
        type: 'interface',
        publicKey: 'qRCwZSKInrMAq5sepfCdaCsRJaoLe5jhtzfiw7CjbwM=',
        listenPort: '51820',
        fwmark: 'off',
        endpoint: '51820',
        status: 'up',
        name: 'Main WireGuard Server',
        latestHandshakeAge: null,
        latestHandshakeEpoch: null,
        peerStatus: 'online',
        ifname: 'wg0',
      ),
      WireGuardStatusItem(
        interfaceName: 'wg0',
        type: 'peer',
        publicKey: 'xTIBA5rboUvnH4htodjb6e697QjLERt1NAB4mZqp8Dg=',
        listenPort: '0',
        fwmark: 'off',
        endpoint: '203.0.113.50:41234',
        status: 'up',
        name: 'Mobile Device',
        latestHandshakeAge: '2 minutes ago',
        latestHandshakeEpoch: (now.millisecondsSinceEpoch ~/ 1000) - 120,
        peerStatus: 'online',
        ifname: 'wg0',
      ),
      WireGuardStatusItem(
        interfaceName: 'wg0',
        type: 'peer',
        publicKey: 'HIgo9xNzJMWLKASShiTqIybxZ0U3wGLiUeJ1PKf8ykw=',
        listenPort: '0',
        fwmark: 'off',
        endpoint: '198.51.100.75:52341',
        status: 'up',
        name: 'Laptop',
        latestHandshakeAge: '45 seconds ago',
        latestHandshakeEpoch: (now.millisecondsSinceEpoch ~/ 1000) - 45,
        peerStatus: 'online',
        ifname: 'wg0',
      ),
    ];

    return WireGuardStatusResponse(
      total: items.length,
      rowCount: items.length,
      current: 1,
      rows: items,
    );
  }

}
