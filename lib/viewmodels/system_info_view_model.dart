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

/// ViewModel for the System Info screen
class SystemInfoViewModel extends ChangeNotifier {
  final DemoApiService _apiService;

  SystemInfo? _systemInfo;
  bool _isLoading = false;
  String? _errorMessage;

  SystemInfo? get systemInfo => _systemInfo;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  SystemInfoViewModel(this._apiService);

  Future<void> loadSystemInfo() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _systemInfo = await _apiService.getSystemInfo();
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
