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

part 'network_host.g.dart';

/// Represents a network host with identity and traffic information
@JsonSerializable()
class NetworkHost {
  /// IP address of the host
  final String address;
  
  /// Hostname (from DHCP lease) or IP if not available
  final String hostname;
  
  /// MAC address manufacturer information
  final String? manufacturer;
  
  /// Download rate in bytes per second
  final int rateIn;
  
  /// Upload rate in bytes per second
  final int rateOut;
  
  /// Total bandwidth usage (download + upload) in bytes per second
  int get totalRate => rateIn + rateOut;
  
  /// MAC address (optional)
  final String? macAddress;
  
  /// Lease expiry time (optional)
  final DateTime? leaseExpiry;

  NetworkHost({
    required this.address,
    required this.hostname,
    this.manufacturer,
    required this.rateIn,
    required this.rateOut,
    this.macAddress,
    this.leaseExpiry,
  });

  factory NetworkHost.fromJson(Map<String, dynamic> json) =>
      _$NetworkHostFromJson(json);

  Map<String, dynamic> toJson() => _$NetworkHostToJson(this);

  /// Create a NetworkHost by merging lease and traffic data
  factory NetworkHost.fromLeaseAndTraffic({
    required Map<String, dynamic> lease,
    required Map<String, dynamic> traffic,
  }) {
    final address = traffic['address'] as String? ?? '';
    
    return NetworkHost(
      address: address,
      hostname: lease['hostname'] as String? ?? address,
      manufacturer: lease['mac_info'] as String?,
      macAddress: lease['hwaddr'] as String? ?? lease['mac'] as String?,
      rateIn: _parseRate(traffic['rate_bits_in'] ?? traffic['rate_in']),
      rateOut: _parseRate(traffic['rate_bits_out'] ?? traffic['rate_out']),
      leaseExpiry: _parseExpiry(lease['expire']),
    );
  }

  /// Create a NetworkHost from traffic data only (no lease info)
  factory NetworkHost.fromTrafficOnly(Map<String, dynamic> traffic) {
    final address = traffic['address'] as String? ?? '';
    
    return NetworkHost(
      address: address,
      hostname: address, // Use IP as hostname when no lease data
      manufacturer: null,
      macAddress: null,
      rateIn: _parseRate(traffic['rate_bits_in'] ?? traffic['rate_in']),
      rateOut: _parseRate(traffic['rate_bits_out'] ?? traffic['rate_out']),
      leaseExpiry: null,
    );
  }

  /// Parse rate value from API response
  /// The API returns rate_bits_in and rate_bits_out in bits per second
  /// We need to convert to bytes per second by dividing by 8
  static int _parseRate(dynamic rate) {
    if (rate == null) return 0;
    
    int bits = 0;
    if (rate is int) {
      bits = rate;
    } else if (rate is double) {
      bits = rate.toInt();
    } else if (rate is String) {
      final parsed = int.tryParse(rate);
      if (parsed != null) {
        bits = parsed;
      } else {
        // Try parsing as double first
        final parsedDouble = double.tryParse(rate);
        bits = parsedDouble?.toInt() ?? 0;
      }
    }
    
    // Convert bits to bytes (divide by 8)
    return (bits / 8).round();
  }

  /// Parse expiry timestamp from API response
  static DateTime? _parseExpiry(dynamic expires) {
    if (expires == null) return null;
    if (expires is int) {
      return DateTime.fromMillisecondsSinceEpoch(expires * 1000);
    }
    if (expires is String) {
      final timestamp = int.tryParse(expires);
      if (timestamp != null) {
        return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
      }
    }
    return null;
  }

  /// Copy with method for updating host data
  NetworkHost copyWith({
    String? address,
    String? hostname,
    String? manufacturer,
    int? rateIn,
    int? rateOut,
    String? macAddress,
    DateTime? leaseExpiry,
  }) {
    return NetworkHost(
      address: address ?? this.address,
      hostname: hostname ?? this.hostname,
      manufacturer: manufacturer ?? this.manufacturer,
      rateIn: rateIn ?? this.rateIn,
      rateOut: rateOut ?? this.rateOut,
      macAddress: macAddress ?? this.macAddress,
      leaseExpiry: leaseExpiry ?? this.leaseExpiry,
    );
  }
}

// Made with Bob
