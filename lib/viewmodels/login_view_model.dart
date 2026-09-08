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

import 'package:uuid/uuid.dart';
import '../models/opnsense_config.dart';
import '../models/profile.dart';
import '../models/connection_endpoint.dart';
import '../models/dhcp_server_type.dart';
import '../services/profile_service.dart';
import '../services/demo_api_service.dart';
import '../services/opnsense_api_service.dart';
import '../services/connection/connection_manager_service.dart';
import 'base/base_form_view_model.dart';

/// ViewModel for login/profile management screen
class LoginViewModel extends BaseFormViewModel {
  final ProfileService _profileService;
  final DemoApiService _demoApiService;
  final OPNsenseApiService _opnsenseApiService;
  final Profile? _existingProfile;

  String? _statusMessage;

  bool get isEditing => _existingProfile != null;
  Profile? get existingProfile => _existingProfile;

  /// Informational status message (progress updates, success confirmations).
  /// Distinct from [errorMessage] which is reserved for genuine error conditions.
  String? get statusMessage => _statusMessage;

  void setStatus(String? message) {
    _statusMessage = message;
    notifyListeners();
  }

  LoginViewModel({
    required this._profileService,
    required this._demoApiService,
    required this._opnsenseApiService,
    this._existingProfile,
  });

  /// Test all connections without saving
  Future<Map<String, dynamic>> testAllConnections({
    required List<ConnectionEndpoint> connections,
    required String apiKey,
    required String apiSecret,
    required bool useHttps,
    required bool allowSelfSignedCerts,
  }) async {
    final result = await executeWithLoading(() async {
      // Validate that we have at least one connection
      if (connections.isEmpty) {
        setError('No connection endpoints configured');
        return {'success': false, 'results': <Map<String, dynamic>>[]};
      }

      // Create connection manager service
      final connectionManager = ConnectionManagerService();

      // Sort connections by priority
      final sortedConnections = connectionManager.sortConnectionsByPriority(connections);
      final totalConnections = sortedConnections.length;

      // Create temporary config for testing
      final tempConfig = OPNsenseConfig(
        host: sortedConnections.first.host,
        port: sortedConnections.first.port,
        apiKey: apiKey,
        apiSecret: apiSecret,
        useHttps: useHttps,
        allowSelfSignedCerts: allowSelfSignedCerts,
      );

      // Test each connection and collect results
      final results = <Map<String, dynamic>>[];
      int successCount = 0;

      for (int i = 0; i < sortedConnections.length; i++) {
        final connection = sortedConnections[i];
        final currentAttempt = i + 1;
        
        // Show progress message
        setStatus('Testing connection $currentAttempt/$totalConnections: ${connection.displayName}');
        
        // Update config for this specific connection
        final testConfig = tempConfig.copyWith(
          host: connection.host,
          port: connection.port,
        );
        
        final testResult = await connectionManager.testConnectionDetailed(
          connection,
          testConfig,
        );
        final isWorking = testResult.isSuccess;
        
        results.add({
          'endpoint': connection.displayName,
          'host': connection.host,
          'port': connection.port,
          'success': isWorking,
          'errorType': testResult.errorType,
          'errorMessage': testResult.errorMessage,
          'statusCode': testResult.statusCode,
          'summary': testResult.summary,
        });

        if (isWorking) {
          successCount++;
        }
      }

      // Clear progress status
      setStatus(null);

      return {
        'success': successCount > 0,
        'results': results,
        'successCount': successCount,
        'totalCount': totalConnections,
      };
    });
    
    return result ?? {'success': false, 'results': <Map<String, dynamic>>[]};
  }

  /// Save profile without testing connection
  Future<bool> saveProfile({
    required String name,
    required List<ConnectionEndpoint> connections,
    required String apiKey,
    required String apiSecret,
    required bool useHttps,
    required bool allowSelfSignedCerts,
    required DhcpServerType dhcpServerType,
  }) async {
    final result = await executeWithLoading(() async {
      // Validate that we have at least one connection
      if (connections.isEmpty) {
        setError('No connection endpoints configured');
        return false;
      }

      // Get the active connection for the default name
      final activeConnection = connections.firstWhere(
        (c) => c.isActive,
        orElse: () => connections.first,
      );

      // Create or update profile
      final profile = _existingProfile != null
          ? _existingProfile.copyWith(
              name: name.isEmpty ? '${activeConnection.host}:${activeConnection.port}' : name,
              connections: connections,
              apiKey: apiKey,
              apiSecret: apiSecret,
              useHttps: useHttps,
              allowSelfSignedCerts: allowSelfSignedCerts,
              dhcpServerType: dhcpServerType,
            )
          : Profile(
              id: const Uuid().v4(),
              name: name.isEmpty ? '${activeConnection.host}:${activeConnection.port}' : name,
              connections: connections,
              apiKey: apiKey,
              apiSecret: apiSecret,
              useHttps: useHttps,
              allowSelfSignedCerts: allowSelfSignedCerts,
              dhcpServerType: dhcpServerType,
              createdAt: DateTime.now(),
              lastUsed: DateTime.now(),
            );

      await _profileService.saveProfile(profile);

      return true;
    });
    
    return result ?? false;
  }

  /// Test connection and save profile
  Future<bool> testAndSaveConnection({
    required String name,
    required List<ConnectionEndpoint> connections,
    required String apiKey,
    required String apiSecret,
    required bool useHttps,
    required bool allowSelfSignedCerts,
    required DhcpServerType dhcpServerType,
  }) async {
    final result = await executeWithLoading(() async {
      // Validate that we have at least one connection
      if (connections.isEmpty) {
        setError('No connection endpoints configured');
        return false;
      }

      // Create connection manager service
      final connectionManager = ConnectionManagerService();

      // Sort connections by priority (active first, then by last successful connection)
      final sortedConnections = connectionManager.sortConnectionsByPriority(connections);
      final totalConnections = sortedConnections.length;

      // Create temporary config for testing connections with dhcpServerType
      final tempConfig = OPNsenseConfig(
        host: sortedConnections.first.host,
        port: sortedConnections.first.port,
        apiKey: apiKey,
        apiSecret: apiSecret,
        useHttps: useHttps,
        allowSelfSignedCerts: allowSelfSignedCerts,
        dhcpServerType: dhcpServerType,
      );

      // Find the best working connection with progress messages
      ConnectionEndpoint? bestConnection;
      
      // Test each connection and provide feedback with progress
      for (int i = 0; i < sortedConnections.length; i++) {
        final connection = sortedConnections[i];
        final currentAttempt = i + 1;
        
        // Show progress message: "Testing connection 1/4: Home Network (192.168.1.1:443)"
        setStatus('Testing connection $currentAttempt/$totalConnections: ${connection.displayName}');
        
        // Update config for this specific connection
        final testConfig = tempConfig.copyWith(
          host: connection.host,
          port: connection.port,
        );
        
        final testResult = await connectionManager.testConnectionDetailed(
          connection,
          testConfig,
        );
        final isWorking = testResult.isSuccess;
        
        if (isWorking) {
          bestConnection = connection.copyWith(
            isActive: true,
            lastSuccessfulConnection: DateTime.now(),
          );
          break;
        }
      }

      // Check if we found a working connection
      if (bestConnection == null) {
        setError('Unable to connect to any configured endpoints. Please check your network settings and try again.');
        return false;
      }

      // Update connections list with the test results
      final updatedConnections = connections.map((conn) {
        if (conn.host == bestConnection!.host && conn.port == bestConnection.port) {
          return bestConnection; // This has updated timestamp and active status
        }
        return conn.copyWith(isActive: false);
      }).toList();

      // Create config with the best connection for final verification (include dhcpServerType)
      final config = OPNsenseConfig(
        host: bestConnection.host,
        port: bestConnection.port,
        apiKey: apiKey,
        apiSecret: apiSecret,
        useHttps: useHttps,
        allowSelfSignedCerts: allowSelfSignedCerts,
        dhcpServerType: dhcpServerType,
      );

      // Initialize API service with the best connection
      _demoApiService.setDemoMode(false);
      _opnsenseApiService.init(config);

      // Perform final connection test
      setStatus('Verifying connection to ${bestConnection.displayName}...');
      final isConnected = await _demoApiService.testConnection();

      if (!isConnected) {
        setError('Connection verification failed for ${bestConnection.displayName}');
        setStatus(null);
        return false;
      }

      // Create or update profile with updated connections
      final profile = _existingProfile != null
          ? _existingProfile.copyWith(
              name: name.isEmpty ? '${bestConnection.host}:${bestConnection.port}' : name,
              connections: updatedConnections,
              apiKey: apiKey,
              apiSecret: apiSecret,
              useHttps: useHttps,
              allowSelfSignedCerts: allowSelfSignedCerts,
              dhcpServerType: dhcpServerType,
              lastUsed: DateTime.now(),
            )
          : Profile(
              id: const Uuid().v4(),
              name: name.isEmpty ? '${bestConnection.host}:${bestConnection.port}' : name,
              connections: updatedConnections,
              apiKey: apiKey,
              apiSecret: apiSecret,
              useHttps: useHttps,
              allowSelfSignedCerts: allowSelfSignedCerts,
              dhcpServerType: dhcpServerType,
              createdAt: DateTime.now(),
              lastUsed: DateTime.now(),
            );

      await _profileService.saveProfile(profile);
      await _profileService.setActiveProfile(profile.id);

      setStatus(null);

      return true;
    });
    
    return result ?? false;
  }
}


