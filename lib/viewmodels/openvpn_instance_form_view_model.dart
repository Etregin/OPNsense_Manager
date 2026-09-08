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

import '../models/openvpn_instance.dart';
import '../services/demo_api_service.dart';
import 'base/base_form_view_model.dart';

/// ViewModel for OpenVPN Instance form screen
class OpenvpnInstanceFormViewModel extends BaseFormViewModel {
  final DemoApiService _apiService;
  final String? _vpnid;

  OpenvpnInstance? _loadedInstance;

  OpenvpnInstance? get loadedInstance => _loadedInstance;
  bool get isEditing => _vpnid != null;

  OpenvpnInstanceFormViewModel({
    required this._apiService,
    this._vpnid,
  });

  /// Load instance data from API (both create/edit — API returns defaults for new)
  Future<void> loadInstance() async {
    setLoading(true);
    clearError();

    try {
      _loadedInstance = await _apiService.getOpenvpnInstance(_vpnid);
    } catch (e) {
      setError(e.toString());
    } finally {
      setLoading(false);
    }
  }

  /// Save instance (create or update)
  Future<bool> saveInstance(OpenvpnInstance instance) async {
    final result = await executeWithLoading(() async {
      if (isEditing) {
        await _apiService.updateOpenvpnInstance(_vpnid!, instance);
      } else {
        await _apiService.addOpenvpnInstance(instance);
      }
      return true;
    });
    return result == true;
  }

  /// Generate an auth token
  Future<String?> generateAuthToken() async {
    final result = await executeWithLoading(() async {
      return await _apiService.generateOpenvpnAuthToken();
    });
    return result;
  }
}
