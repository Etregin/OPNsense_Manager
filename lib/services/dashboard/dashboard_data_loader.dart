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

import '../../models/network_host.dart';
import '../../models/system_info.dart';
import '../../models/thermal_sensor.dart';
import '../demo_api_service.dart';

/// Data class for dashboard data
class DashboardData {
  final SystemInfo systemInfo;
  final Map<String, dynamic> servicesData;
  final List<Map<String, dynamic>> gateways;
  final List<ThermalSensor>? thermalSensors;
  final Map<String, String> availableInterfaces;
  final Map<String, List<NetworkHost>> networkHostsByInterface;

  DashboardData({
    required this.systemInfo,
    required this.servicesData,
    required this.gateways,
    this.thermalSensors,
    required this.availableInterfaces,
    required this.networkHostsByInterface,
  });
}

/// Subset of [DashboardData] that excludes network host data.
/// Used by the 30-second system refresh so network cards are never disrupted.
class SystemOnlyData {
  final SystemInfo systemInfo;
  final Map<String, dynamic> servicesData;
  final List<Map<String, dynamic>> gateways;
  final List<ThermalSensor>? thermalSensors;
  final Map<String, String> availableInterfaces;

  SystemOnlyData({
    required this.systemInfo,
    required this.servicesData,
    required this.gateways,
    this.thermalSensors,
    required this.availableInterfaces,
  });
}

/// Service for loading dashboard data in parallel
class DashboardDataLoader {
  final DemoApiService _apiService;

  DashboardDataLoader(this._apiService);

  /// Load all dashboard data in parallel for faster loading.
  ///
  /// [requestedInterfaces] — the set of interface IDs selected by the user's
  /// network cards. Hosts are fetched once per unique interface.
  Future<DashboardData> loadAllData({
    Set<String> requestedInterfaces = const {'lan'},
  }) async {
    final results = await Future.wait([
      _apiService.getSystemInfo(),
      _loadServices(),
      _loadGateways(),
      _loadThermalSensors(),
      _loadAvailableInterfaces(),
      _loadNetworkHostsForInterfaces(requestedInterfaces),
    ]);

    return DashboardData(
      systemInfo: results[0] as SystemInfo,
      servicesData: results[1] as Map<String, dynamic>,
      gateways: results[2] as List<Map<String, dynamic>>,
      thermalSensors: results[3] as List<ThermalSensor>?,
      availableInterfaces: results[4] as Map<String, String>,
      networkHostsByInterface: results[5] as Map<String, List<NetworkHost>>,
    );
  }

  /// Load services data
  Future<Map<String, dynamic>> _loadServices() async {
    try {
      final services = await _apiService.getServices();
      return {'services': services};
    } catch (e) {
      return {'services': []};
    }
  }

  /// Load gateways data
  Future<List<Map<String, dynamic>>> _loadGateways() async {
    try {
      final gateways = await _apiService.getGateways();
      return gateways.cast<Map<String, dynamic>>();
    } catch (e) {
      return [];
    }
  }

  /// Load thermal sensors data
  /// Returns null if fetch fails, empty list if no sensors available (VM case)
  Future<List<ThermalSensor>?> _loadThermalSensors() async {
    try {
      final sensors = await _apiService.getSystemTemperature();
      return sensors;
    } catch (e) {
      // Return null on error to distinguish from empty array (VM case)
      return null;
    }
  }

  /// Load available network interfaces for the interface selector.
  /// Uses the same source as the Live Network Monitor screen so that the
  /// interface IDs passed to getNetworkHosts() are consistent.
  Future<Map<String, String>> _loadAvailableInterfaces() async {
    try {
      return await _apiService.getAvailableInterfaces();
    } catch (_) {
      return {'lan': 'LAN'};
    }
  }

  /// Load system data only — skips network hosts entirely.
  /// Used by the 30-second background refresh so network cards keep showing
  /// live data from the 2-second timer without being reset to a loading state.
  Future<SystemOnlyData> loadSystemDataOnly() async {
    final results = await Future.wait([
      _apiService.getSystemInfo(),
      _loadServices(),
      _loadGateways(),
      _loadThermalSensors(),
      _loadAvailableInterfaces(),
    ]);

    return SystemOnlyData(
      systemInfo: results[0] as SystemInfo,
      servicesData: results[1] as Map<String, dynamic>,
      gateways: results[2] as List<Map<String, dynamic>>,
      thermalSensors: results[3] as List<ThermalSensor>?,
      availableInterfaces: results[4] as Map<String, String>,
    );
  }

  /// Public entry point used by the dashboard's fast 2-second refresh timer.
  /// Fetches only network host data — does not touch system info or gateways.
  Future<Map<String, List<NetworkHost>>> loadNetworkHostsOnly(
    Set<String> interfaces,
  ) =>
      _loadNetworkHostsForInterfaces(interfaces);

  /// Load network hosts for each requested interface in parallel.
  Future<Map<String, List<NetworkHost>>> _loadNetworkHostsForInterfaces(
    Set<String> interfaces,
  ) async {
    if (interfaces.isEmpty) return {};
    final entries = await Future.wait(
      interfaces.map((iface) async {
        try {
          final hosts = await _apiService.getNetworkHosts(interface: iface);
          return MapEntry(iface, hosts);
        } catch (_) {
          return MapEntry(iface, <NetworkHost>[]);
        }
      }),
    );
    return Map.fromEntries(entries);
  }
}


