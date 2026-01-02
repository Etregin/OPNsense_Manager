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

part 'firewall_rule.g.dart';

/// Firewall rule model
@JsonSerializable()
class FirewallRule {
  final String uuid;
  final String type; // pass, block, reject
  @JsonKey(name: 'interface')
  final String interfaceName;
  final String protocol; // tcp, udp, icmp, any
  final String source;
  final String destination;
  @JsonKey(name: 'source_port')
  final String sourcePort;
  @JsonKey(name: 'destination_port')
  final String destinationPort;
  @JsonKey(name: 'descr')
  final String description;
  final String enabled; // "1" or "0"
  final int sequence;
  @JsonKey(name: 'origin', defaultValue: '')
  final String origin; // Used to identify system-generated rules

  FirewallRule({
    required this.uuid,
    required this.type,
    required this.interfaceName,
    required this.protocol,
    required this.source,
    required this.destination,
    this.sourcePort = '',
    required this.destinationPort,
    required this.description,
    required this.enabled,
    required this.sequence,
    this.origin = '',
  });

  /// Check if rule is enabled
  bool get isEnabled => enabled == "1";

  /// Check if rule is system-generated (cannot be edited/deleted)
  /// System-generated rules have origin field set or come from automation
  bool get isSystemGenerated => origin.isNotEmpty;

  /// Get rule type display name
  String get typeDisplayName {
    switch (type.toLowerCase()) {
      case 'pass':
        return 'Pass';
      case 'block':
        return 'Block';
      case 'reject':
        return 'Reject';
      default:
        return type;
    }
  }

  /// Get protocol display name
  String get protocolDisplayName {
    return protocol.toUpperCase();
  }

  /// Create from JSON
  factory FirewallRule.fromJson(Map<String, dynamic> json) =>
      _$FirewallRuleFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$FirewallRuleToJson(this);

  /// Create a copy with updated fields
  FirewallRule copyWith({
    String? uuid,
    String? type,
    String? interfaceName,
    String? protocol,
    String? source,
    String? destination,
    String? sourcePort,
    String? destinationPort,
    String? description,
    String? enabled,
    int? sequence,
    String? origin,
  }) {
    return FirewallRule(
      uuid: uuid ?? this.uuid,
      type: type ?? this.type,
      interfaceName: interfaceName ?? this.interfaceName,
      protocol: protocol ?? this.protocol,
      source: source ?? this.source,
      destination: destination ?? this.destination,
      sourcePort: sourcePort ?? this.sourcePort,
      destinationPort: destinationPort ?? this.destinationPort,
      description: description ?? this.description,
      enabled: enabled ?? this.enabled,
      sequence: sequence ?? this.sequence,
      origin: origin ?? this.origin,
    );
  }

  @override
  String toString() {
    return 'FirewallRule(uuid: $uuid, type: $type, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FirewallRule && other.uuid == uuid;
  }

  @override
  int get hashCode => uuid.hashCode;
}

/// Request model for creating/updating firewall rules
@JsonSerializable()
class FirewallRuleRequest {
  // Use 'action' instead of 'type' as per OPNsense API
  @JsonKey(name: 'action')
  final String type;
  @JsonKey(name: 'interface')
  final String interfaceName;
  final String protocol;
  
  // Source fields
  @JsonKey(name: 'source_net')
  final String source;
  @JsonKey(name: 'source_not', defaultValue: '0')
  final String sourceNot;
  
  // Destination fields
  @JsonKey(name: 'destination_net')
  final String destination;
  @JsonKey(name: 'destination_not', defaultValue: '0')
  final String destinationNot;
  
  @JsonKey(name: 'destination_port')
  final String destinationPort;
  @JsonKey(name: 'description')  // Changed from 'descr' to 'description'
  final String description;
  final String enabled;
  
  // Additional fields from curl example
  @JsonKey(name: 'source_port', defaultValue: '')
  final String sourcePort;
  @JsonKey(name: 'log', defaultValue: '0')
  final String log;
  
  // Additional required fields
  @JsonKey(name: 'ipprotocol', defaultValue: 'inet')
  final String ipProtocol;
  @JsonKey(name: 'direction', defaultValue: 'in')
  final String direction;
  @JsonKey(name: 'quick', defaultValue: '1')
  final String quick;

  FirewallRuleRequest({
    required this.type,
    required this.interfaceName,
    required this.protocol,
    required this.source,
    required this.destination,
    required this.destinationPort,
    required this.description,
    this.enabled = "1",
    this.sourceNot = "0",
    this.destinationNot = "0",
    this.ipProtocol = "inet",
    this.direction = "in",
    this.quick = "1",
    this.sourcePort = "",
    this.log = "0",
  });

  /// Create from JSON
  factory FirewallRuleRequest.fromJson(Map<String, dynamic> json) =>
      _$FirewallRuleRequestFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    final json = _$FirewallRuleRequestToJson(this);
    
    // Convert protocol to uppercase EXCEPT for "any" which must stay lowercase
    // OPNsense expects: "TCP", "UDP", "ICMP" but "any" (not "ANY")
    if (json['protocol'] != null) {
      final protocolStr = json['protocol'].toString();
      if (protocolStr.toLowerCase() == 'any') {
        json['protocol'] = 'any';
      } else {
        json['protocol'] = protocolStr.toUpperCase();
      }
    }
    
    // Handle port fields based on protocol
    // Ports are only valid for TCP, UDP, and TCP/UDP protocols
    final protocolLower = protocol.toLowerCase();
    final supportsPorts = protocolLower == 'tcp' ||
                          protocolLower == 'udp' ||
                          protocolLower == 'tcp/udp';
    
    if (!supportsPorts) {
      // Remove both port fields for non-TCP/UDP protocols
      json.remove('source_port');
      json.remove('destination_port');
    } else {
      // For TCP/UDP/TCP/UDP, remove port fields if empty or "any"
      if (json['source_port'] == null ||
          json['source_port'].toString().isEmpty ||
          json['source_port'] == 'any') {
        json.remove('source_port');
      }
      if (json['destination_port'] == null ||
          json['destination_port'].toString().isEmpty ||
          json['destination_port'] == 'any') {
        json.remove('destination_port');
      }
    }
    
    // Ensure source and destination are not empty
    if (json['source_net'] == null || json['source_net'].toString().isEmpty) {
      json['source_net'] = 'any';
    }
    if (json['destination_net'] == null || json['destination_net'].toString().isEmpty) {
      json['destination_net'] = 'any';
    }
    
    // Handle null or empty description
    if (json['description'] == null || json['description'] == 'null') {
      json['description'] = '';
    }
    
    return json;
  }

  /// Create from FirewallRule
  factory FirewallRuleRequest.fromRule(FirewallRule rule) {
    return FirewallRuleRequest(
      type: rule.type,
      interfaceName: rule.interfaceName,
      protocol: rule.protocol,
      source: rule.source,
      destination: rule.destination,
      destinationPort: rule.destinationPort,
      description: rule.description,
      enabled: rule.enabled,
    );
  }
}

