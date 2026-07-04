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

import 'package:dio/dio.dart';
import '../base/base_opnsense_service.dart';
import '../base/api_exception.dart';
import '../../models/network_host.dart';
import 'dhcp_service.dart';
import '../../constants/api_endpoints.dart';

/// Service for network operations
class NetworkService extends BaseOPNsenseService {
  final DHCPService _dhcpService = DHCPService();

  /// Get real-time traffic statistics for a specific interface
  /// Returns a list of hosts with their current bandwidth usage
  /// Note: This requires the diagnostics plugin to be installed and enabled
  Future<List<Map<String, dynamic>>> getTrafficTop(String interface) async {
    ensureInitialized();
    
    try {
      final response = await dio.get(ApiEndpoints.diagnosticsTrafficTopInterface(interface));
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        // Handle OPNsense traffic API response format
        // Response structure: {"lan": {"records": [...], "status": "ok"}}
        if (data is Map<String, dynamic>) {
          // Check for interface-specific data (e.g., data['lan'])
          if (data.containsKey(interface)) {
            final interfaceData = data[interface];
            if (interfaceData is Map<String, dynamic>) {
              // Check for records array inside interface data
              if (interfaceData.containsKey('records') && interfaceData['records'] is List) {
                return List<Map<String, dynamic>>.from(interfaceData['records']);
              }
            }
          }
          
          // Fallback: Check for direct records array
          if (data.containsKey('records') && data['records'] is List) {
            return List<Map<String, dynamic>>.from(data['records']);
          }
          
          // Check for rows array
          if (data.containsKey('rows') && data['rows'] is List) {
            return List<Map<String, dynamic>>.from(data['rows']);
          }
        }
        
        // If response is directly a list
        if (data is List) {
          return List<Map<String, dynamic>>.from(data);
        }
        
        return [];
      } else {
        throw ApiException(
          'Failed to get traffic data: HTTP ${response.statusCode}',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (e) {
      throw ApiException('Failed to get traffic data: ${e.toString()}', null);
    }
  }

  /// Get network hosts by merging DHCP leases and traffic data
  /// Returns a list of NetworkHost objects with identity and bandwidth info
  /// Shows ALL leased hosts, even those with zero traffic
  Future<List<NetworkHost>> getNetworkHosts({String interface = 'lan'}) async {
    ensureInitialized();
    
    try {
      // Initialize DHCP service with same config
      _dhcpService.init(dio, config);
      
      // Fetch both datasets in parallel for better performance
      final results = await Future.wait([
        _dhcpService.getDhcpLeases(),
        getTrafficTop(interface),
      ]);
      
      final leases = results[0];
      final trafficData = results[1];
      
      // Create a map of IP addresses to traffic data for quick lookup
      final trafficMap = <String, Map<String, dynamic>>{};
      for (final traffic in trafficData) {
        final address = traffic['address'] as String?;
        if (address != null && address.isNotEmpty) {
          trafficMap[address] = traffic;
        }
      }
      
      // Start with all leased hosts
      final hosts = <NetworkHost>[];
      final processedAddresses = <String>{};
      
      // Add all hosts from leases (with or without traffic)
      for (final lease in leases) {
        final address = lease['address'] as String?;
        if (address == null || address.isEmpty) continue;
        
        processedAddresses.add(address);
        
        // Check if we have traffic data for this IP
        final traffic = trafficMap[address];
        
        if (traffic != null) {
          // Merge lease and traffic data
          hosts.add(NetworkHost.fromLeaseAndTraffic(
            lease: lease,
            traffic: traffic,
          ));
        } else {
          // Only lease data available (no current traffic)
          hosts.add(NetworkHost.fromLeaseAndTraffic(
            lease: lease,
            traffic: {
              'address': address,
              'rate_bits_in': 0,
              'rate_bits_out': 0,
            },
          ));
        }
      }
      
      // Add any hosts from traffic that don't have lease data
      for (final traffic in trafficData) {
        final address = traffic['address'] as String?;
        if (address == null || address.isEmpty) continue;
        
        if (!processedAddresses.contains(address)) {
          hosts.add(NetworkHost.fromTrafficOnly(traffic));
        }
      }
      
      // Sort by total bandwidth usage (highest first), then by hostname
      hosts.sort((a, b) {
        final rateCompare = b.totalRate.compareTo(a.totalRate);
        if (rateCompare != 0) return rateCompare;
        return a.hostname.compareTo(b.hostname);
      });
      
      return hosts;
    } catch (e) {
      throw ApiException('Failed to get network hosts: ${e.toString()}', null);
    }
  }
}


