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

import '../models/wireguard_status.dart';
import '../services/demo_api_service.dart';
import 'base/base_form_view_model.dart';

/// ViewModel for managing WireGuard status screen state
///
/// Handles fetching and displaying WireGuard status data.
class WireGuardStatusViewModel extends BaseFormViewModel {
  final DemoApiService _apiService;

  WireGuardStatusResponse? _statusResponse;

  WireGuardStatusViewModel(this._apiService) {
    loadStatus();
  }

  WireGuardStatusResponse? get statusResponse => _statusResponse;

  /// Returns the list of status items (or empty list if null)
  List<WireGuardStatusItem> get statusItems => _statusResponse?.rows ?? [];

  /// Returns true if status data exists
  bool get hasData => _statusResponse != null && _statusResponse!.hasItems;

  /// Returns the total count of items
  int get totalItems => _statusResponse?.total ?? 0;

  /// Fetches status data from the API
  Future<void> loadStatus() async {
    await executeWithLoading(() async {
      _statusResponse = await _apiService.getWireGuardStatusResponse();
    });
  }

  /// Refreshes the status data
  Future<void> refresh() => loadStatus();
}


