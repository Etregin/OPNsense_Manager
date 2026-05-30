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

import '../../models/tailscale_settings.dart';

/// Centralized state manager for demo mode
/// 
/// Manages all stateful data for demo mode including:
/// - Firewall rule states (enabled/disabled)
/// - Firewall alias states (enabled/disabled)
/// - VPN connection states (connected/disconnected)
/// - Service states (running/stopped)
/// - Tailscale configuration and state
/// - ID generators for new entities
class DemoStateManager {
  static final DemoStateManager _instance = DemoStateManager._internal();
  factory DemoStateManager() => _instance;
  DemoStateManager._internal();

  // Firewall state
  final Map<String, bool> _firewallRuleStates = {};
  final Map<String, bool> _firewallAliasStates = {};
  final Set<String> _deletedAliases = {};
  int _nextAliasId = 10;

  // VPN state
  final Map<String, bool> _vpnConnectionStates = {};

  // Service state
  final Map<String, bool> _serviceStates = {};

  // Tailscale state
  bool _tailscaleServiceRunning = true;
  bool _tailscaleAuthenticated = true;
  Map<String, dynamic> _tailscaleSettings = {
    'accept_routes': true,
    'advertise_routes': '192.168.1.0/24,10.0.0.0/24',
    'exit_node': '',
    'use_exit_node': false,
    'dns_enabled': true,
    'magic_dns': true,
    'ssh_enabled': true,
    'tags': ['tag:server', 'tag:firewall'],
    'hostname': 'demo-opnsense',
  };

  // Tailscale subnets storage
  final Map<String, TailscaleSubnet> _tailscaleSubnets = {
    'demo-subnet-1': TailscaleSubnet(
      uuid: 'demo-subnet-1',
      subnet: '192.168.1.0/24',
      description: 'LAN Network',
    ),
    'demo-subnet-2': TailscaleSubnet(
      uuid: 'demo-subnet-2',
      subnet: '10.0.0.0/24',
      description: 'Internal Services',
    ),
  };
  int _nextSubnetId = 3;

  // ==================== Firewall Rule State ====================

  /// Get firewall rule state (enabled/disabled)
  bool getFirewallRuleState(String uuid, bool defaultState) {
    return _firewallRuleStates[uuid] ?? defaultState;
  }

  /// Toggle firewall rule state
  void toggleFirewallRuleState(String uuid) {
    _firewallRuleStates[uuid] = !(_firewallRuleStates[uuid] ?? true);
  }

  // ==================== Firewall Alias State ====================

  /// Get firewall alias state (enabled/disabled)
  bool getFirewallAliasState(String uuid, bool defaultState) {
    return _firewallAliasStates[uuid] ?? defaultState;
  }

  /// Toggle firewall alias state
  void toggleFirewallAliasState(String uuid) {
    _firewallAliasStates[uuid] = !(_firewallAliasStates[uuid] ?? true);
  }

  /// Mark alias as deleted
  void deleteFirewallAlias(String uuid) {
    _deletedAliases.add(uuid);
  }

  /// Check if alias is deleted
  bool isAliasDeleted(String uuid) {
    return _deletedAliases.contains(uuid);
  }

  /// Get next alias ID
  int getNextAliasId() {
    return _nextAliasId++;
  }

  // ==================== VPN Connection State ====================

  /// Get VPN connection state (connected/disconnected)
  bool getVPNConnectionState(String id, bool defaultState) {
    return _vpnConnectionStates[id] ?? defaultState;
  }

  /// Toggle VPN connection state
  void toggleVPNConnectionState(String id) {
    _vpnConnectionStates[id] = !(_vpnConnectionStates[id] ?? true);
  }

  // ==================== Service State ====================

  /// Get service state (running/stopped)
  bool getServiceState(String name, bool defaultState) {
    return _serviceStates[name] ?? defaultState;
  }

  /// Toggle service state
  void toggleServiceState(String name) {
    _serviceStates[name] = !(_serviceStates[name] ?? true);
  }

  // ==================== Tailscale State ====================

  /// Get Tailscale service running state
  bool get tailscaleServiceRunning => _tailscaleServiceRunning;

  /// Get Tailscale authenticated state
  bool get tailscaleAuthenticated => _tailscaleAuthenticated;

  /// Get Tailscale settings
  Map<String, dynamic> get tailscaleSettings => Map.from(_tailscaleSettings);

  /// Update Tailscale service state
  void updateTailscaleServiceState(String action) {
    switch (action.toLowerCase()) {
      case 'start':
        _tailscaleServiceRunning = true;
        break;
      case 'stop':
        _tailscaleServiceRunning = false;
        break;
      case 'restart':
        _tailscaleServiceRunning = true;
        break;
    }
  }

  /// Update Tailscale settings
  void updateTailscaleSettings(Map<String, dynamic> settings) {
    _tailscaleSettings.addAll(settings);
  }

  /// Logout from Tailscale
  void logoutTailscale() {
    _tailscaleAuthenticated = false;
  }

  /// Update Tailscale settings from TailscaleSettings object
  void updateTailscaleSettingsData(TailscaleSettings settings) {
    // Extract advertise routes from subnets
    final advertiseRoutes = settings.subnets?.values
        .map((s) => s.subnet ?? '')
        .where((s) => s.isNotEmpty)
        .join(',') ?? '';
    
    // Get selected exit node
    final exitNode = settings.selectedExitNode?.value ?? '';
    
    _tailscaleSettings = {
      'accept_routes': settings.acceptSubnetRoutes ?? true,
      'advertise_routes': advertiseRoutes,
      'exit_node': exitNode,
      'use_exit_node': settings.selectedExitNode != null,
      'dns_enabled': settings.acceptDNS ?? true,
      'magic_dns': settings.acceptDNS ?? true,
      'ssh_enabled': settings.enableSSH ?? true,
      'tags': ['tag:server', 'tag:firewall'], // Keep default tags
      'hostname': 'demo-opnsense', // Keep default hostname
    };
  }

  // ==================== Tailscale Subnets ====================

  /// Get all Tailscale subnets
  Map<String, TailscaleSubnet> get tailscaleSubnets => Map.from(_tailscaleSubnets);

  /// Get a specific Tailscale subnet
  TailscaleSubnet? getTailscaleSubnet(String uuid) {
    return _tailscaleSubnets[uuid];
  }

  /// Add a new Tailscale subnet
  String addTailscaleSubnet(TailscaleSubnet subnet) {
    final uuid = 'demo-subnet-${_nextSubnetId++}';
    _tailscaleSubnets[uuid] = TailscaleSubnet(
      uuid: uuid,
      subnet: subnet.subnet,
      description: subnet.description,
    );
    return uuid;
  }

  /// Update an existing Tailscale subnet
  void updateTailscaleSubnet(String uuid, TailscaleSubnet subnet) {
    if (_tailscaleSubnets.containsKey(uuid)) {
      _tailscaleSubnets[uuid] = TailscaleSubnet(
        uuid: uuid,
        subnet: subnet.subnet,
        description: subnet.description,
      );
    }
  }

  /// Delete a Tailscale subnet
  void deleteTailscaleSubnet(String uuid) {
    _tailscaleSubnets.remove(uuid);
  }

  // ==================== Reset ====================

  /// Reset all state to defaults
  void reset() {
    _firewallRuleStates.clear();
    _firewallAliasStates.clear();
    _deletedAliases.clear();
    _vpnConnectionStates.clear();
    _serviceStates.clear();
    _nextAliasId = 10;

    _tailscaleServiceRunning = true;
    _tailscaleAuthenticated = true;
    _tailscaleSettings = {
      'accept_routes': true,
      'advertise_routes': '192.168.1.0/24,10.0.0.0/24',
      'exit_node': '',
      'use_exit_node': false,
      'dns_enabled': true,
      'magic_dns': true,
      'ssh_enabled': true,
      'tags': ['tag:server', 'tag:firewall'],
      'hostname': 'demo-opnsense',
    };

    _tailscaleSubnets.clear();
    _tailscaleSubnets['demo-subnet-1'] = TailscaleSubnet(
      uuid: 'demo-subnet-1',
      subnet: '192.168.1.0/24',
      description: 'LAN Network',
    );
    _tailscaleSubnets['demo-subnet-2'] = TailscaleSubnet(
      uuid: 'demo-subnet-2',
      subnet: '10.0.0.0/24',
      description: 'Internal Services',
    );
    _nextSubnetId = 3;
  }
}


