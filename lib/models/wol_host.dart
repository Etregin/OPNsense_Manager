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

part 'wol_host.g.dart';

/// Represents a Wake-on-LAN host configuration
@JsonSerializable()
class WolHost {
  /// Unique identifier for the host
  final String uuid;
  
  /// Network interface identifier (e.g., "lan", "wan")
  final String interface;
  
  /// Display name for the interface (e.g., "LAN", "WAN")
  @JsonKey(name: '%interface')
  final String interfaceDisplay;
  
  /// MAC address of the host
  final String mac;
  
  /// Description/name of the host
  @JsonKey(name: 'descr', defaultValue: '')
  final String descr;

  WolHost({
    required this.uuid,
    required this.interface,
    required this.interfaceDisplay,
    required this.mac,
    this.descr = '',
  });

  /// Create from JSON
  factory WolHost.fromJson(Map<String, dynamic> json) =>
      _$WolHostFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$WolHostToJson(this);

  /// Create a copy with updated fields
  WolHost copyWith({
    String? uuid,
    String? interface,
    String? interfaceDisplay,
    String? mac,
    String? descr,
  }) {
    return WolHost(
      uuid: uuid ?? this.uuid,
      interface: interface ?? this.interface,
      interfaceDisplay: interfaceDisplay ?? this.interfaceDisplay,
      mac: mac ?? this.mac,
      descr: descr ?? this.descr,
    );
  }

  @override
  String toString() {
    return 'WolHost(uuid: $uuid, mac: $mac, descr: $descr)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is WolHost && other.uuid == uuid;
  }

  @override
  int get hashCode => uuid.hashCode;
}

/// Response model for the search_host API endpoint
@JsonSerializable()
class WolHostResponse {
  /// List of WOL hosts
  final List<WolHost> rows;
  
  /// Number of rows in current page
  final int rowCount;
  
  /// Total number of hosts
  final int total;
  
  /// Current page number
  final int current;

  WolHostResponse({
    required this.rows,
    required this.rowCount,
    required this.total,
    required this.current,
  });

  /// Create from JSON
  factory WolHostResponse.fromJson(Map<String, dynamic> json) =>
      _$WolHostResponseFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$WolHostResponseToJson(this);
}

/// Represents an interface option for WOL host configuration
@JsonSerializable()
class WolInterfaceOption {
  /// Display value for the interface
  final String value;
  
  /// Whether this option is selected (1 = selected, 0 = not selected)
  final int selected;

  WolInterfaceOption({
    required this.value,
    required this.selected,
  });

  /// Check if this option is selected
  bool get isSelected => selected == 1;

  /// Create from JSON
  factory WolInterfaceOption.fromJson(Map<String, dynamic> json) =>
      _$WolInterfaceOptionFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$WolInterfaceOptionToJson(this);
}

/// Request model for adding a new WOL host
@JsonSerializable()
class WolHostRequest {
  /// Network interface identifier
  final String interface;
  
  /// MAC address
  final String mac;
  
  /// Description/name
  @JsonKey(name: 'descr', defaultValue: '')
  final String descr;

  WolHostRequest({
    required this.interface,
    required this.mac,
    this.descr = '',
  });

  /// Create from JSON
  factory WolHostRequest.fromJson(Map<String, dynamic> json) =>
      _$WolHostRequestFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$WolHostRequestToJson(this);
}

/// Response model for add/set host operations
@JsonSerializable()
class WolHostOperationResponse {
  /// Result status (e.g., "saved")
  final String result;
  
  /// UUID of the created/updated host
  final String? uuid;

  WolHostOperationResponse({
    required this.result,
    this.uuid,
  });

  /// Check if operation was successful
  bool get isSuccess => result.toLowerCase() == 'saved';

  /// Create from JSON
  factory WolHostOperationResponse.fromJson(Map<String, dynamic> json) =>
      _$WolHostOperationResponseFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$WolHostOperationResponseToJson(this);
}

/// Represents a single result from the Wake All operation
@JsonSerializable()
class WolWakeAllResult {
  /// MAC address of the host
  final String mac;
  
  /// Status of the wake operation (e.g., "OK")
  final String status;

  WolWakeAllResult({
    required this.mac,
    required this.status,
  });

  /// Check if operation was successful
  bool get isSuccess => status.toUpperCase() == 'OK';

  /// Create from JSON
  factory WolWakeAllResult.fromJson(Map<String, dynamic> json) =>
      _$WolWakeAllResultFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$WolWakeAllResultToJson(this);
}

/// Response model for the Wake All operation
@JsonSerializable()
class WolWakeAllResponse {
  /// List of wake results for each host
  final List<WolWakeAllResult> results;

  WolWakeAllResponse({
    required this.results,
  });

  /// Create from JSON
  factory WolWakeAllResponse.fromJson(Map<String, dynamic> json) =>
      _$WolWakeAllResponseFromJson(json);

  /// Convert to JSON
  Map<String, dynamic> toJson() => _$WolWakeAllResponseToJson(this);
}


