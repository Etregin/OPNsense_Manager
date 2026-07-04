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

import '../models/dhcp_lease.dart';
import '../services/demo_api_service.dart';
import 'base/base_list_view_model.dart';

/// ViewModel for the DHCP Leases screen
class DhcpLeasesViewModel extends BaseListViewModel<DhcpLease> {
  final DemoApiService _apiService;

  DhcpLeasesViewModel(this._apiService);

  @override
  Future<List<DhcpLease>> fetchItems() async {
    final leasesData = await _apiService.getDhcpLeases();
    return leasesData.map((data) => DhcpLease.fromJson(data)).toList();
  }

  @override
  bool matchesFilter(DhcpLease lease, String query) {
    final lower = query.toLowerCase();
    return lease.hostname.toLowerCase().contains(lower) ||
        lease.address.toLowerCase().contains(lower) ||
        lease.macAddress.toLowerCase().contains(lower) ||
        (lease.manufacturer?.toLowerCase().contains(lower) ?? false);
  }
}
