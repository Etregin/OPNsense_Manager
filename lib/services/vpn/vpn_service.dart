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
import '../../models/vpn_connection.dart';
import '../../models/tailscale_status.dart';
import 'wireguard_service.dart';

/// Service for VPN operations
class VPNService extends BaseOPNsenseService {
  final WireGuardService _wireguardService = WireGuardService();

  Future<List<VPNConnection>> getVPNConnections() async {
    ensureInitialized();

    try {
      final connections = <VPNConnection>[];
      final errors = <String, String>{};

      // Get VPN services from the service list (using correct endpoint without /api prefix)
      try {
        final servicesResponse = await dio.get('/core/service/search');
        
        if (servicesResponse.statusCode == 200 && servicesResponse.data != null) {
          final data = servicesResponse.data as Map<String, dynamic>;
          final rows = data['rows'] as List<dynamic>? ?? [];
          
          for (final row in rows) {
            final rowData = row as Map<String, dynamic>;
            final serviceName = rowData['name']?.toString().toLowerCase() ?? '';
            final serviceId = rowData['id']?.toString() ?? '';
            final isRunning = rowData['running']?.toString() == '1' || rowData['running'] == true;
            
            // Check if this is Tailscale VPN service
            if (serviceName == 'tailscale') {
              connections.add(VPNConnection(
                id: serviceId,
                name: 'Tailscale',
                type: serviceName,
                status: isRunning ? 'up' : 'down',
                description: rowData['description']?.toString() ?? 'Tailscale VPN Service',
                enabled: isRunning,
              ));
            }
          }
        }
      } catch (e) {
        errors['Services'] = e.toString();
      }

      // Get OpenVPN sessions (active connections)
      try {
        final openVpnConnections = await _getOpenVPNSessions();
        connections.addAll(openVpnConnections);
      } catch (e) {
        errors['OpenVPN'] = e.toString();
      }

      // Get WireGuard connections
      try {
        final wireguardConnections = await _getWireGuardConnections();
        connections.addAll(wireguardConnections);
      } catch (e) {
        errors['WireGuard'] = e.toString();
      }


      return connections;
    } catch (e) {
      throw ApiException('Failed to get VPN connections: ${e.toString()}', null);
    }
  }

  /// Get Tailscale connection status
  Future<VPNConnection?> getTailscaleStatus() async {
    ensureInitialized();

    try {
      // Get VPN services from the service list
      final servicesResponse = await dio.get('/core/service/search');
      
      if (servicesResponse.statusCode == 200 && servicesResponse.data != null) {
        final data = servicesResponse.data as Map<String, dynamic>;
        final rows = data['rows'] as List<dynamic>? ?? [];
        
        for (final row in rows) {
          final rowData = row as Map<String, dynamic>;
          final serviceName = rowData['name']?.toString().toLowerCase() ?? '';
          final serviceId = rowData['id']?.toString() ?? '';
          final isRunning = rowData['running']?.toString() == '1' || rowData['running'] == true;
          
          // Check if this is Tailscale VPN service
          if (serviceName == 'tailscale') {
            return VPNConnection(
              id: serviceId,
              name: 'Tailscale',
              type: serviceName,
              status: isRunning ? 'up' : 'down',
              description: rowData['description']?.toString() ?? 'Tailscale VPN Service',
              enabled: isRunning,
            );
          }
        }
      }
      
      // Return null if Tailscale service not found
      return null;
    } catch (e) {
      // Return null on error - drawer will show "Unknown" status
      return null;
    }
  }

  /// Get detailed Tailscale status and configuration
  Future<TailscaleStatus> getTailscaleDetails() async {
    ensureInitialized();

    try {
      // Get service status
      final serviceStatusResponse = await dio.post('/tailscale/service/status');
      
      bool serviceRunning = false;
      if (serviceStatusResponse.statusCode == 200 && serviceStatusResponse.data != null) {
        final serviceData = serviceStatusResponse.data as Map<String, dynamic>;
        final status = serviceData['status']?.toString().toLowerCase() ?? '';
        serviceRunning = status == 'running';
      }

      // Get comprehensive Tailscale status
      final statusResponse = await dio.get('/tailscale/status/status');
      final statusData = statusResponse.data as Map<String, dynamic>? ?? {};

      // Get Tailscale settings
      final settingsResponse = await dio.get('/tailscale/settings/get');
      final settingsData = settingsResponse.data as Map<String, dynamic>? ?? {};
      // Fix: API returns 'settings' not 'tailscale'
      final settings = settingsData['settings'] as Map<String, dynamic>? ?? {};

      // Get authentication configuration
      final authResponse = await dio.get('/tailscale/authentication/get');
      final authData = authResponse.data as Map<String, dynamic>? ?? {};
      final authentication = authData['authentication'] as Map<String, dynamic>? ?? {};
      final loginServer = authentication['loginServer']?.toString();
      final preAuthKey = authentication['preAuthKey']?.toString();

      // Extract data from status response
      final backendState = statusData['BackendState']?.toString() ?? 'Stopped';
      final authUrl = statusData['AuthURL']?.toString();
      final version = statusData['Version']?.toString();
      
      // Extract Self data
      final selfData = statusData['Self'] as Map<String, dynamic>? ?? {};
      final hostName = selfData['HostName']?.toString();
      final dnsName = selfData['DNSName']?.toString();
      final tailscaleIPs = selfData['TailscaleIPs'] as List<dynamic>? ?? [];
      final ips = tailscaleIPs.map((ip) => ip.toString()).toList();
      final rxBytes = selfData['RxBytes'] as int?;
      final txBytes = selfData['TxBytes'] as int?;
      
      // Extract CurrentTailnet data
      final currentTailnet = statusData['CurrentTailnet'] as Map<String, dynamic>? ?? {};
      final tailnetName = currentTailnet['Name']?.toString();
      final magicDnsEnabled = currentTailnet['MagicDNSEnabled'] == true;
      
      // Extract User data
      final userMap = statusData['User'] as Map<String, dynamic>? ?? {};
      String? userName;
      if (userMap.isNotEmpty) {
        // User map has userID as key, get first user
        final firstUserData = userMap.values.first as Map<String, dynamic>? ?? {};
        userName = firstUserData['LoginName']?.toString();
      }
      
      // Extract Peer data for count
      final peerMap = statusData['Peer'] as Map<String, dynamic>? ?? {};
      final peersCount = peerMap.length;
      
      // Extract Health data
      final healthList = statusData['Health'] as List<dynamic>? ?? [];
      String? healthStatus;
      if (healthList.isNotEmpty) {
        healthStatus = healthList.join(', ');
      }
      
      // Extract settings - Fix: Convert "1"/"0" strings to booleans
      final acceptSubnetRoutes = settings['acceptSubnetRoutes']?.toString() == '1';
      final acceptDNS = settings['acceptDNS']?.toString() == '1';
      final enableSSH = settings['enableSSH']?.toString() == '1';
      
      // Fix: Parse exit node correctly
      final useExitNodeData = settings['useExitNode'] as Map<String, dynamic>?;
      String? exitNodeValue;
      bool useExitNode = false;
      if (useExitNodeData != null) {
        // Find the selected exit node
        for (final entry in useExitNodeData.entries) {
          if (entry.value is Map && entry.value['selected'] == 1) {
            exitNodeValue = entry.key.isEmpty ? null : entry.key;
            useExitNode = exitNodeValue != null;
            break;
          }
        }
      }
      
      // Fix: Extract advertised subnets from nested structure
      final subnetsData = settings['subnets'] as Map<String, dynamic>?;
      String? advertiseRoutes;
      if (subnetsData != null) {
        final subnetList = <String>[];
        // Handle subnet4 structure
        final subnet4 = subnetsData['subnet4'] as Map<String, dynamic>?;
        if (subnet4 != null) {
          // Iterate through UUIDs
          for (final entry in subnet4.values) {
            if (entry is Map<String, dynamic>) {
              final subnet = entry['subnet']?.toString();
              if (subnet != null && subnet.isNotEmpty) {
                subnetList.add(subnet);
              }
            }
          }
        }
        if (subnetList.isNotEmpty) {
          advertiseRoutes = subnetList.join(', ');
        }
      }
      
      // Determine authentication status
      final authenticated = authUrl == null || authUrl.isEmpty;
      final loginState = authenticated ? 'authenticated' : 'unauthenticated';
      
      return TailscaleStatus(
        // Authentication fields
        authenticated: authenticated,
        loginState: loginState,
        authUrl: authUrl,
        tailnet: tailnetName,
        user: userName,
        deviceName: hostName ?? dnsName,
        loginServer: loginServer,
        preAuthKey: preAuthKey,
        
        // Settings fields
        acceptRoutes: acceptSubnetRoutes,
        advertiseRoutes: advertiseRoutes,
        exitNode: exitNodeValue,
        useExitNode: useExitNode,
        dnsEnabled: acceptDNS,
        magicDns: magicDnsEnabled,
        sshEnabled: enableSSH,
        tags: const [], // Tags not available in current API
        hostname: config.host,
        
        // Status fields
        serviceRunning: serviceRunning,
        backendState: backendState,
        ips: ips,
        bytesReceived: rxBytes,
        bytesSent: txBytes,
        connectedSince: null, // Not available in current API
        health: healthStatus,
        peersCount: peersCount,
        version: version,
      );
    } catch (e) {
      throw ApiException('Failed to get Tailscale details: ${e.toString()}', null);
    }
  }

  /// Get OpenVPN instances and sessions
  Future<List<VPNConnection>> _getOpenVPNSessions() async {
    try {
      final connections = <VPNConnection>[];
      
      // Get OpenVPN instances (servers and clients)
      try {
        final response = await dio.get('/openvpn/service/searchSessions');
        
        if (response.statusCode == 200 && response.data != null) {
          final data = response.data as Map<String, dynamic>;
          final rows = data['rows'] as List<dynamic>? ?? [];
          
          for (final row in rows) {
            final rowData = row as Map<String, dynamic>;
            final instanceType = rowData['type']?.toString() ?? '';
            final status = rowData['status']?.toString() ?? '';
            
            // This endpoint returns both server instances and client sessions
            if (instanceType == 'server' || instanceType == 'client') {
              // This is an OpenVPN server or client instance
              connections.add(VPNConnection(
                id: rowData['id']?.toString() ?? '',
                name: rowData['description']?.toString() ?? 'OpenVPN ${instanceType[0].toUpperCase()}${instanceType.substring(1)}',
                type: 'openvpn',
                status: status == 'ok' ? 'up' : 'down',
                description: rowData['description']?.toString(),
                enabled: status == 'ok',
              ));
            } else {
              // This is a connected client session
              connections.add(VPNConnection(
                id: rowData['id']?.toString() ?? '',
                name: rowData['common_name']?.toString() ?? 'OpenVPN Client',
                type: 'openvpn',
                status: 'up',
                description: rowData['common_name']?.toString(),
                remoteAddress: rowData['real_address']?.toString(),
                virtualAddress: rowData['virtual_address']?.toString(),
                bytesReceived: int.tryParse(rowData['bytes_received']?.toString() ?? '0'),
                bytesSent: int.tryParse(rowData['bytes_sent']?.toString() ?? '0'),
                connectedSince: rowData['connected_since'] != null
                    ? DateTime.tryParse(rowData['connected_since'].toString())
                    : null,
                enabled: true,
              ));
            }
          }
        }
      } catch (e) {
        // Silent fail
      }
      
      return connections;
    } catch (e) {
      return [];
    }
  }
  /// Get WireGuard connections
  Future<List<VPNConnection>> _getWireGuardConnections() async {
    try {
      final connections = <VPNConnection>[];

      // Initialize WireGuard service with same config
      _wireguardService.init(dio, config);

      // Get WireGuard servers
      try {
        final servers = await _wireguardService.getWireGuardServers();
        for (var server in servers) {
          connections.add(VPNConnection(
            id: server.uuid,
            name: server.name,
            type: 'wireguard',
            status: server.isEnabled ? 'up' : 'down',
            description: 'WireGuard VPN Server',
            localAddress: server.tunneladdress,
            port: server.portNumber,
            enabled: server.isEnabled,
          ));
        }
      } catch (e) {
        // Silently handle error
      }

      // Get WireGuard peers
      try {
        final peers = await _wireguardService.getWireGuardPeers();
        for (var peer in peers) {
          connections.add(VPNConnection(
            id: peer.uuid,
            name: peer.name,
            type: 'wireguard',
            status: peer.isEnabled ? 'up' : 'down',
            description: 'WireGuard VPN Peer',
            virtualAddress: peer.tunneladdress,
            enabled: peer.isEnabled,
          ));
        }
      } catch (e) {
        // Silently handle error
      }

      return connections;
    } catch (e) {
      return [];
    }
  }


  /// Toggle VPN connection (connect/disconnect)
  Future<bool> toggleVPNConnection(String id, String type, bool currentStatus) async {
    ensureInitialized();

    try {
      String action = currentStatus ? 'stop' : 'start';

      // Use the core service control endpoint for all services
      final response = await dio.post('/core/service/$action/$id');
      
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>?;
        return data?['result'] == 'ok' || data?['status'] == 'ok';
      }
      
      return false;
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (e) {
      throw ApiException('Failed to toggle VPN connection: ${e.toString()}', null);
    }
  }

  /// Restart VPN service
  Future<bool> restartVPNService(String type) async {
    ensureInitialized();

    try {
      String endpoint;

      switch (type.toLowerCase()) {
        case 'openvpn':
          endpoint = '/api/openvpn/service/restart';
          break;
        case 'tailscale':
          endpoint = '/tailscale/service/restart';
          break;
        default:
          throw ApiException('Unknown VPN type: $type', null);
      }

      final response = await dio.post(endpoint);
      
      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>?;
        return data?['result'] == 'ok' || data?['status'] == 'ok';
      }
      
      return false;
    } on DioException catch (e) {
      throw handleDioError(e);
    } catch (e) {
      throw ApiException('Failed to restart VPN service: ${e.toString()}', null);
    }
  }

  /// Get VPN connection details
  Future<VPNConnection?> getVPNConnectionDetails(String id, String type) async {
    ensureInitialized();

    try {
      final connections = await getVPNConnections();
      return connections.firstWhere(
        (conn) => conn.id == id && conn.type.toLowerCase() == type.toLowerCase(),
        orElse: () => throw ApiException('VPN connection not found', 404),
      );
    } catch (e) {
      throw ApiException('Failed to get VPN connection details: ${e.toString()}', null);
    }
  }
}


