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

part 'tailscale_settings.g.dart';

/// Represents an exit node option in Tailscale
@JsonSerializable()
class TailscaleExitNode {
  /// Display value for the exit node
  final String? value;
  
  /// Whether this exit node is selected ("1" = selected, "0" = not selected)
  @JsonKey(fromJson: _selectedFromJson, toJson: _selectedToJson)
  final bool selected;

  TailscaleExitNode({
    this.value,
    required this.selected,
  });

  /// Convert API string/int to bool
  static bool _selectedFromJson(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is int) return value == 1;
    if (value is String) return value == '1';
    return false;
  }

  /// Convert bool to API int
  static int _selectedToJson(bool value) => value ? 1 : 0;

  factory TailscaleExitNode.fromJson(Map<String, dynamic> json) =>
      _$TailscaleExitNodeFromJson(json);

  Map<String, dynamic> toJson() => _$TailscaleExitNodeToJson(this);
}

/// Represents a single subnet configuration in Tailscale
@JsonSerializable()
class TailscaleSubnet {
  /// UUID of the subnet (only present in search results)
  final String? uuid;
  
  /// Subnet in CIDR notation (e.g., "192.168.1.0/24")
  final String? subnet;
  
  /// Description of the subnet
  final String? description;

  TailscaleSubnet({
    this.uuid,
    this.subnet,
    this.description,
  });

  factory TailscaleSubnet.fromJson(Map<String, dynamic> json) =>
      _$TailscaleSubnetFromJson(json);

  Map<String, dynamic> toJson() => _$TailscaleSubnetToJson(this);

  @override
  String toString() => 'TailscaleSubnet(uuid: $uuid, subnet: $subnet, description: $description)';
}

/// Response from the subnet search endpoint
@JsonSerializable()
class TailscaleSubnetSearchResponse {
  /// List of subnet rows
  final List<TailscaleSubnet> rows;
  
  /// Number of rows in current page
  final int rowCount;
  
  /// Total number of subnets
  final int total;
  
  /// Current page number
  final int current;

  TailscaleSubnetSearchResponse({
    required this.rows,
    required this.rowCount,
    required this.total,
    required this.current,
  });

  factory TailscaleSubnetSearchResponse.fromJson(Map<String, dynamic> json) =>
      _$TailscaleSubnetSearchResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TailscaleSubnetSearchResponseToJson(this);
}

/// Main Tailscale settings model matching the API structure
@JsonSerializable()
class TailscaleSettings {
  /// Enable/disable Tailscale ("1" = enabled, "0" = disabled)
  @JsonKey(fromJson: _boolFromString, toJson: _boolToString)
  final bool? enabled;
  
  /// Login timeout in minutes
  final String? loginTimeout;
  
  /// UDP port to listen on
  final String? listenPort;
  
  /// Accept DNS configuration from Tailscale ("1" = accept, "0" = reject)
  @JsonKey(fromJson: _boolFromString, toJson: _boolToString)
  final bool? acceptDNS;
  
  /// Advertise this node as an exit node ("1" = advertise, "0" = don't advertise)
  @JsonKey(fromJson: _boolFromString, toJson: _boolToString)
  final bool? advertiseExitNode;
  
  /// Exit node selection - complex nested structure
  /// Key is empty string or node ID, value contains node info
  @JsonKey(
    fromJson: _exitNodeFromJson,
    toJson: _exitNodeToJson,
    includeIfNull: false,
  )
  final Map<String, TailscaleExitNode>? useExitNode;
  
  /// Accept subnet routes from other nodes ("1" = accept, "0" = reject)
  @JsonKey(fromJson: _boolFromString, toJson: _boolToString)
  final bool? acceptSubnetRoutes;
  
  /// Enable SSH server ("1" = enabled, "0" = disabled)
  @JsonKey(fromJson: _boolFromString, toJson: _boolToString)
  final bool? enableSSH;
  
  /// Disable source NAT ("1" = disabled, "0" = enabled)
  @JsonKey(fromJson: _boolFromString, toJson: _boolToString)
  final bool? disableSNAT;
  
  /// Subnets configuration - nested structure: subnet4 -> uuid -> {subnet, description}
  @JsonKey(fromJson: _subnetsFromJson, toJson: _subnetsToJson)
  final Map<String, TailscaleSubnet>? subnets;

  TailscaleSettings({
    this.enabled,
    this.loginTimeout,
    this.listenPort,
    this.acceptDNS,
    this.advertiseExitNode,
    this.useExitNode,
    this.acceptSubnetRoutes,
    this.enableSSH,
    this.disableSNAT,
    this.subnets,
  });

  /// Convert API string ("0" or "1") to bool
  static bool? _boolFromString(dynamic value) {
    if (value == null) return null;
    if (value is bool) return value;
    if (value is String) return value == '1';
    return null;
  }

  /// Convert bool to API string
  static String? _boolToString(bool? value) {
    if (value == null) return null;
    return value ? '1' : '0';
  }

  /// Parse exit node structure from API
  static Map<String, TailscaleExitNode>? _exitNodeFromJson(dynamic json) {
    if (json == null) return null;
    if (json is! Map) return null;
    
    final result = <String, TailscaleExitNode>{};
    json.forEach((key, value) {
      if (value is Map<String, dynamic>) {
        result[key.toString()] = TailscaleExitNode.fromJson(value);
      }
    });
    return result;
  }

  /// Convert exit node structure to API format
  /// The API expects either null (field omitted) when no exit node is selected,
  /// or the selected node key (not the entire map structure)
  static Map<String, dynamic>? _exitNodeToJson(Map<String, TailscaleExitNode>? nodes) {
    if (nodes == null) return null;
    
    // Find the selected exit node
    String? selectedKey;
    for (var entry in nodes.entries) {
      if (entry.value.selected) {
        selectedKey = entry.key;
        break;
      }
    }
    
    // If no exit node is selected or the selected key is empty (None), return null
    // This will cause the field to be omitted from JSON when includeIfNull: false
    if (selectedKey == null || selectedKey.isEmpty) {
      return null;
    }
    
    // Return only the selected exit node in the expected format
    return {selectedKey: nodes[selectedKey]!.toJson()};
  }

  /// Parse subnets structure from API
  /// API format: { "subnet4": { "uuid1": {subnet, description}, "uuid2": {...} } }
  static Map<String, TailscaleSubnet>? _subnetsFromJson(dynamic json) {
    if (json == null) return null;
    if (json is! Map) return null;
    
    final result = <String, TailscaleSubnet>{};
    
    // Navigate through the subnet4 wrapper
    final subnet4 = json['subnet4'];
    if (subnet4 is Map) {
      subnet4.forEach((uuid, subnetData) {
        if (subnetData is Map<String, dynamic>) {
          // Add UUID to the subnet data
          final subnetWithUuid = Map<String, dynamic>.from(subnetData);
          subnetWithUuid['uuid'] = uuid.toString();
          result[uuid.toString()] = TailscaleSubnet.fromJson(subnetWithUuid);
        }
      });
    }
    
    return result;
  }

  /// Convert subnets structure to API format
  static Map<String, dynamic>? _subnetsToJson(Map<String, TailscaleSubnet>? subnets) {
    if (subnets == null) return null;
    
    final subnet4Map = <String, dynamic>{};
    subnets.forEach((uuid, subnet) {
      final subnetJson = subnet.toJson();
      // Remove uuid from the nested object as it's used as the key
      subnetJson.remove('uuid');
      subnet4Map[uuid] = subnetJson;
    });
    
    return {'subnet4': subnet4Map};
  }

  /// Get login timeout as integer
  int? get loginTimeoutMinutes {
    if (loginTimeout == null) return null;
    return int.tryParse(loginTimeout!);
  }

  /// Get listen port as integer
  int? get listenPortNumber {
    if (listenPort == null) return null;
    return int.tryParse(listenPort!);
  }

  /// Get list of all subnets
  List<TailscaleSubnet> get subnetList {
    if (subnets == null) return [];
    return subnets!.values.toList();
  }

  /// Get the currently selected exit node (if any)
  TailscaleExitNode? get selectedExitNode {
    if (useExitNode == null) return null;
    
    for (var node in useExitNode!.values) {
      if (node.selected) return node;
    }
    return null;
  }

  factory TailscaleSettings.fromJson(Map<String, dynamic> json) =>
      _$TailscaleSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$TailscaleSettingsToJson(this);

  TailscaleSettings copyWith({
    bool? enabled,
    String? loginTimeout,
    String? listenPort,
    bool? acceptDNS,
    bool? advertiseExitNode,
    Map<String, TailscaleExitNode>? useExitNode,
    bool? acceptSubnetRoutes,
    bool? enableSSH,
    bool? disableSNAT,
    Map<String, TailscaleSubnet>? subnets,
  }) {
    return TailscaleSettings(
      enabled: enabled ?? this.enabled,
      loginTimeout: loginTimeout ?? this.loginTimeout,
      listenPort: listenPort ?? this.listenPort,
      acceptDNS: acceptDNS ?? this.acceptDNS,
      advertiseExitNode: advertiseExitNode ?? this.advertiseExitNode,
      useExitNode: useExitNode ?? this.useExitNode,
      acceptSubnetRoutes: acceptSubnetRoutes ?? this.acceptSubnetRoutes,
      enableSSH: enableSSH ?? this.enableSSH,
      disableSNAT: disableSNAT ?? this.disableSNAT,
      subnets: subnets ?? this.subnets,
    );
  }

  @override
  String toString() => 'TailscaleSettings(enabled: $enabled, listenPort: $listenPort)';
}

/// Response wrapper for the settings/get endpoint
@JsonSerializable()
class TailscaleSettingsResponse {
  final TailscaleSettings settings;

  TailscaleSettingsResponse({
    required this.settings,
  });

  factory TailscaleSettingsResponse.fromJson(Map<String, dynamic> json) =>
      _$TailscaleSettingsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TailscaleSettingsResponseToJson(this);
}

/// Response wrapper for individual subnet get endpoint
@JsonSerializable()
class TailscaleSubnetResponse {
  @JsonKey(name: 'subnet4')
  final TailscaleSubnet subnet;

  TailscaleSubnetResponse({
    required this.subnet,
  });

  factory TailscaleSubnetResponse.fromJson(Map<String, dynamic> json) =>
      _$TailscaleSubnetResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TailscaleSubnetResponseToJson(this);
}


