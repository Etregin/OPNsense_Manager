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
import '../../base/base_opnsense_service.dart';
import '../../base/api_exception.dart';
import '../../../models/firewall_alias.dart';

/// Service for firewall alias metadata operations
class FirewallAliasMetadataService extends BaseOPNsenseService {
  /// Get GeoIP information
  Future<Map<String, dynamic>> getGeoIP() async {
    ensureInitialized();

    try {
      final response = await dio.get('/firewall/alias/get_geoip');

      if (response.statusCode == 200 && response.data is Map) {
        return response.data as Map<String, dynamic>;
      }
      throw ApiException('Failed to get GeoIP data', response.statusCode, ApiErrorType.unknown);
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (e) {
      throw ApiException('Failed to get GeoIP data: ${e.toString()}', null, ApiErrorType.unknown);
    }
  }

  /// Get alias table size
  Future<Map<String, dynamic>> getAliasTableSize() async {
    ensureInitialized();

    try {
      final response = await dio.get('/firewall/alias/get_table_size');

      if (response.statusCode == 200 && response.data is Map) {
        return response.data as Map<String, dynamic>;
      }
      throw ApiException('Failed to get table size', response.statusCode, ApiErrorType.unknown);
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (e) {
      throw ApiException('Failed to get table size: ${e.toString()}', null, ApiErrorType.unknown);
    }
  }

  /// List available categories.
  ///
  /// Returns `{"rows": [{"uuid": "...", "name": "...", ...}]}` — same flat
  /// search_item style. [AliasCategory.name] = UUID (sent to API on save),
  /// [AliasCategory.description] = display label shown in the UI.
  Future<List<AliasCategory>> listAliasCategories() async {
    ensureInitialized();

    try {
      final response = await dio.get('/firewall/alias/list_categories');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data['rows'] is List) {
          return (data['rows'] as List)
              .whereType<Map<String, dynamic>>()
              .map((row) => AliasCategory(
                    name: row['uuid']?.toString() ?? '',
                    description: row['name']?.toString() ?? '',
                  ))
              .where((c) => c.name.isNotEmpty)
              .toList();
        }
        return [];
      }
      throw ApiException('Failed to list categories', response.statusCode, ApiErrorType.unknown);
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (e) {
      throw ApiException('Failed to list categories: ${e.toString()}', null, ApiErrorType.unknown);
    }
  }

  /// List available countries for GeoIP
  Future<List<AliasCountry>> listAliasCountries() async {
    ensureInitialized();

    try {
      final response = await dio.get('/firewall/alias/list_countries');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data['countries'] != null) {
          final countries = data['countries'] as Map<String, dynamic>;
          return countries.entries.map((entry) {
            return AliasCountry(
              code: entry.key,
              name: entry.value.toString(),
            );
          }).toList();
        }
        return [];
      }
      throw ApiException('Failed to list countries', response.statusCode, ApiErrorType.unknown);
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (e) {
      throw ApiException('Failed to list countries: ${e.toString()}', null, ApiErrorType.unknown);
    }
  }

  /// List network aliases
  Future<Map<String, dynamic>> listNetworkAliases() async {
    ensureInitialized();

    try {
      final response = await dio.get('/firewall/alias/list_network_aliases');

      if (response.statusCode == 200 && response.data is Map) {
        return response.data as Map<String, dynamic>;
      }
      throw ApiException(
          'Failed to list network aliases', response.statusCode, ApiErrorType.unknown);
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (e) {
      throw ApiException(
          'Failed to list network aliases: ${e.toString()}', null, ApiErrorType.unknown);
    }
  }

  /// List user groups
  Future<Map<String, dynamic>> listUserGroups() async {
    ensureInitialized();

    try {
      final response = await dio.get('/firewall/alias/list_user_groups');

      if (response.statusCode == 200 && response.data is Map) {
        return response.data as Map<String, dynamic>;
      }
      throw ApiException('Failed to list user groups', response.statusCode, ApiErrorType.unknown);
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (e) {
      throw ApiException('Failed to list user groups: ${e.toString()}', null, ApiErrorType.unknown);
    }
  }
}


