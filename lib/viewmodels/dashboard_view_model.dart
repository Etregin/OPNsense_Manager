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

import 'package:flutter/foundation.dart';
import '../models/system_info.dart';
import '../models/thermal_sensor.dart';
import '../services/demo_api_service.dart';
import '../services/dashboard/dashboard_data_loader.dart';

/// ViewModel for the Dashboard screen
class DashboardViewModel extends ChangeNotifier {
  final DemoApiService _apiService;
  late final DashboardDataLoader _dataLoader;

  SystemInfo? _systemInfo;
  Map<String, dynamic> _servicesData = {};
  List<Map<String, dynamic>> _gateways = [];
  List<ThermalSensor>? _thermalSensors;
  bool _isLoading = false;
  String? _errorMessage;

  SystemInfo? get systemInfo => _systemInfo;
  Map<String, dynamic> get servicesData => _servicesData;
  List<Map<String, dynamic>> get gateways => _gateways;
  List<ThermalSensor>? get thermalSensors => _thermalSensors;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  DashboardViewModel(this._apiService) {
    _dataLoader = DashboardDataLoader(_apiService);
  }

  Future<void> loadDashboardData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final data = await _dataLoader.loadAllData();
      _systemInfo = data.systemInfo;
      _servicesData = data.servicesData;
      _gateways = data.gateways;
      _thermalSensors = data.thermalSensors;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
