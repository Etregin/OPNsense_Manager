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
import '../models/tailscale_status.dart';
import '../services/demo_api_service.dart';
import 'base/base_form_view_model.dart';

/// ViewModel for the standalone Tailscale status screen
class TailscaleStatusViewModel extends BaseFormViewModel {
  final DemoApiService _apiService;

  TailscaleStatus? _status;
  SystemInfo? _systemInfo;

  TailscaleStatus? get status => _status;
  SystemInfo? get systemInfo => _systemInfo;

  TailscaleStatusViewModel(this._apiService);

  Future<void> loadData() async {
    await executeWithLoading(() async {
      final results = await Future.wait([
        _apiService.getTailscaleDetails(),
        _apiService.getSystemInfo(),
      ]);
      _status = results[0] as TailscaleStatus;
      _systemInfo = results[1] as SystemInfo;
    });
  }

  Future<bool> controlService(String action) async {
    return _apiService.controlTailscaleService(action);
  }
}
