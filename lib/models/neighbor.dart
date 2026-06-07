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

part 'neighbor.g.dart';

/// Represents a neighbor discovery entry
@JsonSerializable()
class Neighbor {
  /// Source of the neighbor discovery
  final String source;
  
  /// Network interface name
  @JsonKey(name: 'interface_name')
  final String interfaceName;
  
  /// MAC address (Ethernet address)
  @JsonKey(name: 'ether_address')
  final String etherAddress;
  
  /// IP address
  @JsonKey(name: 'ip_address')
  final String ipAddress;
  
  /// Organization name (nullable)
  @JsonKey(name: 'organization_name')
  final String? organizationName;
  
  /// First seen timestamp
  @JsonKey(name: 'first_seen')
  final String firstSeen;
  
  /// Last seen timestamp
  @JsonKey(name: 'last_seen')
  final String lastSeen;

  Neighbor({
    required this.source,
    required this.interfaceName,
    required this.etherAddress,
    required this.ipAddress,
    this.organizationName,
    required this.firstSeen,
    required this.lastSeen,
  });

  /// Create from JSON
  factory Neighbor.fromJson(Map<String, dynamic> json) =>
      _$NeighborFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$NeighborToJson(this);

  /// Create a copy with updated fields
  Neighbor copyWith({
    String? source,
    String? interfaceName,
    String? etherAddress,
    String? ipAddress,
    String? organizationName,
    String? firstSeen,
    String? lastSeen,
  }) {
    return Neighbor(
      source: source ?? this.source,
      interfaceName: interfaceName ?? this.interfaceName,
      etherAddress: etherAddress ?? this.etherAddress,
      ipAddress: ipAddress ?? this.ipAddress,
      organizationName: organizationName ?? this.organizationName,
      firstSeen: firstSeen ?? this.firstSeen,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }

  @override
  String toString() {
    return 'Neighbor(source: $source, interfaceName: $interfaceName, '
        'etherAddress: $etherAddress, ipAddress: $ipAddress, '
        'organizationName: $organizationName, firstSeen: $firstSeen, '
        'lastSeen: $lastSeen)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Neighbor &&
        other.source == source &&
        other.interfaceName == interfaceName &&
        other.etherAddress == etherAddress &&
        other.ipAddress == ipAddress;
  }

  @override
  int get hashCode =>
      source.hashCode ^
      interfaceName.hashCode ^
      etherAddress.hashCode ^
      ipAddress.hashCode;
}

/// Response model for the neighbor discovery search endpoint
@JsonSerializable()
class NeighborDiscoveryResponse {
  /// Total number of neighbors
  final int total;
  
  /// Number of rows in current page
  final int rowCount;
  
  /// Current page number
  final int current;
  
  /// List of neighbor entries
  final List<Neighbor> rows;

  NeighborDiscoveryResponse({
    required this.total,
    required this.rowCount,
    required this.current,
    required this.rows,
  });

  /// Create from JSON
  factory NeighborDiscoveryResponse.fromJson(Map<String, dynamic> json) =>
      _$NeighborDiscoveryResponseFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$NeighborDiscoveryResponseToJson(this);

  /// Create a copy with updated fields
  NeighborDiscoveryResponse copyWith({
    int? total,
    int? rowCount,
    int? current,
    List<Neighbor>? rows,
  }) {
    return NeighborDiscoveryResponse(
      total: total ?? this.total,
      rowCount: rowCount ?? this.rowCount,
      current: current ?? this.current,
      rows: rows ?? this.rows,
    );
  }

  @override
  String toString() {
    return 'NeighborDiscoveryResponse(total: $total, rowCount: $rowCount, '
        'current: $current, rows: ${rows.length})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NeighborDiscoveryResponse &&
        other.total == total &&
        other.rowCount == rowCount &&
        other.current == current;
  }

  @override
  int get hashCode =>
      total.hashCode ^ rowCount.hashCode ^ current.hashCode;
}

/// Service widget captions for service control buttons
@JsonSerializable()
class ServiceWidget {
  /// Caption for restart button
  @JsonKey(name: 'caption_restart')
  final String captionRestart;
  
  /// Caption for start button
  @JsonKey(name: 'caption_start')
  final String captionStart;
  
  /// Caption for stop button
  @JsonKey(name: 'caption_stop')
  final String captionStop;
  
  ServiceWidget({
    required this.captionRestart,
    required this.captionStart,
    required this.captionStop,
  });
  
  /// Create from JSON
  factory ServiceWidget.fromJson(Map<String, dynamic> json) =>
      _$ServiceWidgetFromJson(json);
  
  /// Convert to JSON
  Map<String, dynamic> toJson() => _$ServiceWidgetToJson(this);

  /// Create a copy with updated fields
  ServiceWidget copyWith({
    String? captionRestart,
    String? captionStart,
    String? captionStop,
  }) {
    return ServiceWidget(
      captionRestart: captionRestart ?? this.captionRestart,
      captionStart: captionStart ?? this.captionStart,
      captionStop: captionStop ?? this.captionStop,
    );
  }

  @override
  String toString() {
    return 'ServiceWidget(captionRestart: $captionRestart, '
        'captionStart: $captionStart, captionStop: $captionStop)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ServiceWidget &&
        other.captionRestart == captionRestart &&
        other.captionStart == captionStart &&
        other.captionStop == captionStop;
  }

  @override
  int get hashCode =>
      captionRestart.hashCode ^ captionStart.hashCode ^ captionStop.hashCode;
}

/// Response model for the neighbor discovery status endpoint
@JsonSerializable()
class NeighborDiscoveryStatus {
  /// Status of the neighbor discovery service
  final String status;
  
  /// Widget captions for service control buttons
  final ServiceWidget? widget;

  NeighborDiscoveryStatus({
    required this.status,
    this.widget,
  });

  /// Create from JSON
  factory NeighborDiscoveryStatus.fromJson(Map<String, dynamic> json) =>
      _$NeighborDiscoveryStatusFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$NeighborDiscoveryStatusToJson(this);

  /// Create a copy with updated fields
  NeighborDiscoveryStatus copyWith({
    String? status,
    ServiceWidget? widget,
  }) {
    return NeighborDiscoveryStatus(
      status: status ?? this.status,
      widget: widget ?? this.widget,
    );
  }

  @override
  String toString() {
    return 'NeighborDiscoveryStatus(status: $status, widget: $widget)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NeighborDiscoveryStatus &&
        other.status == status &&
        other.widget == widget;
  }

  @override
  int get hashCode => status.hashCode ^ widget.hashCode;
}


