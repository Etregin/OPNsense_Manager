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

import 'package:json_annotation/json_annotation.dart';

part 'wireguard_server.g.dart';

/// Represents a WireGuard server configuration in OPNsense
@JsonSerializable()
class WireGuardServer {
  /// Unique identifier for the server
  final String uuid;
  
  /// Enable/disable the server ("1" = enabled, "0" = disabled)
  final String enabled;
  
  /// Server name/description
  final String name;
  
  /// Server's public key (base64 encoded)
  final String pubkey;
  
  /// Server's private key (base64 encoded, sensitive)
  final String privkey;
  
  /// UDP port to listen on (default: 51820)
  final String port;
  
  /// Tunnel IP addresses in CIDR notation (comma-separated)
  /// Example: "10.10.10.1/24,fd00::1/64"
  final String tunneladdress;
  
  /// Comma-separated list of peer UUIDs authorized for this server
  @JsonKey(defaultValue: '')
  final String peers;
  
  /// Disable automatic route installation ("1" = disabled, "0" = enabled)
  @JsonKey(defaultValue: '0')
  final String disableroutes;
  
  /// Gateway configuration (optional)
  @JsonKey(defaultValue: '')
  final String gateway;
  
  /// MTU size for the tunnel interface (optional)
  @JsonKey(defaultValue: '')
  final String mtu;
  
  /// DNS servers for clients (comma-separated, optional)
  @JsonKey(defaultValue: '')
  final String dns;

  WireGuardServer({
    required this.uuid,
    required this.enabled,
    required this.name,
    required this.pubkey,
    required this.privkey,
    required this.port,
    required this.tunneladdress,
    this.peers = '',
    this.disableroutes = '0',
    this.gateway = '',
    this.mtu = '',
    this.dns = '',
  });

  /// Check if server is enabled
  bool get isEnabled => enabled == "1";
  
  /// Check if automatic routes are disabled
  bool get hasRoutesDisabled => disableroutes == "1";
  
  /// Get tunnel addresses as a list
  List<String> get tunnelAddressList {
    if (tunneladdress.isEmpty) return [];
    return tunneladdress.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  }
  
  /// Get peer UUIDs as a list
  List<String> get peerUuidList {
    if (peers.isEmpty) return [];
    return peers.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  }
  
  /// Get DNS servers as a list
  List<String> get dnsList {
    if (dns.isEmpty) return [];
    return dns.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  }
  
  /// Get port as integer
  int get portNumber => int.tryParse(port) ?? 51820;
  
  /// Get MTU as integer (null if not set)
  int? get mtuValue {
    if (mtu.isEmpty) return null;
    return int.tryParse(mtu);
  }

  factory WireGuardServer.fromJson(Map<String, dynamic> json) =>
      _$WireGuardServerFromJson(json);

  Map<String, dynamic> toJson() => _$WireGuardServerToJson(this);

  WireGuardServer copyWith({
    String? uuid,
    String? enabled,
    String? name,
    String? pubkey,
    String? privkey,
    String? port,
    String? tunneladdress,
    String? peers,
    String? disableroutes,
    String? gateway,
    String? mtu,
    String? dns,
  }) {
    return WireGuardServer(
      uuid: uuid ?? this.uuid,
      enabled: enabled ?? this.enabled,
      name: name ?? this.name,
      pubkey: pubkey ?? this.pubkey,
      privkey: privkey ?? this.privkey,
      port: port ?? this.port,
      tunneladdress: tunneladdress ?? this.tunneladdress,
      peers: peers ?? this.peers,
      disableroutes: disableroutes ?? this.disableroutes,
      gateway: gateway ?? this.gateway,
      mtu: mtu ?? this.mtu,
      dns: dns ?? this.dns,
    );
  }

  @override
  String toString() => 'WireGuardServer(uuid: $uuid, name: $name, port: $port)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WireGuardServer && other.uuid == uuid;
  }

  @override
  int get hashCode => uuid.hashCode;
}

/// Request model for creating/updating WireGuard servers
@JsonSerializable()
class WireGuardServerRequest {
  final String name;
  final String pubkey;
  final String privkey;
  final String port;
  final String tunneladdress;
  @JsonKey(defaultValue: '1')
  final String enabled;
  @JsonKey(defaultValue: '')
  final String peers;
  @JsonKey(defaultValue: '0')
  final String disableroutes;
  @JsonKey(defaultValue: '')
  final String gateway;
  @JsonKey(defaultValue: '')
  final String mtu;
  @JsonKey(defaultValue: '')
  final String dns;

  WireGuardServerRequest({
    required this.name,
    required this.pubkey,
    required this.privkey,
    required this.port,
    required this.tunneladdress,
    this.enabled = '1',
    this.peers = '',
    this.disableroutes = '0',
    this.gateway = '',
    this.mtu = '',
    this.dns = '',
  });

  factory WireGuardServerRequest.fromJson(Map<String, dynamic> json) =>
      _$WireGuardServerRequestFromJson(json);

  Map<String, dynamic> toJson() {
    final json = _$WireGuardServerRequestToJson(this);
    // Remove empty optional fields
    json.removeWhere((key, value) => 
      value is String && value.isEmpty && 
      !['name', 'pubkey', 'privkey', 'port', 'tunneladdress'].contains(key)
    );
    return json;
  }

  factory WireGuardServerRequest.fromServer(WireGuardServer server) {
    return WireGuardServerRequest(
      name: server.name,
      pubkey: server.pubkey,
      privkey: server.privkey,
      port: server.port,
      tunneladdress: server.tunneladdress,
      enabled: server.enabled,
      peers: server.peers,
      disableroutes: server.disableroutes,
      gateway: server.gateway,
      mtu: server.mtu,
      dns: server.dns,
    );
  }
}


