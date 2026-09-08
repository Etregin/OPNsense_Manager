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
import '../models/openvpn_log_search_response.dart';
import 'base/base_list_view_model.dart';

/// Callback type for fetching a page of log entries.
///
/// All OPNsense log endpoints share the same request/response contract, so a
/// single typedef covers every log source (OpenVPN, WireGuard, Audit, Boot …).
typedef LogFetcher = Future<OpenvpnLogSearchResponse> Function({
  int current,
  int rowCount,
  Map<String, dynamic>? sort,
  List<String>? severity,
  double? validFrom,
});

/// Generic ViewModel for any OPNsense log file screen.
///
/// The screen sets [rowCount], [severities], [validFrom], and [currentPage]
/// before calling [loadItems], then [fetchItems] forwards them to [fetcher].
///
/// Replaces the per-feature `OpenvpnLogViewModel` and `WireGuardLogViewModel`.
class LogFileViewModel extends BaseListViewModel<OpenvpnLogEntry> {
  final LogFetcher fetcher;

  int rowCount;
  List<String> severities;
  double? validFrom;
  int currentPage;

  /// Total entries reported by the API (used for pagination display).
  int total = 0;

  LogFileViewModel(
    this.fetcher, {
    this.rowCount = 50,
    List<String>? severities,
    this.validFrom,
    this.currentPage = 1,
  }) : severities = severities ??
            const ['Emergency', 'Alert', 'Critical', 'Error', 'Warning'];

  @override
  Future<List<OpenvpnLogEntry>> fetchItems() async {
    final response = await fetcher(
      current: currentPage,
      rowCount: rowCount,
      sort: const <String, dynamic>{},
      severity: severities,
      validFrom: validFrom,
    );
    total = response.total;
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
