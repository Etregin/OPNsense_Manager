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

part 'wireguard_peer.g.dart';

/// Represents a WireGuard peer configuration in OPNsense
@JsonSerializable()
class WireGuardPeer {
  /// Unique identifier for the peer
  final String uuid;
  
  /// Enable/disable the peer ("1" = enabled, "0" = disabled)
  final String enabled;
  
  /// Peer name/description
  final String name;
  
  /// Peer's public key (base64 encoded)
  final String? pubkey;
  
  /// Peer's private key (base64 encoded, sensitive)
  final String? privkey;
  
  /// Tunnel IP addresses in CIDR notation (comma-separated)
  /// Example: "10.10.10.2/24"
  final String? tunneladdress;
  
  /// Remote server endpoint address (IP or hostname)
  final String? serveraddress;
  
  /// Remote server port
  final String? serverport;
  
  /// Remote server's public key (base64 encoded)
  final String? serverpubkey;
  
  /// Endpoint address (alternative to serveraddress, optional)
  final String? endpoint;
  
  /// Comma-separated list of server UUIDs (optional)
  final String? servers;
  
  /// Persistent keepalive interval in seconds (optional)
  /// Recommended: 25 seconds for NAT traversal
  final String? keepalive;
  
  /// Pre-shared key for additional security (base64 encoded, optional)
  final String? psk;
  
  /// Server name (display name from API response)
  @JsonKey(name: '%servers')
  final String? serverName;

  WireGuardPeer({
    required this.uuid,
    required this.enabled,
    required this.name,
    this.pubkey,
    this.privkey,
    this.tunneladdress,
    this.serveraddress,
    this.serverport,
    this.serverpubkey,
    this.endpoint,
    this.servers,
    this.keepalive,
    this.psk,
    this.serverName,
  });

  /// Check if peer is enabled
  bool get isEnabled => enabled == '1';
  
  /// Get tunnel addresses as a list
  List<String> get tunnelAddressList {
    if (tunneladdress == null || tunneladdress!.isEmpty) return [];
    return tunneladdress!.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  }
  
  /// Get server port as integer
  int get serverPortNumber => int.tryParse(serverport ?? '') ?? 51820;
  
  /// Get keepalive interval as integer (null if not set)
  int? get keepaliveInterval {
    if (keepalive == null || keepalive!.isEmpty) return null;
    return int.tryParse(keepalive!);
  }
  
  /// Get server UUIDs as a list
  List<String> get serverUuidList {
    if (servers == null || servers!.isEmpty) return [];
    return servers!.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  }
  
  /// Check if pre-shared key is configured
  bool get hasPresharedKey => psk != null && psk!.isNotEmpty;

  factory WireGuardPeer.fromJson(Map<String, dynamic> json) =>
      _$WireGuardPeerFromJson(json);

  Map<String, dynamic> toJson() => _$WireGuardPeerToJson(this);

  WireGuardPeer copyWith({
    String? uuid,
    String? enabled,
    String? name,
    String? pubkey,
    String? privkey,
    String? tunneladdress,
    String? serveraddress,
    String? serverport,
    String? serverpubkey,
    String? endpoint,
    String? servers,
    String? keepalive,
    String? psk,
    String? serverName,
  }) {
    return WireGuardPeer(
      uuid: uuid ?? this.uuid,
      enabled: enabled ?? this.enabled,
      name: name ?? this.name,
      pubkey: pubkey ?? this.pubkey,
      privkey: privkey ?? this.privkey,
      tunneladdress: tunneladdress ?? this.tunneladdress,
      serveraddress: serveraddress ?? this.serveraddress,
      serverport: serverport ?? this.serverport,
      serverpubkey: serverpubkey ?? this.serverpubkey,
      endpoint: endpoint ?? this.endpoint,
      servers: servers ?? this.servers,
      keepalive: keepalive ?? this.keepalive,
      psk: psk ?? this.psk,
      serverName: serverName ?? this.serverName,
    );
  }

  @override
  String toString() => 'WireGuardPeer(uuid: $uuid, name: $name, server: $serveraddress:$serverport)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WireGuardPeer && other.uuid == uuid;
  }

  @override
  int get hashCode => uuid.hashCode;
}

/// Request model for creating/updating WireGuard peers
@JsonSerializable()
class WireGuardPeerRequest {
  final String name;
  final String pubkey;
  final String privkey;
  final String tunneladdress;
  final String serveraddress;
  final String serverport;
  final String serverpubkey;
  @JsonKey(defaultValue: '1')
  final String enabled;
  final String? endpoint;
  final String? servers;
  final String? keepalive;
  final String? psk;

  WireGuardPeerRequest({
    required this.name,
    required this.pubkey,
    required this.privkey,
    required this.tunneladdress,
    required this.serveraddress,
    required this.serverport,
    required this.serverpubkey,
    this.enabled = '1',
    this.endpoint,
    this.servers,
    this.keepalive,
    this.psk,
  });

  factory WireGuardPeerRequest.fromJson(Map<String, dynamic> json) =>
      _$WireGuardPeerRequestFromJson(json);

  Map<String, dynamic> toJson() {
    final json = _$WireGuardPeerRequestToJson(this);
    // Remove null optional fields
    json.removeWhere((key, value) => value == null);
    return json;
  }

  factory WireGuardPeerRequest.fromPeer(WireGuardPeer peer) {
    return WireGuardPeerRequest(
      name: peer.name,
      pubkey: peer.pubkey ?? '',
      privkey: peer.privkey ?? '',
      tunneladdress: peer.tunneladdress ?? '',
      serveraddress: peer.serveraddress ?? '',
      serverport: peer.serverport ?? '',
      serverpubkey: peer.serverpubkey ?? '',
      enabled: peer.enabled,
      endpoint: peer.endpoint,
      servers: peer.servers,
      keepalive: peer.keepalive,
      psk: peer.psk,
    );
  }
}


