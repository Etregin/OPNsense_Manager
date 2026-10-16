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

import '../models/network_host.dart';
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
  Map<String, String> _availableInterfaces = {'lan': 'LAN'};
  /// Nullable values: null = actively loading, non-null = loaded (may be empty).
  Map<String, List<NetworkHost>?> _networkHostsByInterface = {};
  final Set<String> _loadingInterfaces = {};

  SystemInfo? get systemInfo => _systemInfo;
  Map<String, dynamic> get servicesData => _servicesData;
  List<Map<String, dynamic>> get gateways => _gateways;
  List<ThermalSensor>? get thermalSensors => _thermalSensors;
  Map<String, String> get availableInterfaces => _availableInterfaces;

  /// Returns the hosts for [interface].
  /// - `null`  → actively loading (show spinner)
  /// - `[]`    → loaded, no active devices
  /// - `[...]` → loaded with data
  List<NetworkHost>? getHostsForInterface(String interface) =>
      _networkHostsByInterface.containsKey(interface)
          ? _networkHostsByInterface[interface]
          : null;

  /// Whether [interface] is currently being fetched.
  bool isInterfaceLoading(String interface) =>
      _loadingInterfaces.contains(interface);

  DashboardViewModel(this._apiService) {
    _dataLoader = DashboardDataLoader(_apiService);
  }

  Future<void> loadDashboardData({
    Set<String> requestedInterfaces = const {'lan'},
  }) async {
    // Immediately mark each requested interface as loading so the cards show
    // a spinner rather than "no data available" while the fetch is in flight.
    _loadingInterfaces.addAll(requestedInterfaces);
    for (final iface in requestedInterfaces) {
      _networkHostsByInterface[iface] = null;
    }
    setLoading(true);
    clearError();
    notifyListeners();

    try {
      final data = await _dataLoader.loadAllData(
        requestedInterfaces: requestedInterfaces,
      );
      _systemInfo = data.systemInfo;
      _servicesData = data.servicesData;
      _gateways = data.gateways;
      _thermalSensors = data.thermalSensors;
      _availableInterfaces = data.availableInterfaces;
      _networkHostsByInterface = Map<String, List<NetworkHost>?>.from(
        data.networkHostsByInterface,
      );
    } catch (e) {
      setError(e.toString());
    } finally {
      _loadingInterfaces.removeAll(requestedInterfaces);
      setLoading(false);
    }
  }

  /// Refresh system data only (CPU, memory, gateways, services, thermals) —
  /// does NOT touch [_networkHostsByInterface] or the loading flags, so the
  /// network cards keep showing live data from the 2-second timer uninterrupted.
  /// Used by the 30-second auto-refresh timer.
  Future<void> refreshSystemData() async {
    if (_systemInfo == null) return; // initial load not yet complete
    try {
      final data = await _dataLoader.loadSystemDataOnly();
      _systemInfo = data.systemInfo;
      _servicesData = data.servicesData;
      _gateways = data.gateways;
      _thermalSensors = data.thermalSensors;
      _availableInterfaces = data.availableInterfaces;
      notifyListeners();
    } catch (_) {
      // Silent — keep showing the last known system data on transient errors.
    }
  }

  /// Refresh only network host data — does not touch system info or set the
  /// global loading flag. Used by the fast 2-second timer on the dashboard.
  Future<void> refreshNetworkData({
    required Set<String> requestedInterfaces,
  }) async {
    if (requestedInterfaces.isEmpty) return;
    // Only run if the initial load has already completed (systemInfo is set).
    // This prevents the timer from firing before the layout is ready and
    // overwriting the map with a partial result.
    if (_systemInfo == null) return;
    try {
      final updated =
          await _dataLoader.loadNetworkHostsOnly(requestedInterfaces);
      // Merge into the existing map rather than replacing it, so interfaces
      // loaded by loadDashboardData but not in this tick's set are preserved.
      _networkHostsByInterface = {
        ..._networkHostsByInterface,
        ...Map<String, List<NetworkHost>?>.from(updated),
      };
      notifyListeners();
    } catch (_) {
      // Silent — do not surface errors for background refresh ticks.
    }
  }
}
