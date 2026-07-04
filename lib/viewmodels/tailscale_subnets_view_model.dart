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

import '../models/tailscale_settings.dart';
import '../services/demo_api_service.dart';
import '../services/opnsense_api_service.dart';
import 'base/base_list_view_model.dart';

/// ViewModel for the Tailscale subnets screen
class TailscaleSubnetsViewModel
    extends BaseListViewModel<MapEntry<String, TailscaleSubnet>> {
  final DemoApiService _demoApiService;
  final OPNsenseApiService? _apiService;

  TailscaleSubnetsViewModel(this._demoApiService, this._apiService);

  bool get _isDemoMode => _demoApiService.isDemoMode;

  @override
  Future<List<MapEntry<String, TailscaleSubnet>>> fetchItems() async {
    final response = _isDemoMode
        ? await _demoApiService.getTailscaleSettings()
        : await _apiService!.getTailscaleSettings();
    return response.settings.subnets?.entries.toList() ?? [];
  }

  @override
  bool matchesFilter(
      MapEntry<String, TailscaleSubnet> entry, String query) {
    final lower = query.toLowerCase();
    return (entry.value.subnet?.toLowerCase().contains(lower) ?? false) ||
        (entry.value.description?.toLowerCase().contains(lower) ?? false);
  }

  Future<Map<String, dynamic>> addSubnet(TailscaleSubnet subnet) async {
    final response = _isDemoMode
        ? await _demoApiService.addTailscaleSubnet(subnet)
        : await _apiService!.addTailscaleSubnet(subnet);
    return response;
  }

  Future<Map<String, dynamic>> updateSubnet(
      String uuid, TailscaleSubnet subnet) async {
    final response = _isDemoMode
        ? await _demoApiService.setTailscaleSubnet(uuid, subnet)
        : await _apiService!.setTailscaleSubnet(uuid, subnet);
    return response;
  }

  Future<Map<String, dynamic>> deleteSubnet(String uuid) async {
    final response = _isDemoMode
        ? await _demoApiService.deleteTailscaleSubnet(uuid)
        : await _apiService!.deleteTailscaleSubnet(uuid);
    return response;
  }
}
