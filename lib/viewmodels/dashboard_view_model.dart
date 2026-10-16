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
import '../models/thermal_sensor.dart';
import '../services/demo_api_service.dart';
import '../services/dashboard/dashboard_data_loader.dart';
import 'base/base_form_view_model.dart';

/// ViewModel for the Dashboard screen
class DashboardViewModel extends BaseFormViewModel {
  final DemoApiService _apiService;
  late final DashboardDataLoader _dataLoader;

  SystemInfo? _systemInfo;
  Map<String, dynamic> _servicesData = {};
  List<Map<String, dynamic>> _gateways = [];
  List<ThermalSensor>? _thermalSensors;

  SystemInfo? get systemInfo => _systemInfo;
  Map<String, dynamic> get servicesData => _servicesData;
  List<Map<String, dynamic>> get gateways => _gateways;
  List<ThermalSensor>? get thermalSensors => _thermalSensors;

  DashboardViewModel(this._apiService) {
    _dataLoader = DashboardDataLoader(_apiService);
  }

  Future<void> loadDashboardData() async {
    setLoading(true);
    clearError();

    try {
      final data = await _dataLoader.loadAllData();
      _systemInfo = data.systemInfo;
      _servicesData = data.servicesData;
      _gateways = data.gateways;
      _thermalSensors = data.thermalSensors;
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }
}
