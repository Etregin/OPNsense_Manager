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
import '../../models/neighbor.dart';
import '../base/base_opnsense_service.dart';
import '../base/api_exception.dart';

/// Service for neighbor discovery operations
class NeighborDiscoveryService extends BaseOPNsenseService {
  static const String _statusPath = '/api/hostdiscovery/service/status';
  static const String _searchPath = '/api/hostdiscovery/service/search';

  /// Check the status of the neighbor discovery service
  ///
  /// Returns the current status of the neighbor discovery service.
  /// Throws [ApiException] if the request fails.
  Future<NeighborDiscoveryStatus> checkStatus() async {
    ensureInitialized();

    try {
      final response = await dio.post(
        _statusPath,
        data: {},
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map<String, dynamic>) {
          return NeighborDiscoveryStatus.fromJson(data);
        } else {
          throw ApiException('Invalid response format', response.statusCode);
        }
      } else {
        throw ApiException(
          'Failed to check neighbor discovery status: HTTP ${response.statusCode}',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        'Failed to check neighbor discovery status: ${e.toString()}',
        null,
      );
    }
  }

  /// Search for discovered neighbors
  ///
  /// Returns a list of discovered neighbors sorted by last seen timestamp
  /// in descending order. The search returns up to 50 results per page.
  /// Throws [ApiException] if the request fails.
  Future<List<Neighbor>> searchNeighbors() async {
    ensureInitialized();

    try {
      final payload = {
        'current': 1,
        'rowCount': 50,
        'sort': {'last_seen': 'desc'},
      };

      final response = await dio.post(
        _searchPath,
        data: payload,
      );

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map<String, dynamic>) {
          final searchResponse = NeighborDiscoveryResponse.fromJson(data);
          return searchResponse.rows;
        } else {
          throw ApiException('Invalid response format', response.statusCode);
        }
      } else {
        throw ApiException(
          'Failed to search neighbors: HTTP ${response.statusCode}',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        'Failed to search neighbors: ${e.toString()}',
        null,
      );
    }
  }
}


