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

import '../models/neighbor.dart' show Neighbor, ServiceWidget;
import '../services/demo_api_service.dart';
import 'base/base_list_view_model.dart';

/// ViewModel for the Neighbor Discovery screen
class NeighborDiscoveryViewModel extends BaseListViewModel<Neighbor> {
  final DemoApiService _apiService;

  String? _serviceStatus;
  ServiceWidget? _serviceWidget;
  int _currentPage = 1;
  int _rowCount = 50;
  int _totalResults = 0;

  String? get serviceStatus => _serviceStatus;
  ServiceWidget? get serviceWidget => _serviceWidget;
  int get currentPage => _currentPage;
  int get rowCount => _rowCount;
  int get totalResults => _totalResults;

  NeighborDiscoveryViewModel(this._apiService);

  @override
  Future<List<Neighbor>> fetchItems() async {
    final response = await _apiService.getNeighbors(
      current: _currentPage,
      rowCount: _rowCount,
      searchPhrase: searchQuery.isNotEmpty ? searchQuery : null,
    );
    _totalResults = response.total;
    return response.rows;
  }

  @override
  bool matchesFilter(Neighbor neighbor, String query) {
    final lower = query.toLowerCase();
    return neighbor.ipAddress.toLowerCase().contains(lower) ||
        neighbor.etherAddress.toLowerCase().contains(lower) ||
        neighbor.interfaceName.toLowerCase().contains(lower);
  }

  Future<void> checkServiceStatus() async {
    try {
      final status = await _apiService.checkNeighborDiscoveryStatus();
      _serviceStatus = status.status;
      _serviceWidget = status.widget;
    } catch (e) {
      _serviceStatus = 'unknown';
      _serviceWidget = null;
    }
    notifyListeners();
  }

  Future<void> startService() async {
    await _apiService.startNeighborDiscoveryService();
    await checkServiceStatus();
  }

  Future<void> stopService() async {
    await _apiService.stopNeighborDiscoveryService();
    await checkServiceStatus();
  }

  Future<void> restartService() async {
    await _apiService.restartNeighborDiscoveryService();
    await checkServiceStatus();
  }

  void setPage(int page) {
    _currentPage = page;
    loadItems();
  }

  void setRowCount(int count) {
    _rowCount = count;
    _currentPage = 1;
    loadItems();
  }
}
