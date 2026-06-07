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

import '../models/dhcp_server_type.dart';

/// Adapter class to normalize DHCP lease data from different server types
class DhcpLeaseAdapter {
  /// Parse DHCP leases based on server type
  static List<Map<String, dynamic>> parseLeases(
    dynamic data,
    DhcpServerType serverType,
  ) {
    switch (serverType) {
      case DhcpServerType.dnsmasq:
        return _parseDnsmasqLeases(data);
      case DhcpServerType.isc:
        return _parseIscLeases(data);
      case DhcpServerType.kea:
        return _parseKeaLeases(data);
    }
  }

  /// Parse dnsmasq DHCP leases
  /// Format: Standard OPNsense dnsmasq format with 'rows' array
  static List<Map<String, dynamic>> _parseDnsmasqLeases(dynamic data) {
    if (data is Map<String, dynamic>) {
      // Check for rows array (common OPNsense format)
      if (data.containsKey('rows') && data['rows'] is List) {
        return List<Map<String, dynamic>>.from(data['rows']);
      }
      // Check for leases array
      if (data.containsKey('leases') && data['leases'] is List) {
        return List<Map<String, dynamic>>.from(data['leases']);
      }
      // If data itself is the lease info
      if (data.containsKey('address') || data.containsKey('hostname')) {
        return [data];
      }
    }
    
    // If response is directly a list
    if (data is List) {
      return List<Map<String, dynamic>>.from(data);
    }
    
    return [];
  }

  /// Parse ISC DHCP leases
  /// Format: ISC DHCP server format with different field names
  static List<Map<String, dynamic>> _parseIscLeases(dynamic data) {
    List<Map<String, dynamic>> rawLeases = [];
    
    if (data is Map<String, dynamic>) {
      if (data.containsKey('rows') && data['rows'] is List) {
        rawLeases = List<Map<String, dynamic>>.from(data['rows']);
      } else if (data.containsKey('leases') && data['leases'] is List) {
        rawLeases = List<Map<String, dynamic>>.from(data['leases']);
      } else if (data.containsKey('address') || data.containsKey('ip')) {
        rawLeases = [data];
      }
    } else if (data is List) {
      rawLeases = List<Map<String, dynamic>>.from(data);
    }

    // Normalize ISC DHCP field names to match our model
    return rawLeases.map((lease) {
      return {
        'address': lease['ip'] ?? lease['address'] ?? '',
        'hostname': lease['hostname'] ?? lease['client-hostname'] ?? 'unknown',
        'hwaddr': lease['hardware'] ?? lease['hwaddr'] ?? lease['mac'] ?? '',
        'mac_info': lease['mac_info'] ?? lease['vendor'],
        'starts': _parseIscTime(lease['starts'] ?? lease['start']),
        'ends': _parseIscTime(lease['ends'] ?? lease['end']),
        'expire': _parseIscTime(lease['ends'] ?? lease['end']),
        'state': lease['state'] ?? lease['binding-state'] ?? 'active',
        'cltt': _parseIscTime(lease['cltt']),
        'if': lease['if'] ?? lease['interface'],
        'type': lease['type'] ?? (lease['binding-state'] == 'active' ? 'dynamic' : 'static'),
      };
    }).toList();
  }

  /// Parse KEA DHCP leases
  /// Format: KEA DHCP server format (JSON-based, modern structure)
  static List<Map<String, dynamic>> _parseKeaLeases(dynamic data) {
    List<Map<String, dynamic>> rawLeases = [];
    
    if (data is Map<String, dynamic>) {
      // KEA typically returns leases in 'arguments' -> 'leases' structure
      if (data.containsKey('arguments') && data['arguments'] is Map) {
        final args = data['arguments'] as Map<String, dynamic>;
        if (args.containsKey('leases') && args['leases'] is List) {
          rawLeases = List<Map<String, dynamic>>.from(args['leases']);
        }
      } else if (data.containsKey('rows') && data['rows'] is List) {
        rawLeases = List<Map<String, dynamic>>.from(data['rows']);
      } else if (data.containsKey('leases') && data['leases'] is List) {
        rawLeases = List<Map<String, dynamic>>.from(data['leases']);
      } else if (data.containsKey('ip-address') || data.containsKey('address')) {
        rawLeases = [data];
      }
    } else if (data is List) {
      rawLeases = List<Map<String, dynamic>>.from(data);
    }

    // Normalize KEA DHCP field names to match our model
    return rawLeases.map((lease) {
      return {
        'address': _safeToString(lease['ip-address'] ?? lease['address']),
        'hostname': _safeToString(lease['hostname'] ?? lease['fqdn-fwd']) ?? 'unknown',
        'hwaddr': _safeToString(lease['hw-address'] ?? lease['hwaddr'] ?? lease['mac']),
        'mac_info': _safeToString(lease['mac_info'] ?? lease['vendor-class-data']),
        'starts': _parseKeaTime(lease['cltt']),
        'ends': _parseKeaTime(lease['valid-lft'] ?? lease['valid_lifetime'], lease['cltt']),
        'expire': _parseKeaTime(lease['expire'] ?? lease['valid-lft'] ?? lease['valid_lifetime'], lease['cltt']),
        'state': _safeToString(lease['state']) ?? 'active',
        'cltt': _parseKeaTime(lease['cltt']),
        'if': _safeToString(lease['subnet-id'] ?? lease['if']),
        'if_descr': _safeToString(lease['if_descr']),
        'if_name': _safeToString(lease['if_name']),
        'type': (lease['is_reserved'] is List && (lease['is_reserved'] as List).isNotEmpty) ? 'static' : 'dynamic',
        'prefix_len': _safeToString(lease['prefix_len']),
        'duid': _safeToString(lease['duid']),
        'client_id': _safeToString(lease['client_id']),
        'iaid': _safeToString(lease['iaid']),
        'is_reserved': lease['is_reserved'],
      };
    }).toList();
  }

  /// Parse ISC DHCP time format
  /// ISC DHCP uses various time formats, this handles common ones
  static int? _parseIscTime(dynamic time) {
    if (time == null) return null;
    
    if (time is int) {
      // Already a Unix timestamp
      return time;
    }
    
    if (time is String) {
      // Try parsing as Unix timestamp string
      final parsed = int.tryParse(time);
      if (parsed != null) return parsed;
      
      // Try parsing ISO 8601 or other date formats
      try {
        final dateTime = DateTime.parse(time);
        return dateTime.millisecondsSinceEpoch ~/ 1000;
      } catch (e) {
        return null;
      }
    }
    
    return null;
  }

  /// Parse KEA DHCP time format
  /// KEA uses cltt (client last transaction time) and valid-lft (valid lifetime)
  static int? _parseKeaTime(dynamic time, [dynamic baseTime]) {
    if (time == null) return null;
    
    if (time is int) {
      // If baseTime is provided, add the lifetime to it
      if (baseTime != null && baseTime is int) {
        return baseTime + time;
      }
      return time;
    }
    
    if (time is String) {
      final parsed = int.tryParse(time);
      if (parsed != null) {
        if (baseTime != null) {
          final base = baseTime is int ? baseTime : int.tryParse(baseTime.toString());
          if (base != null) {
            return base + parsed;
          }
        }
        return parsed;
      }
    }
    
    return null;
  }

  /// Safely convert a value to String, handling both int and String types
  /// Returns null if the value is null or empty string
  static String? _safeToString(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      return value.isEmpty ? null : value;
    }
    return value.toString();
  }
}
