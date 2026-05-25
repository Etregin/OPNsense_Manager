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
import 'package:flutter/foundation.dart';
import '../../models/wol_host.dart';
import '../base/base_opnsense_service.dart';
import '../base/api_exception.dart';

/// Service for Wake-on-LAN operations
class WolService extends BaseOPNsenseService {
  static const String _searchHostPath = '/wol/wol/search_host';
  static const String _getHostTemplatePath = '/wol/wol/get_host/';
  static const String _addHostPath = '/wol/wol/add_host/';
  static const String _setHostPath = '/wol/wol/set_host/';
  static const String _deleteHostPath = '/wol/wol/del_host/';
  static const String _wakeHostPath = '/wol/wol/set';
  static const String _wakeAllPath = '/wol/wol/wakeall';
  
  // Cache for plugin availability check
  bool? _wolPluginAvailable;
  
  /// Check if the WOL plugin is installed and available
  ///
  /// This method checks if the os-wol plugin is installed by attempting
  /// to call a lightweight WOL endpoint. The result is cached to avoid
  /// repeated API calls.
  ///
  /// Returns `true` if the plugin is available, `false` otherwise.
  Future<bool> isWolPluginAvailable() async {
    // Return cached result if available
    if (_wolPluginAvailable != null) {
      return _wolPluginAvailable!;
    }
    
    ensureInitialized();
    
    try {
      _logRequest('GET', _getHostTemplatePath);
      final response = await dio.get(_getHostTemplatePath);
      
      // If we get a 200 response, the plugin is available
      if (response.statusCode == 200) {
        _wolPluginAvailable = true;
        debugPrint('[WOL] Plugin is available');
        return true;
      }
      
      // Any other status code means plugin is not available
      _wolPluginAvailable = false;
      debugPrint('[WOL] Plugin not available: HTTP ${response.statusCode}');
      return false;
    } on DioException catch (e) {
      // 404 means the plugin is not installed
      if (e.response?.statusCode == 404) {
        _wolPluginAvailable = false;
        debugPrint('[WOL] Plugin not installed (404)');
        return false;
      }
      
      // For other errors, assume plugin is not available
      _wolPluginAvailable = false;
      debugPrint('[WOL] Plugin check failed: ${e.message}');
      return false;
    } catch (e) {
      // On any error, assume plugin is not available
      _wolPluginAvailable = false;
      debugPrint('[WOL] Plugin check error: ${e.toString()}');
      return false;
    }
  }
  
  /// Clear the plugin availability cache
  ///
  /// This should be called when the service is cleared or when
  /// you want to force a re-check of plugin availability.
  void clearPluginCache() {
    _wolPluginAvailable = null;
  }
  
  @override
  void clear() {
    clearPluginCache();
    super.clear();
  }
  /// Get all configured WOL hosts
  Future<List<WolHost>> getHosts() async {
    ensureInitialized();
    
    try {
      _logRequest('POST', _searchHostPath);
      final response = await dio.post(_searchHostPath);
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data is Map<String, dynamic>) {
          final wolResponse = WolHostResponse.fromJson(data);
          return wolResponse.rows;
        } else {
          throw ApiException('Invalid response format', response.statusCode);
        }
      } else {
        throw ApiException(
          'Failed to get WOL hosts: HTTP ${response.statusCode}',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to get WOL hosts: ${e.toString()}', null);
    }
  }

  /// Get available interface options for WOL configuration
  Future<Map<String, WolInterfaceOption>> getInterfaceOptions() async {
    ensureInitialized();
    
    try {
      _logRequest('GET', _getHostTemplatePath);
      final response = await dio.get(_getHostTemplatePath);
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data is Map<String, dynamic> && data.containsKey('host')) {
          final hostData = data['host'] as Map<String, dynamic>;
          
          if (hostData.containsKey('interface')) {
            final interfaceData = hostData['interface'] as Map<String, dynamic>;
            final Map<String, WolInterfaceOption> options = {};
            
            interfaceData.forEach((key, value) {
              if (value is Map<String, dynamic>) {
                options[key] = WolInterfaceOption.fromJson(value);
              }
            });
            
            return options;
          }
        }
        
        throw ApiException('Invalid response format', response.statusCode);
      } else {
        throw ApiException(
          'Failed to get interface options: HTTP ${response.statusCode}',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to get interface options: ${e.toString()}', null);
    }
  }

  /// Add a new WOL host
  Future<String> addHost(String interface, String mac, String description) async {
    ensureInitialized();
    
    try {
      final request = WolHostRequest(
        interface: interface,
        mac: mac,
        descr: description,
      );
      
      final payload = {
        'host': request.toJson(),
      };
      _logRequest('POST', _addHostPath, payload: payload);
      final response = await dio.post(
        _addHostPath,
        data: payload,
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data is Map<String, dynamic>) {
          final operationResponse = WolHostOperationResponse.fromJson(data);
          
          if (operationResponse.isSuccess) {
            return operationResponse.uuid ?? '';
          } else {
            throw ApiException(
              'Failed to add host: ${operationResponse.result}',
              response.statusCode,
            );
          }
        } else {
          throw ApiException('Invalid response format', response.statusCode);
        }
      } else {
        throw ApiException(
          'Failed to add WOL host: HTTP ${response.statusCode}',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to add WOL host: ${e.toString()}', null);
    }
  }

  /// Update an existing WOL host
  Future<void> updateHost(String uuid, String interface, String mac, String description) async {
    ensureInitialized();
    
    try {
      final request = WolHostRequest(
        interface: interface,
        mac: mac,
        descr: description,
      );
      
      final payload = {
        'host': request.toJson(),
      };
      final path = '$_setHostPath$uuid';
      _logRequest('POST', path, payload: payload);
      final response = await dio.post(
        path,
        data: payload,
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data is Map<String, dynamic>) {
          final operationResponse = WolHostOperationResponse.fromJson(data);
          
          if (!operationResponse.isSuccess) {
            throw ApiException(
              'Failed to update host: ${operationResponse.result}',
              response.statusCode,
            );
          }
        } else {
          throw ApiException('Invalid response format', response.statusCode);
        }
      } else {
        throw ApiException(
          'Failed to update WOL host: HTTP ${response.statusCode}',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to update WOL host: ${e.toString()}', null);
    }
  }

  /// Delete a WOL host
  Future<void> deleteHost(String uuid) async {
    ensureInitialized();
    
    try {
      final path = '$_deleteHostPath$uuid';
      final payload = <String, dynamic>{};
      _logRequest('POST', path, payload: payload);
      
      // Send empty JSON object as payload
      final response = await dio.post(
        path,
        data: payload,
      );
      
      // The endpoint returns HTTP 200 with an empty response body on success
      if (response.statusCode == 200) {
        debugPrint('[WOL] Host deleted successfully: $uuid');
        return; // Success - no need to parse response
      } else {
        throw ApiException(
          'Failed to delete WOL host: HTTP ${response.statusCode}',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to delete WOL host: ${e.toString()}', null);
    }
  }

  /// Wake a host by sending a magic packet
  Future<void> wakeHost(String uuid) async {
    ensureInitialized();
    
    try {
      // Prepare form-encoded data
      final formData = 'uuid=$uuid';
      
      _logRequest('POST', _wakeHostPath, payload: {'uuid': uuid});
      
      // Send POST request with form-encoded data
      final response = await dio.post(
        _wakeHostPath,
        data: formData,
        options: Options(
          contentType: 'application/x-www-form-urlencoded',
        ),
      );
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data is Map<String, dynamic>) {
          final status = data['status'] as String?;
          
          if (status != 'OK') {
            throw ApiException(
              'Failed to wake host: status=$status',
              response.statusCode,
            );
          }
        } else {
          throw ApiException('Invalid response format', response.statusCode);
        }
      } else {
        throw ApiException(
          'Failed to wake host: HTTP ${response.statusCode}',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to wake host: ${e.toString()}', null);
    }
  }

  /// Wake all configured hosts
  Future<List<WolWakeAllResult>> wakeAllHosts() async {
    ensureInitialized();
    
    try {
      _logRequest('POST', _wakeAllPath);
      
      final response = await dio.post(_wakeAllPath);
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data is Map<String, dynamic>) {
          final wakeAllResponse = WolWakeAllResponse.fromJson(data);
          debugPrint('[WOL] Wake All completed: ${wakeAllResponse.results.length} hosts');
          return wakeAllResponse.results;
        } else {
          throw ApiException('Invalid response format', response.statusCode);
        }
      } else {
        throw ApiException(
          'Failed to wake all hosts: HTTP ${response.statusCode}',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to wake all hosts: ${e.toString()}', null);
    }
  }

  /// Copy a WOL host configuration for duplication
  ///
  /// Fetches the host data with fetchmode=copy query parameter
  /// Returns the host data that can be used to create a new host
  Future<Map<String, dynamic>> copyHost(String uuid) async {
    ensureInitialized();
    
    try {
      final path = '$_getHostTemplatePath$uuid?fetchmode=copy';
      _logRequest('GET', path);
      final response = await dio.get(path);
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data is Map<String, dynamic> && data.containsKey('host')) {
          debugPrint('[WOL] Host copied successfully: $uuid');
          return data['host'] as Map<String, dynamic>;
        } else {
          throw ApiException('Invalid response format', response.statusCode);
        }
      } else {
        throw ApiException(
          'Failed to copy WOL host: HTTP ${response.statusCode}',
          response.statusCode,
        );
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException('Failed to copy WOL host: ${e.toString()}', null);
    }
  }

  void _logRequest(String method, String path, {Map<String, dynamic>? payload}) {
    final baseUrl = dio.options.baseUrl;
    final normalizedBaseUrl = baseUrl.endsWith('/')
        ? baseUrl.substring(0, baseUrl.length - 1)
        : baseUrl;
    final fullUrl = '$normalizedBaseUrl$path';
    debugPrint('[WOL] $method $fullUrl');
    if (payload != null) {
      debugPrint('[WOL] payload: $payload');
    }
  }
}


