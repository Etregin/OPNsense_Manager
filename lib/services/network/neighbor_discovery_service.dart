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
  static const String _statusPath = '/hostdiscovery/service/status';
  static const String _searchPath = '/hostdiscovery/service/search';
  static const String _startPath = '/hostdiscovery/service/start';
  static const String _stopPath = '/hostdiscovery/service/stop';
  static const String _restartPath = '/hostdiscovery/service/restart';

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
  /// Returns the full neighbor discovery response including pagination info
  /// and a list of discovered neighbors sorted by last seen timestamp
  /// in descending order.
  ///
  /// Parameters:
  /// - [current]: Current page number (default: 1)
  /// - [rowCount]: Number of rows per page (default: 50)
  /// - [searchPhrase]: Optional search phrase to filter results
  ///
  /// Throws [ApiException] if the request fails.
  Future<NeighborDiscoveryResponse> searchNeighbors({
    int current = 1,
    int rowCount = 50,
    String? searchPhrase,
  }) async {
    ensureInitialized();

    try {
      final data = {
        'current': current,
        'rowCount': rowCount,
        'sort': {'last_seen': 'desc'},
      };
      
      if (searchPhrase != null && searchPhrase.isNotEmpty) {
        data['searchPhrase'] = searchPhrase;
      }

      final response = await dio.post(
        _searchPath,
        data: data,
      );

      if (response.statusCode == 200) {
        final responseData = response.data;

        if (responseData is Map<String, dynamic>) {
          return NeighborDiscoveryResponse.fromJson(responseData);
        }
        throw ApiException('Invalid response format', response.statusCode);
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

  /// Start the neighbor discovery service
  ///
  /// Starts the neighbor discovery service and returns the result.
  /// Throws [ApiException] if the request fails.
  Future<Map<String, dynamic>> startService() async {
    ensureInitialized();

    try {
      final response = await dio.post(
        _startPath,
        data: {},
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ApiException(
          'Failed to start service: HTTP ${response.statusCode}',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        'Failed to start service: ${e.toString()}',
        null,
      );
    }
  }

  /// Stop the neighbor discovery service
  ///
  /// Stops the neighbor discovery service and returns the result.
  /// Throws [ApiException] if the request fails.
  Future<Map<String, dynamic>> stopService() async {
    ensureInitialized();

    try {
      final response = await dio.post(
        _stopPath,
        data: {},
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ApiException(
          'Failed to stop service: HTTP ${response.statusCode}',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        'Failed to stop service: ${e.toString()}',
        null,
      );
    }
  }

  /// Restart the neighbor discovery service
  ///
  /// Restarts the neighbor discovery service and returns the result.
  /// Throws [ApiException] if the request fails.
  Future<Map<String, dynamic>> restartService() async {
    ensureInitialized();

    try {
      final response = await dio.post(
        _restartPath,
        data: {},
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ApiException(
          'Failed to restart service: HTTP ${response.statusCode}',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(
        'Failed to restart service: ${e.toString()}',
        null,
      );
    }
  }
}


