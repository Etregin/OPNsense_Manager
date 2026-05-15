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

/// Service for firewall alias CRUD operations
class FirewallAliasCrudService extends BaseOPNsenseService {
  /// Get all firewall aliases
  Future<List<FirewallAlias>> getFirewallAliases() async {
    ensureInitialized();

    try {
      final response = await dio.get('/firewall/alias/get');

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map &&
            data['alias'] != null &&
            data['alias']['aliases'] != null &&
            data['alias']['aliases']['alias'] != null) {
          final aliasesMap =
              data['alias']['aliases']['alias'] as Map<String, dynamic>;
          final List<FirewallAlias> aliases = [];

          aliasesMap.forEach((aliasName, aliasData) {
            if (aliasData is Map<String, dynamic>) {
              aliases.add(_parseAliasFromMap(aliasName, aliasData));
            }
          });

          return aliases;
        }

        return [];
      } else {
        throw ApiException(
          'Failed to get firewall aliases: ${response.statusMessage}',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (e) {
      throw ApiException(
          'Failed to get firewall aliases: ${e.toString()}', null);
    }
  }

  /// Get a specific firewall alias by UUID
  Future<FirewallAlias> getFirewallAlias(String uuid) async {
    ensureInitialized();

    try {
      final response = await dio.get('/firewall/alias/getItem/$uuid');

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map && data['alias'] != null) {
          final aliasData = data['alias'] as Map<String, dynamic>;
          return FirewallAlias(
            uuid: uuid,
            name: extractSelectedValue(aliasData['name']) as String? ?? '',
            type: extractSelectedValue(aliasData['type']) as String? ?? '',
            content:
                extractSelectedValue(aliasData['content']) as String? ?? '',
            description:
                extractSelectedValue(aliasData['description']) as String? ?? '',
            enabled:
                extractSelectedValue(aliasData['enabled']) as String? ?? '1',
            counters:
                extractSelectedValue(aliasData['counters']) as String? ?? '0',
            proto: extractSelectedValue(aliasData['proto']) as String? ?? '',
            interface:
                extractSelectedValue(aliasData['interface']) as String? ?? '',
            categories:
                extractSelectedValue(aliasData['categories']) as String? ?? '',
          );
        }

        throw ApiException('Invalid alias data received', response.statusCode);
      } else {
        throw ApiException(
          'Failed to get firewall alias: ${response.statusMessage}',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (e) {
      throw ApiException('Failed to get firewall alias: ${e.toString()}', null);
    }
  }

  /// Get alias UUID by name
  Future<String?> getAliasUuidByName(String name) async {
    ensureInitialized();

    try {
      final response =
          await dio.get('/api/firewall/alias/get_alias_uuid/$name');

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data['uuid'] != null) {
          return data['uuid'] as String;
        }
        return null;
      }
      return null;
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (e) {
      throw ApiException('Failed to get alias UUID: ${e.toString()}', null);
    }
  }

  /// Create a new firewall alias
  Future<Map<String, dynamic>> createFirewallAlias(
      FirewallAliasRequest request) async {
    ensureInitialized();

    try {
      final response = await dio.post(
        '/firewall/alias/addItem',
        data: {'alias': request.toJson()},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map) {
          if (data['result'] == 'saved') {
            await _applyChanges();
          }
          return data as Map<String, dynamic>;
        }
        throw ApiException('Invalid response format', response.statusCode);
      } else {
        throw ApiException(
          'Failed to create firewall alias: ${response.statusMessage}',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (e) {
      throw ApiException(
          'Failed to create firewall alias: ${e.toString()}', null);
    }
  }

  /// Update an existing firewall alias
  Future<Map<String, dynamic>> updateFirewallAlias(
    String uuid,
    FirewallAliasRequest request,
  ) async {
    ensureInitialized();

    try {
      final response = await dio.post(
        '/firewall/alias/setItem/$uuid',
        data: {'alias': request.toJson()},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map) {
          if (data['result'] == 'saved') {
            await _applyChanges();
          }
          return data as Map<String, dynamic>;
        }
        throw ApiException('Invalid response format', response.statusCode);
      } else {
        throw ApiException(
          'Failed to update firewall alias: ${response.statusMessage}',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (e) {
      throw ApiException(
          'Failed to update firewall alias: ${e.toString()}', null);
    }
  }

  /// Toggle firewall alias enabled/disabled state
  Future<void> toggleFirewallAlias(String uuid) async {
    ensureInitialized();

    try {
      final response = await dio.post('/firewall/alias/toggleItem/$uuid');

      if (response.statusCode == 200) {
        await _applyChanges();
      } else {
        throw ApiException(
          'Failed to toggle firewall alias: ${response.statusMessage}',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Delete a firewall alias
  Future<void> deleteFirewallAlias(String uuid) async {
    ensureInitialized();

    try {
      final response = await dio.post('/firewall/alias/delItem/$uuid');

      if (response.statusCode == 200) {
        await _applyChanges();
      } else {
        throw ApiException(
          'Failed to delete firewall alias: ${response.statusMessage}',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Apply firewall alias changes
  Future<void> _applyChanges() async {
    try {
      await dio.post('/firewall/alias/reconfigure');
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Parse alias from map data
  FirewallAlias _parseAliasFromMap(
      String aliasName, Map<String, dynamic> aliasData) {
    // Extract type
    String aliasType = '';
    if (aliasData['type'] is Map) {
      final typeMap = aliasData['type'] as Map<String, dynamic>;
      typeMap.forEach((key, value) {
        if (value is Map && value['selected'] == 1) {
          aliasType = key;
        }
      });
    }

    // Extract content
    String content = '';
    if (aliasData['content'] != null) {
      content = aliasData['content'].toString();
    } else if (aliasData['current_items'] != null) {
      if (aliasData['current_items'] is List) {
        content = (aliasData['current_items'] as List).join(',');
      } else {
        content = aliasData['current_items'].toString();
      }
    }

    return FirewallAlias(
      uuid: aliasName,
      name: aliasName,
      type: aliasType,
      content: content,
      description: aliasData['description']?.toString() ?? '',
      enabled: aliasData['enabled']?.toString() ?? '1',
      counters: aliasData['counters']?.toString() ?? '0',
      proto: aliasData['proto']?.toString() ?? '',
      interface: aliasData['interface']?.toString() ?? '',
      categories: aliasData['categories']?.toString() ?? '',
    );
  }
}

// Made with Bob
