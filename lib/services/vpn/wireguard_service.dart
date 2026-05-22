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
import '../../models/wireguard_server.dart';
import '../../models/wireguard_client.dart';
import '../../models/wireguard_peer.dart';
import '../../models/wireguard_key_pair.dart';

/// Service for WireGuard VPN operations
class WireGuardService extends BaseOPNsenseService {
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

  // Client Management Methods

  /// Get all WireGuard clients
  /// Endpoint: GET /wireguard/client/search_client
  /// Returns: List of clients in {"rows": [...]} format
  Future<List<WireGuardClient>> getWireGuardClients() async {
    ensureInitialized();

    try {
      final response = await dio.get('/wireguard/client/search_client');
      
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('rows') && data['rows'] is List) {
          final rows = data['rows'] as List;
          return rows.map((row) => WireGuardClient.fromJson(row as Map<String, dynamic>)).toList();
        }
        return [];
      } else {
        throw ApiException('Failed to get WireGuard clients', response.statusCode);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Get a specific WireGuard client by UUID
  /// Endpoint: GET /wireguard/client/get_client/$uuid
  /// Returns: Client object in {"client": {...}} format
  Future<WireGuardClient> getWireGuardClient(String uuid) async {
    ensureInitialized();

    try {
      final response = await dio.get('/wireguard/client/get_client/$uuid');
      
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('client')) {
          return WireGuardClient.fromJson(data['client'] as Map<String, dynamic>);
        }
        throw ApiException('Client data not found in response', response.statusCode);
      } else {
        throw ApiException('Failed to get WireGuard client', response.statusCode);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Create a new WireGuard client
  /// Endpoint: POST /wireguard/client/add_client
  /// Requires: Full client object including pubkey
  /// Returns: UUID of created client
  Future<String> createWireGuardClient(WireGuardClientRequest request) async {
    ensureInitialized();

    try {
      final response = await dio.post(
        '/wireguard/client/add_client',
        data: {'client': request.toJson()},
      );
      
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('uuid')) {
          return data['uuid'] as String;
        }
        throw ApiException('UUID not found in response', response.statusCode);
      } else {
        throw ApiException('Failed to create WireGuard client', response.statusCode);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Update an existing WireGuard client
  /// Endpoint: POST /wireguard/client/set_client/$uuid
  /// Note: Can also be used for creation, but add_client is more explicit
  Future<void> updateWireGuardClient(String uuid, WireGuardClientRequest request) async {
    ensureInitialized();

    try {
      final response = await dio.post(
        '/wireguard/client/set_client/$uuid',
        data: {'client': request.toJson()},
      );
      
      if (response.statusCode != 200) {
        throw ApiException('Failed to update WireGuard client', response.statusCode);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Delete a WireGuard client
  /// Endpoint: POST /wireguard/client/del_client/$uuid
  Future<void> deleteWireGuardClient(String uuid) async {
    ensureInitialized();

    try {
      final response = await dio.post('/wireguard/client/del_client/$uuid');
      
      if (response.statusCode != 200) {
        throw ApiException('Failed to delete WireGuard client', response.statusCode);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Toggle WireGuard client enabled/disabled state
  /// Endpoint: POST /wireguard/client/toggle_client/$uuid
  Future<void> toggleWireGuardClient(String uuid, bool enabled) async {
    ensureInitialized();

    try {
      final response = await dio.post(
        '/wireguard/client/toggle_client/$uuid',
        data: {'enabled': enabled ? '1' : '0'},
      );
      
      if (response.statusCode != 200) {
        throw ApiException('Failed to toggle WireGuard client', response.statusCode);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  // Peer Management Methods

  /// Get all WireGuard peers
  /// Endpoint: GET /wireguard/server/search_peer
  /// Returns: List of peers in {"rows": [...]} format
  Future<List<WireGuardPeer>> getWireGuardPeers() async {
    ensureInitialized();

    try {
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
  /// Endpoint: GET /wireguard/server/get_peer/$uuid
  /// Returns: Peer object in {"peer": {...}} format
  Future<WireGuardPeer> getWireGuardPeer(String uuid) async {
    ensureInitialized();

    try {
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
  /// Endpoint: POST /wireguard/server/add_peer
  /// Returns: UUID of created peer
  Future<String> createWireGuardPeer(WireGuardPeerRequest request) async {
    ensureInitialized();

    try {
      final response = await dio.post(
        '/wireguard/server/add_peer',
        data: {'peer': request.toJson()},
      );
      
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        if (data.containsKey('uuid')) {
          return data['uuid'] as String;
        }
        throw ApiException('UUID not found in response', response.statusCode);
      } else {
        throw ApiException('Failed to create WireGuard peer', response.statusCode);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Update an existing WireGuard peer
  /// Endpoint: POST /wireguard/server/set_peer/$uuid
  /// Note: Can also be used for creation, but add_peer is more explicit
  Future<void> updateWireGuardPeer(String uuid, WireGuardPeerRequest request) async {
    ensureInitialized();

    try {
      final response = await dio.post(
        '/wireguard/server/set_peer/$uuid',
        data: {'peer': request.toJson()},
      );
      
      if (response.statusCode != 200) {
        throw ApiException('Failed to update WireGuard peer', response.statusCode);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Delete a WireGuard peer
  /// Endpoint: POST /wireguard/server/del_peer/$uuid
  Future<void> deleteWireGuardPeer(String uuid) async {
    ensureInitialized();

    try {
      final response = await dio.post('/wireguard/server/del_peer/$uuid');
      
      if (response.statusCode != 200) {
        throw ApiException('Failed to delete WireGuard peer', response.statusCode);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  /// Toggle WireGuard peer enabled/disabled state
  /// Endpoint: POST /wireguard/server/toggle_peer/$uuid
  Future<void> toggleWireGuardPeer(String uuid, bool enabled) async {
    ensureInitialized();

    try {
      final response = await dio.post(
        '/wireguard/server/toggle_peer/$uuid',
        data: {'enabled': enabled ? '1' : '0'},
      );
      
      if (response.statusCode != 200) {
        throw ApiException('Failed to toggle WireGuard peer', response.statusCode);
      }
    } on DioException catch (e) {
      throw handleDioError(e);
    }
  }

  // Key Generation and Service Control Methods

  /// Generate a new WireGuard key pair
  /// Endpoint: GET /wireguard/server/key_pair
  /// Note: Follows standard pattern - base URL already includes /api/ prefix
  /// Response format: {"privkey": "...", "pubkey": "...", "status": "ok"}
  Future<WireGuardKeyPair> generateWireGuardKeyPair() async {
    ensureInitialized();

    try {
      debugPrint('WireGuardService: Calling /wireguard/server/key_pair');
      final response = await dio.get('/wireguard/server/key_pair');
      
      debugPrint('WireGuardService: Response status: ${response.statusCode}');
      debugPrint('WireGuardService: Response data type: ${response.data.runtimeType}');
      
      if (response.statusCode == 200) {
        final data = response.data;
        
        // Handle different response formats
        if (data is Map<String, dynamic>) {
          debugPrint('WireGuardService: Response keys: ${data.keys.join(", ")}');
          
          // Check if keys are at root level
          if (data.containsKey('pubkey') && data.containsKey('privkey')) {
            debugPrint('WireGuardService: Found keys at root level');
            return WireGuardKeyPair.fromJson(data);
          }
          // Check if keys are wrapped in a 'keypair' or similar object
          if (data.containsKey('keypair')) {
            debugPrint('WireGuardService: Found keys in keypair object');
            return WireGuardKeyPair.fromJson(data['keypair'] as Map<String, dynamic>);
          }
          // Check if keys are wrapped in a 'data' object
          if (data.containsKey('data')) {
            debugPrint('WireGuardService: Found keys in data object');
            return WireGuardKeyPair.fromJson(data['data'] as Map<String, dynamic>);
          }
          // If we have the data but can't find the keys, throw a descriptive error
          final errorMsg = 'Unexpected response format. Keys found: ${data.keys.join(", ")}';
          debugPrint('WireGuardService: ERROR - $errorMsg');
          throw ApiException(errorMsg, response.statusCode);
        }
        
        debugPrint('WireGuardService: ERROR - Invalid response format (not a Map)');
        throw ApiException('Invalid response format', response.statusCode);
      } else {
        debugPrint('WireGuardService: ERROR - Non-200 status code: ${response.statusCode}');
        throw ApiException('Failed to generate WireGuard key pair', response.statusCode);
      }
    } on DioException catch (e) {
      debugPrint('WireGuardService: DioException - ${e.type}: ${e.message}');
      throw handleDioError(e);
    } catch (e) {
      debugPrint('WireGuardService: Unexpected error - $e');
      rethrow;
    }
  }

  /// Apply WireGuard configuration changes
  /// Endpoint: POST /wireguard/service/reconfigure
  Future<void> applyWireGuardConfiguration() async {
    ensureInitialized();

    try {
      final response = await dio.post('/wireguard/service/reconfigure');
      
      if (response.statusCode != 200) {
        throw ApiException('Failed to apply WireGuard configuration', response.statusCode);
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

  /// Restart WireGuard service
  /// Endpoint: POST /wireguard/service/restart
  Future<void> restartWireGuardService() async {
    ensureInitialized();

    try {
      final response = await dio.post('/wireguard/service/restart');
      
      if (response.statusCode != 200) {
        throw ApiException('Failed to restart WireGuard service', response.statusCode);
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
}


