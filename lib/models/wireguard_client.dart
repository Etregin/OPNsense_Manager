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

part 'wireguard_client.g.dart';

/// Represents a WireGuard client configuration in OPNsense
@JsonSerializable()
class WireGuardClient {
  /// Unique identifier for the client
  final String uuid;
  
  /// Enable/disable the client ("1" = enabled, "0" = disabled)
  final String enabled;
  
  /// Client name/description
  final String name;
  
  /// Client's public key (base64 encoded)
  final String pubkey;
  
  /// Client's private key (base64 encoded, sensitive)
  final String privkey;
  
  /// Tunnel IP addresses in CIDR notation (comma-separated)
  /// Example: "10.10.10.2/24"
  final String tunneladdress;
  
  /// Remote server endpoint address (IP or hostname)
  final String serveraddress;
  
  /// Remote server port
  final String serverport;
  
  /// Remote server's public key (base64 encoded)
  final String serverpubkey;
  
  /// Persistent keepalive interval in seconds (optional)
  /// Recommended: 25 seconds for NAT traversal
  @JsonKey(defaultValue: '')
  final String keepalive;
  
  /// Pre-shared key for additional security (base64 encoded, optional)
  @JsonKey(defaultValue: '')
  final String psk;

  WireGuardClient({
    required this.uuid,
    required this.enabled,
    required this.name,
    required this.pubkey,
    required this.privkey,
    required this.tunneladdress,
    required this.serveraddress,
    required this.serverport,
    required this.serverpubkey,
    this.keepalive = '',
    this.psk = '',
  });

  /// Check if client is enabled
  bool get isEnabled => enabled == "1";
  
  /// Get tunnel addresses as a list
  List<String> get tunnelAddressList {
    if (tunneladdress.isEmpty) return [];
    return tunneladdress.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  }
  
  /// Get server port as integer
  int get serverPortNumber => int.tryParse(serverport) ?? 51820;
  
  /// Get keepalive interval as integer (null if not set)
  int? get keepaliveInterval {
    if (keepalive.isEmpty) return null;
    return int.tryParse(keepalive);
  }
  
  /// Check if pre-shared key is configured
  bool get hasPresharedKey => psk.isNotEmpty;

  factory WireGuardClient.fromJson(Map<String, dynamic> json) =>
      _$WireGuardClientFromJson(json);

  Map<String, dynamic> toJson() => _$WireGuardClientToJson(this);

  WireGuardClient copyWith({
    String? uuid,
    String? enabled,
    String? name,
    String? pubkey,
    String? privkey,
    String? tunneladdress,
    String? serveraddress,
    String? serverport,
    String? serverpubkey,
    String? keepalive,
    String? psk,
  }) {
    return WireGuardClient(
      uuid: uuid ?? this.uuid,
      enabled: enabled ?? this.enabled,
      name: name ?? this.name,
      pubkey: pubkey ?? this.pubkey,
      privkey: privkey ?? this.privkey,
      tunneladdress: tunneladdress ?? this.tunneladdress,
      serveraddress: serveraddress ?? this.serveraddress,
      serverport: serverport ?? this.serverport,
      serverpubkey: serverpubkey ?? this.serverpubkey,
      keepalive: keepalive ?? this.keepalive,
      psk: psk ?? this.psk,
    );
  }

  @override
  String toString() => 'WireGuardClient(uuid: $uuid, name: $name, server: $serveraddress:$serverport)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WireGuardClient && other.uuid == uuid;
  }

  @override
  int get hashCode => uuid.hashCode;
}

/// Request model for creating/updating WireGuard clients
@JsonSerializable()
class WireGuardClientRequest {
  final String name;
  final String pubkey;
  final String privkey;
  final String tunneladdress;
  final String serveraddress;
  final String serverport;
  final String serverpubkey;
  @JsonKey(defaultValue: '1')
  final String enabled;
  @JsonKey(defaultValue: '')
  final String keepalive;
  @JsonKey(defaultValue: '')
  final String psk;

  WireGuardClientRequest({
    required this.name,
    required this.pubkey,
    required this.privkey,
    required this.tunneladdress,
    required this.serveraddress,
    required this.serverport,
    required this.serverpubkey,
    this.enabled = '1',
    this.keepalive = '',
    this.psk = '',
  });

  factory WireGuardClientRequest.fromJson(Map<String, dynamic> json) =>
      _$WireGuardClientRequestFromJson(json);

  Map<String, dynamic> toJson() {
    final json = _$WireGuardClientRequestToJson(this);
    // Remove empty optional fields
    json.removeWhere((key, value) => 
      value is String && value.isEmpty && 
      !['name', 'pubkey', 'privkey', 'tunneladdress', 'serveraddress', 'serverport', 'serverpubkey'].contains(key)
    );
    return json;
  }

  factory WireGuardClientRequest.fromClient(WireGuardClient client) {
    return WireGuardClientRequest(
      name: client.name,
      pubkey: client.pubkey,
      privkey: client.privkey,
      tunneladdress: client.tunneladdress,
      serveraddress: client.serveraddress,
      serverport: client.serverport,
      serverpubkey: client.serverpubkey,
      enabled: client.enabled,
      keepalive: client.keepalive,
      psk: client.psk,
    );
  }
}


