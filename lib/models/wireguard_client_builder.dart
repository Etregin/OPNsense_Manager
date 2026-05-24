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

part 'wireguard_client_builder.g.dart';

/// Represents a server option in the client builder
@JsonSerializable()
class WireGuardBuilderServer {
  final String value;
  
  @JsonKey(fromJson: _selectedFromJson, toJson: _selectedToJson)
  final String selected;

  WireGuardBuilderServer({
    required this.value,
    required this.selected,
  });

  bool get isSelected => selected == '1';

  /// Convert selected field from dynamic (int/string) to string
  static String _selectedFromJson(dynamic value) {
    if (value is int) {
      return value.toString();
    }
    return value as String;
  }

  /// Convert selected field to string for JSON
  static String _selectedToJson(String value) => value;

  factory WireGuardBuilderServer.fromJson(Map<String, dynamic> json) =>
      _$WireGuardBuilderServerFromJson(json);

  Map<String, dynamic> toJson() => _$WireGuardBuilderServerToJson(this);
}

/// Represents the client builder configuration data
@JsonSerializable()
class WireGuardClientBuilder {
  /// Available servers as a map of UUID to server info
  final Map<String, WireGuardBuilderServer> servers;

  /// Default name for new clients
  @JsonKey(defaultValue: '')
  final String name;

  /// Default endpoint address
  @JsonKey(defaultValue: '')
  final String endpoint;

  /// Default tunnel address - can be a map structure or string
  @JsonKey(fromJson: _tunnelAddressFromJson, defaultValue: '')
  final String tunneladdress;

  /// Default server address
  @JsonKey(defaultValue: '')
  final String serveraddress;

  /// Default server port
  @JsonKey(defaultValue: '51820')
  final String serverport;

  /// Default DNS servers
  @JsonKey(defaultValue: '')
  final String dns;

  /// Default keepalive interval
  @JsonKey(defaultValue: '')
  final String keepalive;

  WireGuardClientBuilder({
    required this.servers,
    this.name = '',
    this.endpoint = '',
    this.tunneladdress = '',
    this.serveraddress = '',
    this.serverport = '51820',
    this.dns = '',
    this.keepalive = '',
  });

  /// Convert tunneladdress from dynamic (map or string) to string
  static String _tunnelAddressFromJson(dynamic value) {
    if (value == null) return '';
    
    // If it's already a string, return it
    if (value is String) return value;
    
    // If it's a map (like { "": { "value": "", "selected": 1 } })
    if (value is Map) {
      // Try to find the first entry with a selected value
      for (final entry in value.entries) {
        if (entry.value is Map) {
          final nestedMap = entry.value as Map;
          if (nestedMap.containsKey('value')) {
            return nestedMap['value']?.toString() ?? '';
          }
        }
      }
    }
    
    return '';
  }

  /// Get list of server UUIDs
  List<String> get serverUuids => servers.keys.toList();

  /// Get selected server UUID (if any)
  String? get selectedServerUuid {
    for (final entry in servers.entries) {
      if (entry.value.isSelected) {
        return entry.key;
      }
    }
    return null;
  }

  factory WireGuardClientBuilder.fromJson(Map<String, dynamic> json) =>
      _$WireGuardClientBuilderFromJson(json);

  Map<String, dynamic> toJson() => _$WireGuardClientBuilderToJson(this);
}

/// Response wrapper for client builder endpoint
@JsonSerializable()
class WireGuardClientBuilderResponse {
  @JsonKey(name: 'configbuilder')
  final WireGuardClientBuilder configBuilder;

  WireGuardClientBuilderResponse({
    required this.configBuilder,
  });

  factory WireGuardClientBuilderResponse.fromJson(Map<String, dynamic> json) =>
      _$WireGuardClientBuilderResponseFromJson(json);

  Map<String, dynamic> toJson() => _$WireGuardClientBuilderResponseToJson(this);
}

/// Server info response from get_server_info endpoint
@JsonSerializable()
class WireGuardServerInfo {
  /// Server public key
  @JsonKey(defaultValue: '')
  final String pubkey;

  /// Server endpoint address
  @JsonKey(defaultValue: '')
  final String endpoint;

  /// Server port
  @JsonKey(defaultValue: '')
  final String port;

  /// Tunnel address for peer
  @JsonKey(defaultValue: '')
  final String tunneladdress;

  /// DNS servers for peer
  @JsonKey(name: 'peer_dns', defaultValue: '')
  final String peerDns;

  /// MTU setting
  @JsonKey(defaultValue: '')
  final String mtu;

  /// Address setting
  @JsonKey(defaultValue: '')
  final String address;

  WireGuardServerInfo({
    this.pubkey = '',
    this.endpoint = '',
    this.port = '',
    this.tunneladdress = '',
    this.peerDns = '',
    this.mtu = '',
    this.address = '',
  });

  factory WireGuardServerInfo.fromJson(Map<String, dynamic> json) =>
      _$WireGuardServerInfoFromJson(json);

  Map<String, dynamic> toJson() => _$WireGuardServerInfoToJson(this);
}

/// Request model for adding a client via builder
@JsonSerializable()
class WireGuardClientBuilderRequest {
  final String name;
  final String pubkey;
  final String privkey;
  final String tunneladdress;
  final String serveraddress;
  final String serverport;
  final String serverpubkey;
  final String servers;
  
  @JsonKey(defaultValue: '')
  final String psk;
  
  @JsonKey(defaultValue: '')
  final String keepalive;
  
  @JsonKey(defaultValue: '')
  final String endpoint;

  @JsonKey(defaultValue: '1')
  final String enabled;

  WireGuardClientBuilderRequest({
    required this.name,
    required this.pubkey,
    required this.privkey,
    required this.tunneladdress,
    required this.serveraddress,
    required this.serverport,
    required this.serverpubkey,
    required this.servers,
    this.psk = '',
    this.keepalive = '',
    this.endpoint = '',
    this.enabled = '1',
  });

  factory WireGuardClientBuilderRequest.fromJson(Map<String, dynamic> json) =>
      _$WireGuardClientBuilderRequestFromJson(json);

  Map<String, dynamic> toJson() => _$WireGuardClientBuilderRequestToJson(this);
}


