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
import '../services/demo_api_service.dart';
import '../utils/constants.dart';
import 'base/base_form_view_model.dart';

/// ViewModel for the Tailscale authentication settings screen
class TailscaleAuthViewModel extends BaseFormViewModel {
  final DemoApiService _apiService;

  SystemInfo? _systemInfo;
  String _loginServer = AppConstants.tailscaleLoginServer;
  String _preAuthKey = '';
  bool _isSaving = false;

  SystemInfo? get systemInfo => _systemInfo;
  String get loginServer => _loginServer;
  String get preAuthKey => _preAuthKey;
  bool get isSaving => _isSaving;

  TailscaleAuthViewModel(this._apiService);

  Future<void> loadData() async {
    await executeWithLoading(() async {
      final results = await Future.wait([
        _apiService.getSystemInfo(),
        _apiService.getTailscaleAuthentication(),
      ]);
      _systemInfo = results[0] as SystemInfo;
      final authSettings = results[1] as Map<String, String?>;
      _loginServer = authSettings['loginServer'] ?? AppConstants.tailscaleLoginServer;
      _preAuthKey = authSettings['preAuthKey'] ?? '';
    });
  }

  Future<bool> saveSettings(String loginServer, String preAuthKey) async {
    _isSaving = true;
    notifyListeners();

    try {
      final success = await _apiService.setTailscaleAuthentication(
        loginServer,
        preAuthKey,
      );
      if (success) {
        _loginServer = loginServer;
        _preAuthKey = preAuthKey;
      }
      return success;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}
