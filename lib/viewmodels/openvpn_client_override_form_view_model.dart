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

import '../models/openvpn_client_override.dart';
import '../services/demo_api_service.dart';
import 'base/base_form_view_model.dart';

/// ViewModel for OpenVPN Client Override form screen
class OpenvpnClientOverrideFormViewModel extends BaseFormViewModel {
  final DemoApiService _apiService;
  final String? _uuid;

  OpenvpnClientOverride? _loadedOverride;

  OpenvpnClientOverride? get loadedOverride => _loadedOverride;
  bool get isEditing => _uuid != null;

  OpenvpnClientOverrideFormViewModel({
    required this._apiService,
    this._uuid,
  });

  /// Load override data from API
  Future<void> loadOverride() async {
    setLoading(true);
    clearError();

    try {
      _loadedOverride = await _apiService.getClientOverride(_uuid);
      setLoading(false);
    } catch (e) {
      setLoading(false);
      setError(e.toString());
    }
  }

  /// Save override (create or update)
  Future<bool> saveOverride(OpenvpnClientOverride override) async {
    final result = await executeWithLoading(() async {
      await _apiService.setClientOverride(_uuid ?? '', override);
      return true;
    });
    return result == true;
  }
}
