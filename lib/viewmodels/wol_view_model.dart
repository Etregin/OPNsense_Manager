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

import '../models/wol_host.dart';
import '../services/demo_api_service.dart';
import 'base/base_list_view_model.dart';

/// ViewModel for the Wake-on-LAN screen
class WolViewModel extends BaseListViewModel<WolHost> {
  final DemoApiService _apiService;

  WolViewModel(this._apiService);

  @override
  Future<List<WolHost>> fetchItems() async {
    return _apiService.getWolHosts();
  }

  @override
  bool matchesFilter(WolHost host, String query) {
    final lower = query.toLowerCase();
    return host.mac.toLowerCase().contains(lower) ||
        host.descr.toLowerCase().contains(lower) ||
        host.interfaceDisplay.toLowerCase().contains(lower);
  }
}
