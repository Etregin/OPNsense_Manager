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
  final String pubkey;
  
  /// Pre-shared key for additional security (base64 encoded, optional)
  @JsonKey(defaultValue: '')
  final String psk;
  
  /// Allowed tunnel addresses/IPs in CIDR notation (comma-separated)
  /// Defines which IPs this peer is allowed to use
  /// Example: "10.10.10.2/32,fd00::2/128"
  final String tunneladdress;
  
  /// Peer endpoint address (IP:port, optional)
  /// Only needed if peer is behind NAT and server needs to initiate
  @JsonKey(defaultValue: '')
  final String endpoint;
  
  /// Persistent keepalive interval in seconds (optional)
  /// Recommended: 25 seconds for NAT traversal
  @JsonKey(defaultValue: '')
  final String keepalive;

  WireGuardPeer({
    required this.uuid,
    required this.enabled,
    required this.name,
    required this.pubkey,
    this.psk = '',
    required this.tunneladdress,
    this.endpoint = '',
    this.keepalive = '',
  });

  /// Check if peer is enabled
  bool get isEnabled => enabled == "1";
  
  /// Get allowed tunnel addresses as a list
  List<String> get tunnelAddressList {
    if (tunneladdress.isEmpty) return [];
    return tunneladdress.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  }
  
  /// Check if endpoint is configured
  bool get hasEndpoint => endpoint.isNotEmpty;
  
  /// Get keepalive interval as integer (null if not set)
  int? get keepaliveInterval {
    if (keepalive.isEmpty) return null;
    return int.tryParse(keepalive);
  }
  
  /// Check if pre-shared key is configured
  bool get hasPresharedKey => psk.isNotEmpty;
  
  /// Parse endpoint into host and port (returns null if not configured)
  ({String host, int port})? get endpointParsed {
    if (!hasEndpoint) return null;
    final parts = endpoint.split(':');
    if (parts.length != 2) return null;
    final port = int.tryParse(parts[1]);
    if (port == null) return null;
    return (host: parts[0], port: port);
  }

  factory WireGuardPeer.fromJson(Map<String, dynamic> json) =>
      _$WireGuardPeerFromJson(json);

  Map<String, dynamic> toJson() => _$WireGuardPeerToJson(this);

  WireGuardPeer copyWith({
    String? uuid,
    String? enabled,
    String? name,
    String? pubkey,
    String? psk,
    String? tunneladdress,
    String? endpoint,
    String? keepalive,
  }) {
    return WireGuardPeer(
      uuid: uuid ?? this.uuid,
      enabled: enabled ?? this.enabled,
      name: name ?? this.name,
      pubkey: pubkey ?? this.pubkey,
      psk: psk ?? this.psk,
      tunneladdress: tunneladdress ?? this.tunneladdress,
      endpoint: endpoint ?? this.endpoint,
      keepalive: keepalive ?? this.keepalive,
    );
  }

  @override
  String toString() => 'WireGuardPeer(uuid: $uuid, name: $name)';

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
  final String tunneladdress;
  @JsonKey(defaultValue: '1')
  final String enabled;
  @JsonKey(defaultValue: '')
  final String psk;
  @JsonKey(defaultValue: '')
  final String endpoint;
  @JsonKey(defaultValue: '')
  final String keepalive;

  WireGuardPeerRequest({
    required this.name,
    required this.pubkey,
    required this.tunneladdress,
    this.enabled = '1',
    this.psk = '',
    this.endpoint = '',
    this.keepalive = '',
  });

  factory WireGuardPeerRequest.fromJson(Map<String, dynamic> json) =>
      _$WireGuardPeerRequestFromJson(json);

  Map<String, dynamic> toJson() {
    final json = _$WireGuardPeerRequestToJson(this);
    // Remove empty optional fields
    json.removeWhere((key, value) => 
      value is String && value.isEmpty && 
      !['name', 'pubkey', 'tunneladdress'].contains(key)
    );
    return json;
  }

  factory WireGuardPeerRequest.fromPeer(WireGuardPeer peer) {
    return WireGuardPeerRequest(
      name: peer.name,
      pubkey: peer.pubkey,
      tunneladdress: peer.tunneladdress,
      enabled: peer.enabled,
      psk: peer.psk,
      endpoint: peer.endpoint,
      keepalive: peer.keepalive,
    );
  }
}


