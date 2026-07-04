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
import '../models/tailscale_status.dart';
import '../services/demo_api_service.dart';

/// ViewModel for the standalone Tailscale status screen
class TailscaleStatusViewModel extends ChangeNotifier {
  final DemoApiService _apiService;

  TailscaleStatus? _status;
  SystemInfo? _systemInfo;
  bool _isLoading = false;
  String? _errorMessage;

  TailscaleStatus? get status => _status;
  SystemInfo? get systemInfo => _systemInfo;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  TailscaleStatusViewModel(this._apiService);

  Future<void> loadData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _apiService.getTailscaleDetails(),
        _apiService.getSystemInfo(),
      ]);
      _status = results[0] as TailscaleStatus;
      _systemInfo = results[1] as SystemInfo;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> controlService(String action) async {
    return _apiService.controlTailscaleService(action);
  }
}
