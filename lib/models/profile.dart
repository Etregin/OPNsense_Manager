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
import 'connection_endpoint.dart';
import 'opnsense_config.dart';
import 'dhcp_server_type.dart';

part 'profile.g.dart';

/// Profile model for storing OPNsense connection configurations
@JsonSerializable(explicitToJson: true)
class Profile {
  final String id;
  final String name;
  final List<ConnectionEndpoint> connections;
  final String apiKey;
  final String apiSecret;
  final bool useHttps;
  final bool allowSelfSignedCerts;
  final bool isDemo;
  final DateTime createdAt;
  final DateTime? lastUsed;
  
  /// DHCP server type (dnsmasq, ISC, or KEA)
  @JsonKey(defaultValue: DhcpServerType.dnsmasq)
  final DhcpServerType dhcpServerType;

  Profile({
    required this.id,
    required this.name,
    required this.connections,
    required this.apiKey,
    required this.apiSecret,
    required this.useHttps,
    this.allowSelfSignedCerts = false,
    this.isDemo = false,
    required this.createdAt,
    this.lastUsed,
    this.dhcpServerType = DhcpServerType.dnsmasq,
  }) : assert(connections.isNotEmpty, 'Profile must have at least one connection endpoint');

  /// Get the active connection endpoint
  /// Returns the first active connection, or the first connection if none are active
  ConnectionEndpoint get activeConnection {
    try {
      return connections.firstWhere((conn) => conn.isActive);
    } on StateError catch (_) {
      return connections.first;
    }
  }

  /// Backward compatibility: Get host from active connection
  String get host => activeConnection.host;

  /// Backward compatibility: Get port from active connection
  int get port => activeConnection.port;

  /// Create a copy with updated fields
  Profile copyWith({
    String? id,
    String? name,
    List<ConnectionEndpoint>? connections,
    String? apiKey,
    String? apiSecret,
    bool? useHttps,
    bool? allowSelfSignedCerts,
    bool? isDemo,
    DateTime? createdAt,
    DateTime? lastUsed,
    DhcpServerType? dhcpServerType,
  }) {
    return Profile(
      id: id ?? this.id,
      name: name ?? this.name,
      connections: connections ?? this.connections,
      apiKey: apiKey ?? this.apiKey,
      apiSecret: apiSecret ?? this.apiSecret,
      useHttps: useHttps ?? this.useHttps,
      allowSelfSignedCerts:
          allowSelfSignedCerts ?? this.allowSelfSignedCerts,
      isDemo: isDemo ?? this.isDemo,
      createdAt: createdAt ?? this.createdAt,
      lastUsed: lastUsed ?? this.lastUsed,
      dhcpServerType: dhcpServerType ?? this.dhcpServerType,
    );
  }

  /// Get base URL for API calls
  String get baseUrl => '${useHttps ? 'https' : 'http'}://${activeConnection.host}:${activeConnection.port}/api';

  /// Convert to OPNsenseConfig
  OPNsenseConfig toOPNsenseConfig() {
    return OPNsenseConfig(
      host: activeConnection.host,
      port: activeConnection.port,
      apiKey: apiKey,
      apiSecret: apiSecret,
      useHttps: useHttps,
      allowSelfSignedCerts: allowSelfSignedCerts,
      dhcpServerType: dhcpServerType,
    );
  }

  /// Find a connection by label
  ConnectionEndpoint? getConnectionByLabel(String label) {
    try {
      return connections.firstWhere((conn) => conn.label == label);
    } on StateError catch (_) {
      return null;
    }
  }

  /// Mark a specific connection as active
  Profile setActiveConnection(String host, int port) {
    final updatedConnections = connections.map((conn) {
      if (conn.host == host && conn.port == port) {
        return conn.copyWith(isActive: true);
      } else {
        return conn.copyWith(isActive: false);
      }
    }).toList();

    return copyWith(connections: updatedConnections);
  }

  /// Add a new connection endpoint
  Profile addConnection(ConnectionEndpoint connection) {
    final updatedConnections = List<ConnectionEndpoint>.from(connections)
      ..add(connection);
    return copyWith(connections: updatedConnections);
  }

  /// Remove a connection endpoint
  /// Ensures at least one connection remains
  Profile removeConnection(String host, int port) {
    if (connections.length <= 1) {
      throw StateError('Cannot remove the last connection endpoint');
    }

    final updatedConnections = connections
        .where((conn) => !(conn.host == host && conn.port == port))
        .toList();

    return copyWith(connections: updatedConnections);
  }

  /// JSON serialization for in-memory/export use, may include credentials.
  /// Handles backward compatibility with old format (single host/port)
  factory Profile.fromJson(Map<String, dynamic> json) {
    // Check if this is the old format (has 'host' and 'port' fields)
    if (json.containsKey('host') && json.containsKey('port') && !json.containsKey('connections')) {
      // Convert old format to new format
      final host = json['host'] as String;
      final port = json['port'] as int;
      
      // Create a single connection endpoint from the old host/port
      final connection = ConnectionEndpoint(
        host: host,
        port: port,
        isActive: true,
      );
      
      // Add the connections list to the JSON
      json['connections'] = [connection.toJson()];
      
      // Remove old fields
      json.remove('host');
      json.remove('port');
    }
    
    return _$ProfileFromJson(json);
  }
  Map<String, dynamic> toJson() => _$ProfileToJson(this);

  /// JSON serialization for shared-preferences persistence.
  /// Credentials are intentionally excluded and must be loaded from secure storage.
  Map<String, dynamic> toStorageJson() {
    final json = _$ProfileToJson(this);
    json.remove('apiKey');
    json.remove('apiSecret');
    return json;
  }

  /// Create a profile from shared-preferences metadata plus credentials from secure storage.
  factory Profile.fromStorageJson(
    Map<String, dynamic> json, {
    required String apiKey,
    required String apiSecret,
  }) {
    final storageJson = Map<String, dynamic>.from(json)
      ..['apiKey'] = apiKey
      ..['apiSecret'] = apiSecret;
    return _$ProfileFromJson(storageJson);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is Profile &&
        other.id == id &&
        other.name == name &&
        _listEquals(other.connections, connections) &&
        other.apiKey == apiKey &&
        other.apiSecret == apiSecret &&
        other.useHttps == useHttps &&
        other.allowSelfSignedCerts == allowSelfSignedCerts &&
        other.isDemo == isDemo &&
        other.createdAt == createdAt &&
        other.lastUsed == lastUsed &&
        other.dhcpServerType == dhcpServerType;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      name,
      Object.hashAll(connections),
      apiKey,
      apiSecret,
      useHttps,
      allowSelfSignedCerts,
      isDemo,
      createdAt,
      lastUsed,
      dhcpServerType,
    );
  }

  /// Helper method to compare lists
  bool _listEquals<T>(List<T>? a, List<T>? b) {
    if (a == null) return b == null;
    if (b == null || a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}

