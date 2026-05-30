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
import '../dhcp_lease_adapter.dart';

/// Service for DHCP operations
class DHCPService extends BaseOPNsenseService {
  Future<List<Map<String, dynamic>>> getDhcpLeases() async {
    ensureInitialized();
    
    // Get the configured DHCP server type
    final serverType = config.dhcpServerType;
    
    try {
      // Use the appropriate API endpoint for the server type
      final response = await dio.get(serverType.apiEndpoint);
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        // Use the adapter to parse leases based on server type
        return DhcpLeaseAdapter.parseLeases(data, serverType);
      } else {
        throw ApiException(
          'Failed to get DHCP leases: HTTP ${response.statusCode}',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (e) {
      throw ApiException('Failed to get DHCP leases: ${e.toString()}', null);
    }
  }
}


