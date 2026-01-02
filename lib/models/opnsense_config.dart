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


import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'opnsense_config.g.dart';

/// Configuration model for OPNsense connection
@JsonSerializable()
class OPNsenseConfig {
  final String host;
  final int port;
  final String apiKey;
  final String apiSecret;
  final bool useHttps;

  OPNsenseConfig({
    required this.host,
    required this.port,
    required this.apiKey,
    required this.apiSecret,
    this.useHttps = true,
  });

  /// Get base URL for API requests
  String get baseUrl {
    final protocol = useHttps ? 'https' : 'http';
    return '$protocol://$host:$port/api';
  }

  /// Get Basic Auth header value
  String get authHeader {
    final credentials = '$apiKey:$apiSecret';
    final encoded = base64Encode(utf8.encode(credentials));
    return 'Basic $encoded';
  }

  /// Create from JSON
  factory OPNsenseConfig.fromJson(Map<String, dynamic> json) =>
      _$OPNsenseConfigFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$OPNsenseConfigToJson(this);

  /// Create a copy with updated fields
  OPNsenseConfig copyWith({
    String? host,
    int? port,
    String? apiKey,
    String? apiSecret,
    bool? useHttps,
  }) {
    return OPNsenseConfig(
      host: host ?? this.host,
      port: port ?? this.port,
      apiKey: apiKey ?? this.apiKey,
      apiSecret: apiSecret ?? this.apiSecret,
      useHttps: useHttps ?? this.useHttps,
    );
  }

  @override
  String toString() {
    return 'OPNsenseConfig(host: $host, port: $port, useHttps: $useHttps)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is OPNsenseConfig &&
        other.host == host &&
        other.port == port &&
        other.apiKey == apiKey &&
        other.apiSecret == apiSecret &&
        other.useHttps == useHttps;
  }

  @override
  int get hashCode {
    return host.hashCode ^
        port.hashCode ^
        apiKey.hashCode ^
        apiSecret.hashCode ^
        useHttps.hashCode;
  }
}

