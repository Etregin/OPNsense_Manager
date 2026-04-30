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

part 'dhcp_lease.g.dart';

/// Represents a DHCP lease from OPNsense
@JsonSerializable()
class DhcpLease {
  /// IP address assigned to the client
  final String address;
  
  /// Hostname of the client
  final String hostname;
  
  /// MAC address of the client
  @JsonKey(name: 'hwaddr')
  final String macAddress;
  
  /// MAC address manufacturer information
  @JsonKey(name: 'mac_info')
  final String? manufacturer;
  
  /// Lease start time (Unix timestamp)
  final int? starts;
  
  /// Lease end time (Unix timestamp)
  final int? ends;
  
  /// Lease expiry time (Unix timestamp)
  final int? expire;
  
  /// Lease state (active, expired, etc.)
  final String? state;
  
  /// Client identifier
  @JsonKey(name: 'cltt')
  final int? clientLastTransactionTime;
  
  /// Network interface
  @JsonKey(name: 'if')
  final String? interface;
  
  /// Lease type (static or dynamic)
  final String? type;

  DhcpLease({
    required this.address,
    required this.hostname,
    required this.macAddress,
    this.manufacturer,
    this.starts,
    this.ends,
    this.expire,
    this.state,
    this.clientLastTransactionTime,
    this.interface,
    this.type,
  });

  factory DhcpLease.fromJson(Map<String, dynamic> json) =>
      _$DhcpLeaseFromJson(json);

  Map<String, dynamic> toJson() => _$DhcpLeaseToJson(this);
  
  /// Get lease expiry as DateTime
  DateTime? get expiryDateTime {
    if (expire == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(expire! * 1000);
  }
  
  /// Get lease start as DateTime
  DateTime? get startDateTime {
    if (starts == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(starts! * 1000);
  }
  
  /// Get lease end as DateTime
  DateTime? get endDateTime {
    if (ends == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(ends! * 1000);
  }
  
  /// Check if lease is expired
  bool get isExpired {
    final expiry = expiryDateTime;
    if (expiry == null) return false;
    return expiry.isBefore(DateTime.now());
  }
  
  /// Check if lease is active
  bool get isActive {
    return state?.toLowerCase() == 'active' || !isExpired;
  }
  
  /// Check if this is a static lease
  bool get isStatic {
    return type?.toLowerCase() == 'static';
  }
}
