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
import '../services/demo_api_service.dart';

/// ViewModel for the Tailscale authentication settings screen
class TailscaleAuthViewModel extends ChangeNotifier {
  final DemoApiService _apiService;

  SystemInfo? _systemInfo;
  String _loginServer = 'https://login.tailscale.com';
  String _preAuthKey = '';
  bool _isLoading = false;
  bool _isSaving = false;
  String? _errorMessage;

  SystemInfo? get systemInfo => _systemInfo;
  String get loginServer => _loginServer;
  String get preAuthKey => _preAuthKey;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;

  TailscaleAuthViewModel(this._apiService);

  Future<void> loadData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _apiService.getSystemInfo(),
        _apiService.getTailscaleAuthentication(),
      ]);
      _systemInfo = results[0] as SystemInfo;
      final authSettings = results[1] as Map<String, String?>;
      _loginServer = authSettings['loginServer'] ?? 'https://login.tailscale.com';
      _preAuthKey = authSettings['preAuthKey'] ?? '';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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
