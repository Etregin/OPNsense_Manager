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

import '../screens/firewall_logs_screen.dart';
import '../services/demo_api_service.dart';
import 'base/base_list_view_model.dart';

/// ViewModel for the firewall logs screen.
///
/// Handles loading the log entries from the API. Complex UI state
/// (pause/resume, auto-scroll, selection mode) remains in the screen.
class FirewallLogsViewModel extends BaseListViewModel<FirewallLogEntry> {
  final DemoApiService _apiService;
  int historySize;

  FirewallLogsViewModel(this._apiService, {this.historySize = 100});

  @override
  Future<List<FirewallLogEntry>> fetchItems() async {
    final logsData = await _apiService.getFirewallLogs(limit: historySize);
    return logsData
        .map((log) => FirewallLogEntry.fromJson(log as Map<String, dynamic>))
        .toList();
  }

  @override
  bool matchesFilter(FirewallLogEntry log, String query) {
    final lower = query.toLowerCase();
    return log.sourceIp.toLowerCase().contains(lower) ||
        log.destIp.toLowerCase().contains(lower) ||
        log.interface.toLowerCase().contains(lower) ||
        log.action.toLowerCase().contains(lower) ||
        log.protocol.toLowerCase().contains(lower);
  }
}
