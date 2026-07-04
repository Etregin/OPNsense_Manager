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

import '../models/openvpn_log_entry.dart';
import '../services/demo_api_service.dart';
import 'base/base_list_view_model.dart';

/// ViewModel for the OpenVPN log file screen.
///
/// Filter parameters (rowCount, severities, validFrom) are set by the screen
/// before calling [loadItems], so [fetchItems] can use them.
class OpenvpnLogViewModel extends BaseListViewModel<OpenvpnLogEntry> {
  final DemoApiService _apiService;

  int rowCount;
  List<String> severities;
  double? validFrom;
  int currentPage;

  OpenvpnLogViewModel(
    this._apiService, {
    this.rowCount = 50,
    List<String>? severities,
    this.validFrom,
    this.currentPage = 1,
  }) : severities = severities ?? const ['Emergency', 'Alert', 'Critical', 'Error', 'Warning'];

  @override
  Future<List<OpenvpnLogEntry>> fetchItems() async {
    final response = await _apiService.searchOpenvpnLogs(
      current: currentPage,
      rowCount: rowCount,
      sort: const <String, dynamic>{'timestamp': 'desc'},
      severity: severities,
      validFrom: validFrom,
    );
    return response.rows;
  }

  @override
  bool matchesFilter(OpenvpnLogEntry log, String query) {
    final lower = query.toLowerCase();
    return log.line.toLowerCase().contains(lower) ||
        log.severity.toLowerCase().contains(lower) ||
        (log.processName?.toLowerCase().contains(lower) ?? false);
  }
}
