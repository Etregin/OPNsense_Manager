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

import '../../models/system_info.dart';
import '../../models/thermal_sensor.dart';
import '../demo_api_service.dart';

/// Data class for dashboard data
class DashboardData {
  final SystemInfo systemInfo;
  final Map<String, dynamic> servicesData;
  final List<Map<String, dynamic>> gateways;
  final List<ThermalSensor>? thermalSensors;

  DashboardData({
    required this.systemInfo,
    required this.servicesData,
    required this.gateways,
    this.thermalSensors,
  });
}

/// Service for loading dashboard data in parallel
class DashboardDataLoader {
  final DemoApiService _apiService;

  DashboardDataLoader(this._apiService);

  /// Load all dashboard data in parallel for faster loading
  Future<DashboardData> loadAllData() async {
    final results = await Future.wait([
      _apiService.getSystemInfo(),
      _loadServices(),
      _loadGateways(),
      _loadThermalSensors(),
    ]);

    return DashboardData(
      systemInfo: results[0] as SystemInfo,
      servicesData: results[1] as Map<String, dynamic>,
      gateways: results[2] as List<Map<String, dynamic>>,
      thermalSensors: results[3] as List<ThermalSensor>?,
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
    } catch (e, stackTrace) {
      // Log error for debugging
      print('Error loading thermal sensors: $e');
      print('Stack trace: $stackTrace');
      // Return null on error to distinguish from empty array (VM case)
      return null;
    }
  }
}


