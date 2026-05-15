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

import 'dart:math';
import 'package:flutter/foundation.dart';
import '../../models/tailscale_status.dart';
import '../../models/tailscale_settings.dart';
import 'demo_state_manager.dart';

/// Generator for Tailscale-specific demo data
/// 
/// Handles generation of:
/// - Tailscale status and connection information
/// - Tailscale settings and configuration
/// - Tailscale subnet management
class DemoTailscaleDataGenerator {
  final DemoStateManager _stateManager;
  final Random _random = Random();

  DemoTailscaleDataGenerator(this._stateManager);

  /// Generate Tailscale status with realistic connection data
  TailscaleStatus generateTailscaleStatus() {
    final isConnected = _stateManager.tailscaleServiceRunning && 
                       _stateManager.tailscaleAuthenticated;
    final settings = _stateManager.tailscaleSettings;
    
    return TailscaleStatus(
      // Authentication fields - matching real API structure
      authenticated: _stateManager.tailscaleAuthenticated,
      loginState: _stateManager.tailscaleAuthenticated ? 'authenticated' : 'unauthenticated',
      // authUrl comes from status.AuthURL (empty when authenticated)
      authUrl: _stateManager.tailscaleAuthenticated 
          ? null 
          : 'https://login.tailscale.com/admin/machines/auth/demo-key-12345',
      // tailnet comes from status.CurrentTailnet.Name
      tailnet: _stateManager.tailscaleAuthenticated ? 'demo-network.ts.net' : null,
      // user comes from status.User[userID].LoginName
      user: _stateManager.tailscaleAuthenticated ? 'demo-user@example.com' : null,
      // deviceName comes from status.Self.HostName
      deviceName: _stateManager.tailscaleAuthenticated ? 'demo-opnsense' : null,
      
      // Settings fields - matching real API structure from settings endpoint
      // acceptRoutes from settings.acceptSubnetRoutes
      acceptRoutes: settings['accept_routes'] as bool,
      // advertiseRoutes from settings.subnets (comma-separated)
      advertiseRoutes: settings['advertise_routes'] as String?,
      // exitNode from settings.exitNode
      exitNode: (settings['exit_node'] as String?)?.isEmpty == true
          ? null
          : settings['exit_node'] as String?,
      // useExitNode from settings.useExitNode
      useExitNode: settings['use_exit_node'] as bool,
      // dnsEnabled from settings.acceptDNS
      dnsEnabled: settings['dns_enabled'] as bool,
      // magicDns from status.CurrentTailnet.MagicDNSEnabled
      magicDns: settings['magic_dns'] as bool,
      // sshEnabled from settings.enableSSH
      sshEnabled: settings['ssh_enabled'] as bool,
      tags: List<String>.from(settings['tags'] as List),
      hostname: settings['hostname'] as String?,
      
      // Status fields - matching real API structure
      serviceRunning: _stateManager.tailscaleServiceRunning,
      // backendState from status.BackendState
      backendState: isConnected 
          ? 'Running' 
          : _stateManager.tailscaleServiceRunning ? 'Starting' : 'Stopped',
      // ips from status.Self.TailscaleIPs
      ips: isConnected ? ['100.64.0.1', 'fd7a:115c:a1e0::1'] : [],
      // bytesReceived from status.Self.RxBytes
      bytesReceived: isConnected 
          ? 1024 * 1024 * 95 + _random.nextInt(1024 * 1024 * 20) 
          : null,
      // bytesSent from status.Self.TxBytes
      bytesSent: isConnected 
          ? 1024 * 1024 * 62 + _random.nextInt(1024 * 1024 * 15) 
          : null,
      connectedSince: isConnected 
          ? DateTime.now().subtract(Duration(days: 14, hours: _random.nextInt(24))) 
          : null,
      // health from status.Health array (null or empty = healthy)
      health: null,
      // peersCount from status.Peer object count
      peersCount: isConnected ? 5 + _random.nextInt(3) : 0,
      // version from status.Version
      version: '1.56.1',
    );
  }

  /// Generate Tailscale settings response
  TailscaleSettingsResponse generateTailscaleSettings() {
    return TailscaleSettingsResponse(
      settings: TailscaleSettings(
        enabled: _stateManager.tailscaleServiceRunning,
        loginTimeout: '60',
        listenPort: '41641',
        acceptDNS: _stateManager.tailscaleSettings['dns_enabled'] as bool,
        advertiseExitNode: false,
        useExitNode: _buildExitNodeMap(),
        acceptSubnetRoutes: _stateManager.tailscaleSettings['accept_routes'] as bool,
        enableSSH: _stateManager.tailscaleSettings['ssh_enabled'] as bool,
        disableSNAT: false,
        subnets: Map<String, TailscaleSubnet>.from(_stateManager.tailscaleSubnets),
      ),
    );
  }

  /// Build exit node map structure
  Map<String, TailscaleExitNode> _buildExitNodeMap() {
    final exitNode = _stateManager.tailscaleSettings['exit_node'] as String?;
    if (exitNode == null || exitNode.isEmpty) {
      return {
        '': TailscaleExitNode(value: 'None', selected: true),
      };
    }
    return {
      '': TailscaleExitNode(value: 'None', selected: false),
      exitNode: TailscaleExitNode(value: exitNode, selected: true),
    };
  }

  /// Update Tailscale settings data
  void updateTailscaleSettingsData(TailscaleSettings settings) {
    debugPrint('🔄 [DemoTailscaleDataGenerator] Updating Tailscale settings...');
    debugPrint('🔍 [DemoTailscaleDataGenerator] Settings: enabled=${settings.enabled}, acceptDNS=${settings.acceptDNS}');
    
    try {
      if (settings.enabled != null) {
        debugPrint('✓ [DemoTailscaleDataGenerator] Updating enabled: ${settings.enabled}');
        _stateManager.updateTailscaleServiceState(settings.enabled! ? 'start' : 'stop');
      }
      
      final updatedSettings = <String, dynamic>{};
      
      if (settings.acceptDNS != null) {
        debugPrint('✓ [DemoTailscaleDataGenerator] Updating acceptDNS: ${settings.acceptDNS}');
        updatedSettings['dns_enabled'] = settings.acceptDNS!;
      }
      if (settings.acceptSubnetRoutes != null) {
        debugPrint('✓ [DemoTailscaleDataGenerator] Updating acceptSubnetRoutes: ${settings.acceptSubnetRoutes}');
        updatedSettings['accept_routes'] = settings.acceptSubnetRoutes!;
      }
      if (settings.enableSSH != null) {
        debugPrint('✓ [DemoTailscaleDataGenerator] Updating enableSSH: ${settings.enableSSH}');
        updatedSettings['ssh_enabled'] = settings.enableSSH!;
      }
      
      // Update exit node if provided
      if (settings.useExitNode != null) {
        debugPrint('🔍 [DemoTailscaleDataGenerator] Processing useExitNode: ${settings.useExitNode}');
        try {
          final selectedNode = settings.selectedExitNode;
          debugPrint('🔍 [DemoTailscaleDataGenerator] Selected node: $selectedNode');
          
          if (selectedNode != null && selectedNode.value != null && selectedNode.value != 'None') {
            debugPrint('✓ [DemoTailscaleDataGenerator] Setting exit node: ${selectedNode.value}');
            updatedSettings['exit_node'] = selectedNode.value!;
            updatedSettings['use_exit_node'] = true;
          } else {
            debugPrint('✓ [DemoTailscaleDataGenerator] Clearing exit node');
            updatedSettings['exit_node'] = '';
            updatedSettings['use_exit_node'] = false;
          }
        } catch (exitNodeError) {
          debugPrint('❌ [DemoTailscaleDataGenerator] Error processing exit node: $exitNodeError');
          rethrow;
        }
      }
      
      if (updatedSettings.isNotEmpty) {
        _stateManager.updateTailscaleSettings(updatedSettings);
      }
      
      debugPrint('✅ [DemoTailscaleDataGenerator] Settings updated successfully');
    } catch (e, stackTrace) {
      debugPrint('❌ [DemoTailscaleDataGenerator] Error updating settings: $e');
      debugPrint('❌ [DemoTailscaleDataGenerator] Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Generate subnet search response
  TailscaleSubnetSearchResponse generateTailscaleSubnetSearch() {
    final subnetList = _stateManager.tailscaleSubnets.values.toList();
    return TailscaleSubnetSearchResponse(
      rows: subnetList,
      rowCount: subnetList.length,
      total: subnetList.length,
      current: 1,
    );
  }

  /// Generate a specific subnet response
  TailscaleSubnetResponse generateTailscaleSubnet(String uuid) {
    final subnet = _stateManager.getTailscaleSubnet(uuid);
    if (subnet == null) {
      throw Exception('Subnet not found: $uuid');
    }
    return TailscaleSubnetResponse(subnet: subnet);
  }
}


