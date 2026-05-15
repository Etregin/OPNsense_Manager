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

/// Service for controlling OPNsense services
class ServiceControlService extends BaseOPNsenseService {
  Future<List<dynamic>> getServices() async {
    if (!isInitialized) {
      throw ApiException('API service not initialized', null);
    }

    try {
      
      final response = await dio.get('/core/service/search');
      
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data is Map<String, dynamic> && data.containsKey('rows')) {
          final services = data['rows'] as List<dynamic>?;
          return services ?? [];
        } else if (data is List) {
          return data;
        }
        
        return [];
      } else {
        throw ApiException('Failed to get services', response.statusCode);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Control a service (start, stop, restart)
  /// Endpoint: /api/core/service/{action}/{serviceName}
  /// Actions: start, stop, restart
  Future<bool> controlService(String serviceName, String action) async {
    if (!isInitialized) {
      throw ApiException('API service not initialized', null);
    }

    try {
      
      final response = await dio.post('/core/service/$action/$serviceName');
      
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        // Check if response indicates success
        if (data is Map<String, dynamic>) {
          final result = data['result'] ?? data['status'] ?? 'ok';
          return result.toString().toLowerCase() == 'ok' || 
                 result.toString().toLowerCase() == 'success';
        }
        return true;
      } else {
        throw ApiException('Failed to $action service', response.statusCode);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }
}


