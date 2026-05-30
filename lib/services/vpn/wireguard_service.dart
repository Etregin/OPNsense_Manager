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
import '../base/base_opnsense_service.dart';
import '../base/api_exception.dart';
import '../../models/wireguard_server.dart';
import '../../models/wireguard_peer.dart';
import '../../models/wireguard_key_pair.dart';
import '../../models/wireguard_client_builder.dart';
import '../../models/wireguard_status.dart';

/// Service for WireGuard VPN operations
class WireGuardService extends BaseOPNsenseService {
  // Severity level constants for log filtering
  // Maps UI severity levels to API severity arrays (cumulative)
  static const Map<String, List<String>> severityLevels = {
    'Emergency': ['Emergency'],
    'Alert': ['Emergency', 'Alert'],
    'Critical': ['Emergency', 'Alert', 'Critical'],
    'Error': ['Emergency', 'Alert', 'Critical', 'Error'],
    'Warning': ['Emergency', 'Alert', 'Critical', 'Error', 'Warning'],
    'Notice': ['Emergency', 'Alert', 'Critical', 'Error', 'Warning', 'Notice'],
    'Informational': ['Emergency', 'Alert', 'Critical', 'Error', 'Warning', 'Notice', 'Informational'],
    'Debug': ['Emergency', 'Alert', 'Critical', 'Error', 'Warning', 'Notice', 'Informational', 'Debug'],
  };

  // Time filter constants (in seconds)
  static const int lastDaySeconds = 86400;      // 24 hours
  static const int lastWeekSeconds = 604800;    // 7 days
  static const int lastMonthSeconds = 2592000;  // 30 days

  Future<List<WireGuardServer>> getWireGuardServers() async {
    ensureInitialized();

    try {
      final response = await dio.get('/wireguard/server/search_server');
      
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('rows') && data['rows'] is List) {
          final rows = data['rows'] as List;
          return rows.map((row) => WireGuardServer.fromJson(row as Map<String, dynamic>)).toList();
        }
        return [];
      } else {
        throw ApiException('Failed to get WireGuard servers', response.statusCode);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Get a specific WireGuard server by UUID
  /// Endpoint: GET /wireguard/server/get_server/$uuid
  /// Returns: Server object in {"server": {...}} format
  Future<WireGuardServer> getWireGuardServer(String uuid) async {
    ensureInitialized();

    try {
      final response = await dio.get('/wireguard/server/get_server/$uuid');
      
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('server')) {
          return WireGuardServer.fromJson(data['server'] as Map<String, dynamic>);
        }
        throw ApiException('Server data not found in response', response.statusCode);
      } else {
        throw ApiException('Failed to get WireGuard server', response.statusCode);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Create a new WireGuard server
  /// Endpoint: POST /wireguard/server/add_server
  /// Requires: Full server object including privkey
  /// Returns: UUID of created server
  Future<String> createWireGuardServer(WireGuardServerRequest request) async {
    ensureInitialized();

    try {
      final response = await dio.post(
        '/wireguard/server/add_server',
        data: {'server': request.toJson()},
      );
      
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('uuid')) {
          return data['uuid'] as String;
        }
        throw ApiException('UUID not found in response', response.statusCode);
      } else {
        throw ApiException('Failed to create WireGuard server', response.statusCode);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Update an existing WireGuard server
  /// Endpoint: POST /wireguard/server/set_server/$uuid
  /// Note: Can also be used for creation, but add_server is more explicit
  Future<void> updateWireGuardServer(String uuid, WireGuardServerRequest request) async {
    ensureInitialized();

    try {
      final response = await dio.post(
        '/wireguard/server/set_server/$uuid',
        data: {'server': request.toJson()},
      );
      
      if (response.statusCode != 200) {
        throw ApiException('Failed to update WireGuard server', response.statusCode);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Delete a WireGuard server
  /// Endpoint: POST /wireguard/server/del_server/$uuid
  Future<void> deleteWireGuardServer(String uuid) async {
    ensureInitialized();

    try {
      final response = await dio.post('/wireguard/server/del_server/$uuid');
      
      if (response.statusCode != 200) {
        throw ApiException('Failed to delete WireGuard server', response.statusCode);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Toggle WireGuard server enabled/disabled state
  /// Endpoint: POST /wireguard/server/toggle_server/$uuid
  Future<void> toggleWireGuardServer(String uuid, bool enabled) async {
    ensureInitialized();

    try {
      final response = await dio.post(
        '/wireguard/server/toggle_server/$uuid',
        data: {'enabled': enabled ? '1' : '0'},
      );
      
      if (response.statusCode != 200) {
        throw ApiException('Failed to toggle WireGuard server', response.statusCode);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  // Peer Management Methods (Legacy Client API)
  // Note: OPNsense WireGuard plugin does not have a separate /wireguard/client/ API.
  // "Peers" are managed under /wireguard/server/ endpoints.
  // These methods are kept for backward compatibility but delegate to peer methods.

  /// Search WireGuard peers with pagination support
  /// Endpoint: POST /api/wireguard/client/search_client
  /// Payload: {current: 1, rowCount: 50, sort: {}}
  /// Returns: Paginated response with rows, rowCount, total, current
  Future<Map<String, dynamic>> searchClients({
    int current = 1,
    int rowCount = 50,
    Map<String, dynamic>? sort,
  }) async {
    ensureInitialized();

    try {
      final response = await dio.post(
        '/wireguard/client/search_client',
        data: {
          'current': current,
          'rowCount': rowCount,
          'sort': sort ?? {},
        },
      );
      
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ApiException('Failed to search WireGuard peers', response.statusCode);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Get all WireGuard peers (delegates to getWireGuardPeers)
  /// Returns: List of peers in {"rows": [...]} format
  Future<List<WireGuardPeer>> getWireGuardPeers() async {
    ensureInitialized();

    try {
      // Use peer endpoint
      final response = await dio.get('/wireguard/server/search_peer');
      
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('rows') && data['rows'] is List) {
          final rows = data['rows'] as List;
          return rows.map((row) => WireGuardPeer.fromJson(row as Map<String, dynamic>)).toList();
        }
        return [];
      } else {
        throw ApiException('Failed to get WireGuard peers', response.statusCode);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Get a specific WireGuard peer by UUID
  /// Endpoint: GET /wireguard/client/get_client/$uuid
  /// Returns: Peer object in {"client": {...}} format with complex nested structure
  /// Note: tunneladdress and servers are Maps with selected=1 for active items
  Future<Map<String, dynamic>> getPeer(String uuid) async {
    ensureInitialized();

    try {
      final response = await dio.get('/wireguard/client/get_client/$uuid');
      
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('client')) {
          return data['client'] as Map<String, dynamic>;
        }
        throw ApiException('Peer data not found in response', response.statusCode);
      } else {
        throw ApiException('Failed to get WireGuard peer', response.statusCode);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Get a specific WireGuard peer by UUID
  /// Returns: Peer object in {"peer": {...}} format
  /// @deprecated Use getPeer() for the new API endpoint
  Future<WireGuardPeer> getWireGuardPeer(String uuid) async {
    ensureInitialized();

    try {
      // Use peer endpoint
      final response = await dio.get('/wireguard/server/get_peer/$uuid');
      
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('peer')) {
          return WireGuardPeer.fromJson(data['peer'] as Map<String, dynamic>);
        }
        throw ApiException('Peer data not found in response', response.statusCode);
      } else {
        throw ApiException('Failed to get WireGuard peer', response.statusCode);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Create a new WireGuard peer
  /// Endpoint: POST /wireguard/client/add_client
  /// Returns: UUID of created peer
  Future<String> createWireGuardPeer(WireGuardPeerRequest request) async {
    ensureInitialized();

    try {
      final peerPayload = request.toJson();

      final response = await dio.post(
        '/wireguard/client/add_client',
        data: {'client': peerPayload},
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;

        if (data.containsKey('result') && data['result'] == 'failed') {
          final validations = data['validations'] as Map<String, dynamic>?;
          final message = data['message'];

          if (validations != null && validations.isNotEmpty) {
            final errors = validations.entries
                .map((e) => '${e.key}: ${e.value}')
                .join(', ');
            throw ApiException('Validation failed: $errors', response.statusCode);
          }

          throw ApiException(
            'Failed to create peer: ${message ?? 'Unknown error'}',
            response.statusCode,
          );
        }

        if (data.containsKey('uuid')) {
          return data['uuid'] as String;
        }

        if (data.containsKey('result') && data['result'] == 'saved') {
          return '';
        }

        throw ApiException('Unexpected response format: ${data.toString()}', response.statusCode);
      } else {
        throw ApiException('Failed to create WireGuard peer', response.statusCode);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Update an existing WireGuard peer
  /// Endpoint: POST /wireguard/client/set_client/$uuid
  Future<void> updateWireGuardPeer(String uuid, WireGuardPeerRequest request) async {
    ensureInitialized();

    try {
      final peerPayload = request.toJson();

      final response = await dio.post(
        '/wireguard/client/set_client/$uuid',
        data: {'client': peerPayload},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map<String, dynamic> &&
            data.containsKey('result') &&
            data['result'] == 'failed') {
          final validations = data['validations'] as Map<String, dynamic>?;
          final message = data['message'];

          if (validations != null && validations.isNotEmpty) {
            final errors = validations.entries
                .map((e) => '${e.key}: ${e.value}')
                .join(', ');
            throw ApiException('Validation failed: $errors', response.statusCode);
          }

          throw ApiException(
            'Failed to update peer: ${message ?? 'Unknown error'}',
            response.statusCode,
          );
        }
        return;
      }

      throw ApiException('Failed to update WireGuard peer', response.statusCode);
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Delete a WireGuard peer
  /// Endpoint: POST /wireguard/client/del_client/$uuid
  Future<void> deleteWireGuardPeer(String uuid) async {
    ensureInitialized();

    try {
      // Use client endpoint
      final response = await dio.post('/wireguard/client/del_client/$uuid');
      
      if (response.statusCode != 200) {
        throw ApiException('Failed to delete WireGuard peer', response.statusCode);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Toggle WireGuard peer enabled/disabled state
  /// Endpoint: POST /wireguard/client/toggle_client/$uuid
  Future<void> toggleWireGuardPeer(String uuid, bool enabled) async {
    ensureInitialized();

    try {
      // Use client endpoint
      final response = await dio.post(
        '/wireguard/client/toggle_client/$uuid',
        data: {'enabled': enabled ? '1' : '0'},
      );
      
      if (response.statusCode != 200) {
        throw ApiException('Failed to toggle WireGuard peer', response.statusCode);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }


  /// Get WireGuard service status
  /// Endpoint: GET /wireguard/service/show
  Future<Map<String, dynamic>> getWireGuardStatus() async {
    ensureInitialized();

    try {
      final response = await dio.get('/wireguard/service/show');
      
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ApiException('Failed to get WireGuard status', response.statusCode);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Start WireGuard service
  /// Endpoint: POST /wireguard/service/start
  Future<Map<String, dynamic>> startWireGuardService() async {
    ensureInitialized();

    try {
      final response = await dio.post('/wireguard/service/start');
      
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ApiException('Failed to start WireGuard service', response.statusCode);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Stop WireGuard service
  /// Endpoint: POST /wireguard/service/stop
  Future<Map<String, dynamic>> stopWireGuardService() async {
    ensureInitialized();

    try {
      final response = await dio.post('/wireguard/service/stop');
      
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ApiException('Failed to stop WireGuard service', response.statusCode);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Restart WireGuard service
  /// Endpoint: POST /wireguard/service/restart
  Future<Map<String, dynamic>> restartWireGuardService() async {
    ensureInitialized();

    try {
      final response = await dio.post('/wireguard/service/restart');
      
      if (response.statusCode == 200) {
        return response.data as Map<String, dynamic>;
      } else {
        throw ApiException('Failed to restart WireGuard service', response.statusCode);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Reconfigure WireGuard (apply changes)
  /// Endpoint: POST /wireguard/service/reconfigure
  /// This applies pending configuration changes to the running WireGuard service
  Future<Map<String, dynamic>> reconfigureWireGuard() async {
    ensureInitialized();

    try {
      final response = await dio.post('/wireguard/service/reconfigure');
      
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        
        // Check for explicit failure in response
        if (data.containsKey('status') && data['status'] == 'failed') {
          final message = data['message'] ?? 'Unknown error';
          throw ApiException('Failed to reconfigure WireGuard: $message', response.statusCode);
        }
        
        return data;
      } else {
        throw ApiException('Failed to reconfigure WireGuard', response.statusCode);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Get WireGuard status with pagination
  /// Endpoint: POST /wireguard/service/show
  /// Payload: {"current":1,"rowCount":50,"sort":{}}
  /// Returns: Paginated status response with interface and peer information
  Future<WireGuardStatusResponse> getStatus() async {
    ensureInitialized();

    try {
      final response = await dio.post(
        '/wireguard/service/show',
        data: {
          'current': 1,
          'rowCount': 50,
          'sort': {},
        },
      );
      
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return WireGuardStatusResponse.fromJson(data);
      } else {
        throw ApiException('Failed to get WireGuard status', response.statusCode);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  // Key Generation Methods

  /// Generate a new WireGuard key pair
  /// Endpoint: GET /wireguard/server/key_pair
  /// Response format: {"privkey": "...", "pubkey": "...", "status": "ok"}
  Future<WireGuardKeyPair> generateWireGuardKeyPair() async {
    ensureInitialized();

    try {
      final response = await dio.get('/wireguard/server/key_pair');
      
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('privkey') && data.containsKey('pubkey')) {
          return WireGuardKeyPair(
            privateKey: data['privkey'] as String,
            publicKey: data['pubkey'] as String,
          );
        }
        throw ApiException('Key pair data not found in response', response.statusCode);
      } else {
        throw ApiException('Failed to generate WireGuard key pair', response.statusCode);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }
  /// Generate a pre-shared key (PSK) for WireGuard peers
  /// Endpoint: GET /wireguard/client/psk
  /// Response format: {"psk": "...", "status": "ok"}
  Future<String> generateWireGuardPSK() async {
    ensureInitialized();

    try {
      final response = await dio.get('/wireguard/client/psk');
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        if (data is Map<String, dynamic>) {
          if (data.containsKey('psk')) {
            return data['psk'] as String;
          }
          
          final errorMsg = 'PSK not found in response. Keys found: ${data.keys.join(", ")}';
          throw ApiException(errorMsg, response.statusCode);
        }
        
        throw ApiException('Invalid response format', response.statusCode);
      } else {
        throw ApiException('Failed to generate WireGuard PSK', response.statusCode);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }


  /// Start a specific WireGuard instance
  /// Endpoint: POST /wireguard/service/start/$uuid
  Future<void> startWireGuardInstance(String uuid) async {
    ensureInitialized();

    try {
      final response = await dio.post('/wireguard/service/start/$uuid');
      
      if (response.statusCode != 200) {
        throw ApiException('Failed to start WireGuard instance', response.statusCode);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Stop a specific WireGuard instance
  /// Endpoint: POST /wireguard/service/stop/$uuid
  Future<void> stopWireGuardInstance(String uuid) async {
    ensureInitialized();

    try {
      final response = await dio.post('/wireguard/service/stop/$uuid');
      
      if (response.statusCode != 200) {
        throw ApiException('Failed to stop WireGuard instance', response.statusCode);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Restart a specific WireGuard instance
  /// Endpoint: POST /wireguard/service/restart/$uuid
  Future<void> restartWireGuardInstance(String uuid) async {
    ensureInitialized();

    try {
      final response = await dio.post('/wireguard/service/restart/$uuid');
      
      if (response.statusCode != 200) {
        throw ApiException('Failed to restart WireGuard instance', response.statusCode);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  // Client Builder Methods

  /// Get client builder configuration data
  /// Endpoint: GET /wireguard/client/get_client_builder
  /// Returns: Builder configuration with available servers and defaults
  Future<WireGuardClientBuilder> getClientBuilder() async {
    ensureInitialized();

    try {
      final response = await dio.get('/wireguard/client/get_client_builder');
      
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('configbuilder')) {
          return WireGuardClientBuilder.fromJson(
            data['configbuilder'] as Map<String, dynamic>,
          );
        }
        throw ApiException('Config builder data not found in response', response.statusCode);
      } else {
        throw ApiException('Failed to get client builder', response.statusCode);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Get server info for client builder
  /// Endpoint: GET /wireguard/client/get_server_info/{uuid}
  /// Returns: Server information including pubkey, endpoint, tunnel address, DNS
  Future<WireGuardServerInfo> getServerInfo(String uuid) async {
    ensureInitialized();

    try {
      final response = await dio.get('/wireguard/client/get_server_info/$uuid');
      
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        return WireGuardServerInfo.fromJson(data);
      } else {
        throw ApiException('Failed to get server info', response.statusCode);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Add a client via the builder
  /// Endpoint: POST /wireguard/client/add_client_builder
  /// Payload: Wrapped under "configbuilder" key per API contract
  /// Returns: Empty string on success (API returns {"result":"saved"})
  Future<void> addClientBuilder(WireGuardClientBuilderRequest request) async {
    ensureInitialized();

    try {
      // Build payload matching exact API contract
      // API contract: enabled, name, pubkey, psk, tunneladdress, keepalive, server, endpoint
      final innerPayload = {
        'enabled': request.enabled,
        'name': request.name,
        'pubkey': request.pubkey,
        'psk': request.psk.isEmpty ? '' : request.psk,
        'tunneladdress': request.tunneladdress,
        'keepalive': request.keepalive.isEmpty ? '' : request.keepalive,
        'server': request.servers, // API expects 'server' (singular), not 'servers'
        'endpoint': request.endpoint.isEmpty ? '' : request.endpoint,
      };

      // Wrap payload under "configbuilder" key as required by API
      final payload = {'configbuilder': innerPayload};

      final response = await dio.post(
        '/wireguard/client/add_client_builder',
        data: payload,
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;

        // Check for explicit failure
        if (data.containsKey('result') && data['result'] == 'failed') {
          final validations = data['validations'] as Map<String, dynamic>?;
          final message = data['message'];

          if (validations != null && validations.isNotEmpty) {
            final errors = validations.entries
                .map((e) => '${e.key}: ${e.value}')
                .join(', ');
            throw ApiException('Validation failed: $errors', response.statusCode);
          }

          throw ApiException(
            'Failed to add client: ${message ?? 'Unknown error'}',
            response.statusCode,
          );
        }

        // Success case: {"result":"saved"} with HTTP 200
        if (data.containsKey('result') && data['result'] == 'saved') {
          return;
        }

        // Legacy UUID response (if API ever returns it)
        if (data.containsKey('uuid')) {
          return;
        }

        throw ApiException('Unexpected response format: ${data.toString()}', response.statusCode);
      } else {
        throw ApiException('Failed to add client via builder', response.statusCode);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Get WireGuard logs with filtering capabilities
  /// Endpoint: POST /api/diagnostics/log/core/wireguard
  ///
  /// Parameters:
  /// - [rowCount]: Number of log entries to retrieve (default: 50)
  /// - [severity]: List of severity levels to include (e.g., ['Emergency', 'Alert'])
  ///               Use severityLevels constant for proper cumulative filtering
  /// - [validFrom]: Optional Unix timestamp to filter logs from a specific time
  ///                Use time filter constants (lastDaySeconds, lastWeekSeconds, lastMonthSeconds)
  ///                or omit for no time limit
  ///
  /// Returns: Map containing:
  /// - rows: List of log entries with timestamp, severity, process_name, line, etc.
  /// - total_rows: Total number of matching log entries
  /// - rowCount: Number of rows in current response
  /// - current: Current page number
  /// - total: Total number of entries
  ///
  /// Example:
  /// ```dart
  /// // Get last 100 logs with Error level and above from last day
  /// final currentTime = DateTime.now().millisecondsSinceEpoch / 1000;
  /// final logs = await getWireGuardLogs(
  ///   rowCount: 100,
  ///   severity: WireGuardService.severityLevels['Error']!,
  ///   validFrom: currentTime - WireGuardService.lastDaySeconds,
  /// );
  /// ```
  Future<Map<String, dynamic>> getWireGuardLogs({
    int rowCount = 50,
    List<String>? severity,
    double? validFrom,
  }) async {
    ensureInitialized();

    try {
      // Build payload according to API specification
      final payload = <String, dynamic>{
        'current': 1,
        'rowCount': rowCount,
        'sort': {},
        'severity': severity ?? severityLevels['Debug']!, // Default to all severity levels
      };

      // Add validFrom only if provided (for time filtering)
      if (validFrom != null) {
        payload['validFrom'] = validFrom;
      }

      final response = await dio.post(
        '/diagnostics/log/core/wireguard',
        data: payload,
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        
        // Validate response structure
        if (!data.containsKey('rows')) {
          throw ApiException('Invalid response: missing rows field', response.statusCode);
        }

        return data;
      } else {
        throw ApiException('Failed to get WireGuard logs', response.statusCode);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Helper method to get severity levels for a given severity name
  /// Returns the cumulative list of severity levels up to and including the specified level
  ///
  /// Example:
  /// ```dart
  /// final errorLevels = getSeverityLevels('Error');
  /// // Returns: ['Emergency', 'Alert', 'Critical', 'Error']
  /// ```
  static List<String> getSeverityLevels(String severityName) {
    return severityLevels[severityName] ?? severityLevels['Debug']!;
  }

  /// Helper method to calculate Unix timestamp for time-based filtering
  ///
  /// Parameters:
  /// - [secondsAgo]: Number of seconds to subtract from current time
  ///
  /// Returns: Unix timestamp (as double) for use with validFrom parameter
  ///
  /// Example:
  /// ```dart
  /// // Get timestamp for last day
  /// final lastDay = getTimestampFromNow(WireGuardService.lastDaySeconds);
  /// ```
  static double getTimestampFromNow(int secondsAgo) {
    final now = DateTime.now().millisecondsSinceEpoch / 1000;
    return now - secondsAgo;
  }
}


