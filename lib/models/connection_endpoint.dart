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

part 'connection_endpoint.g.dart';

/// Connection endpoint model for storing multiple IP addresses and ports
/// 
/// Supports failover and redundancy by allowing profiles to have multiple
/// connection endpoints with labels and connection tracking.
@JsonSerializable()
class ConnectionEndpoint {
  /// IP address or hostname
  final String host;
  
  /// Port number
  final int port;
  
  /// Optional user-friendly label (e.g., "Primary", "Backup", "Office")
  final String? label;
  
  /// Whether this endpoint is currently active
  final bool isActive;
  
  /// Track last successful connection time
  final DateTime? lastSuccessfulConnection;

  const ConnectionEndpoint({
    required this.host,
    required this.port,
    this.label,
    this.isActive = false,
    this.lastSuccessfulConnection,
  });

  /// Get display name - returns label if available, otherwise "host:port"
  String get displayName => label ?? '$host:$port';

  /// Create a copy with updated fields
  ConnectionEndpoint copyWith({
    String? host,
    int? port,
    String? label,
    bool? isActive,
    DateTime? lastSuccessfulConnection,
  }) {
    return ConnectionEndpoint(
      host: host ?? this.host,
      port: port ?? this.port,
      label: label ?? this.label,
      isActive: isActive ?? this.isActive,
      lastSuccessfulConnection:
          lastSuccessfulConnection ?? this.lastSuccessfulConnection,
    );
  }

  /// JSON serialization
  factory ConnectionEndpoint.fromJson(Map<String, dynamic> json) =>
      _$ConnectionEndpointFromJson(json);
  
  Map<String, dynamic> toJson() => _$ConnectionEndpointToJson(this);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    
    return other is ConnectionEndpoint &&
        other.host == host &&
        other.port == port &&
        other.label == label &&
        other.isActive == isActive &&
        other.lastSuccessfulConnection == lastSuccessfulConnection;
  }

  @override
  int get hashCode {
    return Object.hash(
      host,
      port,
      label,
      isActive,
      lastSuccessfulConnection,
    );
  }
}

// Made with Bob
