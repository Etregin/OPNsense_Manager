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

part 'firewall_alias.g.dart';

/// Firewall alias model
@JsonSerializable()
class FirewallAlias {
  final String uuid;
  final String name;
  final String type; // host, network, port, url, geoip, networkgroup, etc.
  final String content;
  @JsonKey(name: 'description', defaultValue: '')
  final String description;
  final String enabled; // "1" or "0"
  @JsonKey(name: 'counters', defaultValue: '0')
  final String counters;
  @JsonKey(name: 'proto', defaultValue: '')
  final String proto; // For port aliases: tcp, udp, tcp/udp
  @JsonKey(name: 'interface', defaultValue: '')
  final String interface;
  @JsonKey(name: 'categories', defaultValue: '')
  final String categories;

  FirewallAlias({
    required this.uuid,
    required this.name,
    required this.type,
    required this.content,
    this.description = '',
    this.enabled = '1',
    this.counters = '0',
    this.proto = '',
    this.interface = '',
    this.categories = '',
  });

  /// Check if alias is enabled
  bool get isEnabled => enabled == "1";

  /// Get type display name
  String get typeDisplayName {
    switch (type.toLowerCase()) {
      case 'host':
        return 'Host(s)';
      case 'network':
        return 'Network(s)';
      case 'port':
        return 'Port(s)';
      case 'url':
        return 'URL (IPs)';
      case 'urltable':
        return 'URL Table (IPs)';
      case 'geoip':
        return 'GeoIP';
      case 'networkgroup':
        return 'Network Group';
      case 'mac':
        return 'MAC Address';
      case 'external':
        return 'External';
      case 'internal':
        return 'Internal';
      default:
        return type;
    }
  }

  /// Get content items as list
  List<String> get contentList {
    if (content.isEmpty) return [];
    return content.split(',').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
  }

  /// Create from JSON
  factory FirewallAlias.fromJson(Map<String, dynamic> json) =>
      _$FirewallAliasFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$FirewallAliasToJson(this);

  /// Create a copy with updated fields
  FirewallAlias copyWith({
    String? uuid,
    String? name,
    String? type,
    String? content,
    String? description,
    String? enabled,
    String? counters,
    String? proto,
    String? interface,
    String? categories,
  }) {
    return FirewallAlias(
      uuid: uuid ?? this.uuid,
      name: name ?? this.name,
      type: type ?? this.type,
      content: content ?? this.content,
      description: description ?? this.description,
      enabled: enabled ?? this.enabled,
      counters: counters ?? this.counters,
      proto: proto ?? this.proto,
      interface: interface ?? this.interface,
      categories: categories ?? this.categories,
    );
  }

  @override
  String toString() {
    return 'FirewallAlias(uuid: $uuid, name: $name, type: $type)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is FirewallAlias && other.uuid == uuid;
  }

  @override
  int get hashCode => uuid.hashCode;
}

/// Request model for creating/updating firewall aliases
@JsonSerializable()
class FirewallAliasRequest {
  final String name;
  final String type;
  final String content;
  @JsonKey(name: 'description', defaultValue: '')
  final String description;
  @JsonKey(name: 'enabled', defaultValue: '1')
  final String enabled;
  @JsonKey(name: 'counters', defaultValue: '0')
  final String counters;
  @JsonKey(name: 'proto', defaultValue: '')
  final String proto;
  @JsonKey(name: 'interface', defaultValue: '')
  final String interface;
  @JsonKey(name: 'categories', defaultValue: '')
  final String categories;

  FirewallAliasRequest({
    required this.name,
    required this.type,
    required this.content,
    this.description = '',
    this.enabled = '1',
    this.counters = '0',
    this.proto = '',
    this.interface = '',
    this.categories = '',
  });

  /// Create from JSON
  factory FirewallAliasRequest.fromJson(Map<String, dynamic> json) =>
      _$FirewallAliasRequestFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    final json = _$FirewallAliasRequestToJson(this);
    
    // Remove empty optional fields
    json.removeWhere((key, value) => 
      value == null || 
      (value is String && value.isEmpty && key != 'description')
    );
    
    return json;
  }

  /// Create from FirewallAlias
  factory FirewallAliasRequest.fromAlias(FirewallAlias alias) {
    return FirewallAliasRequest(
      name: alias.name,
      type: alias.type,
      content: alias.content,
      description: alias.description,
      enabled: alias.enabled,
      counters: alias.counters,
      proto: alias.proto,
      interface: alias.interface,
      categories: alias.categories,
    );
  }
}

/// Alias utility item for add/delete operations
@JsonSerializable()
class AliasUtilItem {
  final String address;
  
  AliasUtilItem({required this.address});
  
  factory AliasUtilItem.fromJson(Map<String, dynamic> json) =>
      _$AliasUtilItemFromJson(json);
  
  Map<String, dynamic> toJson() => _$AliasUtilItemToJson(this);
}

/// Alias table entry
@JsonSerializable()
class AliasTableEntry {
  final String ip;
  @JsonKey(name: 'hostname', defaultValue: '')
  final String hostname;
  
  AliasTableEntry({
    required this.ip,
    this.hostname = '',
  });
  
  factory AliasTableEntry.fromJson(Map<String, dynamic> json) =>
      _$AliasTableEntryFromJson(json);
  
  Map<String, dynamic> toJson() => _$AliasTableEntryToJson(this);
}

/// Category information
@JsonSerializable()
class AliasCategory {
  final String name;
  @JsonKey(name: 'description', defaultValue: '')
  final String description;
  
  AliasCategory({
    required this.name,
    this.description = '',
  });
  
  factory AliasCategory.fromJson(Map<String, dynamic> json) =>
      _$AliasCategoryFromJson(json);
  
  Map<String, dynamic> toJson() => _$AliasCategoryToJson(this);
}

/// Country information for GeoIP
@JsonSerializable()
class AliasCountry {
  final String code;
  final String name;
  
  AliasCountry({
    required this.code,
    required this.name,
  });
  
  factory AliasCountry.fromJson(Map<String, dynamic> json) =>
      _$AliasCountryFromJson(json);
  
  Map<String, dynamic> toJson() => _$AliasCountryToJson(this);
}

// Made with Bob
