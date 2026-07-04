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

import 'dart:convert';
import 'package:dio/dio.dart';
import '../base/base_opnsense_service.dart';
import '../base/api_exception.dart';
import '../../models/openvpn_instance.dart';
import '../../models/openvpn_search_response.dart';
import '../../models/openvpn_client_override.dart';
import '../../models/openvpn_client_override_search_response.dart';
import '../../models/openvpn_static_key.dart';
import '../../models/openvpn_session_search_response.dart';
import '../../models/openvpn_route_search_response.dart';
import '../../models/openvpn_log_search_response.dart';
import '../../constants/api_endpoints.dart';

/// Service for OpenVPN operations
///
/// This service handles all OpenVPN instance and static key management
/// operations through the OPNsense API.
class OpenvpnService extends BaseOPNsenseService {
  // Instance Management Methods

  /// Search/list OpenVPN instances with pagination support
  ///
  /// Endpoint: POST /api/openvpn/instances/search/
  /// Payload: {"current": 1, "rowCount": 50, "sort": {}}
  ///
  /// Parameters:
  /// - [current]: Current page number (default: 1)
  /// - [rowCount]: Number of rows per page (default: 50)
  /// - [sort]: Sort configuration (default: {})
  ///
  /// Returns: [OpenvpnSearchResponse] with paginated instance list
  Future<OpenvpnSearchResponse> searchInstances({
    int current = 1,
    int rowCount = 50,
    Map<String, dynamic>? sort,
    String? searchPhrase,
    String? enabled,
  }) async {
    ensureInitialized();

    try {
      final data = {
        'current': current,
        'rowCount': rowCount,
        'sort': sort ?? {},
      };

      // Add optional search/filter parameters if provided
      if (searchPhrase != null && searchPhrase.isNotEmpty) {
        data['searchPhrase'] = searchPhrase;
      }
      if (enabled != null && enabled.isNotEmpty) {
        data['enabled'] = enabled;
      }

      final response = await dio.post(
        ApiEndpoints.openvpnInstancesSearch,
        data: data,
      );

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        
        return OpenvpnSearchResponse.fromJson(responseData);
      } else {
        throw ApiException('Failed to search OpenVPN instances', response.statusCode, ApiErrorType.unknown);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Get OpenVPN instance details for add/edit
  ///
  /// Endpoint: GET /api/openvpn/instances/get/ (for new)
  ///           GET /api/openvpn/instances/get/{vpnid} (for edit)
  ///
  /// Parameters:
  /// - [vpnid]: Instance ID (null for new instance)
  ///
  /// Returns: [OpenvpnInstance] with form data structure
  Future<OpenvpnInstance> getInstance(String? vpnid) async {
    ensureInitialized();

    try {
      final endpoint = vpnid != null
          ? ApiEndpoints.openvpnInstanceGet(vpnid)
          : ApiEndpoints.openvpnInstancesGetNew;

      final response = await dio.get(endpoint);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        
        if (data.containsKey('instance')) {
          final instanceData = data['instance'];
          
          // Ensure instanceData is a Map before casting
          if (instanceData is! Map<String, dynamic>) {
            throw ApiException('Instance data is not a Map<String, dynamic>, got: ${instanceData.runtimeType}', response.statusCode, ApiErrorType.unknown);
          }
          
          final instance = OpenvpnInstance.fromJson(instanceData);
          return instance;
        }
        throw ApiException('Instance data not found in response', response.statusCode, ApiErrorType.unknown);
      } else {
        throw ApiException('Failed to get OpenVPN instance', response.statusCode, ApiErrorType.unknown);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Create a new OpenVPN instance
  ///
  /// Endpoint: POST /api/openvpn/instances/add/
  /// Payload: {"instance": {...}}
  ///
  /// Parameters:
  /// - [instance]: Instance configuration
  ///
  /// Returns: API response map (may contain validation errors)
  Future<Map<String, dynamic>> addInstance(OpenvpnInstance instance) async {
    ensureInitialized();

    try {
      final payload = {'instance': instance.toJson()};
      
      final response = await dio.post(
        ApiEndpoints.openvpnInstancesAdd,
        data: payload,
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;

        // Check for validation errors
        if (data.containsKey('result') && data['result'] == 'failed') {
          final validations = data['validations'] as Map<String, dynamic>?;
          final message = data['message'];

          if (validations != null && validations.isNotEmpty) {
            final errors = validations.entries
                .map((e) => '${e.key}: ${e.value}')
                .join(', ');
            throw ApiException('Validation failed: $errors', response.statusCode, ApiErrorType.unknown);
          }

          throw ApiException(
            'Failed to add instance: ${message ?? 'Unknown error'}',
            response.statusCode,
          ApiErrorType.unknown,
          );
        }

        return data;
      } else {
        throw ApiException('Failed to add OpenVPN instance', response.statusCode, ApiErrorType.unknown);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Update an existing OpenVPN instance
  ///
  /// Endpoint: POST /api/openvpn/instances/set/{vpnid}
  /// Payload: {"instance": {...}}
  ///
  /// Parameters:
  /// - [vpnid]: Instance ID
  /// - [instance]: Updated instance configuration
  ///
  /// Returns: API response map (may contain validation errors)
  Future<Map<String, dynamic>> updateInstance(
    String vpnid,
    OpenvpnInstance instance,
  ) async {
    ensureInitialized();

    try {
      final payload = {'instance': instance.toJson()};
      
      final response = await dio.post(
        ApiEndpoints.openvpnInstanceSet(vpnid),
        data: payload,
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;

        // Check for validation errors
        if (data.containsKey('result') && data['result'] == 'failed') {
          final validations = data['validations'] as Map<String, dynamic>?;
          final message = data['message'];

          if (validations != null && validations.isNotEmpty) {
            final errors = validations.entries
                .map((e) => '${e.key}: ${e.value}')
                .join(', ');
            throw ApiException('Validation failed: $errors', response.statusCode, ApiErrorType.unknown);
          }

          throw ApiException(
            'Failed to update instance: ${message ?? 'Unknown error'}',
            response.statusCode,
          ApiErrorType.unknown,
          );
        }

        return data;
      } else {
        throw ApiException('Failed to update OpenVPN instance', response.statusCode, ApiErrorType.unknown);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Delete an OpenVPN instance
  ///
  /// Endpoint: POST /api/openvpn/instances/del/{vpnid}
  ///
  /// Parameters:
  /// - [vpnid]: Instance ID to delete
  ///
  /// Returns: API response map
  Future<Map<String, dynamic>> deleteInstance(String vpnid) async {
    ensureInitialized();

    try {
      final response = await dio.post(
        ApiEndpoints.openvpnInstanceDelete(vpnid),
        data: {}, // Empty payload as required by API
      );

      if (response.statusCode == 200) {
        final result = response.data as Map<String, dynamic>;
        return result;
      } else {
        throw ApiException('Failed to delete OpenVPN instance', response.statusCode, ApiErrorType.unknown);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Toggle OpenVPN instance enabled/disabled state
  ///
  /// Endpoint: POST /api/openvpn/instances/toggle/{vpnid}
  ///
  /// Parameters:
  /// - [vpnid]: Instance ID to toggle
  ///
  /// Returns: API response map
  Future<Map<String, dynamic>> toggleInstance(String vpnid) async {
    ensureInitialized();

    try {
      final response = await dio.post(
        ApiEndpoints.openvpnInstanceToggle(vpnid),
        data: {},
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ApiException('Failed to toggle OpenVPN instance', response.statusCode, ApiErrorType.unknown);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }

  }

  /// Reconfigure OpenVPN service (apply pending configuration changes)
  /// Endpoint: POST /openvpn/service/reconfigure
  Future<Map<String, dynamic>> reconfigureOpenvpn() async {
    ensureInitialized();

    try {
      final response = await dio.post(
        ApiEndpoints.openvpnServiceReconfigure,
        data: {},
      );
      
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        
        // Check for explicit failure in response
        if (data.containsKey('status') && data['status'] == 'failed') {
          final message = data['message'] ?? 'Unknown error';
          throw ApiException('Failed to reconfigure OpenVPN: $message', response.statusCode, ApiErrorType.unknown);
        }
        
        return data;
      } else {
        throw ApiException('Failed to reconfigure OpenVPN', response.statusCode, ApiErrorType.unknown);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Generate an auth token secret
  ///
  /// Endpoint: GET /api/openvpn/instances/gen_key/auth-token
  ///
  /// Returns: Generated key string
  Future<String> generateAuthToken() async {
    ensureInitialized();

    try {
      final response = await dio.get(ApiEndpoints.openvpnAuthTokenGenerate);

      if (response.statusCode == 200) {
        final data = response.data;

        // Handle different response formats
        if (data is Map<String, dynamic>) {
          if (data.containsKey('key')) {
            return data['key'] as String;
          }
          if (data.containsKey('token')) {
            return data['token'] as String;
          }
          throw ApiException('Key not found in response', response.statusCode, ApiErrorType.unknown);
        }

        if (data is String) {
          return data;
        }

        throw ApiException('Invalid response format', response.statusCode, ApiErrorType.unknown);
      } else {
        throw ApiException('Failed to generate auth token', response.statusCode, ApiErrorType.unknown);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Search OpenVPN core logs with pagination and filters.
  ///
  /// Endpoint: POST /api/diagnostics/log/core/openvpn
  Future<OpenvpnLogSearchResponse> searchLogs({
    int current = 1,
    int rowCount = 50,
    Map<String, dynamic>? sort,
    List<String>? severity,
    double? validFrom,
  }) async {
    ensureInitialized();

    try {
      final data = <String, dynamic>{
        'current': current,
        'rowCount': rowCount,
        'sort': sort ?? <String, dynamic>{},
      };

      if (severity != null && severity.isNotEmpty) {
        data['severity'] = severity;
      }

      if (validFrom != null) {
        data['validFrom'] = validFrom;
      }

      final response = await dio.post(
        ApiEndpoints.diagnosticsLogOpenvpn,
        data: data,
      );

      if (response.statusCode == 200) {
        return OpenvpnLogSearchResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw ApiException('Failed to search OpenVPN logs', response.statusCode, ApiErrorType.unknown);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  // Static Key Management Methods

  /// Search/list static keys with pagination support
  ///
  /// Endpoint: POST /api/openvpn/instances/search_static_key/
  /// Payload: {"current": 1, "rowCount": 50, "sort": {}}
  ///
  /// Parameters:
  /// - [current]: Current page number (default: 1)
  /// - [rowCount]: Number of rows per page (default: 50)
  /// - [sort]: Sort configuration (default: {})
  ///
  /// Returns: [OpenvpnStaticKeySearchResponse] with paginated key list
  Future<OpenvpnStaticKeySearchResponse> searchStaticKeys({
    int current = 1,
    int rowCount = 50,
    Map<String, dynamic>? sort,
  }) async {
    ensureInitialized();

    try {
      final response = await dio.post(
        ApiEndpoints.openvpnStaticKeySearch,
        data: {
          'current': current,
          'rowCount': rowCount,
          'sort': sort ?? {},
        },
      );

      if (response.statusCode == 200) {
        return OpenvpnStaticKeySearchResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw ApiException('Failed to search static keys', response.statusCode, ApiErrorType.unknown);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Get static key details for add/edit
  ///
  /// Endpoint: GET /api/openvpn/instances/get_static_key/ (for new)
  ///           GET /api/openvpn/instances/get_static_key/{keyid} (for edit)
  ///
  /// Parameters:
  /// - [keyid]: Key ID (null for new key)
  ///
  /// Returns: [OpenvpnStaticKey] with form data structure
  Future<OpenvpnStaticKey> getStaticKey(String? keyid) async {
    ensureInitialized();

    try {
      final endpoint = keyid != null
          ? ApiEndpoints.openvpnStaticKeyGet(keyid)
          : ApiEndpoints.openvpnStaticKeyGetNew;

      final response = await dio.get(endpoint);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('statickey')) {
          return OpenvpnStaticKey.fromJson(data['statickey'] as Map<String, dynamic>);
        }
        throw ApiException('Static key data not found in response', response.statusCode, ApiErrorType.unknown);
      } else {
        throw ApiException('Failed to get static key', response.statusCode, ApiErrorType.unknown);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Generate a static key
  ///
  /// Endpoint: GET /api/openvpn/instances/gen_key/{mode}
  ///
  /// Parameters:
  /// - [mode]: Key generation mode (tls-auth, tls-crypt, tls-crypt-v2-server)
  ///
  /// Returns: Generated key string
  Future<String> generateStaticKey(String mode) async {
    ensureInitialized();

    try {
      final response = await dio.get(ApiEndpoints.openvpnStaticKeyGenerate(mode));

      if (response.statusCode == 200) {
        final data = response.data;

        // Handle different response formats
        if (data is Map<String, dynamic>) {
          if (data.containsKey('key')) {
            return data['key'] as String;
          }
          throw ApiException('Key not found in response', response.statusCode, ApiErrorType.unknown);
        }

        if (data is String) {
          return data;
        }

        throw ApiException('Invalid response format', response.statusCode, ApiErrorType.unknown);
      } else {
        throw ApiException('Failed to generate static key', response.statusCode, ApiErrorType.unknown);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Add a new static key
  ///
  /// Endpoint: POST /api/openvpn/instances/add_static_key/
  /// Payload: {"statickey": {...}}
  ///
  /// Parameters:
  /// - [key]: Static key configuration
  ///
  /// Returns: API response map (may contain validation errors)
  Future<Map<String, dynamic>> addStaticKey(OpenvpnStaticKey key) async {
    ensureInitialized();

    try {
      final response = await dio.post(
        ApiEndpoints.openvpnStaticKeyAdd,
        data: {'statickey': key.toJson()},
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;

        // Check for validation errors
        if (data.containsKey('result') && data['result'] == 'failed') {
          final validations = data['validations'] as Map<String, dynamic>?;
          final message = data['message'];

          if (validations != null && validations.isNotEmpty) {
            final errors = validations.entries
                .map((e) => '${e.key}: ${e.value}')
                .join(', ');
            throw ApiException('Validation failed: $errors', response.statusCode, ApiErrorType.unknown);
          }

          throw ApiException(
            'Failed to add static key: ${message ?? 'Unknown error'}',
            response.statusCode,
          ApiErrorType.unknown,
          );
        }

        return data;
      } else {
        throw ApiException('Failed to add static key', response.statusCode, ApiErrorType.unknown);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Update an existing static key
  ///
  /// Endpoint: POST /api/openvpn/instances/set_static_key/{keyid}
  /// Payload: {"statickey": {...}}
  ///
  /// Parameters:
  /// - [keyid]: Key ID
  /// - [key]: Updated key configuration
  ///
  /// Returns: API response map (may contain validation errors)
  Future<Map<String, dynamic>> updateStaticKey(
    String keyid,
    OpenvpnStaticKey key,
  ) async {
    ensureInitialized();

    try {
      final response = await dio.post(
        ApiEndpoints.openvpnStaticKeySet(keyid),
        data: {'statickey': key.toJson()},
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;

        // Check for validation errors
        if (data.containsKey('result') && data['result'] == 'failed') {
          final validations = data['validations'] as Map<String, dynamic>?;
          final message = data['message'];

          if (validations != null && validations.isNotEmpty) {
            final errors = validations.entries
                .map((e) => '${e.key}: ${e.value}')
                .join(', ');
            throw ApiException('Validation failed: $errors', response.statusCode, ApiErrorType.unknown);
          }

          throw ApiException(
            'Failed to update static key: ${message ?? 'Unknown error'}',
            response.statusCode,
          ApiErrorType.unknown,
          );
        }

        return data;
      } else {
        throw ApiException('Failed to update static key', response.statusCode, ApiErrorType.unknown);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Delete a static key
  ///
  /// Endpoint: POST /api/openvpn/instances/del_static_key/{keyid}
  ///
  /// Parameters:
  /// - [keyid]: Key ID to delete
  ///
  /// Returns: API response map
  Future<Map<String, dynamic>> deleteStaticKey(String keyid) async {
    ensureInitialized();

    try {
      final response = await dio.post(ApiEndpoints.openvpnStaticKeyDelete(keyid));

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ApiException('Failed to delete static key', response.statusCode, ApiErrorType.unknown);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  // Client Specific Override Management Methods

  /// Search/list OpenVPN client specific overrides with pagination support
  ///
  /// Endpoint: POST /api/openvpn/client_overwrites/search/
  /// Payload: {"current": 1, "rowCount": 50, "sort": {}}
  ///
  /// Parameters:
  /// - [current]: Current page number (default: 1)
  /// - [rowCount]: Number of rows per page (default: 50)
  /// - [sort]: Sort configuration (default: {})
  /// - [searchPhrase]: Search phrase to filter results (optional)
  ///
  /// Returns: [OpenvpnSearchResponse] with paginated client override list
  Future<OpenvpnClientOverrideSearchResponse> searchClientOverrides({
    int current = 1,
    int rowCount = 50,
    Map<String, dynamic>? sort,
    String? searchPhrase,
  }) async {
    ensureInitialized();

    try {
      final data = {
        'current': current,
        'rowCount': rowCount,
        'sort': sort ?? {},
      };
      
      // Add searchPhrase only if provided
      if (searchPhrase != null && searchPhrase.isNotEmpty) {
        data['searchPhrase'] = searchPhrase;
      }

      final response = await dio.post(
        ApiEndpoints.openvpnClientOverridesSearch,
        data: data,
      );

      if (response.statusCode == 200) {
        final responseData = response.data as Map<String, dynamic>;
        
        return OpenvpnClientOverrideSearchResponse.fromJson(responseData);
      } else {
        throw ApiException('Failed to search client overrides', response.statusCode, ApiErrorType.unknown);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Get client specific override details for add/edit
  ///
  /// Endpoint: GET /api/openvpn/client_overwrites/get/ (for new)
  ///           GET /api/openvpn/client_overwrites/get/{uuid} (for edit)
  ///
  /// Parameters:
  /// - [uuid]: Override UUID (null or empty string for new override)
  ///
  /// Returns: [OpenvpnClientOverride] with form data structure
  Future<OpenvpnClientOverride> getClientOverride(String? uuid) async {
    ensureInitialized();

    try {
      final endpoint = (uuid != null && uuid.isNotEmpty)
          ? ApiEndpoints.openvpnClientOverrideGet(uuid)
          : ApiEndpoints.openvpnClientOverrideGetNew;

      final response = await dio.get(endpoint);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        
        if (data.containsKey('cso')) {
          final csoData = data['cso'];
          
          // Ensure csoData is a Map before casting
          if (csoData is! Map<String, dynamic>) {
            throw ApiException('CSO data is not a Map<String, dynamic>, got: ${csoData.runtimeType}', response.statusCode, ApiErrorType.unknown);
          }
          
          final override = OpenvpnClientOverride.fromJson(csoData);
          return override;
        }
        throw ApiException('CSO data not found in response', response.statusCode, ApiErrorType.unknown);
      } else {
        throw ApiException('Failed to get client override', response.statusCode, ApiErrorType.unknown);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Create or update a client specific override
  ///
  /// Endpoint: POST /api/openvpn/client_overwrites/add/ (for new)
  ///           POST /api/openvpn/client_overwrites/set/{uuid} (for update)
  /// Payload: {"cso": {...}}
  ///
  /// Parameters:
  /// - [uuid]: Override UUID (null or empty string for new override)
  /// - [override]: Client override configuration
  ///
  /// Returns: API response map (may contain validation errors)
  Future<Map<String, dynamic>> setClientOverride(
    String? uuid,
    OpenvpnClientOverride override,
  ) async {
    ensureInitialized();

    try {
      final payload = {'cso': override.toJson()};
      
      // Convert to JSON string manually to preserve string types
      // This prevents Dio from converting "1" and "0" strings to integers
      final jsonString = jsonEncode(payload);

      // Determine endpoint based on whether this is add or update
      final String endpoint;
      if (uuid == null || uuid.isEmpty) {
        // New override - use add endpoint
        endpoint = ApiEndpoints.openvpnClientOverrideAdd;
      } else {
        // Existing override - use set endpoint with UUID
        endpoint = ApiEndpoints.openvpnClientOverrideSet(uuid);
      }
      
      final response = await dio.post(
        endpoint,
        data: jsonString,
        options: Options(
          contentType: Headers.jsonContentType,
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;

        // Check for validation errors
        if (data.containsKey('result') && data['result'] == 'failed') {
          final validations = data['validations'] as Map<String, dynamic>?;
          final message = data['message'];

          if (validations != null && validations.isNotEmpty) {
            final errors = validations.entries
                .map((e) => '${e.key}: ${e.value}')
                .join(', ');
            throw ApiException('Validation failed: $errors', response.statusCode, ApiErrorType.unknown);
          }

          throw ApiException(
            'Failed to set client override: ${message ?? 'Unknown error'}',
            response.statusCode,
          ApiErrorType.unknown,
          );
        }

        return data;
      } else {
        throw ApiException('Failed to set client override', response.statusCode, ApiErrorType.unknown);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Delete a client specific override
  ///
  /// Endpoint: POST /api/openvpn/client_overwrites/del/{uuid}
  ///
  /// Parameters:
  /// - [uuid]: Override UUID to delete
  ///
  /// Returns: API response map
  Future<Map<String, dynamic>> deleteClientOverride(String uuid) async {
    ensureInitialized();

    try {
      final response = await dio.post(
        ApiEndpoints.openvpnClientOverrideDelete(uuid),
        data: {}, // Empty payload as required by API
      );

      if (response.statusCode == 200) {
        final result = response.data as Map<String, dynamic>;
        return result;
      } else {
        throw ApiException('Failed to delete client override', response.statusCode, ApiErrorType.unknown);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Toggle client specific override enabled/disabled state
  ///
  /// Endpoint: POST /api/openvpn/client_overwrites/toggle/{uuid}
  ///
  /// Parameters:
  /// - [uuid]: Override UUID to toggle
  ///
  /// Returns: API response map
  Future<Map<String, dynamic>> toggleClientOverride(String uuid) async {
    ensureInitialized();

    try {
      final response = await dio.post(
        ApiEndpoints.openvpnClientOverrideToggle(uuid),
        data: {},
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ApiException('Failed to toggle client override', response.statusCode, ApiErrorType.unknown);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  // Connection Status Management Methods

  /// Search/list OpenVPN sessions with pagination support
  ///
  /// Endpoint: POST /api/openvpn/service/search_sessions
  /// Payload: {"current": 1, "rowCount": 50, "sort": {}}
  ///
  /// Parameters:
  /// - [current]: Current page number (default: 1)
  /// - [rowCount]: Number of rows per page (default: 50)
  /// - [sort]: Sort configuration (default: {})
  ///
  /// Returns: [OpenvpnSessionSearchResponse] with paginated session list
  Future<OpenvpnSessionSearchResponse> searchSessions({
    int current = 1,
    int rowCount = 50,
    Map<String, dynamic>? sort,
  }) async {
    ensureInitialized();

    try {
      final response = await dio.post(
        ApiEndpoints.openvpnInstancesSearchSessions,
        data: {
          'current': current,
          'rowCount': rowCount,
          'sort': sort ?? {},
        },
      );

      if (response.statusCode == 200) {
        return OpenvpnSessionSearchResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw ApiException('Failed to search OpenVPN sessions', response.statusCode, ApiErrorType.unknown);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Start an OpenVPN service
  ///
  /// Endpoint: POST /api/openvpn/service/start_service/{id}
  /// Payload: {}
  ///
  /// Parameters:
  /// - [id]: Service ID to start
  ///
  /// Returns: API response map with result status
  Future<Map<String, dynamic>> startService(String id) async {
    ensureInitialized();

    try {
      final response = await dio.post(
        ApiEndpoints.openvpnServiceStart(id),
        data: {},
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        
        // Check for explicit failure in response
        if (data.containsKey('result') && data['result'] != 'ok') {
          final message = data['message'] ?? 'Unknown error';
          throw ApiException('Failed to start service: $message', response.statusCode, ApiErrorType.unknown);
        }
        
        return data;
      } else {
        throw ApiException('Failed to start OpenVPN service', response.statusCode, ApiErrorType.unknown);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Stop an OpenVPN service
  ///
  /// Endpoint: POST /api/openvpn/service/stop_service/{id}
  /// Payload: {}
  ///
  /// Parameters:
  /// - [id]: Service ID to stop
  ///
  /// Returns: API response map with result status
  Future<Map<String, dynamic>> stopService(String id) async {
    ensureInitialized();

    try {
      final response = await dio.post(
        ApiEndpoints.openvpnServiceStop(id),
        data: {},
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        
        // Check for explicit failure in response
        if (data.containsKey('result') && data['result'] != 'ok') {
          final message = data['message'] ?? 'Unknown error';
          throw ApiException('Failed to stop service: $message', response.statusCode, ApiErrorType.unknown);
        }
        
        return data;
      } else {
        throw ApiException('Failed to stop OpenVPN service', response.statusCode, ApiErrorType.unknown);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Restart an OpenVPN service
  ///
  /// Endpoint: POST /api/openvpn/service/restart_service/{id}
  /// Payload: {}
  ///
  /// Parameters:
  /// - [id]: Service ID to restart
  ///
  /// Returns: API response map with result status
  Future<Map<String, dynamic>> restartService(String id) async {
    ensureInitialized();

    try {
      final response = await dio.post(
        ApiEndpoints.openvpnServiceRestart2(id),
        data: {},
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        
        // Check for explicit failure in response
        if (data.containsKey('result') && data['result'] != 'ok') {
          final message = data['message'] ?? 'Unknown error';
          throw ApiException('Failed to restart service: $message', response.statusCode, ApiErrorType.unknown);
        }
        
        return data;
      } else {
        throw ApiException('Failed to restart OpenVPN service', response.statusCode, ApiErrorType.unknown);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Search/list OpenVPN routes with pagination support
  ///
  /// Endpoint: POST /api/openvpn/service/search_routes
  /// Payload: {"current": 1, "rowCount": 50, "sort": {}}
  ///
  /// Parameters:
  /// - [current]: Current page number (default: 1)
  /// - [rowCount]: Number of rows per page (default: 50)
  /// - [sort]: Sort configuration (default: {})
  ///
  /// Returns: [OpenvpnRouteSearchResponse] with paginated route list
  Future<OpenvpnRouteSearchResponse> searchRoutes({
    int current = 1,
    int rowCount = 50,
    Map<String, dynamic>? sort,
  }) async {
    ensureInitialized();

    try {
      final response = await dio.post(
        ApiEndpoints.openvpnInstancesSearchRoutes,
        data: {
          'current': current,
          'sort': sort ?? {},
          'rowCount': rowCount,
        },
      );

      if (response.statusCode == 200) {
        return OpenvpnRouteSearchResponse.fromJson(
          response.data as Map<String, dynamic>,
        );
      } else {
        throw ApiException('Failed to search OpenVPN routes', response.statusCode, ApiErrorType.unknown);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }
}
