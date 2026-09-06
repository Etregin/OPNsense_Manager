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
  final String categories; // comma-separated selected category UUIDs
  /// Human-readable category display names.
  /// Populated from `%categories` (search_item) or computed from getItem map.
  /// Not persisted to JSON.
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String categoryLabels;
  /// List of category UUIDs from `categories_uuid` in search_item response.
  /// Not persisted to JSON.
  @JsonKey(includeFromJson: false, includeToJson: false)
  final List<String> categoriesUuid;
  @JsonKey(name: 'current_items', defaultValue: '0')
  final String currentItems;
  @JsonKey(defaultValue: '')
  final String updatefreq;
  @JsonKey(name: 'path_expression', defaultValue: '')
  final String pathExpression;
  /// Selected authtype key from the API selection map, e.g. "none" / "Basic".
  /// Not persisted to JSON (read-model only; write uses [FirewallAliasRequest]).
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String authtype;
  /// Username for URL-based aliases with Basic auth.
  /// Not persisted to JSON.
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String username;
  /// Password for URL-based aliases with Basic auth.
  /// Not persisted to JSON.
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String password;
  /// Expire date/time string for external aliases.
  /// Not persisted to JSON.
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String expire;

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
    this.categoryLabels = '',
    this.categoriesUuid = const [],
    this.currentItems = '0',
    this.updatefreq = '',
    this.pathExpression = '',
    this.authtype = '',
    this.username = '',
    this.password = '',
    this.expire = '',
  });

  /// Check if alias is enabled
  bool get isEnabled => enabled == '1';

  /// Returns true for system-managed aliases (bogons, sshlockout, __lan_network, etc.).
  /// System aliases have non-UUID identifiers — plain names or names with underscores/dashes
  /// that don't follow the 8-4-4-4-12 UUID format. Only user-created aliases have real UUIDs.
  bool get isSystemAlias {
    // Standard UUID: 8-4-4-4-12 hex characters separated by dashes
    final uuidPattern = RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
    );
    return !uuidPattern.hasMatch(uuid);
  }

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
      case 'urljson':
        return 'URL Table in JSON format (IPs)';
      case 'geoip':
        return 'GeoIP';
      case 'networkgroup':
        return 'Network Group';
      case 'mac':
        return 'MAC Address';
      case 'asn':
        return 'BGP ASN';
      case 'dynipv6host':
        return 'Dynamic IPv6 Host';
      case 'authgroup':
        return 'Auth Group';
      case 'internal':
        return 'Internal (automatic)';
      case 'external':
        return 'External (advanced)';
      default:
        return type;
    }
  }

  /// Get content items as list.
  /// Content is stored newline-separated (from getFirewallAlias API parsing)
  /// but may also be comma-separated in legacy / list-endpoint data.
  List<String> get contentList {
    if (content.isEmpty) return [];
    // Prefer newline split; fall back to comma split if no newlines present
    final separator = content.contains('\n') ? '\n' : ',';
    return content.split(separator).map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
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
    String? categoryLabels,
    List<String>? categoriesUuid,
    String? currentItems,
    String? updatefreq,
    String? pathExpression,
    String? authtype,
    String? username,
    String? password,
    String? expire,
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
      categoryLabels: categoryLabels ?? this.categoryLabels,
      categoriesUuid: categoriesUuid ?? this.categoriesUuid,
      currentItems: currentItems ?? this.currentItems,
      updatefreq: updatefreq ?? this.updatefreq,
      pathExpression: pathExpression ?? this.pathExpression,
      authtype: authtype ?? this.authtype,
      username: username ?? this.username,
      password: password ?? this.password,
      expire: expire ?? this.expire,
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
  final String? updatefreq;
  @JsonKey(name: 'path_expression')
  final String? pathExpression;
  final String? authtype;
  final String? password;
  final String? username;
  final String? expire;

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
    this.updatefreq,
    this.pathExpression,
    this.authtype,
    this.password,
    this.username,
    this.expire,
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
      updatefreq: alias.updatefreq.isEmpty ? null : alias.updatefreq,
      pathExpression: alias.pathExpression.isEmpty ? null : alias.pathExpression,
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

/// Category information.
/// [name] = UUID, [description] = display label, [color] = 6-char hex (no #).
@JsonSerializable()
class AliasCategory {
  final String name;
  @JsonKey(name: 'description', defaultValue: '')
  final String description;
  @JsonKey(defaultValue: '')
  final String color;
  
  AliasCategory({
    required this.name,
    this.description = '',
    this.color = '',
  });
  
  factory AliasCategory.fromJson(Map<String, dynamic> json) =>
      _$AliasCategoryFromJson(json);
  
  Map<String, dynamic> toJson() => _$AliasCategoryToJson(this);
}

/// Country information for GeoIP.
/// [region] matches the API's `region` field (e.g. "Europe", "Asia", "America").
/// Entries with a null region are placed under "Other".
@JsonSerializable()
class AliasCountry {
  final String code;
  final String name;
  @JsonKey(defaultValue: '')
  final String region;
  
  AliasCountry({
    required this.code,
    required this.name,
    this.region = '',
  });
  
  factory AliasCountry.fromJson(Map<String, dynamic> json) =>
      _$AliasCountryFromJson(json);
  
  Map<String, dynamic> toJson() => _$AliasCountryToJson(this);
}


