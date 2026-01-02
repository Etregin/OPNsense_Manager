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
import 'opnsense_config.dart';

part 'profile.g.dart';

/// Profile model for storing OPNsense connection configurations
@JsonSerializable()
class Profile {
  final String id;
  final String name;
  final String host;
  final int port;
  final String apiKey;
  final String apiSecret;
  final bool useHttps;
  final DateTime createdAt;
  final DateTime? lastUsed;

  Profile({
    required this.id,
    required this.name,
    required this.host,
    required this.port,
    required this.apiKey,
    required this.apiSecret,
    required this.useHttps,
    required this.createdAt,
    this.lastUsed,
  });

  /// Create a copy with updated fields
  Profile copyWith({
    String? id,
    String? name,
    String? host,
    int? port,
    String? apiKey,
    String? apiSecret,
    bool? useHttps,
    DateTime? createdAt,
    DateTime? lastUsed,
  }) {
    return Profile(
      id: id ?? this.id,
      name: name ?? this.name,
      host: host ?? this.host,
      port: port ?? this.port,
      apiKey: apiKey ?? this.apiKey,
      apiSecret: apiSecret ?? this.apiSecret,
      useHttps: useHttps ?? this.useHttps,
      createdAt: createdAt ?? this.createdAt,
      lastUsed: lastUsed ?? this.lastUsed,
    );
  }

  /// Get base URL for API calls
  String get baseUrl => '${useHttps ? 'https' : 'http'}://$host:$port/api';

  /// Convert to OPNsenseConfig
  OPNsenseConfig toOPNsenseConfig() {
    return OPNsenseConfig(
      host: host,
      port: port,
      apiKey: apiKey,
      apiSecret: apiSecret,
      useHttps: useHttps,
    );
  }

  /// JSON serialization
  factory Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);
  Map<String, dynamic> toJson() => _$ProfileToJson(this);
}

