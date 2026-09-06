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

/// Service for firewall alias utility operations
class FirewallAliasUtilService extends BaseOPNsenseService {
  /// Get all aliases (utility endpoint)
  Future<Map<String, dynamic>> getAliasesUtil() async {
    ensureInitialized();

    try {
      final response = await dio.get('/firewall/alias_util/aliases');

      if (response.statusCode == 200 && response.data is Map) {
        return response.data as Map<String, dynamic>;
      }
      throw ApiException('Failed to get aliases', response.statusCode, ApiErrorType.unknown);
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (e) {
      throw ApiException('Failed to get aliases: ${e.toString()}', null, ApiErrorType.unknown);
    }
  }

  /// List alias table entries
  Future<List<AliasTableEntry>> listAliasTable(String aliasName) async {
    ensureInitialized();

    try {
      final response =
          await dio.get('/firewall/alias_util/list/$aliasName');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data['rows'] != null) {
          final rows = data['rows'] as List;
          return rows.map((row) {
            return AliasTableEntry(
              ip: row['ip'] ?? '',
              hostname: row['hostname'] ?? '',
            );
          }).toList();
        }
        return [];
      }
      throw ApiException('Failed to list alias table', response.statusCode, ApiErrorType.unknown);
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (e) {
      throw ApiException('Failed to list alias table: ${e.toString()}', null, ApiErrorType.unknown);
    }
  }

  /// Add item to alias table
  Future<Map<String, dynamic>> addToAliasTable(
      String aliasName, String address) async {
    ensureInitialized();

    try {
      final response = await dio.post(
        '/firewall/alias_util/add/$aliasName',
        data: {'address': address},
      );

      if (response.statusCode == 200 && response.data is Map) {
        return response.data as Map<String, dynamic>;
      }
      throw ApiException('Failed to add to alias table', response.statusCode, ApiErrorType.unknown);
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (e) {
      throw ApiException('Failed to add to alias table: ${e.toString()}', null, ApiErrorType.unknown);
    }
  }

  /// Delete item from alias table
  Future<Map<String, dynamic>> deleteFromAliasTable(
      String aliasName, String address) async {
    ensureInitialized();

    try {
      final response = await dio.post(
        '/firewall/alias_util/delete/$aliasName',
        data: {'address': address},
      );

      if (response.statusCode == 200 && response.data is Map) {
        return response.data as Map<String, dynamic>;
      }
      throw ApiException(
          'Failed to delete from alias table', response.statusCode, ApiErrorType.unknown);
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (e) {
      throw ApiException(
          'Failed to delete from alias table: ${e.toString()}', null, ApiErrorType.unknown);
    }
  }

  /// Flush alias table
  Future<Map<String, dynamic>> flushAliasTable(String aliasName) async {
    ensureInitialized();

    try {
      final response =
          await dio.post('/firewall/alias_util/flush/$aliasName');

      if (response.statusCode == 200 && response.data is Map) {
        return response.data as Map<String, dynamic>;
      }
      throw ApiException('Failed to flush alias table', response.statusCode, ApiErrorType.unknown);
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (e) {
      throw ApiException('Failed to flush alias table: ${e.toString()}', null, ApiErrorType.unknown);
    }
  }

  /// Find references to an alias
  Future<Map<String, dynamic>> findAliasReferences(String aliasName) async {
    ensureInitialized();

    try {
      final response = await dio.post(
        '/firewall/alias_util/find_references',
        data: {'alias': aliasName},
      );

      if (response.statusCode == 200 && response.data is Map) {
        return response.data as Map<String, dynamic>;
      }
      throw ApiException(
          'Failed to find alias references', response.statusCode, ApiErrorType.unknown);
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (e) {
      throw ApiException(
          'Failed to find alias references: ${e.toString()}', null, ApiErrorType.unknown);
    }
  }

  /// Update bogons
  Future<Map<String, dynamic>> updateBogons() async {
    ensureInitialized();

    try {
      final response = await dio.get('/firewall/alias_util/update_bogons');

      if (response.statusCode == 200 && response.data is Map) {
        return response.data as Map<String, dynamic>;
      }
      throw ApiException('Failed to update bogons', response.statusCode, ApiErrorType.unknown);
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (e) {
      throw ApiException('Failed to update bogons: ${e.toString()}', null, ApiErrorType.unknown);
    }
  }
}


