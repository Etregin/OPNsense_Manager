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

import '../models/network_host.dart';
import '../services/demo_api_service.dart';
import 'base/base_list_view_model.dart';

/// ViewModel for the Live Network Monitor screen
class LiveNetworkMonitorViewModel extends BaseListViewModel<NetworkHost> {
  final DemoApiService _apiService;

  List<String> _selectedInterfaces;
  final Map<String, List<int>> _rateHistory = {};
  static const int _maxHistoryLength = 20;

  List<String> get selectedInterfaces => _selectedInterfaces;
  Map<String, List<int>> get rateHistory => Map.unmodifiable(_rateHistory);

  LiveNetworkMonitorViewModel(this._apiService,
      {List<String>? selectedInterfaces})
      : _selectedInterfaces = selectedInterfaces ?? ['lan'];

  void setSelectedInterfaces(List<String> interfaces) {
    _selectedInterfaces = interfaces;
    loadItems();
  }

  @override
  Future<List<NetworkHost>> fetchItems() async {
    // Fetch hosts from all selected interfaces and merge by IP
    final List<NetworkHost> allHosts = [];
    for (final interface in _selectedInterfaces) {
      final hosts = await _apiService.getNetworkHosts(interface: interface);
      allHosts.addAll(hosts);
    }

    // Deduplicate by IP — keep the entry with highest bandwidth
    final Map<String, NetworkHost> uniqueHosts = {};
    for (final host in allHosts) {
      if (!uniqueHosts.containsKey(host.address) ||
          host.totalRate > uniqueHosts[host.address]!.totalRate) {
        uniqueHosts[host.address] = host;
      }
    }

    final hosts = uniqueHosts.values.toList();

    // Update rate history for sparkline effect
    for (final host in hosts) {
      final history = _rateHistory.putIfAbsent(host.address, () => []);
      history.add(host.totalRate);
      if (history.length > _maxHistoryLength) {
        history.removeAt(0);
      }
    }

    return hosts;
  }

  @override
  bool matchesFilter(NetworkHost host, String query) {
    final lower = query.toLowerCase();
    return host.hostname.toLowerCase().contains(lower) ||
        host.address.toLowerCase().contains(lower) ||
        (host.manufacturer?.toLowerCase().contains(lower) ?? false);
  }
}
