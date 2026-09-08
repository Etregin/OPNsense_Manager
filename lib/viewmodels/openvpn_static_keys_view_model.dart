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

import '../models/openvpn_static_key.dart';
import '../services/demo_api_service.dart';
import '../utils/constants.dart';
import 'base/base_list_view_model.dart';

/// ViewModel for the OpenVPN static keys list screen.
class OpenvpnStaticKeysViewModel extends BaseListViewModel<OpenvpnStaticKey> {
  final DemoApiService _apiService;

  int currentPage;
  int rowCount;

  OpenvpnStaticKeysViewModel(
    this._apiService, {
    this.currentPage = 1,
    this.rowCount = 50,
  });

  @override
  Future<List<OpenvpnStaticKey>> fetchItems() async {
    final response = await _apiService.searchOpenvpnStaticKeys(
      current: currentPage,
      rowCount: rowCount == -1 ? AppConstants.allRowsSentinel : rowCount,
    );
    return response.rows;
  }

  @override
  bool matchesFilter(OpenvpnStaticKey key, String query) {
    final lower = query.toLowerCase();
    return key.description.toLowerCase().contains(lower) ||
        (key.keyid?.toLowerCase().contains(lower) ?? false);
  }

  /// Delete a static key
  Future<void> deleteStaticKey(String keyid) async {
    await _apiService.deleteOpenvpnStaticKey(keyid);
    await refresh();
  }
}
