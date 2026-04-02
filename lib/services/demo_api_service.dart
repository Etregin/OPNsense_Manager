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
import '../models/vpn_connection.dart';
import 'demo_data_service.dart';
import 'opnsense_api_service.dart';

/// Wrapper service that provides demo data when in demo mode
class DemoApiService {
  final OPNsenseApiService _realApiService;
  final DemoDataService _demoDataService = DemoDataService();
  bool _isDemoMode = false;

  DemoApiService(this._realApiService);

  /// Enable or disable demo mode
  void setDemoMode(bool enabled) {
    _isDemoMode = enabled;
    if (!enabled) {
      _demoDataService.reset();
    }
  }

  /// Check if demo mode is active
  bool get isDemoMode => _isDemoMode;

  /// Test connection - always succeeds in demo mode
  Future<bool> testConnection() async {
    if (_isDemoMode) {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 500));
      return true;
    }
    return _realApiService.testConnection();
  }

  /// Get system info
  Future<SystemInfo> getSystemInfo() async {
    if (_isDemoMode) {
      await Future.delayed(const Duration(milliseconds: 300));
      return _demoDataService.generateSystemInfo();
    }
    return _realApiService.getSystemInfo();
  }

  /// Get firewall rules
  Future<List<FirewallRule>> getFirewallRules() async {
    if (_isDemoMode) {
      await Future.delayed(const Duration(milliseconds: 400));
      return _demoDataService.generateFirewallRules();
    }
    return _realApiService.getFirewallRules();
  }

  /// Get available interfaces
  Future<Map<String, dynamic>> getAvailableInterfaces() async {
    if (_isDemoMode) {
      await Future.delayed(const Duration(milliseconds: 200));
      return _demoDataService.generateAvailableInterfaces();
    }
    return _realApiService.getAvailableInterfaces();
  }

  /// Get firewall rule by UUID
  Future<FirewallRule?> getFirewallRule(String uuid) async {
    if (_isDemoMode) {
      await Future.delayed(const Duration(milliseconds: 200));
      final rules = _demoDataService.generateFirewallRules();
      try {
        return rules.firstWhere((rule) => rule.uuid == uuid);
      } catch (e) {
        return null;
      }
    }
    return _realApiService.getFirewallRule(uuid);
  }

  /// Toggle firewall rule
  Future<void> toggleFirewallRule(String uuid) async {
    if (_isDemoMode) {
      await Future.delayed(const Duration(milliseconds: 300));
      _demoDataService.toggleFirewallRuleState(uuid);
      return;
    }
    return _realApiService.toggleFirewallRule(uuid);
  }

  /// Create a new firewall rule
  Future<String> createFirewallRule(FirewallRuleRequest request) async {
    if (_isDemoMode) {
      await Future.delayed(const Duration(milliseconds: 600));
      // In demo mode, just return a fake UUID
      return 'demo-rule-${DateTime.now().millisecondsSinceEpoch}';
    }
    return _realApiService.createFirewallRule(request);
  }

  /// Update an existing firewall rule
  Future<void> updateFirewallRule(String uuid, FirewallRuleRequest request) async {
    if (_isDemoMode) {
      await Future.delayed(const Duration(milliseconds: 600));
      // In demo mode, just simulate success
      return;
    }
    return _realApiService.updateFirewallRule(uuid, request);
  }

  /// Delete firewall rule
  Future<void> deleteFirewallRule(String uuid) async {
    if (_isDemoMode) {
      await Future.delayed(const Duration(milliseconds: 300));
      // In demo mode, we just pretend to delete
      return;
    }
    return _realApiService.deleteFirewallRule(uuid);
  }

  /// Apply firewall changes
  Future<void> applyFirewallChanges() async {
    if (_isDemoMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      return;
    }
    return _realApiService.applyFirewallChanges();
  }

  /// Get firewall logs
  Future<List<dynamic>> getFirewallLogs({int limit = 100}) async {
    if (_isDemoMode) {
      await Future.delayed(const Duration(milliseconds: 400));
      return _demoDataService.generateFirewallLogs(limit: limit);
    }
    return _realApiService.getFirewallLogs(limit: limit);
  }

  /// Get services
  Future<List<dynamic>> getServices() async {
    if (_isDemoMode) {
      await Future.delayed(const Duration(milliseconds: 300));
      final services = _demoDataService.generateServices();
      return services['services'] as List<dynamic>;
    }
    return _realApiService.getServices();
  }

  /// Get gateways
  Future<List<dynamic>> getGateways() async {
    if (_isDemoMode) {
      await Future.delayed(const Duration(milliseconds: 300));
      return _demoDataService.generateGateways();
    }
    return _realApiService.getGateways();
  }

  /// Control service (start/stop/restart)
  Future<bool> controlService(String serviceName, String action) async {
    if (_isDemoMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      if (action == 'start' || action == 'stop') {
        _demoDataService.toggleServiceState(serviceName);
      }
      return true;
    }
    return _realApiService.controlService(serviceName, action);
  }

  /// Get VPN connections
  Future<List<VPNConnection>> getVPNConnections() async {
    if (_isDemoMode) {
      await Future.delayed(const Duration(milliseconds: 400));
      return _demoDataService.generateVPNConnections();
    }
    return _realApiService.getVPNConnections();
  }

  /// Toggle VPN connection
  Future<bool> toggleVPNConnection(String id, String type, bool currentStatus) async {
    if (_isDemoMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      _demoDataService.toggleVPNConnectionState(id);
      return true;
    }
    return _realApiService.toggleVPNConnection(id, type, currentStatus);
  }

  /// Restart VPN service
  Future<bool> restartVPNService(String type) async {
    if (_isDemoMode) {
      await Future.delayed(const Duration(milliseconds: 800));
      return true;
    }
    return _realApiService.restartVPNService(type);
  }

  /// Get VPN connection details
  Future<VPNConnection?> getVPNConnectionDetails(String id, String type) async {
    if (_isDemoMode) {
      await Future.delayed(const Duration(milliseconds: 300));
      final connections = _demoDataService.generateVPNConnections();
      try {
        return connections.firstWhere(
          (conn) => conn.id == id && conn.type.toLowerCase() == type.toLowerCase(),
        );
      } catch (e) {
        return null;
      }
    }
    return _realApiService.getVPNConnectionDetails(id, type);
  }

  /// Reboot system
  Future<void> rebootSystem() async {
    if (_isDemoMode) {
      await Future.delayed(const Duration(milliseconds: 500));
      throw ApiException('Cannot reboot in demo mode', 403);
    }
    return _realApiService.rebootSystem();
  }

  /// Clear service state
  void clear() {
    _demoDataService.reset();
    _realApiService.clear();
  }
}

