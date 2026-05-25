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
import '../base/base_opnsense_service.dart';
import '../base/api_exception.dart';
import '../../models/tailscale_settings.dart';

/// Service for Tailscale VPN operations
class TailscaleService extends BaseOPNsenseService {
  // Cache for plugin availability check
  bool? _tailscalePluginAvailable;
  
  /// Check if the Tailscale plugin is installed and available
  ///
  /// This method checks if the os-tailscale plugin is installed by attempting
  /// to call a lightweight Tailscale endpoint. The result is cached to avoid
  /// repeated API calls.
  ///
  /// Returns `true` if the plugin is available, `false` otherwise.
  Future<bool> isTailscalePluginAvailable() async {
    // Return cached result if available
    if (_tailscalePluginAvailable != null) {
      return _tailscalePluginAvailable!;
    }
    
    ensureInitialized();
    
    try {
      debugPrint('[Tailscale] Checking plugin availability...');
      final response = await dio.get('/tailscale/service/status');
      
      // If we get a 200 response, the plugin is available
      if (response.statusCode == 200) {
        _tailscalePluginAvailable = true;
        debugPrint('[Tailscale] Plugin is available');
        return true;
      }
      
      // Any other status code means plugin is not available
      _tailscalePluginAvailable = false;
      debugPrint('[Tailscale] Plugin not available: HTTP ${response.statusCode}');
      return false;
    } on DioException catch (e) {
      // 404 means the plugin is not installed
      if (e.response?.statusCode == 404) {
        _tailscalePluginAvailable = false;
        debugPrint('[Tailscale] Plugin not installed (404)');
        return false;
      }
      
      // For other errors, assume plugin is not available
      _tailscalePluginAvailable = false;
      debugPrint('[Tailscale] Plugin check failed: ${e.message}');
      return false;
    } catch (e) {
      // On any error, assume plugin is not available
      _tailscalePluginAvailable = false;
      debugPrint('[Tailscale] Plugin check error: ${e.toString()}');
      return false;
    }
  }
  
  /// Clear the plugin availability cache
  ///
  /// This should be called when the service is cleared or when
  /// you want to force a re-check of plugin availability.
  void clearPluginCache() {
    _tailscalePluginAvailable = null;
  }
  
  @override
  void clear() {
    clearPluginCache();
    super.clear();
  }
  
  /// Control Tailscale service (start, stop, restart)
  Future<bool> controlTailscaleService(String action) async {
    ensureInitialized();

    try {
      // Map action to Tailscale API service control endpoint
      final endpoint = action == 'start'
          ? '/tailscale/service/start'
          : action == 'stop'
              ? '/tailscale/service/stop'
              : '/tailscale/service/restart';

      final response = await dio.post(endpoint);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>?;
        final result = data?['response']?.toString() ?? '';
        
        // Handle success
        if (result == 'OK') {
          return true;
        }
        
        // Handle error responses (e.g., "Error (1)" when service is already in desired state)
        if (result.contains('Error')) {
          // Service might already be in the desired state
          // Return false to indicate no change was made
          return false;
        }
        
        return false;
      }
      return false;
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Update Tailscale settings
  Future<bool> updateTailscaleSettings(Map<String, dynamic> settings) async {
    ensureInitialized();

    try {
      // Map settings to OPNsense Tailscale API format
      final opnsenseSettings = <String, dynamic>{};
      
      // Map accept_routes to acceptSubnetRoutes
      if (settings.containsKey('accept_routes')) {
        opnsenseSettings['acceptSubnetRoutes'] = settings['accept_routes'] == true ? '1' : '0';
      }
      
      // Map exit_node to useExitNode
      if (settings.containsKey('exit_node')) {
        final exitNode = settings['exit_node'];
        if (exitNode != null && exitNode.toString().isNotEmpty) {
          opnsenseSettings['useExitNode'] = '1';
          opnsenseSettings['exitNode'] = exitNode.toString();
        } else {
          opnsenseSettings['useExitNode'] = '0';
          opnsenseSettings['exitNode'] = '';
        }
      }
      
      // Map dns_enabled to acceptDNS
      if (settings.containsKey('dns_enabled')) {
        opnsenseSettings['acceptDNS'] = settings['dns_enabled'] == true ? '1' : '0';
      }
      
      // Map ssh_enabled to enableSSH
      if (settings.containsKey('ssh_enabled')) {
        opnsenseSettings['enableSSH'] = settings['ssh_enabled'] == true ? '1' : '0';
      }
      
      // Note: advertise_routes (subnets) requires separate subnet management API calls
      // For now, we skip this field as it needs add_subnet/del_subnet/set_subnet endpoints
      
      final response = await dio.post(
        '/api/tailscale/settings/set',
        data: {'tailscale': opnsenseSettings},
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>?;
        return data?['result'] == 'saved';
      }
      return false;
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Get Tailscale authentication URL
  /// Get Tailscale authentication settings
  /// Returns a map with 'loginServer' and 'preAuthKey' fields
  Future<Map<String, String?>> getTailscaleAuthentication() async {
    ensureInitialized();

    try {
      final url = '/tailscale/authentication/get';
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>?;
        final auth = data?['authentication'] as Map<String, dynamic>?;
        
        return {
          'loginServer': auth?['loginServer'] as String?,
          'preAuthKey': auth?['preAuthKey'] as String?,
        };
      }
      return {'loginServer': null, 'preAuthKey': null};
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Set Tailscale authentication settings
  /// Saves the login server and pre-authentication key
  Future<bool> setTailscaleAuthentication(String loginServer, String preAuthKey) async {
    ensureInitialized();

    try {
      final url = '/tailscale/authentication/set';
      final response = await dio.post(
        url,
        data: {
          'authentication': {
            'loginServer': loginServer,
            'preAuthKey': preAuthKey,
          },
        },
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>?;
        return data?['result'] == 'saved';
      }
      return false;
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Logout from Tailscale
  /// Note: This functionality is not supported by the OPNsense Tailscale API.
  /// The API does not provide a logout endpoint. To logout, you would need to
  /// stop the service and manually remove authentication on the Tailscale admin console.
  Future<bool> logoutTailscale() async {
    ensureInitialized();

    try {
      // The OPNsense Tailscale API does not provide a logout endpoint
      // As a workaround, we could stop the service, but that's not a true logout
      // Return false to indicate this operation is not supported
      return false;
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  // ==================== Tailscale Settings Management ====================

  /// Get Tailscale settings
  /// Retrieves the current Tailscale configuration settings
  Future<TailscaleSettingsResponse> getTailscaleSettings() async {
    ensureInitialized();

    try {
      final response = await dio.get('/tailscale/settings/get');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return TailscaleSettingsResponse.fromJson(data);
      }
      throw ApiException('Failed to get Tailscale settings', response.statusCode);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Set Tailscale settings
  /// Updates the Tailscale configuration with the provided settings
  Future<Map<String, dynamic>> setTailscaleSettings(TailscaleSettings settings) async {
    ensureInitialized();

    try {
      final response = await dio.post(
        '/tailscale/settings/set',
        data: {'settings': settings.toJson()},
      );

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      throw ApiException('Failed to set Tailscale settings', response.statusCode);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Search Tailscale subnets
  /// Returns a paginated list of configured subnets
  Future<TailscaleSubnetSearchResponse> searchTailscaleSubnets() async {
    ensureInitialized();

    try {
      final response = await dio.get('/tailscale/settings/search_subnet');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return TailscaleSubnetSearchResponse.fromJson(data);
      }
      throw ApiException('Failed to search Tailscale subnets', response.statusCode);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Get a specific Tailscale subnet by UUID
  /// Returns the subnet configuration for the given UUID
  Future<TailscaleSubnetResponse> getTailscaleSubnet(String uuid) async {
    ensureInitialized();

    try {
      final response = await dio.get('/tailscale/settings/get_subnet/$uuid');

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return TailscaleSubnetResponse.fromJson(data);
      }
      throw ApiException('Failed to get Tailscale subnet', response.statusCode);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Add a new Tailscale subnet
  /// Creates a new subnet configuration
  Future<Map<String, dynamic>> addTailscaleSubnet(TailscaleSubnet subnet) async {
    ensureInitialized();

    try {
      // Convert subnet to JSON and remove uuid field (not needed for add operation)
      final subnetData = subnet.toJson();
      subnetData.remove('uuid');
      
      final response = await dio.post(
        '/tailscale/settings/add_subnet',
        data: {'subnet4': subnetData},
      );
      
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      throw ApiException('Failed to add Tailscale subnet', response.statusCode);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Update an existing Tailscale subnet
  /// Modifies the subnet configuration for the given UUID
  Future<Map<String, dynamic>> setTailscaleSubnet(String uuid, TailscaleSubnet subnet) async {
    ensureInitialized();

    try {
      // Convert subnet to JSON and remove uuid field (UUID is in the URL path)
      final subnetData = subnet.toJson();
      subnetData.remove('uuid');
      
      final response = await dio.post(
        '/tailscale/settings/set_subnet/$uuid',
        data: {'subnet4': subnetData},
      );
      
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      throw ApiException('Failed to update Tailscale subnet', response.statusCode);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Delete a Tailscale subnet
  /// Removes the subnet configuration for the given UUID
  Future<Map<String, dynamic>> deleteTailscaleSubnet(String uuid) async {
    ensureInitialized();

    try {
      final response = await dio.post(
        '/tailscale/settings/del_subnet/$uuid',
      );
      
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      throw ApiException('Failed to delete Tailscale subnet', response.statusCode);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Reload Tailscale settings
  /// Applies the current configuration and restarts the service if needed
  Future<Map<String, dynamic>> reloadTailscaleSettings() async {
    ensureInitialized();

    try {
      final response = await dio.get('/tailscale/settings/reload');

      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      }
      throw ApiException('Failed to reload Tailscale settings', response.statusCode);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }
}


