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

/// Service for IPsec VPN operations
class IPsecService extends BaseOPNsenseService {
  Future<List<Map<String, dynamic>>> getIPsecConnections() async {
    ensureInitialized();

    try {
      final response = await dio.get('/ipsec/connections/search_connection');
      
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('rows') && data['rows'] is List) {
          return List<Map<String, dynamic>>.from(data['rows']);
        }
        return [];
      } else {
        throw ApiException('Failed to get IPsec connections', response.statusCode);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Get IPsec sessions (Phase 1)
  Future<List<Map<String, dynamic>>> getIPsecSessionsPhase1() async {
    ensureInitialized();

    try {
      final response = await dio.get('/ipsec/sessions/search_phase1');
      
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('rows') && data['rows'] is List) {
          return List<Map<String, dynamic>>.from(data['rows']);
        }
        return [];
      } else {
        throw ApiException('Failed to get IPsec Phase 1 sessions', response.statusCode);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }
}


