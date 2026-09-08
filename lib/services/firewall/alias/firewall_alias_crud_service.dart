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
  /// Get all firewall aliases via the search_item endpoint.
  ///
  /// This endpoint returns flat, pre-parsed rows — all fields are already
  /// plain strings with no selection-map nesting. The `%type` field contains
  /// the human-readable type label, while `type` is the internal key.
  Future<List<FirewallAlias>> getFirewallAliases() async {
    ensureInitialized();

    try {
      final response = await dio.post(
        '/firewall/alias/search_item',
        data: {'current': 1, 'rowCount': -1, 'searchPhrase': ''},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data['rows'] is List) {
          return (data['rows'] as List)
              .whereType<Map<String, dynamic>>()
              .map<FirewallAlias>(_parseAliasFromRow)
              .toList();
        }
        return [];
      } else {
        throw ApiException(
          'Failed to get firewall aliases: ${response.statusMessage}',
          response.statusCode,
          ApiErrorType.unknown,
        );
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (e) {
      throw ApiException(
          'Failed to get firewall aliases: ${e.toString()}', null, ApiErrorType.unknown);
    }
  }

  /// Get a specific firewall alias by UUID
  Future<FirewallAlias> getFirewallAlias(String uuid) async {
    ensureInitialized();

    try {
      final response = await dio.get('/firewall/alias/get_item/$uuid');

      if (response.statusCode == 200) {
        final data = response.data;

        if (data is Map && data['alias'] != null) {
          final aliasData = data['alias'] as Map<String, dynamic>;

          // type — single-select map: return the selected key
          final type = extractSelectedValue(aliasData['type']);

          // content — multi-select picker of ALL aliases; the ones belonging
          // to THIS alias have selected == 1. Skip the empty-string sentinel.
          final content = _extractMultiSelected(aliasData['content']);

          // proto — multi-select map: collect all selected keys, joined by comma
          final proto = _extractMultiSelectedJoined(aliasData['proto'], ',');

          // interface — single-select map; '' key means "None"
          final interface_ = extractSelectedValue(aliasData['interface']);

          // categories — multi-select map {"uuid": {"value": "name", "selected": 0|1}}
          // or empty array []. Collect selected UUIDs and display labels separately.
          final categoriesRaw = aliasData['categories'];
          String categories = '';
          String categoryLabels = '';
          if (categoriesRaw is Map<String, dynamic>) {
            final selectedEntries = categoriesRaw.entries.where(
              (e) => e.key.isNotEmpty && e.value is Map && e.value['selected'] == 1,
            ).toList();
            categories = selectedEntries.map((e) => e.key).join(',');
            categoryLabels = selectedEntries
                .map((e) => (e.value as Map)['value']?.toString() ?? e.key)
                .join(', ');
          }

          // authtype — single-select map: return the selected key (e.g. "Basic")
          final authtype = extractSelectedValue(aliasData['authtype']);

          return FirewallAlias(
            uuid: uuid,
            name: aliasData['name']?.toString() ?? uuid,
            type: type,
            content: content,
            description: aliasData['description']?.toString() ?? '',
            enabled: aliasData['enabled']?.toString() ?? '1',
            counters: aliasData['counters']?.toString() ?? '0',
            proto: proto,
            interface: interface_,
            categories: categories,
            categoryLabels: categoryLabels,
            currentItems: aliasData['current_items']?.toString() ?? '0',
            updatefreq: aliasData['updatefreq']?.toString() ?? '',
            pathExpression: aliasData['path_expression']?.toString() ?? '',
            authtype: authtype,
            username: aliasData['username']?.toString() ?? '',
            password: aliasData['password']?.toString() ?? '',
            expire: aliasData['expire']?.toString() ?? '',
          );
        }

        throw ApiException('Invalid alias data received', response.statusCode, ApiErrorType.unknown);
      } else {
        throw ApiException(
          'Failed to get firewall alias: ${response.statusMessage}',
          response.statusCode,
          ApiErrorType.unknown,
        );
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (e) {
      throw ApiException('Failed to get firewall alias: ${e.toString()}', null, ApiErrorType.unknown);
    }
  }

  /// Get alias UUID by name
  Future<String?> getAliasUuidByName(String name) async {
    ensureInitialized();

    try {
      final response =
          await dio.get('/firewall/alias/get_alias_uuid/$name');

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
      throw ApiException('Failed to get alias UUID: ${e.toString()}', null, ApiErrorType.unknown);
    }
  }

  /// Create a new firewall alias.
  ///
  /// Throws [ApiException] if the API returns `result != "saved"`, including
  /// a human-readable summary of any `validations` returned by the server.
  Future<Map<String, dynamic>> createFirewallAlias(
      FirewallAliasRequest request) async {
    ensureInitialized();

    try {
      final response = await dio.post(
        '/firewall/alias/add_item',
        data: {'alias': request.toJson()},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map) {
          final result = data['result']?.toString() ?? '';
          if (result == 'saved') {
            await _applyChanges();
            return data as Map<String, dynamic>;
          }
          // Surface server-side validation failures as an exception so the
          // ViewModel's executeWithLoading marks the save as failed.
          throw ApiException(
            _buildValidationMessage(data, 'Failed to create alias'),
            response.statusCode,
            ApiErrorType.unknown,
          );
        }
        throw ApiException('Invalid response format', response.statusCode, ApiErrorType.unknown);
      } else {
        throw ApiException(
          'Failed to create firewall alias: ${response.statusMessage}',
          response.statusCode,
          ApiErrorType.unknown,
        );
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
          'Failed to create firewall alias: ${e.toString()}', null, ApiErrorType.unknown);
    }
  }

  /// Update an existing firewall alias.
  ///
  /// Throws [ApiException] if the API returns `result != "saved"`, including
  /// a human-readable summary of any `validations` returned by the server.
  Future<Map<String, dynamic>> updateFirewallAlias(
    String uuid,
    FirewallAliasRequest request,
  ) async {
    ensureInitialized();

    try {
      final response = await dio.post(
        '/firewall/alias/set_item/$uuid',
        data: {'alias': request.toJson()},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map) {
          final result = data['result']?.toString() ?? '';
          if (result == 'saved') {
            await _applyChanges();
            return data as Map<String, dynamic>;
          }
          throw ApiException(
            _buildValidationMessage(data, 'Failed to update alias'),
            response.statusCode,
            ApiErrorType.unknown,
          );
        }
        throw ApiException('Invalid response format', response.statusCode, ApiErrorType.unknown);
      } else {
        throw ApiException(
          'Failed to update firewall alias: ${response.statusMessage}',
          response.statusCode,
          ApiErrorType.unknown,
        );
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
          'Failed to update firewall alias: ${e.toString()}', null, ApiErrorType.unknown);
    }
  }

  /// Toggle firewall alias enabled/disabled state
  Future<void> toggleFirewallAlias(String uuid) async {
    ensureInitialized();

    try {
      final response = await dio.post('/firewall/alias/toggle_item/$uuid');

      if (response.statusCode == 200) {
        await _applyChanges();
      } else {
        throw ApiException(
          'Failed to toggle firewall alias: ${response.statusMessage}',
          response.statusCode,
          ApiErrorType.unknown,
        );
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Get default alias item structure (option lists for type, proto, interface, authtype)
  Future<Map<String, dynamic>> getAliasItemDefaults() async {
    ensureInitialized();

    try {
      final response = await dio.get('/firewall/alias/get_item/');

      if (response.statusCode == 200 && response.data is Map) {
        return response.data as Map<String, dynamic>;
      }
      throw ApiException(
          'Failed to get alias item defaults', response.statusCode, ApiErrorType.unknown);
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (e) {
      throw ApiException(
          'Failed to get alias item defaults: ${e.toString()}', null, ApiErrorType.unknown);
    }
  }

  /// Delete a firewall alias
  Future<void> deleteFirewallAlias(String uuid) async {
    ensureInitialized();

    try {
      final response = await dio.post('/firewall/alias/del_item/$uuid');

      if (response.statusCode == 200) {
        await _applyChanges();
      } else {
        throw ApiException(
          'Failed to delete firewall alias: ${response.statusMessage}',
          response.statusCode,
          ApiErrorType.unknown,
        );
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Collects all non-empty keys from a multi-select map where selected == 1,
  /// joined by newline. Used for `content` fields.
  String _extractMultiSelected(Object? field) {
    if (field is! Map<String, dynamic>) return '';
    return field.entries
        .where((e) => e.key.isNotEmpty && e.value is Map && e.value['selected'] == 1)
        .map((e) => e.key)
        .join('\n');
  }

  /// Same as [_extractMultiSelected] but with a custom [separator].
  /// Used for `proto` fields where values are joined by comma.
  String _extractMultiSelectedJoined(Object? field, String separator) {
    if (field is! Map<String, dynamic>) return '';
    return field.entries
        .where((e) => e.key.isNotEmpty && e.value is Map && e.value['selected'] == 1)
        .map((e) => e.key)
        .join(separator);
  }

  /// Apply firewall alias changes
  Future<void> _applyChanges() async {
    try {
      await dio.post('/firewall/alias/reconfigure');
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Builds a human-readable error message from an OPNsense API response that
  /// did NOT return `result == "saved"`.
  ///
  /// The `validations` node is a flat or nested map where each key is a field
  /// path (e.g. `"alias.name"`) and the value is an error string. We join them
  /// into a single message. If no validations are present we fall back to the
  /// result string or [fallback].
  String _buildValidationMessage(Map<dynamic, dynamic> data, String fallback) {
    final validations = data['validations'];
    if (validations is Map && validations.isNotEmpty) {
      final messages = validations.entries
          .map((e) {
            final field = e.key.toString().replaceFirst('alias.', '');
            final msg = e.value?.toString() ?? '';
            return msg.isNotEmpty ? '$field: $msg' : field;
          })
          .toList();
      return messages.join('; ');
    }
    final result = data['result']?.toString() ?? '';
    return result.isNotEmpty ? '$fallback ($result)' : fallback;
  }

  /// Parse a flat row from the POST /firewall/alias/search_item response.
  ///
  /// All fields are already plain strings — no selection-map nesting.
  /// `type` is the internal key (e.g. "host", "internal").
  /// `%type` is the human-readable label (unused here; [FirewallAlias.typeDisplayName] derives it).
  FirewallAlias _parseAliasFromRow(Map<String, dynamic> row) {
    // `%categories` is the pre-resolved display label e.g. "test categ"
    final categoryLabels = row['%categories']?.toString() ?? '';
    // `categories_uuid` is a List of UUID strings
    final categoriesUuid = (row['categories_uuid'] is List)
        ? (row['categories_uuid'] as List).map((e) => e.toString()).toList()
        : <String>[];

    return FirewallAlias(
      uuid: row['uuid']?.toString() ?? '',
      name: row['name']?.toString() ?? '',
      type: row['type']?.toString() ?? '',
      content: row['content']?.toString() ?? '',
      description: row['description']?.toString() ?? '',
      enabled: row['enabled']?.toString() ?? '1',
      counters: row['counters']?.toString() ?? '0',
      proto: row['proto']?.toString() ?? '',
      interface: row['interface']?.toString() ?? '',
      categories: row['categories']?.toString() ?? '',
      categoryLabels: categoryLabels,
      categoriesUuid: categoriesUuid,
      currentItems: row['current_items']?.toString() ?? '0',
      updatefreq: row['updatefreq']?.toString() ?? '',
      pathExpression: row['path_expression']?.toString() ?? '',
    );
  }
}


