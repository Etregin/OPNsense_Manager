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

import '../models/system_info.dart';
import '../models/firewall_rule.dart';
import '../models/firewall_alias.dart';
import '../models/vpn_connection.dart';
import '../models/network_host.dart';
import '../models/tailscale_status.dart';
import '../models/tailscale_settings.dart';
import 'demo/demo_state_manager.dart';
import 'demo/demo_system_data_generator.dart';
import 'demo/demo_firewall_data_generator.dart';
import 'demo/demo_vpn_data_generator.dart';
import 'demo/demo_network_data_generator.dart';
import 'demo/demo_tailscale_data_generator.dart';

/// Service for generating realistic demo data
/// 
/// This is a facade that delegates to specialized generators:
/// - System data (info, services, gateways)
/// - Firewall data (rules, aliases, logs)
/// - VPN data (OpenVPN, WireGuard, Tailscale)
/// - Network data (hosts, DHCP leases)
/// - Tailscale data (status, settings, subnets)
class DemoDataService {
  static final DemoDataService _instance = DemoDataService._internal();
  factory DemoDataService() => _instance;

  // State manager and generators
  final DemoStateManager _stateManager = DemoStateManager();
  late final DemoSystemDataGenerator _systemGenerator;
  late final DemoFirewallDataGenerator _firewallGenerator;
  late final DemoVPNDataGenerator _vpnGenerator;
  late final DemoNetworkDataGenerator _networkGenerator;
  late final DemoTailscaleDataGenerator _tailscaleGenerator;

  DemoDataService._internal() {
    _systemGenerator = DemoSystemDataGenerator(_stateManager);
    _firewallGenerator = DemoFirewallDataGenerator(_stateManager);
    _vpnGenerator = DemoVPNDataGenerator(_stateManager);
    _networkGenerator = DemoNetworkDataGenerator();
    _tailscaleGenerator = DemoTailscaleDataGenerator(_stateManager);
  }

  // ==================== System Data ====================

  /// Generate demo system info
  SystemInfo generateSystemInfo() => _systemGenerator.generateSystemInfo();

  /// Generate demo services
  Map<String, dynamic> generateServices() => _systemGenerator.generateServices();

  /// Generate demo gateways
  List<Map<String, dynamic>> generateGateways() => _systemGenerator.generateGateways();

  // ==================== Firewall Data ====================

  /// Generate demo firewall rules
  List<FirewallRule> generateFirewallRules() => _firewallGenerator.generateFirewallRules();

  /// Generate demo firewall aliases
  List<FirewallAlias> generateFirewallAliases() => _firewallGenerator.generateFirewallAliases();

  /// Generate demo firewall logs
  List<Map<String, dynamic>> generateFirewallLogs({int limit = 100}) => 
      _firewallGenerator.generateFirewallLogs(limit: limit);

  /// Generate available interfaces for firewall rules
  Map<String, dynamic> generateAvailableInterfaces() => 
      _firewallGenerator.generateAvailableInterfaces();

  /// Toggle firewall rule state
  void toggleFirewallRuleState(String uuid) => 
      _stateManager.toggleFirewallRuleState(uuid);

  /// Toggle firewall alias state
  void toggleFirewallAliasState(String uuid) => 
      _stateManager.toggleFirewallAliasState(uuid);

  /// Delete firewall alias
  void deleteFirewallAlias(String uuid) => 
      _stateManager.deleteFirewallAlias(uuid);

  /// Get next alias ID for creating new aliases
  int getNextAliasId() => _stateManager.getNextAliasId();

  // ==================== VPN Data ====================

  /// Generate demo VPN connections
  List<VPNConnection> generateVPNConnections() => _vpnGenerator.generateVPNConnections();

  /// Generate demo WireGuard peers
  List<Map<String, dynamic>> generateWireGuardPeers() =>
      _vpnGenerator.generateWireGuardPeers();

  /// Generate demo WireGuard servers
  List<Map<String, dynamic>> generateWireGuardServers() => 
      _vpnGenerator.generateWireGuardServers();

  /// Toggle VPN connection state
  void toggleVPNConnectionState(String id) => 
      _stateManager.toggleVPNConnectionState(id);

  // ==================== Network Data ====================

  /// Generate demo network hosts with bandwidth usage
  List<NetworkHost> generateNetworkHosts() => _networkGenerator.generateNetworkHosts();

  /// Generate demo DHCP leases
  List<Map<String, dynamic>> generateDhcpLeases() => _networkGenerator.generateDhcpLeases();

  // ==================== Service State ====================

  /// Toggle service state
  void toggleServiceState(String name) => _stateManager.toggleServiceState(name);

  // ==================== Tailscale Data ====================

  /// Generate Tailscale status
  TailscaleStatus generateTailscaleStatus() => 
      _tailscaleGenerator.generateTailscaleStatus();

  /// Generate Tailscale settings response
  TailscaleSettingsResponse generateTailscaleSettings() => 
      _tailscaleGenerator.generateTailscaleSettings();

  /// Update Tailscale service state
  void updateTailscaleServiceState(String action) => 
      _stateManager.updateTailscaleServiceState(action);

  /// Update Tailscale settings
  void updateTailscaleSettings(Map<String, dynamic> settings) => 
      _stateManager.updateTailscaleSettings(settings);

  /// Logout from Tailscale
  void logoutTailscale() => _stateManager.logoutTailscale();

  /// Update Tailscale settings data
  void updateTailscaleSettingsData(TailscaleSettings settings) => 
      _tailscaleGenerator.updateTailscaleSettingsData(settings);

  /// Generate subnet search response
  TailscaleSubnetSearchResponse generateTailscaleSubnetSearch() => 
      _tailscaleGenerator.generateTailscaleSubnetSearch();

  /// Generate a specific subnet response
  TailscaleSubnetResponse generateTailscaleSubnet(String uuid) => 
      _tailscaleGenerator.generateTailscaleSubnet(uuid);

  /// Add a new Tailscale subnet
  String addTailscaleSubnet(TailscaleSubnet subnet) => 
      _stateManager.addTailscaleSubnet(subnet);

  /// Update an existing Tailscale subnet
  void updateTailscaleSubnet(String uuid, TailscaleSubnet subnet) => 
      _stateManager.updateTailscaleSubnet(uuid, subnet);

  /// Delete a Tailscale subnet
  void deleteTailscaleSubnet(String uuid) => 
      _stateManager.deleteTailscaleSubnet(uuid);

  // ==================== Reset ====================

  /// Reset all demo data to defaults
  void reset() => _stateManager.reset();
}


